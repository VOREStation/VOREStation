// Hooded suits

//Hoods for winter coats and chaplain hoodie etc

/obj/item/clothing/suit/storage/hooded
	var/obj/item/clothing/head/hood
	var/hoodtype = null //so the chaplain hoodie or other hoodies can override this
	var/hood_up = FALSE
	var/toggleicon
	actions_types = list(/datum/action/item_action/toggle_hood)

/obj/item/clothing/suit/storage/hooded/New()
	toggleicon = "[initial(icon_state)]"
	MakeHood()
	..()

/obj/item/clothing/suit/storage/hooded/Destroy()
	QDEL_NULL(hood)
	return ..()

/obj/item/clothing/suit/storage/hooded/proc/MakeHood()
	if(!hood)
		var/obj/item/clothing/head/hood/H = new hoodtype(src)
		hood = H

/obj/item/clothing/suit/storage/hooded/ui_action_click(mob/user, actiontype)
	ToggleHood()

/obj/item/clothing/suit/storage/hooded/equipped(mob/user, slot)
	if(slot != slot_wear_suit)
		RemoveHood()
	..()

/obj/item/clothing/suit/storage/hooded/proc/RemoveHood()
	hood_up = FALSE
	update_icon()
	if(hood)
		hood.canremove = TRUE // This shouldn't matter anyways but just incase.
		if(ishuman(hood.loc))
			var/mob/living/carbon/H = hood.loc
			H.unEquip(hood, 1)
			H.update_inv_wear_suit()
		hood.forceMove(src)

/obj/item/clothing/suit/storage/hooded/dropped(mob/user)
	RemoveHood()
	..()

/obj/item/clothing/suit/storage/hooded/proc/ToggleHood()
	if(!hood_up)
		if(ishuman(loc))
			var/mob/living/carbon/human/H = src.loc
			if(H.wear_suit != src)
				to_chat(H, span_warning("You must be wearing [src] to put up the hood!"))
				return
			if(H.head)
				to_chat(H, span_warning("You're already wearing something on your head!"))
				return
			else
				if(color != hood.color)
					hood.color = color
				H.equip_to_slot_if_possible(hood,slot_head,0,0,1)
				hood_up = TRUE
				hood.canremove = FALSE
				update_icon()
				H.update_inv_wear_suit()
	else
		RemoveHood()

/obj/item/clothing/suit/storage/hooded/update_icon()
	. = ..()
	icon_state = "[toggleicon][hood_up ? "_t" : ""]"

/obj/item/clothing/suit/storage/hooded/costume
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	flags_inv = HIDEJUMPSUIT|HIDETIE|HIDEHOLSTER
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS
	actions_types = list(/datum/action/item_action/toggle_hood)

/obj/item/clothing/suit/storage/hooded/costume/siffet
	name = "siffet costume"
	desc = "A costume made from 'synthetic' siffet fur, it smells like a weasel nest."
	icon_state = "siffet"
	item_state_slots = list(slot_r_hand_str = "siffet", slot_l_hand_str = "siffet")
	hoodtype = /obj/item/clothing/head/hood/siffet_hood

/obj/item/clothing/suit/storage/hooded/costume/carp
	name = "carp costume"
	desc = "A costume made from 'synthetic' carp scales, it smells."
	icon_state = "carp_casual"
	item_state_slots = list(slot_r_hand_str = "carp_casual", slot_l_hand_str = "carp_casual") //Does not exist -S2-
	hoodtype = /obj/item/clothing/head/hood/carp_hood
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE	//Space carp like space, so you should too

/obj/item/clothing/suit/storage/hooded/costume/ian	//It's Ian, rub his bell- oh god what happened to his inside parts?
	name = "corgi costume"
	desc = "A costume that looks like someone made a human-like corgi, it won't guarantee belly rubs."
	icon_state = "ian"
	item_state_slots = list(slot_r_hand_str = "ian", slot_l_hand_str = "ian") //Does not exist -S2-
	hoodtype = /obj/item/clothing/head/hood/ian_hood

// winter coats go here

