// Space carp show up as a random event to wreck hapless people in space or near windows.
// They generally fit the archetype of 'fast but fragile'.
// This is compensated by being in groups (usually).

/datum/category_item/catalogue/fauna/carp
	name = "Voidborne Fauna - Space Carp"
	desc = "A strange descendant of some form of voidborne life, they are the most \
	common naturally void-faring lifeform found in human territory. They've been named \
	'Space Carp' by various groups of spacers due to resembling the fish from Earth.\
	<br><br>\
	Their lifecycle begins as a fungus-like growth, sometimes found on the walls of spacecraft \
	and space stations, before growing into a form which allows for independent travel. Even \
	when fully grown, they can sometimes be found to stow away on the hulls of spaceborne objects, \
	which might explain how they became widespread across many star systems.\
	<br><br>\
	Carp have a special gas bladder inside of them, which they utilize as a means of movement in \
	space by stategically releasing the gas to propel themselves in a process that resembles \
	thrusters on a spacecraft. The gas contained inside the carp also allows them \
	to float when inside an atmosphere. The carp might also spray 'spores' using a similar method.\
	<br><br>\
	They are hypercarnivorous to the point of cannibalism, consuming their own dead in order to \
	sustain themselves during hard times, which are rather frequent due to their prey being \
	vastly technologically advanced. For human habitats that are well secured, carp are generally \
	an annoyance. For those unable to adequately protect themselves, however, they can be \
	rather dangerous, especially if a mass migration of carp arrives."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/animal/space/carp
	name = "space carp"
	desc = "A ferocious, fang-bearing creature that resembles a fish."
	catalogue_data = list(/datum/category_item/catalogue/fauna/carp)
	icon_state = "carp"
	icon_living = "carp"
	icon_dead = "carp_dead"
	icon_gib = "carp_gib"

	faction = FACTION_CARP
	maxHealth = 25
	health = 25
	movement_cooldown = -2
	hovering = TRUE

	response_help = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm = "hits the"

	melee_damage_lower = 7 // About 14 DPS.
	melee_damage_upper = 7
	base_attack_cooldown = 10 // One attack a second.
	attack_sharp = TRUE
	attack_sound = 'sound/weapons/bite.ogg'
	attacktext = list("bitten")

	organ_names = /decl/mob_organ_names/fish

	meat_amount = 5
	meat_type = /obj/item/reagent_containers/food/snacks/carpmeat

	ai_holder_type = /datum/ai_holder/simple_mob/melee

	var/knockdown_chance = 15

