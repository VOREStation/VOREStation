// File for modifier defines that don't fit anywhere else. Since this is a misc file, it's doomed to get filled with everything like all the others.


/*
	Berserk is a modifier that grants vastly increased melee capability for a short period of time, easily allowing the
holder to do more than twice the damage they would normally do, as it both increases outgoing melee damage, and
reduces their attack delay. The screen will also turn deep red and the holder will get larger in size.

The modifier also gives some defenses, in that it gives additional max health (this can bite them in the ass later since
its not permanent), makes them move slightly faster, cancels disabling effects when it triggers, and reduces the power of
future disables by a very large amount. It also suppresses pain until it expires, however berserking while under massive pain
is likely to cause them to pass out when exhaustion hits.

Due to the intense rage felt by the holder, the focus needed to use ranged weapons is lost, making accuracy with them
massively reduced. The holder also feels less of a need to evade attacks and will be easier to hit.

Berserk can be extended by having another instance try to affect the holder while in the middle of a berserk.

After the modifier expires, a second modifier representing exhaustion is placed, which inflicts massive maluses and prevents
further berserks until it expires. This generally means that someone getting caught while exhausted will be much easier to fight,
as they will be much slower, attack slower, do less melee damage, be easier to hit, and disabling effects will affect them harder.

Berserking causes the holder to feel hungrier. If they are starving, this modifier cannot be applied. Diona cannot
be berserked, or those who are suffering from exhaustion. Non-Drone Synthetics that receive the berserk modifier will
instead get a version that has no benefits, but will not cost nutrition or cause exhaustion. Drones cannot receive berserk, as
they are emotionless automatrons.

Berserk is a somewhat rare modifier to obtain freely (and for good reason), however here are ways to see it in action;
- Red Slimes will berserk if they go rabid.
- Red slime core reactions will berserk slimes that can see the user in addition to making them go rabid.
- Red slime core reactions will berserk prometheans that can see the user.
- Saviks will berserk when losing a fight.
- Changelings can evolve a 2 point ability to use a changeling-specific variant of Berserk, that replaces the text with a 'we' variant.
Recursive Enhancement allows the changeling to instead used an improved variant that features less exhaustion time and less nutrition drain.
- Xenoarch artifacts may have forced berserking as one of their effects. This is especially fun if an artifact that makes hostile mobs is nearby.
Will cause three brainloss in those affected due to the artifact meddling with their mind.
- A rare alien artifact might be found on the Surface, or obtained from Xenoarch, that causes berserking when it thinks
the wearer is in danger, however in addition to the usual drawbacks, each use causes three brainloss in the user, due to how
the artifact triggers the rage.

*/

/datum/modifier/berserk
	name = "berserk"
	desc = "You are filled with an overwhelming rage."
	client_color = "#FF5555" // Make everything red!
	mob_overlay_state = "berserk"

	on_created_text = "<span class='critical'>You feel an intense and overwhelming rage overtake you as you go berserk!</span>"
	on_expired_text = "<span class='notice'>The blaze of rage inside you has ran out.</span>"
	stacks = MODIFIER_STACK_EXTEND

	// The good stuff.
	slowdown = -1							// Move a bit faster.
	attack_speed_percent = 0.66				// Attack at 2/3 the normal delay.
	outgoing_melee_damage_percent = 1.5		// 50% more damage from melee.
	max_health_percent = 1.5				// More health as a buffer, however the holder might fall into crit after this expires if they're mortally wounded.
	disable_duration_percent = 0.25			// Disables only last 25% as long.
	icon_scale_x_percent = 1.2				// Look scarier.
	icon_scale_y_percent = 1.2
	pain_immunity = TRUE					// Avoid falling over from shock (at least until it expires).

	// The less good stuff.
	accuracy = -75							// Aiming requires focus.
	accuracy_dispersion = 3					// Ditto.
	evasion = -45							// Too angry to dodge.

	var/nutrition_cost = 150
	var/exhaustion_duration = 2 MINUTES 	// How long the exhaustion modifier lasts after it expires. Set to 0 to not apply one.
	var/last_shock_stage = 0


// For changelings.
/datum/modifier/berserk/changeling
	on_created_text = "<span class='critical'>We feel an intense and overwhelming rage overtake us as we go berserk!</span>"
	on_expired_text = "<span class='notice'>The blaze of rage inside us has ran out.</span>"

// For changelings who bought the Recursive Enhancement evolution.
/datum/modifier/berserk/changeling/recursive
	exhaustion_duration = 1 MINUTE
	nutrition_cost = 75


