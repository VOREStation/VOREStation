#define NOGRAV_FIGHTER_DAMAGE 20

/obj/mecha/combat/fighter
	name = "Delete me, nerd!!"
	desc = "The base type of fightercraft. Don't spawn this one!"

	var/datum/effect/effect/system/ion_trail_follow/ion_trail
	var/stabilization_enabled = TRUE //If our anti-space-drift is on
	var/ground_capable = FALSE //If we can fly over normal turfs and not just space

	icon = 'icons/mecha/fighters64x64.dmi'
	
	icon_state = ""
	initial_icon = ""
	
	step_in = 2 //Fast

	health = 400
	maxhealth = 400
	
	infra_luminosity = 6

	opacity = FALSE

	wreckage = /obj/effect/decal/mecha_wreckage/gunpod

	stomp_sound = 'sound/machines/generator/generator_end.ogg'
	swivel_sound = 'sound/machines/hiss.ogg'

	bound_height = 64
	bound_width = 64

	max_hull_equip = 2
	max_weapon_equip = 2
	max_utility_equip = 1
	max_universal_equip = 1
	max_special_equip = 1

/obj/mecha/combat/fighter/Initialize()
	. = ..()
	ion_trail = new /datum/effect/effect/system/ion_trail_follow()
	ion_trail.set_up(src)
	ion_trail.stop()

/obj/mecha/combat/fighter/moved_inside(var/mob/living/carbon/human/H)
	. = ..()
	consider_gravity()

/obj/mecha/combat/fighter/go_out()
	. = ..()
	consider_gravity()

//Modified phazon code
/obj/mecha/combat/fighter/Topic(href, href_list)
	..()
	if (href_list["toggle_stabilization"])
		stabilization_enabled = !stabilization_enabled
		send_byjax(src.occupant,"exosuit.browser","stabilization_command","[stabilization_enabled?"Dis":"En"]able thruster stabilization")
		src.occupant_message("<span class='notice'>Thruster stabilization [stabilization_enabled? "enabled" : "disabled"].</span>")
		return

