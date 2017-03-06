/obj/item/clothing/glasses/omnihud
	name = "a.r. glasses"
	desc = "The KHI-62 AR Glasses are a design from Kitsuhana Heavy Industries. These are a cheap export version \
	for Nanotrasen. Probably not as complete as KHI could make them, but more readily available for NT."
	origin_tech = list(TECH_MAGNET = 3, TECH_BIO = 3)
	var/obj/item/clothing/glasses/hud/omni/hud = null
	var/mode = "civ"
	icon_state = "glasses"
	var/flash_prot = 0 //0 for none, 1 for flash weapon protection, 2 for welder protection

	New()
		..()
		src.hud = new/obj/item/clothing/glasses/hud/omni(src)
		return

	proc/flashed()
		if(flash_prot && ishuman(loc))
			loc << "<span class='warning'>Your [src.name] darken to try and protect your eyes!</span>"

	prescribe(var/mob/user)
		prescription = !prescription

		//Look it's really not that fancy. It's not ACTUALLY unique scrip data.
		if(prescription)
			name = "[initial(name)] (pr)"
			user.visible_message("[user] uploads new prescription data to \the [src.name].")
		else
			name = "[initial(name)]"
			user.visible_message("[user] deletes the prescription data of \the [src.name].")

		playsound(user,'sound/items/screwdriver.ogg', 50, 1)

/obj/item/clothing/glasses/omnihud/prescription
	name = "AR glasses (pr)"
	prescription = 1

/obj/item/clothing/glasses/omnihud/med
	name = "AR-M glasses"
	desc = "The KHI-62-M AR glasses are a design from Kitsuhana Heavy Industries. \
	These have been upgraded with medical records access and virus database integration."
	mode = "med"

/obj/item/clothing/glasses/omnihud/sec
	name = "AR-S glasses"
	desc = "The KHI-62-S AR glasses are a design from Kitsuhana Heavy Industries. \
	These have been upgraded with security records integration and flash protection."
	mode = "sec"
	flash_prot = 1 //Flash protection.

/obj/item/clothing/glasses/omnihud/eng
	name = "AR-E glasses"
	desc = "The KHI-62-E AR glasses are a design from Kitsuhana Heavy Industries. \
	These have been upgraded with advanced electrochromic lenses to protect your eyes during welding."
	mode = "civ"
	flash_prot = 2 //Welding protection.

/obj/item/clothing/glasses/omnihud/rnd
	name = "AR-R glasses"
	desc = "The KHI-62-R AR glasses are a design from Kitsuhana Heavy Industries. \
	These have been ... modified ... to fit into a different frame."
	icon = 'icons/obj/clothing/glasses.dmi'
	icon_override = null
	icon_state = "purple"
	mode = "civ"

/obj/item/clothing/glasses/omnihud/all
	name = "AR-B glasses"
	desc = "The KHI-62-B AR glasses are a design from Kitsuhana Heavy Industries. \
	These have been upgraded with every feature the lesser models have. Now we're talkin'."
	mode = "best"
	flash_prot = 2 //Welding protection.

/obj/item/clothing/glasses/hud/omni
	name = "internal omni hud"
	desc = "You shouldn't see this. This is an internal item for glasses."
	var/obj/item/clothing/glasses/omnihud/shades = null

	vision_flags = SEE_MOBS
	see_invisible = SEE_INVISIBLE_NOLIGHTING

	New()
		..()
		if(istype(loc,/obj/item/clothing/glasses/omnihud))
			shades = loc
		else
			qdel(src)

/obj/item/clothing/glasses/hud/omni/process_hud(var/mob/M)
	process_omni_hud(M,shades.mode)