/datum/modifier/berserk/on_applied()
	if(ishuman(holder)) // Most other mobs don't really use nutrition and can't get it back.
		holder.adjust_nutrition(-nutrition_cost)
	holder.visible_message("<span class='critical'>\The [holder] descends into an all consuming rage!</span>")

	// End all stuns.
	holder.SetParalysis(0)
	holder.SetStunned(0)
	holder.SetWeakened(0)
	holder.setHalLoss(0)
	holder.lying = 0
	holder.update_canmove()

	// Temporarily end pain.
	if(ishuman(holder))
		var/mob/living/carbon/human/H = holder
		last_shock_stage = H.shock_stage
		H.shock_stage = 0

/datum/modifier/berserk/on_expire()
	if(exhaustion_duration > 0 && holder.stat != DEAD)
		holder.add_modifier(/datum/modifier/berserk_exhaustion, exhaustion_duration)

		if(prob(last_shock_stage))
			to_chat(holder, "<span class='warning'>You pass out from the pain you were suppressing.</span>")
			holder.Paralyse(5)

		if(ishuman(holder))
			var/mob/living/carbon/human/H = holder
			H.shock_stage = last_shock_stage

/datum/modifier/berserk/can_apply(var/mob/living/L, var/suppress_failure = FALSE)
	if(L.stat)
		if(!suppress_failure)
			to_chat(L, "<span class='warning'>You can't be unconscious or dead to berserk.</span>")
		return FALSE // It would be weird to see a dead body get angry all of a sudden.

	if(!L.is_sentient())
		return FALSE // Drones don't feel anything.

	if(L.has_modifier_of_type(/datum/modifier/berserk_exhaustion))
		if(!suppress_failure)
			to_chat(L, "<span class='warning'>You recently berserked, and cannot do so again while exhausted.</span>")
		return FALSE // On cooldown.

	if(L.isSynthetic())
		L.add_modifier(/datum/modifier/berserk_synthetic, 30 SECONDS)
		return FALSE // Borgs can get angry but their metal shell can't be pushed harder by just being mad. Same for Posibrains.

	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(H.species.name == "Diona")
			to_chat(L, "<span class='warning'>You feel strange for a moment, but it passes.</span>")
			return FALSE // Happy trees aren't affected by blood rages.

	if(L.nutrition < nutrition_cost)
		if(!suppress_failure)
			to_chat(L, "<span class='warning'>You are too hungry to berserk.</span>")
		return FALSE // Too hungry to enrage.

	return ..()

/datum/modifier/berserk/tick()
	if(holder.stat == DEAD)
		expire(silent = TRUE)


// Applied when berserk expires. Acts as a downside as well as the cooldown for berserk.
/datum/modifier/berserk_exhaustion
	name = "exhaustion"
	desc = "You recently exerted yourself extremely hard, and need a rest."

	on_created_text = "<span class='warning'>You feel extremely exhausted.</span>"
	on_expired_text = "<span class='notice'>You feel less exhausted now.</span>"
	stacks = MODIFIER_STACK_EXTEND

	slowdown = 2
	attack_speed_percent = 1.5
	outgoing_melee_damage_percent = 0.6
	disable_duration_percent = 1.5
	evasion = -30

/datum/modifier/berserk_exhaustion/on_applied()
	holder.visible_message("<span class='warning'>\The [holder] looks exhausted.</span>")


// Synth version with no benefits due to a loss of focus inside a metal shell, which can't be pushed harder just be being mad.
// Fortunately there is no exhaustion or nutrition cost.
/datum/modifier/berserk_synthetic
	name = "recklessness"
	desc = "You are filled with an overwhelming rage, however your metal shell prevents taking advantage of this."
	client_color = "#FF0000" // Make everything red!
	mob_overlay_state = "berserk"

	on_created_text = "<span class='danger'>You feel an intense and overwhelming rage overtake you as you go berserk! \
	Unfortunately, your lifeless body cannot benefit from this. You feel reckless...</span>"
	on_expired_text = "<span class='notice'>The blaze of rage inside your mind has ran out.</span>"
	stacks = MODIFIER_STACK_EXTEND

	// Just being mad isn't gonna overclock your body when you're a beepboop.
	accuracy = -75				// Aiming requires focus.
	accuracy_dispersion = 3		// Ditto.
	evasion = -45				// Too angry to dodge.

// Speedy, but not hasted.
/datum/modifier/sprinting
	name = "sprinting"
	desc = "You are filled with energy!"

	on_created_text = "<span class='warning'>You feel a surge of energy!</span>"
	on_expired_text = "<span class='notice'>The energy high dies out.</span>"
	stacks = MODIFIER_STACK_EXTEND

	slowdown = -1
	disable_duration_percent = 0.8

