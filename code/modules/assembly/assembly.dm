/obj/item/device/assembly
	name = "assembly"
	desc = "A small electronic device that should never exist."
	icon = 'icons/obj/assemblies/new_assemblies.dmi'
	icon_state = ""
	w_class = ITEMSIZE_SMALL
	matter = list(DEFAULT_WALL_MATERIAL = 100)
	throwforce = 2
	throw_speed = 3
	throw_range = 10
	origin_tech = list(TECH_MAGNET = 1)

	var/secured = 1
	var/list/attached_overlays = null
	var/obj/item/device/assembly_holder/holder = null
	var/cooldown = FALSE //To prevent spam
	var/wires = WIRE_RECEIVE | WIRE_PULSE

	var/const/WIRE_RECEIVE = 1			//Allows Pulsed(0) to call Activate()
	var/const/WIRE_PULSE = 2				//Allows Pulse(0) to act on the holder
	var/const/WIRE_PULSE_SPECIAL = 4		//Allows Pulse(0) to act on the holders special assembly
	var/const/WIRE_RADIO_RECEIVE = 8		//Allows Pulsed(1) to call Activate()
	var/const/WIRE_RADIO_PULSE = 16		//Allows Pulse(1) to send a radio message

/obj/item/device/assembly/proc/holder_movement()
	return

/obj/item/device/assembly/proc/process_cooldown()
	if(cooldown)
		return FALSE
	cooldown = TRUE
	VARSET_IN(src, cooldown, FALSE, 2 SECONDS)
	return TRUE

/obj/item/device/assembly/proc/pulsed(var/radio = 0)
	if(holder && (wires & WIRE_RECEIVE))
		activate()
	if(radio && (wires & WIRE_RADIO_RECEIVE))
		activate()
	return 1

/obj/item/device/assembly/proc/pulse(var/radio = 0)
	if(holder && (wires & WIRE_PULSE))
		holder.process_activation(src, 1, 0)
	if(holder && (wires & WIRE_PULSE_SPECIAL))
		holder.process_activation(src, 0, 1)
	return 1

/obj/item/device/assembly/proc/activate()
	if(!secured || !process_cooldown())
		return FALSE
	return TRUE

/obj/item/device/assembly/proc/toggle_secure()
	secured = !secured
	update_icon()
	return secured

/obj/item/device/assembly/proc/attach_assembly(var/obj/item/device/assembly/A, var/mob/user)
	holder = new/obj/item/device/assembly_holder(get_turf(src))
	if(holder.attach(A,src,user))
		to_chat(user, "<span class='notice'>You attach \the [A] to \the [src]!</span>")
		return TRUE

/obj/item/device/assembly/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(isassembly(W))
		var/obj/item/device/assembly/A = W
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

/obj/item/device/assembly/process()
	return PROCESS_KILL

/obj/item/device/assembly/examine(mob/user)
	..(user)
	if((in_range(src, user) || loc == user))
		if(secured)
			to_chat(user, "\The [src] is ready!")
		else
			to_chat(user, "\The [src] can be attached!")
	return


/obj/item/device/assembly/attack_self(mob/user as mob)
	if(!user)	return 0
	user.set_machine(src)
	interact(user)
	return 1

/obj/item/device/assembly/interact(mob/user as mob)
	return //HTML MENU FOR WIRES GOES HERE

/obj/item/device/assembly/nano_host()
    if(istype(loc, /obj/item/device/assembly_holder))
        return loc.nano_host()
    return ..()
