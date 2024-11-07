//Generic Ring

/obj/item/clothing/accessory/ring
	name = "generic ring"
	desc = "Torus shaped finger decoration."
	icon_state = "material"
	drop_sound = 'sound/items/drop/ring.ogg'
	slot = ACCESSORY_SLOT_RING
	slot_flags = SLOT_GLOVES
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_gloves.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_gloves.dmi',
		)
	gender = PLURAL
	w_class = ITEMSIZE_SMALL
	icon = 'icons/inventory/hands/item.dmi'
	drop_sound = 'sound/items/drop/ring.ogg'
	pickup_sound = 'sound/items/pickup/ring.ogg'
	force = 2
	siemens_coefficient = 1

/////////////////////////////////////////
//Standard Rings
/obj/item/clothing/accessory/ring/engagement
	name = "engagement ring"
	desc = "An engagement ring. It certainly looks expensive."
	icon_state = "diamond"

/obj/item/clothing/accessory/ring/engagement/attack_self(mob/user)
	user.visible_message(span_warning("\The [user] gets down on one knee, presenting \the [src]."),span_warning("You get down on one knee, presenting \the [src]."))

/obj/item/clothing/accessory/ring/cti
	name = "CTI ring"
	desc = "A ring commemorating graduation from CTI."
	icon_state = "cti-grad"

/obj/item/clothing/accessory/ring/mariner
	name = "Mariner University ring"
	desc = "A ring commemorating graduation from Mariner University."
	icon_state = "mariner-grad"


/////////////////////////////////////////
//Reagent Rings

/obj/item/clothing/accessory/ring/reagent
	flags = OPENCONTAINER
	origin_tech = list(TECH_MATERIAL = 2, TECH_ILLEGAL = 4)

/obj/item/clothing/accessory/ring/reagent/Initialize()
	. = ..()
	create_reagents(15)

/obj/item/clothing/accessory/ring/reagent/equipped(var/mob/living/carbon/human/H)
	..()
	if(istype(H) && H.gloves==src)

		if(reagents.total_volume)
			to_chat(H, span_danger("You feel a prick as you slip on \the [src]."))
			if(H.reagents)
				var/contained = reagents.get_reagents()
				var/trans = reagents.trans_to_mob(H, 15, CHEM_BLOOD)
				add_attack_logs(usr, H, "Injected with [name] containing [contained] transferred [trans] units")
	return

//Sleepy Ring
/obj/item/clothing/accessory/ring/reagent/sleepy
	name = "silver ring"
	desc = "A ring made from what appears to be silver."
	icon_state = "material"
	origin_tech = list(TECH_MATERIAL = 2, TECH_ILLEGAL = 5)

/obj/item/clothing/accessory/ring/reagent/sleepy/Initialize()
	. = ..()
	reagents.add_reagent("chloralhydrate", 15) // Less than a sleepy-pen, but still enough to knock someone out

/////////////////////////////////////////
//Seals and Signet Rings

/obj/item/clothing/accessory/ring/seal
	var/stamptext = null

/obj/item/clothing/accessory/ring/seal/secgen
	name = "Secretary-General's official seal"
	desc = "The official seal of the Secretary-General of the Sol Central Government, featured prominently on a silver ring."
	icon_state = "seal-secgen"

/obj/item/clothing/accessory/ring/seal/mason
	name = "\improper Masonic ring"
	desc = "The Square and Compasses feature prominently on this Masonic ring."
	icon_state = "seal-masonic"

/obj/item/clothing/accessory/ring/seal/signet
	name = "signet ring"
	desc = "A signet ring, for when you're too sophisticated to sign letters."
	icon_state = "seal-signet"
	var/nameset = FALSE

/obj/item/clothing/accessory/ring/seal/signet/attack_self(mob/user)
	if(nameset)
		to_chat(user, span_notice("The [src] has already been claimed!"))
		return

	to_chat(user, span_notice("You claim the [src] as your own!"))
	change_name(user)
	nameset = TRUE