/obj/item/clothing/suit/storage/hooded/wintercoat
	name = "winter coat"
	desc = "A heavy jacket made from 'synthetic' animal furs."
	icon_state = "coatwinter"
	item_state_slots = list(slot_r_hand_str = "coatwinter", slot_l_hand_str = "coatwinter")
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	flags_inv = HIDEHOLSTER
	cold_protection = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	hoodtype = /obj/item/clothing/head/hood/winter
	allowed = list(/obj/item/pen, /obj/item/paper, /obj/item/flashlight, /obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes,
	/obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask, /obj/item/suit_cooling_unit)

/obj/item/clothing/suit/storage/hooded/wintercoat/captain
	name = "site manager's winter coat"
	desc = "A heavy jacket made from the most expensive animal furs on the market and sewn with the finest of jewels. Truly a coat befitting a Manager."
	icon_state = "coatcaptain"
	item_state_slots = list(slot_r_hand_str = "coatcaptain", slot_l_hand_str = "coatcaptain")
	armor = list(melee = 20, bullet = 15, laser = 20, energy = 10, bomb = 15, bio = 0, rad = 0)
	hoodtype = /obj/item/clothing/head/hood/winter/captain
	allowed =  list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight, /obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes,
	/obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask, /obj/item/suit_cooling_unit, /obj/item/gun/energy,
	/obj/item/reagent_containers/spray/pepper, /obj/item/gun/projectile, /obj/item/ammo_magazine, /obj/item/ammo_casing, /obj/item/melee/baton,
	/obj/item/handcuffs, /obj/item/clothing/head/helmet)

/obj/item/clothing/suit/storage/hooded/wintercoat/hop
	name = "head of personnel's winter coat"
	desc = "A cozy winter coat, covered in thick fur. The breast features a proud yellow chevron, reminding everyone that you're the second banana."
	icon_state = "coathop"
	armor = list(melee = 5, bullet = 0, laser = 0, energy = 0, bomb = 5, bio = 5, rad = 0)
	hoodtype = /obj/item/clothing/head/hood/winter/hop
	allowed =  list (/obj/item/pen, /obj/item/paper, /obj/item/flashlight, /obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes,
	/obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask, /obj/item/suit_cooling_unit, /obj/item/gun/energy,
	/obj/item/reagent_containers/spray/pepper, /obj/item/gun/projectile, /obj/item/ammo_magazine, /obj/item/ammo_casing, /obj/item/melee/baton,
	/obj/item/handcuffs, /obj/item/clothing/head/helmet)

/obj/item/clothing/suit/storage/hooded/wintercoat/security
	name = "security winter coat"
	desc = "A heavy jacket made from greyshirt hide. There seems to be a sewed in holster, as well as a thin weave of protection against most damage."
	icon_state = "coatsecurity"
	item_state_slots = list(slot_r_hand_str = "coatsecurity", slot_l_hand_str = "coatsecurity")
	armor = list(melee = 25, bullet = 20, laser = 20, energy = 15, bomb = 20, bio = 0, rad = 0)
	hoodtype = /obj/item/clothing/head/hood/winter/security
	allowed = list(/obj/item/pen, /obj/item/paper, /obj/item/flashlight, /obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes,
	/obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask, /obj/item/suit_cooling_unit, /obj/item/gun/energy,
	/obj/item/reagent_containers/spray/pepper, /obj/item/gun/projectile, /obj/item/ammo_magazine, /obj/item/ammo_casing, /obj/item/melee/baton,
	/obj/item/handcuffs, /obj/item/clothing/head/helmet, /obj/item/clothing/mask/gas)

/obj/item/clothing/suit/storage/hooded/wintercoat/security/hos
	name = "head of security's winter coat"
	desc = "A heavy jacket made from greyshirt hide. There seems to be a sewed in holster, as well as a thin weave of protection against most damage."
	icon_state = "coathos"
	armor = list(melee = 30, bullet = 20, laser = 20, energy = 20, bomb = 20, bio = 0, rad = 0)
	hoodtype = /obj/item/clothing/head/hood/winter/security/hos
	allowed = list(/obj/item/pen, /obj/item/paper, /obj/item/flashlight, /obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes,
	/obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask, /obj/item/suit_cooling_unit, /obj/item/gun/energy,
	/obj/item/reagent_containers/spray/pepper, /obj/item/gun/projectile, /obj/item/ammo_magazine, /obj/item/ammo_casing, /obj/item/melee/baton,
	/obj/item/handcuffs, /obj/item/clothing/head/helmet, /obj/item/clothing/mask/gas)

