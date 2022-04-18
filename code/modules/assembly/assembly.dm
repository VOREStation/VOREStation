/obj/item/assembly
	name = "assembly"
	desc = "A small electronic device that should never exist."
	icon = 'icons/obj/assemblies/new_assemblies.dmi'
	icon_state = ""
	w_class = ITEMSIZE_SMALL
	matter = list(MAT_STEEL = 100)
	throwforce = 2
	throw_speed = 3
	throw_range = 10
	drop_sound = 'sound/items/drop/component.ogg'
	pickup_sound =  'sound/items/pickup/component.ogg'
	origin_tech = list(TECH_MAGNET = 1)

	var/secured = 1
	var/list/attached_overlays = null
	var/obj/item/assembly_holder/holder = null
	var/cooldown = FALSE //To prevent spam
	var/wires = WIRE_RECEIVE | WIRE_PULSE

	var/const/WIRE_RECEIVE = 1			//Allows Pulsed(0) to call Activate()
	var/const/WIRE_PULSE = 2				//Allows Pulse(0) to act on the holder
	var/const/WIRE_PULSE_SPECIAL = 4		//Allows Pulse(0) to act on the holders special assembly
	var/const/WIRE_RADIO_RECEIVE = 8		//Allows Pulsed(1) to call Activate()
	var/const/WIRE_RADIO_PULSE = 16		//Allows Pulse(1) to send a radio message

/obj/item/assembly/proc/holder_movement()
	return

/obj/item/assembly/proc/process_cooldown()
	if(cooldown)
		return FALSE
	cooldown = TRUE
	VARSET_IN(src, cooldown, FALSE, 2 SECONDS)
	return TRUE

/obj/item/assembly/proc/pulsed(var/radio = 0)
	if(holder && (wires & WIRE_RECEIVE))
		activate()
	if(radio && (wires & WIRE_RADIO_RECEIVE))
		activate()
	return 1

/obj/item/assembly/proc/pulse(var/radio = 0)
	if(holder && (wires & WIRE_PULSE))
		holder.process_activation(src, 1, 0)
	if(holder && (wires & WIRE_PULSE_SPECIAL))
		holder.process_activation(src, 0, 1)
	return 1

/obj/item/assembly/proc/activate()
	if(!secured || !process_cooldown())
		return FALSE
	return TRUE

/obj/item/assembly/proc/toggle_secure()
	secured = !secured
	update_icon()
	return secured

/obj/item/assembly/proc/attach_assembly(var/obj/item/assembly/A, var/mob/user)
	holder = new/obj/item/assembly_holder(get_turf(src))
	if(holder.attach(A,src,user))
		to_chat(user, "<span class='notice'>You attach \the [A] to \the [src]!</span>")
		return TRUE

/obj/item/assembly/attackby(obj/item/W as obj, mob/user as mob)
	if(isassembly(W))
		var/obj/item/assembly/A = W
		if((!A.secured) && (!secured))
			attach_assembly(A,user)
			return
	if(W.is_screwdriver())
		if(toggle_secure())
			to_chat(user, "<span class='notice'>\The [src] is ready!</span>")
		else
			to_chat(user, "<span class='notice'>\The [src] can now be attached!</span>")
		return
	return ..()

/obj/item/assembly/process()
	return PROCESS_KILL

/obj/item/assembly/examine(mob/user)
	. = ..()
	if((in_range(src, user) || loc == user))
		if(secured)
			. += "\The [src] is ready!"
		else
			. += "\The [src] can be attached!"

/obj/item/assembly/attack_self(mob/user as mob)
	if(!user)
		return 0
	user.set_machine(src)
	tgui_interact(user)
	return 1

/obj/item/assembly/tgui_state(mob/user)
	return GLOB.tgui_deep_inventory_state

/obj/item/assembly/tgui_interact(mob/user, datum/tgui/ui)
	return // tgui goes here

/obj/item/assembly/tgui_host()
	if(istype(loc, /obj/item/assembly_holder))
		return loc.tgui_host()
	return ..()
