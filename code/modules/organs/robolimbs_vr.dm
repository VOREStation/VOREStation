/datum/robolimb
	var/includes_tail			//Cyberlimbs dmi includes a tail sprite to wear.

// arokha : Aronai Kadigan
/datum/robolimb/kitsuhana
	company = "Kitsuhana"
	desc = "This limb seems rather vulpine and fuzzy, with realistic-feeling flesh."
	icon = 'icons/mob/human_races/cyberlimbs/kitsuhana.dmi'
	blood_color = "#5dd4fc"
	includes_tail = 1
	lifelike = 1
	unavailable_to_build = 1
	unavailable_at_chargen = 1

/obj/item/weapon/disk/limb/kitsuhana
	company = "Kitsuhana"



/datum/robolimb/talon //They're buildable by default due to being extremely basic.
	company = "Talon LLC"
	desc = "This metallic limb is sleek and featuresless apart from some exposed motors"
	icon = 'icons/mob/human_races/cyberlimbs/talon/talon_main.dmi' //Sprited by: Viveret


/obj/item/weapon/disk/limb/talon
	company = "Talon LLC"