/obj/item/clothing/suit/storage/hooded/wintercoat/medical
	name = "medical winter coat"
	desc = "A heavy jacket made from 'synthetic' animal furs. There's a thick weave of sterile material, good for virus outbreaks!"
	icon_state = "coatmedical"
	item_state_slots = list(slot_r_hand_str = "coatmedical", slot_l_hand_str = "coatmedical")
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 0)
	hoodtype = /obj/item/clothing/head/hood/winter/medical
	allowed = list(/obj/item/pen, /obj/item/paper, /obj/item/flashlight, /obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes,
	/obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask, /obj/item/suit_cooling_unit, /obj/item/analyzer, /obj/item/stack/medical,
	/obj/item/dnainjector, /obj/item/reagent_containers/dropper, /obj/item/reagent_containers/syringe, /obj/item/reagent_containers/hypospray,
	/obj/item/healthanalyzer, /obj/item/reagent_containers/glass/bottle, /obj/item/reagent_containers/glass/beaker,
	/obj/item/reagent_containers/pill, /obj/item/storage/pill_bottle, /obj/item/clothing/mask/gas)

/obj/item/clothing/suit/storage/hooded/wintercoat/medical/alt
	name = "medical winter coat, alt"
	desc = "A heavy jacket made from 'synthetic' animal furs. There's a thick weave of sterile material, good for virus outbreaks!"
	icon_state = "coatmedicalalt"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 0)
	hoodtype = /obj/item/clothing/head/hood/winter/medical/alt

/obj/item/clothing/suit/storage/hooded/wintercoat/medical/viro
	name = "virologist winter coat"
	desc = "A white winter coat with green markings. Warm, but wont fight off the common cold or any other disease. Might make people stand far away from you in the hallway. The zipper tab looks like an oversized bacteriophage."
	icon_state = "coatviro"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 0)
	hoodtype = /obj/item/clothing/head/hood/winter/medical/viro

/obj/item/clothing/suit/storage/hooded/wintercoat/medical/para
	name = "paramedic winter coat"
	desc = "A heavy jacket made from 'synthetic' animal furs.It has an aura of underappreciation."
	icon_state = "coatpara"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 0)
	hoodtype = /obj/item/clothing/head/hood/winter/medical/para

/obj/item/clothing/suit/storage/hooded/wintercoat/medical/chemist
	name = "chemist winter coat"
	desc = "A lab-grade winter coat made with acid resistant polymers. For the enterprising chemist who was exiled to a frozen wasteland on the go."
	icon_state = "coatchemist"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 0)
	hoodtype = /obj/item/clothing/head/hood/winter/medical/chemist

/obj/item/clothing/suit/storage/hooded/wintercoat/medical/cmo
	name = "chief medical officer's winter coat"
	desc = "A lab-grade winter coat made with acid resistant polymers. For the enterprising chemist who was exiled to a frozen wasteland on the go."
	icon_state = "coatcmo"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 0)
	hoodtype = /obj/item/clothing/head/hood/winter/medical/cmo

/obj/item/clothing/suit/storage/hooded/wintercoat/medical/sar
	name = "search and rescue winter coat"
	desc = "A heavy winter jacket. A white star of life is emblazoned on the back, with the words search and rescue written underneath."
	icon_state = "coatsar"
	armor = list(melee = 15, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 5)
	hoodtype = /obj/item/clothing/head/hood/winter/medical/sar //VOREStation edit: sar winter hood
	allowed = list (/obj/item/gun, /obj/item/pen, /obj/item/paper, /obj/item/flashlight, /obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes,
	/obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask, /obj/item/suit_cooling_unit, /obj/item/analyzer, /obj/item/stack/medical,
	/obj/item/dnainjector, /obj/item/reagent_containers/dropper, /obj/item/reagent_containers/syringe, /obj/item/reagent_containers/hypospray,
	/obj/item/healthanalyzer, /obj/item/reagent_containers/glass/bottle, /obj/item/reagent_containers/glass/beaker,
	/obj/item/reagent_containers/pill, /obj/item/storage/pill_bottle, /obj/item/clothing/mask/gas)