/obj/mecha/combat/fighter/get_commands()
	var/output = {"<div class='wr'>
						<div class='header'>Special</div>
						<div class='links'>
						<a href='?src=\ref[src];toggle_stabilization=1'><span id="stabilization_command">[stabilization_enabled?"Dis":"En"]able thruster stabilization</span></a><br>
						</div>
						</div>
						"}
	output += ..()
	return output

/obj/mecha/combat/fighter/can_ztravel()
	return (stabilization_enabled && has_charge(step_energy_drain))

// No space drifting
/obj/mecha/combat/fighter/check_for_support()
	if (stabilization_enabled)
		return 1

	return ..()

// No falling if we've got our boosters on
/obj/mecha/combat/fighter/can_fall()
	return (stabilization_enabled && has_charge(step_energy_drain))

/obj/mecha/combat/fighter/proc/consider_gravity(var/moved = FALSE)
	var/gravity = has_gravity()
	if(gravity && ground_capable && occupant)
		start_hover()
	else if((!gravity && ground_capable) || !occupant)
		stop_hover()
	else if(moved && gravity && !ground_capable)
		occupant_message("Collision alert! Vehicle not rated for use in gravity!")
		take_damage(NOGRAV_FIGHTER_DAMAGE, "brute")
		playsound(loc, 'sound/effects/grillehit.ogg', 50, 1)

/obj/mecha/combat/fighter/handle_equipment_movement()
	. = ..()
	consider_gravity(TRUE)	

/obj/mecha/combat/fighter/proc/start_hover()
	if(!ion_trail.on) //We'll just use this to store if we're floating or not
		ion_trail.start()
		var/amplitude = 2 //maximum displacement from original position
		var/period = 36 //time taken for the mob to go up >> down >> original position, in deciseconds. Should be multiple of 4

		var/top = old_y + amplitude
		var/bottom = old_y - amplitude
		var/half_period = period / 2
		var/quarter_period = period / 4

		animate(src, pixel_y = top, time = quarter_period, easing = SINE_EASING | EASE_OUT, loop = -1)		//up
		animate(pixel_y = bottom, time = half_period, easing = SINE_EASING, loop = -1)						//down
		animate(pixel_y = old_y, time = quarter_period, easing = SINE_EASING | EASE_IN, loop = -1)			//back

/obj/mecha/combat/fighter/proc/stop_hover()
	if(ion_trail.on)
		ion_trail.stop()
		animate(src, pixel_y = old_y, time = 5, easing = SINE_EASING | EASE_IN) //halt animation

/obj/mecha/combat/fighter/check_for_support()
	if (has_charge(step_energy_drain) && stabilization_enabled)
		return 1

	var/list/things = orange(1, src)

	if(locate(/obj/structure/grille in things) || locate(/obj/structure/lattice in things) || locate(/turf/simulated in things) || locate(/turf/unsimulated in things))
		return 1
	else
		return 0


/obj/mecha/combat/fighter/play_entered_noise(var/mob/who)
	if(hasInternalDamage())
		who << sound('sound/mecha/fighter_entered_bad.ogg',volume=50)
	else
		who << sound('sound/mecha/fighter_entered.ogg',volume=50)

////////////// Equipment //////////////

// For 64x64 fighters
/obj/item/mecha_parts/mecha_equipment/omni_shield/fighter64
	shield_type = /obj/item/shield_projector/rectangle/mecha/fighter64
/obj/item/shield_projector/rectangle/mecha/fighter64
	shift_x = 16
	shift_y = 16


////////////// Gunpod //////////////

/obj/mecha/combat/fighter/gunpod
	name = "Gunpod"
	desc = "Small mounted weapons platform capable of space and surface combat. More like a flying tank than a dedicated fightercraft."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "gunpod"
	initial_icon = "gunpod"

	catalogue_data = list(/datum/category_item/catalogue/technology/gunpod)
	wreckage = /obj/effect/decal/mecha_wreckage/gunpod

	step_in = 3 //Slightly slower than others

	ground_capable = TRUE
	
	// Paint colors! Null if not set.
	var/stripe1_color
	var/stripe2_color
	var/image/stripe1_overlay
	var/image/stripe2_overlay

/obj/mecha/combat/fighter/gunpod/loaded/Initialize() //Loaded version with gans
	. = ..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/missile_rack/explosive
	ME.attach(src)

/obj/mecha/combat/fighter/gunpod/recon/Initialize() //Blinky
	. = ..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/teleporter(src)
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/tesla_energy_relay(src)
	ME.attach(src)

/obj/mecha/combat/fighter/gunpod/update_icon()
	cut_overlays()
	..()

	if(stripe1_color)
		stripe1_overlay = image("gunpod_stripes1")
		stripe1_overlay.color = stripe1_color
		add_overlay(stripe1_overlay)
	if(stripe2_color)
		stripe2_overlay = image("gunpod_stripes2")
		stripe2_overlay.color = stripe2_color
		add_overlay(stripe2_overlay)

/obj/mecha/combat/fighter/gunpod/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/device/multitool) && state == 1)
		var/new_paint_location = input("Please select a target zone.", "Paint Zone", null) as null|anything in list("Fore Stripe", "Aft Stripe", "CANCEL")
		if(new_paint_location && new_paint_location != "CANCEL")
			var/new_paint_color = input("Please select a paint color.", "Paint Color", null) as color|null
			if(new_paint_color)
				switch(new_paint_location)
					if("Fore Stripe")
						stripe1_color = new_paint_color
					if("Aft Stripe")
						stripe2_color = new_paint_color

		update_icon()
	else ..()

/obj/effect/decal/mecha_wreckage/gunpod
	name = "Gunpod wreckage"
	desc = "Remains of some unfortunate gunpod. Completely unrepairable."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "gunpod-broken"
	bound_width = 64
	bound_height = 64

/datum/category_item/catalogue/technology/gunpod
	name = "Voidcraft - Gunpod"
	desc = "This is a small space-capable fightercraft that has an arrowhead design. Can hold up to one pilot, \
	and sometimes one or two passengers, with the right modifications made. \
	Typically used as small fighter craft, the gunpod can't carry much of a payload, though it's still capable of holding it's own."
	value = CATALOGUER_REWARD_MEDIUM


////////////// Baron //////////////

/obj/mecha/combat/fighter/baron
	name = "Baron"
	desc = "A conventional space superiority fighter, one-seater. Not capable of ground operations."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "baron"
	initial_icon = "baron"

	catalogue_data = list(/datum/category_item/catalogue/technology/baron)
	wreckage = /obj/effect/decal/mecha_wreckage/baron

	ground_capable = FALSE

/obj/mecha/combat/fighter/baron/loaded/Initialize() //Loaded version with gans
	. = ..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/energy/laser
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/omni_shield/fighter64
	ME.attach(src)

/obj/effect/decal/mecha_wreckage/baron
	name = "Baron wreckage"
	desc = "Remains of some unfortunate fighter. Completely unrepairable."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "baron-broken"
	bound_width = 64
	bound_height = 64