// Speedy, but not berserked.
/datum/modifier/melee_surge
	name = "melee surge"
	desc = "You are filled with energy!"

	on_created_text = "<span class='warning'>You feel a surge of energy!</span>"
	on_expired_text = "<span class='notice'>The energy high dies out.</span>"
	stacks = MODIFIER_STACK_ALLOWED

	attack_speed_percent = 0.8
	outgoing_melee_damage_percent = 1.1
	disable_duration_percent = 0.8

// Non-cult version of deep wounds.
// Surprisingly, more dangerous.
/datum/modifier/grievous_wounds
	name = "grievous wounds"
	desc = "Your wounds are not easily mended."

	on_created_text = "<span class='critical'>Your wounds pain you greatly.</span>"
	on_expired_text = "<span class='notice'>The pain lulls.</span>"

	stacks = MODIFIER_STACK_EXTEND

	incoming_healing_percent = 0.50	// 50% less healing.
	disable_duration_percent = 1.22	// 22% longer disables.
	bleeding_rate_percent = 1.20	// 20% more bleeding.

	accuracy_dispersion = 2			// A combination of fear and immense pain or damage reults in a twitching firing arm. Flee.

// Applied when near something very cold.
// Reduces mobility, attack speed.
/datum/modifier/chilled
	name = "chilled"
	desc = "You feel yourself freezing up. Its hard to move."
	mob_overlay_state = "chilled"

	on_created_text = "<span class='danger'>You feel like you're going to freeze! It's hard to move.</span>"
	on_expired_text = "<span class='warning'>You feel somewhat warmer and more mobile now.</span>"
	stacks = MODIFIER_STACK_EXTEND

	slowdown = 2
	evasion = -40
	attack_speed_percent = 1.4
	disable_duration_percent = 1.2


// Similar to being on fire, except poison tends to be more long term.
// Antitoxins will remove stacks over time.
// Synthetics can't receive this.
/datum/modifier/poisoned
	name = "poisoned"
	desc = "You have poison inside of you. It will cause harm over a long span of time if not cured."
	mob_overlay_state = "poisoned"

	on_created_text = "<span class='warning'>You feel sick...</span>"
	on_expired_text = "<span class='notice'>You feel a bit better.</span>"
	stacks = MODIFIER_STACK_ALLOWED // Multiple instances will hurt a lot.
	var/damage_per_tick = 1

/datum/modifier/poisoned/weak
	damage_per_tick = 0.5

/datum/modifier/poisoned/strong
	damage_per_tick = 2

/datum/modifier/poisoned/tick()
	if(holder.stat == DEAD)
		expire(silent = TRUE)
	holder.inflict_poison_damage(damage_per_tick)

/datum/modifier/poisoned/can_apply(mob/living/L)
	if(L.isSynthetic())
		return FALSE
	if(L.get_poison_protection() >= 1)
		return FALSE
	return TRUE

/datum/modifier/poisoned/paralysis
	desc = "You have poison inside of you. It will cause harm over a long span of time if not cured, and may cause temporary paralysis."
	on_created_text = "<span class='warning'>You feel incredibly weak...</span>"
	damage_per_tick = 0.75

/datum/modifier/poisoned/paralysis/tick()
	..()
	if(prob(5))
		holder.Paralyse(3)

/datum/modifier/poisoned/paralysis/on_applied()
	..()
	holder.Paralyse(4)

// Pulse modifier.
/datum/modifier/false_pulse
	name = "false pulse"
	desc = "Your blood flows, despite all other factors."

	on_created_text = "<span class='notice'>You feel alive.</span>"
	on_expired_text = "<span class='notice'>You feel.. different.</span>"
	stacks = MODIFIER_STACK_EXTEND

	pulse_set_level = PULSE_NORM

/datum/modifier/slow_pulse
	name = "slow pulse"
	desc = "Your blood flows slower."

	on_created_text = "<span class='notice'>You feel sluggish.</span>"
	on_expired_text = "<span class='notice'>You feel energized.</span>"
	stacks = MODIFIER_STACK_EXTEND

	bleeding_rate_percent = 0.8

	pulse_modifier = -1

// Temperature Normalizer.
/datum/modifier/homeothermic
	name = "temperature resistance"
	desc = "Your body normalizes to room temperature."

	on_created_text = "<span class='notice'>You feel comfortable.</span>"
	on_expired_text = "<span class='notice'>You feel.. still probably comfortable.</span>"
	stacks = MODIFIER_STACK_EXTEND