/obj/item/clothing/suit/storage/hooded/wintercoat/science
	name = "science winter coat"
	desc = "A heavy jacket made from 'synthetic' animal furs. It has a small tag that says 'Bomb Proof! (Not fully bomb proof)'."
	icon_state = "coatscience"
	item_state_slots = list(slot_r_hand_str = "coatscience", slot_l_hand_str = "coatscience")
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 10, bio = 0, rad = 0)
	hoodtype = /obj/item/clothing/head/hood/winter/science
	allowed = list(/obj/item/pen, /obj/item/paper, /obj/item/flashlight, /obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes,
	/obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask, /obj/item/suit_cooling_unit, /obj/item/analyzer,/obj/item/stack/medical,
	/obj/item/dnainjector, /obj/item/reagent_containers/dropper, /obj/item/reagent_containers/syringe, /obj/item/reagent_containers/hypospray,
	/obj/item/healthanalyzer, /obj/item/reagent_containers/glass/bottle, /obj/item/reagent_containers/glass/beaker,
	/obj/item/reagent_containers/pill, /obj/item/storage/pill_bottle)

/obj/item/clothing/suit/storage/hooded/wintercoat/science/robotics
	name = "robotics winter coat"
	desc = "A black winter coat with a badass flaming robotic skull for the zipper tab. This one has bright red designs and a few useless buttons."
	icon_state = "coatrobotics"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 10, bio = 0, rad = 0)
	hoodtype = /obj/item/clothing/head/hood/winter/science/robotics

/obj/item/clothing/suit/storage/hooded/wintercoat/science/rd
	name = "research director's winter coat"
	desc = "A thick arctic winter coat with an outdated atomic model instead of a plastic zipper tab. Most in the know are heavily aware that Bohr's model of the atom was outdated by the time of the 1930s when the Heisenbergian and Schrodinger models were generally accepted for true. Nevertheless, we still see its use in anachronism, roleplaying, and, in this case, as a zipper tab. At least it should keep you warm on your ivory pillar."
	icon_state = "coatrd"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 20, bio = 0, rad = 0)
	hoodtype = /obj/item/clothing/head/hood/winter/science/rd

/obj/item/clothing/suit/storage/hooded/wintercoat/engineering
	name = "engineering winter coat"
	desc = "A heavy jacket made from 'synthetic' animal furs. There seems to be a thin weave of lead on the inside."
	icon_state = "coatengineer"
	item_state_slots = list(slot_r_hand_str = "coatengineer", slot_l_hand_str = "coatengineer")
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 20)
	hoodtype = /obj/item/clothing/head/hood/winter/engineering
	allowed = list(/obj/item/pen, /obj/item/paper, /obj/item/flashlight, /obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes,
	/obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask, /obj/item/suit_cooling_unit, /obj/item/analyzer, /obj/item/flashlight,
	/obj/item/multitool, /obj/item/pipe_painter, /obj/item/radio, /obj/item/t_scanner, /obj/item/tool/crowbar, /obj/item/tool/screwdriver,
	/obj/item/weldingtool, /obj/item/tool/wirecutters, /obj/item/tool/wrench, /obj/item/tank/emergency/oxygen, /obj/item/clothing/mask/gas, /obj/item/taperoll/engineering, /obj/item/clothing/head/hardhat) //please engineers take your hardhat with you I beg of you

/obj/item/clothing/suit/storage/hooded/wintercoat/engineering/atmos
	name = "atmospherics winter coat"
	desc = "A heavy jacket made from 'synthetic' animal furs. It seems to have burn marks on the inside from a phoron fire."
	icon_state = "coatatmos"
	item_state_slots = list(slot_r_hand_str = "coatatmos", slot_l_hand_str = "coatatmos")
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 20)
	hoodtype = /obj/item/clothing/head/hood/winter/engineering/atmos

/obj/item/clothing/suit/storage/hooded/wintercoat/engineering/ce
	name = "chief engineer's winter coat"
	desc = "A heavy jacket made from 'synthetic' animal furs. It seems to have burn marks on the inside from a phoron fire."
	icon_state = "coatce"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 20)
	hoodtype = /obj/item/clothing/head/hood/winter/engineering/ce