/datum/category_item/catalogue/technology/baron
	name = "Voidcraft - Baron"
	desc = "This is a small space fightercraft that has an arrowhead design. Can hold up to one pilot. \
	Unlike some fighters, this one is not designed for atmospheric operation, and is only capable of performing \
	maneuvers in the vacuum of space. Attempting to operate it in an atmosphere is not recommended."
	value = CATALOGUER_REWARD_MEDIUM


////////////// Scoralis //////////////

/obj/mecha/combat/fighter/scoralis
	name = "scoralis"
	desc = "An imported space fighter with integral cloaking device. Beware the power consumption, though. Not capable of ground operations."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "scoralis"
	initial_icon = "scoralis"

	catalogue_data = list(/datum/category_item/catalogue/technology/scoralis)
	wreckage = /obj/effect/decal/mecha_wreckage/scoralis

	ground_capable = FALSE

/obj/mecha/combat/fighter/scoralis/loaded/Initialize() //Loaded version with gans
	. = ..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/weapon/ballistic/lmg
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/cloak
	ME.attach(src)

/obj/effect/decal/mecha_wreckage/scoralis
	name = "scoralis wreckage"
	desc = "Remains of some unfortunate fighter. Completely unrepairable."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "scoralis-broken"
	bound_width = 64
	bound_height = 64

/datum/category_item/catalogue/technology/scoralis
	name = "Voidcraft - Scoralis"
	desc = "An import model fightercraft, this one contains an integral cloaking device that renders the fighter invisible \
	to the naked eye. Still detectable on thermal sensors, the craft can maneuver in close to ill-equipped foes and strike unseen. \
	Not rated for atmospheric travel, this craft excels at hit and run tactics, as it will likely need to recharge batteries between each 'hit'."
	value = CATALOGUER_REWARD_MEDIUM

////////////// Allure //////////////

/obj/mecha/combat/fighter/allure
	name = "allure"
	desc = "A fighter of Zorren design, it's blocky appearance is made up for by it's stout armor and finely decorated hull paint."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "allure"
	initial_icon = "allure"

	catalogue_data = list(/datum/category_item/catalogue/technology/allure)
	wreckage = /obj/effect/decal/mecha_wreckage/allure

	ground_capable = FALSE

	health = 500
	maxhealth = 500

/obj/mecha/combat/fighter/allure/loaded/Initialize() //Loaded version with gans
	. = ..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/cloak
	ME.attach(src)

/obj/effect/decal/mecha_wreckage/allure
	name = "allure wreckage"
	desc = "Remains of some unfortunate fighter. Completely unrepairable."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "allure-broken"
	bound_width = 64
	bound_height = 64

/datum/category_item/catalogue/technology/allure
	name = "Voidcraft - Allure"
	desc = "A space superiority fighter of zorren design, many would comment that the blocky shape hinders aesthetic appeal. However, Zorren are \
	often found painting their hulls in intricate designs of purple and gold, and this craft is no exception to the rule. Some individual seems to have \
	decorated it finely. Import craft like this one often ship with no weapons, though the Zorren saw fit to integrate a cloaking device."
	value = CATALOGUER_REWARD_MEDIUM

////////////// Pinnace //////////////

/obj/mecha/combat/fighter/pinnace
	name = "pinnace"
	desc = "A cramped ship's boat, capable of atmospheric and space flight. Not capable of mounting weapons. Capable of fitting one pilot and one passenger."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "pinnace"
	initial_icon = "pinnace"

	max_hull_equip = 1
	max_weapon_equip = 0
	max_utility_equip = 0
	max_universal_equip = 0
	max_special_equip = 1

	catalogue_data = list(/datum/category_item/catalogue/technology/pinnace)
	wreckage = /obj/effect/decal/mecha_wreckage/pinnace

	ground_capable = TRUE

/obj/mecha/combat/fighter/pinnace/loaded/Initialize() //Loaded version with gans
	. = ..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/tool/passenger
	ME.attach(src)

/obj/effect/decal/mecha_wreckage/pinnace
	name = "pinnace wreckage"
	desc = "Remains of some unfortunate ship's boat. Completely unrepairable."
	icon = 'icons/mecha/fighters64x64.dmi'
	icon_state = "pinnace-broken"
	bound_width = 64
	bound_height = 64

/datum/category_item/catalogue/technology/pinnace
	name = "Voidcraft - Pinnace"
	desc = "A very small boat, usually used as a tender at very close ranges. The lack of a bluespace \
	drive means that it can't get too far from it's parent ship. Though the pinnace is typically unarmed, \
	it is capable of atmospheric flight and escaping most pursuing fighters by diving into the atmosphere of \
	nearby planets to seek cover."
	value = CATALOGUER_REWARD_MEDIUM

#undef NOGRAV_FIGHTER_DAMAGE