/datum/modifier/homeothermic/tick()
	..()
	holder.bodytemperature = round((holder.bodytemperature + T20C) / 2)

/datum/modifier/exothermic
	name = "heat resistance"
	desc = "Your body lowers to room temperature."

	on_created_text = "<span class='notice'>You feel comfortable.</span>"
	on_expired_text = "<span class='notice'>You feel.. still probably comfortable.</span>"
	stacks = MODIFIER_STACK_EXTEND

/datum/modifier/exothermic/tick()
	..()
	if(holder.bodytemperature > T20C)
		holder.bodytemperature = round((holder.bodytemperature + T20C) / 2)

/datum/modifier/endothermic
	name = "cold resistance"
	desc = "Your body rises to room temperature."

	on_created_text = "<span class='notice'>You feel comfortable.</span>"
	on_expired_text = "<span class='notice'>You feel.. still probably comfortable.</span>"
	stacks = MODIFIER_STACK_EXTEND

/datum/modifier/endothermic/tick()
	..()
	if(holder.bodytemperature < T20C)
		holder.bodytemperature = round((holder.bodytemperature + T20C) / 2)

// Nullifies EMP.
/datum/modifier/faraday
	name = "EMP shielding"
	desc = "You are covered in some form of faraday shielding. EMPs have no effect."
	mob_overlay_state = "electricity"

	on_created_text = "<span class='notice'>You feel a surge of energy, that fades to a calm tide.</span>"
	on_expired_text = "<span class='warning'>You feel a longing for the flow of energy.</span>"
	stacks = MODIFIER_STACK_EXTEND

	emp_modifier = 5

// Nullifies explosions.
/datum/modifier/blastshield
	name = "Blast Shielding"
	desc = "You are protected from explosions somehow."
	mob_overlay_state = "electricity"

	on_created_text = "<span class='notice'>You feel a surge of energy, that fades to a stalwart hum.</span>"
	on_expired_text = "<span class='warning'>You feel a longing for the flow of energy.</span>"
	stacks = MODIFIER_STACK_EXTEND

	explosion_modifier = 3

// Kills on expiration.
/datum/modifier/doomed
	name = "Doomed"
	desc = "You are doomed."

	on_created_text = "<span class='notice'>You feel an overwhelming sense of dread.</span>"
	on_expired_text = "<span class='warning'>You feel the life drain from your body.</span>"
	stacks = MODIFIER_STACK_EXTEND

/datum/modifier/doomed/on_expire()
	if(holder.stat != DEAD)
		holder.visible_message("<span class='alien'>\The [holder] collapses, the life draining from their body.</span>")
		holder.death()

/datum/modifier/outline_test
	name = "Outline Test"
	desc = "This only exists to prove filter effects work and gives an example of how to animate() the resulting filter object."

	filter_parameters = list(type = "outline", size = 1, color = "#FFFFFF", flags = OUTLINE_SHARP)

/datum/modifier/outline_test/tick()
	animate(filter_instance, size = 3, time = 0.25 SECONDS)
	animate(size = 1, 0.25 SECONDS)


// Acts as a psuedo-godmode, yet probably is more reliable than the actual var for it nowdays.
// Can't protect from instantly killing things like singulos.
/datum/modifier/invulnerable
	name = "invulnerable"
	desc = "You are almost immune to harm, for a little while at least."
	stacks = MODIFIER_STACK_EXTEND

	disable_duration_percent = 0
	incoming_damage_percent = 0
//	bleeding_rate_percent = 0
	pain_immunity = TRUE
	armor_percent = list("melee" = 2000, "bullet" = 2000, "laser" = 2000, "bomb" = 2000, "energy" = 2000, "bio" = 2000, "rad" = 2000)
	heat_protection = 1.0
	cold_protection = 1.0
	siemens_coefficient = 0.0

// Reduces resistance to "elements".
// Note that most things that do give resistance gives 100% protection,
// and due to multiplicitive stacking, this modifier won't do anything to change that.
/datum/modifier/elemental_vulnerability
	name = "elemental vulnerability"
	desc = "You're more vulnerable to extreme temperatures and electricity."
	stacks = MODIFIER_STACK_EXTEND

	heat_protection = -0.5
	cold_protection = -0.5
	siemens_coefficient = 1.5

/datum/modifier/entangled
	name = "entangled"
	desc = "Its hard to move."

	on_created_text = "<span class='danger'>You're caught in something! It's hard to move.</span>"
	on_expired_text = "<span class='warning'>Your movement is freed.</span>"
	stacks = MODIFIER_STACK_EXTEND

	slowdown = 2
