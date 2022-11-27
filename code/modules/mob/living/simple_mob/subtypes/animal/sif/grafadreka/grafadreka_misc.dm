/datum/modifier/sifsap_salve
	name = "Sifsap Salve"
	desc = "Your wounds have been salved with Sivian sap."
	mob_overlay_state = "cyan_sparkles"
	stacks = MODIFIER_STACK_FORBID
	on_created_text = "<span class = 'notice'>The glowing sap seethes and bubbles in your wounds, tingling and stinging.</span>"
	on_expired_text = "<span class = 'notice'>The last of the sap in your wounds fizzles away.</span>"


/datum/modifier/sifsap_salve/tick()
	if (holder.stat == DEAD || holder.isSynthetic())
		expire()
	if (istype(holder, /mob/living/simple_mob/animal/sif))
		var/mob/living/simple_mob/animal/sif/critter = holder
		if (critter.health >= (critter.getMaxHealth() * critter.sap_heal_threshold))
			return
		if (holder.resting)
			if (istype(holder.loc, /obj/structure/animal_den))
				holder.adjustBruteLoss(-3)
				holder.adjustFireLoss(-3)
				holder.adjustToxLoss(-2)
			else
				holder.adjustBruteLoss(-2)
				holder.adjustFireLoss(-2)
				holder.adjustToxLoss(-1)
		else
			holder.adjustBruteLoss(-1)
			holder.adjustFireLoss(-1)


/datum/category_item/catalogue/fauna/grafadreka
	name = "Sivian Fauna - Grafadreka"
	desc = {"Classification: S tesca pabulator
<br><br>
The reclusive grafadreka (Icelandic, lit. 'digging dragon'), also known as the snow drake, is a large reptillian pack predator similar in size and morphology to old Earth hyenas. They commonly dig shallow dens in dirt, snow or foliage, sometimes using them for concealment prior to an ambush. Biological cousins to the elusive kururak, they have heavy, low-slung bodies and powerful jaws suited to hunting land prey rather than fishing. Colonization and subsequent expansion have displaced many populations from their tundral territories into colder areas; as a result, their diet of Sivian prey animals has pivoted to a diet of giant spider meat.
<br><br>
Grafadrekas are capable of exerting bite pressures in excess of 900 PSI, which allows them to crack bones or carapace when scavenging for food. While they share the hypercarnivorous metabolism of their cousins, they have developed a symbiotic relationship with the bacteria responsible for the bioluminescence of Sivian trees. This assists with digesting plant matter, and gives their pelts a distinctive and eerie glow.
<br><br>
They have been observed to occasionally attack and kill colonists, generally when conditions are too poor to hunt their usual prey. Despite this, and despite their disposition being generally skittish and avoidant of colonists, some Sivian communities hold that they have been observed to guide or protect lost travellers.
<br><br>
Field studies suggest analytical abilities on par with some species of cepholapods, but their symbiotic physiology rapidly fails in captivity, making laboratory testing difficult. Their inability to make use of tools or form wider social groups beyond a handful of individuals has been hypothesised to prevent the expression of more complex social behaviors."}
	value = CATALOGUER_REWARD_HARD


/datum/say_list/grafadreka
	speak = list("Chff!", "Skhh.", "Rrrss...")
	emote_see = list("scratches its ears","grooms its spines", "sways its tail", "claws at the ground")
	emote_hear = list("hisses", "rattles", "rasps", "barks")


/decl/mob_organ_names/grafadreka
	hit_zones = list(
		"head",
		"chest",
		"left foreleg",
		"right foreleg",
		"left hind leg",
		"right hind leg",
		"face spines",
		"body spines",
		"tail spines",
		"tail"
	)


/decl/emote/audible/drake_howl
	key = "dhowl"
	emote_message_3p = "lifts USER_THEIR head up and gives an eerie howl."
	emote_sound = 'sound/effects/drakehowl_close.ogg'
	broadcast_sound ='sound/effects/drakehowl_far.ogg'
	emote_cooldown = 20 SECONDS
	broadcast_distance = 90


/decl/emote/audible/drake_howl/broadcast_emote_to(send_sound, mob/target, direction)
	. = ..()
	if (.)
		to_chat(target, SPAN_NOTICE("You hear an eerie howl from somewhere to the [dir2text(direction)]."))


/obj/item/projectile/drake_spit
	name = "drake spit"
	icon_state = "ice_1"
	damage = 0
	embed_chance = 0
	damage_type = BRUTE
	muzzle_type = null
	hud_state = "monkey"
	combustion = FALSE
	stun = 3
	weaken = 3
	eyeblur = 5
	fire_sound = 'sound/effects/splat.ogg'


/obj/item/projectile/drake_spit/weak
	stun = 0
	weaken = 0
	eyeblur = 2


/obj/structure/animal_den/ghost_join/grafadreka
	name = "drake den"
	critter = /mob/living/simple_mob/animal/sif/grafadreka


/obj/structure/animal_den/ghost_join/grafadreka_hatchling
	name = "drake hatchling den"
	critter = /mob/living/simple_mob/animal/sif/grafadreka/hatchling


/mob/living/simple_mob/animal/sif/grafadreka/rainbow/setup_colours()
	glow_colour = get_random_colour(TRUE)
	fur_colour =  get_random_colour(TRUE)
	claw_colour = get_random_colour(TRUE)
	base_colour = get_random_colour(TRUE)
	eye_colour =  get_random_colour(TRUE)
	..()
