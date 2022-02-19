//Generic Ring

/obj/item/clothing/gloves/ring
	name = "generic ring"
	desc = "Torus shaped finger decoration."
	icon_state = "material"
	drop_sound = 'sound/items/drop/ring.ogg'

/////////////////////////////////////////
//Standard Rings
/obj/item/clothing/gloves/ring/engagement
	name = "engagement ring"
	desc = "An engagement ring. It certainly looks expensive."
	icon_state = "diamond"

/obj/item/clothing/gloves/ring/engagement/attack_self(mob/user)
	user.visible_message("<span class='warning'>\The [user] gets down on one knee, presenting \the [src].</span>","<span class='warning'>You get down on one knee, presenting \the [src].</span>")

/obj/item/clothing/gloves/ring/cti
	name = "CTI ring"
	desc = "A ring commemorating graduation from CTI."
	icon_state = "cti-grad"

/obj/item/clothing/gloves/ring/mariner
	name = "Mariner University ring"
	desc = "A ring commemorating graduation from Mariner University."
	icon_state = "mariner-grad"


/////////////////////////////////////////
//Reagent Rings

/obj/item/clothing/gloves/ring/reagent
	flags = OPENCONTAINER
	origin_tech = list(TECH_MATERIAL = 2, TECH_ILLEGAL = 4)

/obj/item/clothing/gloves/ring/reagent/New()
	..()
	create_reagents(15)

/obj/item/clothing/gloves/ring/reagent/equipped(var/mob/living/carbon/human/H)
	..()
	if(istype(H) && H.gloves==src)

		if(reagents.total_volume)
			to_chat(H, "<span class='danger'>You feel a prick as you slip on \the [src].</span>")
			if(H.reagents)
				var/contained = reagents.get_reagents()
				var/trans = reagents.trans_to_mob(H, 15, CHEM_BLOOD)
				add_attack_logs(usr, H, "Injected with [name] containing [contained] transferred [trans] units")
	return

//Sleepy Ring
/obj/item/clothing/gloves/ring/reagent/sleepy
	name = "silver ring"
	desc = "A ring made from what appears to be silver."
	icon_state = "material"
	origin_tech = list(TECH_MATERIAL = 2, TECH_ILLEGAL = 5)

/obj/item/clothing/gloves/ring/reagent/sleepy/New()
	..()
	reagents.add_reagent("chloralhydrate", 15) // Less than a sleepy-pen, but still enough to knock someone out

/////////////////////////////////////////
//Seals and Signet Rings

/obj/item/clothing/gloves/ring/seal
	var/stamptext = null
/obj/item/clothing/gloves/ring/seal/secgen
	name = "Secretary-General's official seal"
	desc = "The official seal of the Secretary-General of the Sol Central Government, featured prominently on a silver ring."
	icon_state = "seal-secgen"

/obj/item/clothing/gloves/ring/seal/mason
	name = "\improper Masonic ring"
	desc = "The Square and Compasses feature prominently on this Masonic ring."
	icon_state = "seal-masonic"

/obj/item/clothing/gloves/ring/seal/signet
	name = "signet ring"
	desc = "A signet ring, for when you're too sophisticated to sign letters."
	icon_state = "seal-signet"
	var/nameset = FALSE

/obj/item/clothing/gloves/ring/seal/signet/attack_self(mob/user)
	if(nameset)
		to_chat(user, "<span class='notice'>The [src] has already been claimed!</span>")
		return

	to_chat(user, "<span class='notice'>You claim the [src] as your own!</span>")
	change_name(user)
	nameset = TRUE

/obj/item/clothing/gloves/ring/seal/signet/proc/change_name(var/signet_name = "Unknown")
	name = "[signet_name]'s signet ring"
	desc = "A signet ring belonging to [signet_name], for when you're too sophisticated to sign letters."