/obj/item/clothing/suit/storage/hooded/wintercoat/hydro
	name = "hydroponics winter coat"
	desc = "A heavy jacket made from synthetic animal furs. There's a small tag that says 'Vegan Friendly'."
	icon_state = "coathydro"
	item_state_slots = list(slot_r_hand_str = "coathydro", slot_l_hand_str = "coathydro")
	hoodtype = /obj/item/clothing/head/hood/winter/hydro
	allowed = list(/obj/item/pen, /obj/item/paper, /obj/item/flashlight, /obj/item/tank/emergency/oxygen,
	/obj/item/storage/fancy/cigarettes, /obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask,
	/obj/item/suit_cooling_unit, /obj/item/reagent_containers/spray/plantbgone, /obj/item/analyzer/plant_analyzer, /obj/item/seeds,
	/obj/item/reagent_containers/glass/bottle, /obj/item/material/minihoe)

/obj/item/clothing/suit/storage/hooded/wintercoat/cargo
	name = "cargo winter coat"
	desc = "A heavy jacket made from 'synthetic' animal furs. It seems to be rather rugged, from the back-breaking work of pushing crates."
	icon_state = "coatcargo"
	item_state_slots = list(slot_r_hand_str = "coatcargo", slot_l_hand_str = "coatcargo")
	hoodtype = /obj/item/clothing/head/hood/winter/cargo

