/*
 * Modifiers originating from cult runes, spells, or pylons are kept here.
 */


////////// Self-Enhancing
/datum/modifier/fortify
	name = "fortified body"
	desc = "You are taking less damage from outside sources."

	on_created_text = "<span class='critical'>Your body becomes a mountain to your enemies' storm.</span>"
	on_expired_text = "<span class='notice'>Your body softens, returning to its regular durability.</span>"
	stacks = MODIFIER_STACK_EXTEND

	disable_duration_percent = 0.25			// Disables only last 25% as long.
	incoming_damage_percent = 0.5			// 50% incoming damage.
	icon_scale_x_percent = 1.2				// Become a bigger target.
	icon_scale_y_percent = 1.2
	pain_immunity = TRUE

	slowdown = 2
	evasion = -20

/datum/modifier/ambush
	name = "phased"
	desc = "You are partially shifted from the material plane."

	on_created_text = "<span class='critical'>Your body pulses, before partially dematerializing.</span>"
	on_expired_text = "<span class='notice'>Your body rematerializes fully.</span>"

	stacks = MODIFIER_STACK_FORBID

	incoming_damage_percent = 0.1			// 10% incoming damage. You're not all there.
	outgoing_melee_damage_percent = 0		// 0% outgoing damage. Be prepared.
	pain_immunity = TRUE

	evasion = 50							//Luckily, not being all there means you're actually hard to hit with a gun.

/datum/modifier/ambush/on_applied()
	holder.alpha = 30
	return

// Override this for special effects when it gets removed.
/datum/modifier/ambush/on_expire()
	holder.alpha = 255
	return

////////// On-hit
/datum/modifier/deep_wounds
	name = "deep wounds"
	desc = "Your wounds are mysteriously harder to mend."

	on_created_text = "<span class='cult'>Your wounds pain you greatly.</span>"
	on_expired_text = "<span class='notice'>Your wounds numb for a moment.</span>"

	stacks = MODIFIER_STACK_EXTEND

	incoming_healing_percent = 0.66 // 34% less healing.
	disable_duration_percent = 1.22 // 22% longer disables.


////////// Auras
/datum/modifier/repair_aura //This aura does not apply modifiers to individuals in the area.
	name = "aura of repair (cult)"
	desc = "You are emitting a field of strange energy, capable of repairing occult constructs."

	on_created_text = "<span class='cult'>You begin emitting an occult repair aura.</span>"
	on_expired_text = "<span class='notice'>The occult repair aura fades.</span>"
	stacks = MODIFIER_STACK_EXTEND

	mob_overlay_state = "cult_aura"

/datum/modifier/repair_aura/tick()
	spawn()
		for(var/mob/living/simple_mob/construct/T in view(4,holder))
			T.adjustBruteLoss(rand(-10,-15))
			T.adjustFireLoss(rand(-10,-15))

/datum/modifier/agonize //This modifier is used in an aura spell.
	name = "agonize"
	desc = "Your body is wracked with pain."

	on_created_text = "<span class='cult'>A red lightning quickly covers your body. The pain is horrendous.</span>"
	on_expired_text = "<span class='notice'>The lightning fades, and so too does the ongoing pain.</span>"

	stacks = MODIFIER_STACK_EXTEND

	mob_overlay_state = "red_electricity_constant"

/datum/modifier/agonize/tick()
	spawn()
		if(ishuman(holder))
			var/mob/living/human/H = holder
			H.apply_effect(20, AGONY)
			if(prob(10))
				to_chat(H, "<span class='warning'>Just make it stop!</span>")

////////// Target Modifier
/datum/modifier/mend_occult
	name = "occult mending"
	desc = "Your body is mending, though at what cost?"

	on_created_text = "<span class='cult'>Something haunting envelops your body as it begins to mend.</span>"
	on_expired_text = "<span class='notice'>The cloak of unease dissipates.</span>"

	stacks = MODIFIER_STACK_EXTEND

	mob_overlay_state = "red_electricity_constant"

/datum/modifier/mend_occult/tick()
	spawn()
		if(isliving(holder))
			var/mob/living/L = holder
			if(istype(L, /mob/living/simple_mob/construct))
				L.adjustBruteLoss(rand(-5,-10))
				L.adjustFireLoss(rand(-5,-10))
			else
				L.adjustBruteLoss(-2)
				L.adjustFireLoss(-2)

			if(ishuman(holder))
				var/mob/living/human/H = holder

				for(var/obj/item/organ/O in H.internal_organs)
					if(O.damage > 0) // Fix internal damage
						O.damage = max(O.damage - 2, 0)
					if(O.damage <= 5 && O.organ_tag == O_EYES) // Fix eyes
						H.sdisabilities &= ~BLIND

				for(var/obj/item/organ/external/O in H.organs) // Fix limbs, no matter if they are Man or Machine.
					O.heal_damage(rand(1,3), rand(1,3), internal = 1, robo_repair = 1)

				for(var/obj/item/organ/E in H.bad_external_organs) // Fix bones
					var/obj/item/organ/external/affected = E
					if((affected.damage < affected.min_broken_damage * config.organ_health_multiplier) && (affected.status & ORGAN_BROKEN))
						affected.status &= ~ORGAN_BROKEN

					for(var/datum/wound/W in affected.wounds) // Fix IB
						if(istype(W, /datum/wound/internal_bleeding))
							affected.wounds -= W
							affected.update_damages()

				H.restore_blood()
				if(!iscultist(H))
					H.apply_effect(2, AGONY)
				if(prob(10))
					to_chat(H, "<span class='danger'>It feels as though your body is being torn apart!</span>")
			L.updatehealth()

/datum/modifier/gluttonyregeneration
	name = "gluttonous regeneration"
	desc = "You are filled with an overwhelming hunger."
	mob_overlay_state = "electricity"

	on_created_text = "<span class='critical'>You feel an intense and overwhelming hunger overtake you as your body regenerates!</span>"
	on_expired_text = "<span class='notice'>The blaze of hunger inside you has been snuffed.</span>"
	stacks = MODIFIER_STACK_EXTEND

/datum/modifier/gluttonyregeneration/can_apply(var/mob/living/L)
	if(L.stat == DEAD)
		to_chat(L, "<span class='warning'>You can't be dead to consume.</span>")
		return FALSE

	if(!L.is_sentient())
		return FALSE // Drones don't feel anything, not even hunger.

	if(L.has_modifier_of_type(/datum/modifier/berserk_exhaustion))
		to_chat(L, "<span class='warning'>You recently berserked, so you are too tired to consume.</span>")
		return FALSE

	if(!ishuman(L)) // Only humanoids feel hunger. Totally.
		return FALSE

	else
		var/mob/living/human/H = L
		if(H.species.name == "Diona")
			to_chat(L, "<span class='warning'>You feel strange for a moment, but it passes.</span>")
			return FALSE // Happy trees aren't affected by incredible hunger.

	return ..()

/datum/modifier/gluttonyregeneration/tick()
	spawn()
		if(ishuman(holder))
			var/mob/living/human/H = holder
			var/starting_nutrition = H.nutrition
			H.adjust_nutrition(-10)
			var/healing_amount = starting_nutrition - H.nutrition
			if(healing_amount < 0) // If you are eating enough to somehow outpace this, congratulations, you are gluttonous enough to gain a boon.
				healing_amount *= -2

			H.adjustBruteLoss(-healing_amount * 0.25)

			H.adjustFireLoss(-healing_amount * 0.25)

			H.adjustOxyLoss(-healing_amount * 0.25)

			H.adjustToxLoss(-healing_amount * 0.25)

	..()