

/obj/machinery/computer3/aiupload
	name = "AI Upload"
	desc = "Used to upload laws to the AI."
	icon_state = "frame-rnd"
	circuit = /obj/item/weapon/circuitboard/aiupload
	var/mob/living/silicon/ai/current = null
	var/opened = 0


/obj/machinery/computer3/aiupload/verb/AccessInternals()
	set category = "Object"
	set name = "Access Computer's Internals"
	set src in oview(1)
	if(!Adjacent(usr) || usr.restrained() || usr.lying || usr.stat || istype(usr, /mob/living/silicon) || !istype(usr, /mob/living))
		return

	opened = !opened
	if(opened)
		to_chat(usr, "<span class='notice'>The access panel is now open.</span>")
	else
		to_chat(usr, "<span class='notice'>The access panel is now closed.</span>")
	return


/obj/machinery/computer3/aiupload/attackby(obj/item/weapon/aiModule/module as obj, mob/user as mob)
	if (user.z > 6)
		to_chat(user, "<span class='danger'>Unable to establish a connection:</span> You're too far away from the station!")
		return
	if(istype(module, /obj/item/weapon/aiModule))
		module.install(src, user)
	else
		return ..()


/obj/machinery/computer3/aiupload/attack_hand(var/mob/user as mob)
	if(src.stat & NOPOWER)
		to_chat(user, "The upload computer has no power!")
		return
	if(src.stat & BROKEN)
		to_chat(user, "The upload computer is broken!")
		return

	src.current = select_active_ai(user)

	if (!src.current)
		to_chat(user, "No active AIs detected.")
	else
		to_chat(user, "[src.current.name] selected for law changes.")
	return



/obj/machinery/computer3/borgupload
	name = "Cyborg Upload"
	desc = "Used to upload laws to Cyborgs."
	icon_state = "frame-rnd"
	circuit = /obj/item/weapon/circuitboard/borgupload
	var/mob/living/silicon/robot/current = null


/obj/machinery/computer3/borgupload/attackby(obj/item/weapon/aiModule/module as obj, mob/user as mob)
	if(istype(module, /obj/item/weapon/aiModule))
		module.install(src, user)
	else
		return ..()


/obj/machinery/computer3/borgupload/attack_hand(var/mob/user as mob)
	if(src.stat & NOPOWER)
		to_chat(user, "The upload computer has no power!")
		return
	if(src.stat & BROKEN)
		to_chat(user, "The upload computer is broken!")
		return

	src.current = freeborg()

	if (!src.current)
		to_chat(user, "No free cyborgs detected.")
	else
		to_chat(user, "[src.current.name] selected for law changes.")
	return