/obj/item/clothing/suit/storage/hooded/wintercoat/cargo/qm
	name = "quartermaster's winter coat"
	desc = "A dark brown winter coat that has a golden crate pin for its zipper pully."
	icon_state = "coatqm"
	armor = list(melee = 10, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	hoodtype = /obj/item/clothing/head/hood/winter/cargo/qm

/obj/item/clothing/suit/storage/hooded/wintercoat/miner
	name = "mining winter coat"
	desc = "A heavy jacket made from real animal furs. The miner who made this must have been through the Underdark."
	icon_state = "coatminer"
	item_state_slots = list(slot_r_hand_str = "coatminer", slot_l_hand_str = "coatminer")
	armor = list(melee = 10, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	hoodtype = /obj/item/clothing/head/hood/winter/cargo/miner
	allowed = list(/obj/item/pen, /obj/item/paper, /obj/item/flashlight, /obj/item/storage/fancy/cigarettes,
	/obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask, /obj/item/suit_cooling_unit,
	/obj/item/tank, /obj/item/radio, /obj/item/pickaxe, /obj/item/storage/bag/ore, /obj/item/clothing/mask/gas)

/obj/item/clothing/suit/storage/hooded/wintercoat/bar
	name = "bartender winter coat"
	desc = "A heavy jacket made from 'synthetic' animal furs. It smells of booze."
	icon_state = "coatbar"
	hoodtype = /obj/item/clothing/head/hood/winter/bar

/obj/item/clothing/suit/storage/hooded/wintercoat/janitor
	name = "janitor winter coat"
	desc = "A purple-and-beige winter coat that smells of space cleaner."
	icon_state = "coatjanitor"
	hoodtype = /obj/item/clothing/head/hood/winter/janitor

/obj/item/clothing/suit/storage/hooded/wintercoat/aformal
	name = "assistant formal winter coat"
	desc = "A black button up winter coat."
	icon_state = "coataformal"
	hoodtype = /obj/item/clothing/head/hood/winter/aformal

/obj/item/clothing/suit/storage/hooded/wintercoat/ratvar
	name = "brassy winter coat"
	desc = "A softly-glowing, brass-colored button up winter coat. Instead of a zipper tab, it has a brass cog with a tiny red gemstone inset."
	icon_state = "coatratvar"
	hoodtype = /obj/item/clothing/head/hood/winter/ratvar
	light_range = 3
	light_power = 1
	light_color = "#B18B25" //clockwork slab background top color
	light_on = TRUE

/obj/item/clothing/suit/storage/hooded/wintercoat/narsie
	name = "runed winter coat"
	desc = "A somber button-up in tones of grey entropy and a wicked crimson zipper. When pulled all the way up, the zipper looks like a bloody gash. The zipper pull looks like a single drop of blood."
	icon_state = "coatnarsie"
	hoodtype = /obj/item/clothing/head/hood/winter/narsie

/obj/item/clothing/suit/storage/hooded/wintercoat/cosmic
	name = "cosmic winter coat"
	desc = "A starry winter coat that even glows softly."
	icon_state = "coatcosmic"
	hoodtype = /obj/item/clothing/head/hood/winter/cosmic
	light_power = 1.8
	light_range = 1.2
	light_on = TRUE

/obj/item/clothing/suit/storage/hooded/wintercoat/christmasred
	name = "red christmas winter coat"
	desc = "A festive red Christmas coat! Smells like Candy Cane!"
	icon_state = "coatchristmasr"
	hoodtype = /obj/item/clothing/head/hood/winter/christmasred

/obj/item/clothing/suit/storage/hooded/wintercoat/christmasgreen
	name = "green christmas winter coat"
	desc = "A festive green Christmas coat! Smells like Candy Cane!"
	icon_state = "coatchristmasg"
	hoodtype = /obj/item/clothing/head/hood/winter/christmasgreen

// winter coats end here

/obj/item/clothing/suit/storage/hooded/explorer
	name = "explorer suit"
	desc = "An armoured suit for exploring harsh environments."
	icon_state = "explorer"
	item_state = "explorer"
	flags = THICKMATERIAL
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	cold_protection = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	hoodtype = /obj/item/clothing/head/hood/explorer
	siemens_coefficient = 0.9
	armor = list(melee = 30, bullet = 20, laser = 20, energy = 20, bomb = 35, bio = 75, rad = 35) // Inferior to sec vests in bullet/laser but better for environmental protection.
	allowed = list(
		/obj/item/flashlight,
		/obj/item/gun,
		/obj/item/ammo_magazine,
		/obj/item/melee,
		/obj/item/material/knife,
		/obj/item/tank,
		/obj/item/radio,
		/obj/item/pickaxe
		)

/obj/item/clothing/suit/storage/hooded/techpriest
	name = "techpriest robes"
	desc = "For those who REALLY love their toasters."
	icon_state = "techpriest"
	hoodtype = /obj/item/clothing/head/hood/techpriest

/obj/item/clothing/suit/storage/hooded/raincoat
    name = "raincoat"
    desc = "A thin, opaque coat meant to protect you from all sorts of rain. Preferred by outdoorsmen and janitors alike across the rift. Of course, the only type of fluids you'd like to protect yourself from around this place don't rain down from the sky. Usually. Comes with a hood!"
    icon_state = "raincoat"
    body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
    flags_inv = HIDEHOLSTER
    hoodtype = /obj/item/clothing/head/hood/raincoat
    allowed = list(/obj/item/pen, /obj/item/paper, /obj/item/flashlight, /obj/item/tank/emergency/oxygen, /obj/item/storage/fancy/cigarettes,
	/obj/item/storage/box/matches, /obj/item/reagent_containers/food/drinks/flask, /obj/item/suit_cooling_unit)


//hooded cloaks
/obj/item/clothing/suit/storage/hooded/cloak
    name = "hooded maroon cloak"
    desc = "A simple maroon colored cloak."
    icon_state = "maroon_cloak"
    body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
    hoodtype = /obj/item/clothing/head/hood/cloak

/obj/item/clothing/suit/storage/hooded/cloak/winter
    name = "hooded winter cloak"
    desc = "A simple wool cloak used during winter."
    icon_state = "winter_cloak"
    hoodtype = /obj/item/clothing/head/hood/cloak/winter

/obj/item/clothing/suit/storage/hooded/cloak/asymmetric
    name = "hooded asymmetric cloak"
    desc = "A blue hooded cloak with an asymmetric design."
    icon_state = "asymmetric_cloak"
    hoodtype = /obj/item/clothing/head/hood/cloak/asymmetric


/obj/item/clothing/suit/storage/hooded/cloak/fancy
    name = "hooded fancy cloak"
    desc = "A fancy black hooded cloak."
    icon_state = "hb_cloak"
    hoodtype = /obj/item/clothing/head/hood/cloak/fancy