/obj/item/clothing/accessory/ring/seal/signet/proc/change_name(var/signet_name = "Unknown")
	name = "[signet_name]'s signet ring"
	desc = "A signet ring belonging to [signet_name], for when you're too sophisticated to sign letters."

/obj/item/clothing/accessory/ring/wedding
	name = "golden wedding ring"
	desc = "For showing your devotion to another person. It has a golden glimmer to it."
	icon = 'icons/inventory/hands/item_vr.dmi'
	icon_state = "wedring_g"
	item_state = "wedring_g"
	var/partnername = ""

/obj/item/clothing/accessory/ring/wedding/attack_self(mob/user)
	partnername = copytext(sanitize(input(user, "Would you like to change the holoengraving on the ring?", "Name your spouse", "Bae") as null|text),1,MAX_NAME_LEN)
	name = "[initial(name)] - [partnername]"

/obj/item/clothing/accessory/ring/wedding/silver
	name = "silver wedding ring"
	desc = "For showing your devotion to another person. It has a silver glimmer to it."
	icon_state = "wedring_s"
	item_state = "wedring_s"

/////////////////////////////////////////
//Material Rings
/obj/item/clothing/accessory/ring/material
	icon = 'icons/inventory/hands/item.dmi'
	icon_state = "material"

/obj/item/clothing/accessory/ring/material/New(var/newloc, var/new_material)
	..(newloc)
	if(!new_material)
		new_material = MAT_STEEL
	material = get_material_by_name(new_material)
	if(!istype(material))
		qdel(src)
		return
	name = "[material.display_name] ring"
	desc = "A ring made from [material.display_name]."
	color = material.icon_colour

/obj/item/clothing/accessory/ring/material/get_material()
	return material

/obj/item/clothing/accessory/ring/material/wood/New(var/newloc)
	..(newloc, MAT_WOOD)

/obj/item/clothing/accessory/ring/material/plastic/New(var/newloc)
	..(newloc, MAT_PLASTIC)

/obj/item/clothing/accessory/ring/material/iron/New(var/newloc)
	..(newloc, MAT_IRON)

/obj/item/clothing/accessory/ring/material/glass/New(var/newloc)
	..(newloc, MAT_GLASS)

/obj/item/clothing/accessory/ring/material/steel/New(var/newloc)
	..(newloc, MAT_STEEL)

/obj/item/clothing/accessory/ring/material/silver/New(var/newloc)
	..(newloc, MAT_SILVER)

/obj/item/clothing/accessory/ring/material/gold/New(var/newloc)
	..(newloc, MAT_GOLD)

/obj/item/clothing/accessory/ring/material/platinum/New(var/newloc)
	..(newloc, MAT_PLATINUM)

/obj/item/clothing/accessory/ring/material/phoron/New(var/newloc)
	..(newloc, MAT_PHORON)

/obj/item/clothing/accessory/ring/material/titanium/New(var/newloc)
	..(newloc, MAT_TITANIUM)

/obj/item/clothing/accessory/ring/material/copper/New(var/newloc)
	..(newloc, MAT_COPPER)

/obj/item/clothing/accessory/ring/material/bronze/New(var/newloc)
	..(newloc, MAT_BRONZE)

/obj/item/clothing/accessory/ring/material/uranium/New(var/newloc)
	..(newloc, MAT_URANIUM)

/obj/item/clothing/accessory/ring/material/osmium/New(var/newloc)
	..(newloc, MAT_OSMIUM)

/obj/item/clothing/accessory/ring/material/lead/New(var/newloc)
	..(newloc, MAT_LEAD)

/obj/item/clothing/accessory/ring/material/diamond/New(var/newloc)
	..(newloc, MAT_DIAMOND)

/obj/item/clothing/accessory/ring/material/tin/New(var/newloc)
	..(newloc, MAT_TIN)

/obj/item/clothing/accessory/ring/material/void_opal/New(var/newloc)
	..(newloc, MAT_VOPAL)