/mob/living/simple_mob/animal/space/carp/apply_melee_effects(var/atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(prob(knockdown_chance))
			L.Weaken(3)
			L.visible_message(span_danger("\The [src] knocks down \the [L]!"))

// Subtypes.

// Won't wander away.
/mob/living/simple_mob/animal/space/carp/event
	ai_holder_type = /datum/ai_holder/simple_mob/event


/mob/living/simple_mob/animal/space/carp/large
	name = "elder carp"
	desc = "An older, more matured carp. Few survive to this age due to their aggressiveness."
	icon = 'icons/mob/64x32.dmi'
	icon_state = "shark"
	icon_living = "shark"
	icon_dead = "shark_dead"

	maxHealth = 50
	health = 50
	movement_cooldown = 1 // Slower than the younger carp.
	mob_size = MOB_LARGE

	pixel_x = -16
	default_pixel_x = -16
	icon_expected_width = 64
	icon_expected_height = 32

	meat_amount = 7


/mob/living/simple_mob/animal/space/carp/large/huge
	name = "great white carp"
	desc = "A very rare breed of carp- and a very aggressive one."
	icon = 'icons/mob/64x64.dmi'
	icon_dead = "megacarp_dead"
	icon_living = "megacarp"
	icon_state = "megacarp"

	maxHealth = 230
	health = 230
	movement_cooldown = 3

	melee_damage_lower = 15 // About 20 DPS.
	melee_damage_upper = 25

	pixel_y = -16
	default_pixel_y = -16
	icon_expected_width = 64
	icon_expected_height = 64

	meat_amount = 15

	knockdown_chance = 15

/mob/living/simple_mob/animal/space/carp/large/huge/vorny
	name = "great white carp"
	desc = "A very rare breed of carp- and a very hungry one."
	icon = 'icons/mob/64x64.dmi'
	icon_dead = "megacarp_dead"
	icon_living = "megacarp"
	icon_state = "megacarp"

	maxHealth = 230
	health = 230
	movement_cooldown = 3

	melee_damage_lower = 1 // Minimal damage to make the knockdown work.
	melee_damage_upper = 1

	pixel_y = -16
	default_pixel_y = -16
	icon_expected_width = 64
	icon_expected_height = 64

	meat_amount = 15

	knockdown_chance = 50
	ai_holder_type = /datum/ai_holder/simple_mob/vore

/mob/living/simple_mob/animal/space/carp/large/huge/vorny/init_vore()
	if(!voremob_loaded)
		return
	. = ..()
	var/obj/belly/B = vore_selected
	B.name = "stomach"
	B.desc = "You've been swallowed whole and alive by a massive white carp! The stomach around you is oppressively tight, squeezing and grinding wrinkled walls across your body, making it hard to make any movement at all. The chamber is flooded with fluids that completely overwhelm you."
	B.mode_flags = DM_FLAG_THICKBELLY
	B.belly_fullscreen = "yet_another_tumby"
	B.digest_brute = 2
	B.digest_burn = 2
	B.digest_oxy = 1
	B.digestchance = 100
	B.absorbchance = 0
	B.escapechance = 3
	B.selective_preference = DM_DIGEST
	B.escape_stun = 10

/mob/living/simple_mob/animal/space/carp/holographic
	name = "holographic carp"
	desc = "An obviously holographic, but still ferocious looking carp."
	// Might be worth using a filter similar to AI holograms in the future.
	icon = 'icons/mob/AI.dmi'
	icon_state = "holo4"
	icon_living = "holo4"
	icon_dead = "holo4"
	alpha = 127
	icon_gib = null
	meat_amount = 0
	meat_type = null

	mob_class = MOB_CLASS_PHOTONIC // Xeno-taser won't work on this as its not a 'real' carp.

/mob/living/simple_mob/animal/space/carp/holographic/Initialize(mapload)
	set_light(2) // Hologram lighting.
	return ..()

// Presumably the holodeck emag code requires this.
// Pass TRUE to make safe. Pass FALSE to make unsafe.
/mob/living/simple_mob/animal/space/carp/holographic/proc/set_safety(safe)
	if(!isnull(get_AI_stance())) // Will return null if lacking an AI holder or a player is controlling it w/o autopilot var.
		ai_holder.hostile = !safe // Inverted so safe = TRUE means hostility = FALSE.
		ai_holder.forget_everything() // Reset state so it'll stop chewing on its target.

// Called on death.
/mob/living/simple_mob/animal/space/carp/holographic/proc/derez()
	visible_message(span_notice("\The [src] fades away!"))
	qdel(src)

/mob/living/simple_mob/animal/space/carp/holographic/gib()
	derez() // Holograms can't gib.

/mob/living/simple_mob/animal/space/carp/holographic/death()
	..()
	derez()

// a slow-moving carp with the appearance of a sea mine and behaviour of a sea mine
/mob/living/simple_mob/animal/space/carp/puffer
	name = "puffercarp"
	desc = "A bloated, inflated carp covered in spines."
	catalogue_data = list(/datum/category_item/catalogue/fauna/carp, /datum/category_item/catalogue/fauna/carp/puffer)
	icon_state = "puffercarp"
	icon_living = "puffercarp"
	icon_dead = "puffercarp_dead"
	icon_gib = "generic_gib"
	movement_cooldown = 15
	var/ready_to_blow = TRUE

/datum/category_item/catalogue/fauna/carp/puffer
	name = "Voidborne Fauna - Space Carp: puffer variant"
	desc = "An unusual subspecies of space carp with a novel defensive \
	and reproductive strategy - once the puffercarp is ready to spread spores \
	it begins to produce a highly volatile compound within its gas bladders, \
	which in addition to providing them with a means of propulsion through space \
	as per most space carp species, affords the puffercarp with a somewhat unique trait \
	- namely, that they are able to ignite and detonate their gas bladders \
	at will, and will do so aggressively when threatened. The bladders also tend to ignite \
	when struck by thermal or electrical discharges, or even sympathetic detonation from \
	other explosives - including other nearby puffercarp. As a result, most voidborne \
	predators have a tendency to keep clear, but even if this deterrent doesn't work the resulting \
	explosion serves to scatter their spores over a massive area - this improved seeding \
	strategy compared to regular carp results in the propagation of the species despite the \
	fact that it means each adult carp can only reproduce exactly once. \
	<br><br>\
	Due to their premature mortality it is extremely rare to see a puffercarp grow to any notable \
	size, often appearing to be somewhat stunted in growth compared to other subspecies, \
	their gas bloating being the only thing that brings them close to \
	the normal scale of an adult carp. "
	value = CATALOGUER_REWARD_HARD //if you can hang around close enough to this thing without setting it off, you deserve it

/mob/living/simple_mob/animal/space/carp/puffer/proc/kaboom()
	if(ready_to_blow)
		ready_to_blow = FALSE
		gib()
		var/turf/T = get_turf(src)
		explosion(T, -1, -1, 4, 4)


/mob/living/simple_mob/animal/space/carp/puffer/apply_melee_effects() //it gets close enough to attack? EXPLODE
	kaboom()

/mob/living/simple_mob/animal/space/carp/puffer/adjustFireLoss(var/amount,var/include_robo) //you make it hot? EXPLODE
	if(amount>0)
		kaboom()
	..()

/mob/living/simple_mob/animal/space/carp/puffer/ex_act() //explode? YOU BETTER BELIEVE THAT'S AN EXPLODE
	kaboom()
