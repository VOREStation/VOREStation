/*
 * Defines the helmets, gloves and shoes for rigs.
 */

/obj/item/clothing/head/helmet/space/rig
	name = "helmet"
	item_flags = THICKMATERIAL|ALLOW_SURVIVALFOOD
	flags_inv = 		 HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES
	heat_protection =    HEAD|FACE|EYES
	cold_protection =    HEAD|FACE|EYES
	light_range = 4
	sprite_sheets = list(
		SPECIES_TAJARAN = 'icons/inventory/head/mob_tajaran.dmi',
		SPECIES_SKRELL = 'icons/inventory/head/mob_skrell.dmi',
		SPECIES_UNATHI = 'icons/inventory/head/mob_unathi.dmi',
		SPECIES_VOX = 'icons/inventory/head/mob_vox.dmi',
		SPECIES_TESHARI = 'icons/inventory/head/mob_teshari.dmi'
		)
	species_restricted = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_TAJARAN, SPECIES_UNATHI, SPECIES_PROMETHEAN, SPECIES_TESHARI) //vox, diona, and zaddat can't use hardsuits not designed for them
	max_pressure_protection = null
	min_pressure_protection = null

/obj/item/clothing/gloves/gauntlets/rig
	name = "gauntlets"
	flags = PHORONGUARD
	item_flags = THICKMATERIAL
	body_parts_covered = HANDS
	heat_protection =    HANDS
	cold_protection =    HANDS
	species_restricted = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_TAJARAN, SPECIES_UNATHI, SPECIES_PROMETHEAN, SPECIES_TESHARI)
	gender = PLURAL

/obj/item/clothing/shoes/magboots/rig
	name = "boots"
	body_parts_covered = FEET
	cold_protection = FEET
	heat_protection = FEET
	species_restricted = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_TAJARAN, SPECIES_UNATHI, SPECIES_PROMETHEAN, SPECIES_TESHARI)
	gender = PLURAL
	icon_base = null

/obj/item/clothing/suit/space/rig
	name = "chestpiece"
	allowed = list(/obj/item/flashlight,/obj/item/tank,/obj/item/suit_cooling_unit)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	heat_protection =	 UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	cold_protection =	 UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	flags_inv =			 HIDEJUMPSUIT|HIDETAIL
	item_flags =		 THICKMATERIAL | AIRTIGHT
	slowdown = 0
	//will reach 10 breach damage after 25 laser carbine blasts, 3 revolver hits, or ~1 PTR hit. Completely immune to smg or sts hits.
	breach_threshold = 38
	resilience = 0.2
	can_breach = 1
	sprite_sheets = list(
		SPECIES_TAJARAN = 'icons/inventory/suit/mob_tajaran.dmi',
		SPECIES_UNATHI = 'icons/inventory/suit/mob_unathi.dmi',
		SPECIES_VOX = 'icons/inventory/suit/mob_vox.dmi',
		SPECIES_TESHARI = 'icons/inventory/suit/mob_teshari.dmi'
		)
	supporting_limbs = list()
	species_restricted = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_TAJARAN, SPECIES_UNATHI, SPECIES_PROMETHEAN, SPECIES_TESHARI) //vox, diona, and zaddat can't use hardsuits not designed for them
	var/obj/item/material/knife/tacknife
	max_pressure_protection = null
	min_pressure_protection = null

/obj/item/clothing/suit/space/rig/attack_hand(var/mob/living/M)
	if(tacknife)
		tacknife.loc = get_turf(src)
		if(M.put_in_active_hand(tacknife))
			to_chat(M, span_notice("You slide \the [tacknife] out of [src]."))
			playsound(src, 'sound/weapons/flipblade.ogg', 40, 1)
			tacknife = null
			update_icon()
		return
	..()

/obj/item/clothing/suit/space/rig/attackby(var/obj/item/I, var/mob/living/M)
	if(istype(I, /obj/item/material/knife/tacknife))
		if(tacknife)
			return
		M.drop_item()
		tacknife = I
		I.loc = src
		to_chat(M, span_notice("You slide the [I] into [src]."))
		playsound(src, 'sound/weapons/flipblade.ogg', 40, 1)
		update_icon()
	..()

//TODO: move this to modules
/obj/item/clothing/head/helmet/space/rig/proc/prevent_track()
	return 0

/obj/item/clothing/gloves/gauntlets/rig/Touch(var/atom/A, var/proximity)

	if(!A || !proximity)
		return 0

	var/mob/living/carbon/human/H = loc
	if(!istype(H) || (!H.back && !H.belt))
		return 0

	var/obj/item/rig/suit = H.back
	if(!suit || !istype(suit) || !suit.installed_modules.len)
		return 0

	for(var/obj/item/rig_module/module in suit.installed_modules)
		if(module.active && module.activates_on_touch)
			if(module.engage(A))
				return 1

	return 0

//Rig pieces for non-spacesuit based rigs

/obj/item/clothing/head/lightrig
	name = "mask"
	body_parts_covered = HEAD|FACE|EYES
	heat_protection =    HEAD|FACE|EYES
	cold_protection =    HEAD|FACE|EYES
	flags =              THICKMATERIAL|AIRTIGHT
	species_restricted = null

/obj/item/clothing/suit/lightrig
	name = "suit"
	allowed = list(/obj/item/flashlight)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	heat_protection =    UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	cold_protection =    UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	flags_inv =          HIDEJUMPSUIT
	flags =              THICKMATERIAL
	species_restricted = null

/obj/item/clothing/shoes/lightrig
	name = "boots"
	body_parts_covered = FEET
	cold_protection = FEET
	heat_protection = FEET
	species_restricted = null
	gender = PLURAL

/obj/item/clothing/gloves/gauntlets/lightrig
	name = "gloves"
	flags = THICKMATERIAL
	body_parts_covered = HANDS
	heat_protection =    HANDS
	cold_protection =    HANDS
	species_restricted = null
	gender = PLURAL
