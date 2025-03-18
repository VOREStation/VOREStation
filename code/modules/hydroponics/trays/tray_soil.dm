/obj/machinery/portable_atmospherics/hydroponics/soil
	name = "soil"
	icon_state = "soil"
	density = FALSE
	use_power = USE_POWER_OFF
	mechanical = 0
	tray_light = 0
	frozen = -1

/obj/machinery/portable_atmospherics/hydroponics/soil/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O,/obj/item/tank))
		return
	if(istype(O,/obj/item/shovel))
		if(!seed)
			var/choice= tgui_alert(user, "Do you want to destroy the growplot?", "Destroy growplot?" , list("Yes", "No"))
			if(!choice||choice=="No")
				return
			user.visible_message("[user] starts dispersing the [src]...", runemessage = "disperses the [src]")
			if(do_after(user, 5 SECONDS, exclusive = TASK_USER_EXCLUSIVE))
				qdel(src)
		else
			to_chat(user, span_notice("There is something growing here."))
	else
		return ..()

/obj/machinery/portable_atmospherics/hydroponics/soil/Initialize(mapload)
	. = ..()
	verbs -= /obj/machinery/portable_atmospherics/hydroponics/verb/close_lid_verb
	verbs -= /obj/machinery/portable_atmospherics/hydroponics/verb/remove_label
	verbs -= /obj/machinery/portable_atmospherics/hydroponics/verb/setlight

/obj/machinery/portable_atmospherics/hydroponics/soil/CanPass()
	return 1

/obj/machinery/portable_atmospherics/hydroponics/soil/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/shovel) && user.a_intent == I_HURT)
		user.visible_message(span_notice("\The [user] begins filling in \the [src]."))
		if(do_after(user, 3 SECONDS) && !QDELETED(src))
			user.visible_message(span_notice("\The [user] fills in \the [src]."))
			qdel(src)
		return
	. = ..()


// Holder for vine plants.
// Icons for plants are generated as overlays, so setting it to invisible wouldn't work.
// Hence using a blank icon.
/obj/machinery/portable_atmospherics/hydroponics/soil/invisible
	name = "plant"
	icon = 'icons/obj/seeds.dmi'
	icon_state = "blank"

/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/Initialize(mapload,var/datum/seed/newseed)
	//VOREStation Addition Start
	if(istype(loc, /turf/simulated/open) || istype(loc, /turf/space))
		return INITIALIZE_HINT_QDEL
	//VOREStation Addition End
	. = ..()
	seed = newseed
	dead = 0
	age = 1
	health = seed.get_trait(TRAIT_ENDURANCE)
	lastcycle = world.time
	pixel_y = rand(-5,5)
	check_health()

/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/remove_dead()
	..()
	qdel(src)

/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/harvest()
	..()
	if(!seed) // Repeat harvests are a thing.
		qdel(src)

/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/die()
	qdel(src)

/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/process()
	if(!seed)
		qdel(src)
		return
	else if(name=="plant")
		name = seed.display_name
	..()

/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/Destroy()
	// Check if we're masking a decal that needs to be visible again.
	for(var/obj/effect/plant/plant in get_turf(src))
		if(plant.invisibility == INVISIBILITY_MAXIMUM)
			plant.invisibility = initial(plant.invisibility)
	. = ..()
