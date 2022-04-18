//I still dont think this should be a closet but whatever
/obj/structure/fireaxecabinet
	name = "fire axe cabinet"
	desc = "There is small label that reads \"For Emergency use only\" along with details for safe use of the axe. As if."
	var/obj/item/material/twohanded/fireaxe/fireaxe
	icon = 'icons/obj/closet.dmi'	//Not bothering to move icons out for now. But its dumb still.
	icon_state = "fireaxe1000"
	layer = ABOVE_WINDOW_LAYER
	anchored = TRUE
	density = FALSE
	var/open = 0
	var/hitstaken = 0
	var/locked = 1
	var/smashed = 0

/obj/structure/fireaxecabinet/Initialize()
	. = ..()
	fireaxe = new /obj/item/material/twohanded/fireaxe()

/obj/structure/fireaxecabinet/attackby(var/obj/item/O as obj, var/mob/user as mob)  //Marker -Agouri
	//..() //That's very useful, Erro

	// This could stand to be put further in, made better, etc. but fuck you. Fuck whoever
	// wrote this code. Fuck everything about this object. I hope you step on a Lego.
	user.setClickCooldown(10)
	// Seriously why the fuck is this even a closet aghasjdhasd I hate you

	//var/hasaxe = 0       //gonna come in handy later~ // FUCK YOUR TILDES.
	//if(fireaxe)
	//	hasaxe = 1

	if (isrobot(user) || locked)
		if(istype(O, /obj/item/multitool))
			to_chat(user, "<span class='warning'>Resetting circuitry...</span>")
			playsound(src, 'sound/machines/lockreset.ogg', 50, 1)
			if(do_after(user, 20 * O.toolspeed))
				locked = 0
				to_chat(user, "<span class = 'caution'> You disable the locking modules.</span>")
				update_icon()
			return
		else if(istype(O))
			var/obj/item/W = O
			if(smashed || open)
				if(open)
					toggle_close_open()
				return
			else
				playsound(src, 'sound/effects/Glasshit.ogg', 100, 1) //We don't want this playing every time
			if(W.force < 15)
				to_chat(user, "<span class='notice'>The cabinet's protective glass glances off the hit.</span>")
			else
				hitstaken++
				if(hitstaken == 4)
					playsound(src, 'sound/effects/Glassbr3.ogg', 100, 1) //Break cabinet, receive goodies. Cabinet's fucked for life after that.
					smashed = 1
					locked = 0
					open= 1
			update_icon()
		return
	if (istype(O, /obj/item/material/twohanded/fireaxe) && open)
		if(!fireaxe)
			if(O:wielded)
				O:wielded = 0
				O.update_icon()
			fireaxe = O
			user.remove_from_mob(O)
			contents += O
			to_chat(user, "<span class='notice'>You place the fire axe back in the [name].</span>")
			update_icon()
		else
			if(smashed)
				return
			else
				toggle_close_open()
	else
		if(smashed)
			return
		if(istype(O, /obj/item/multitool))
			if(open)
				open = 0
				update_icon()
				flick("[icon_state]closing", src)
				return
			else
				to_chat(user, "<span class='warning'>Resetting circuitry...</span>")
				playsound(src, 'sound/machines/lockenable.ogg', 50, 1)
				if(do_after(user,20 * O.toolspeed))
					locked = 1
					to_chat(user, "<span class = 'caution'> You re-enable the locking modules.</span>")
				return
		else
			toggle_close_open()


/obj/structure/fireaxecabinet/attack_hand(mob/user as mob)
	//var/hasaxe = 0	//Fuck this. Fuck everything about this. Who wrote this. Why.
	//if(fireaxe)
	//	hasaxe = 1

	if(locked)
		to_chat(user, "<span class='warning'>The cabinet won't budge!</span>")
		return

	if(open)
		if(fireaxe)
			user.put_in_hands(fireaxe)
			fireaxe = null
			to_chat (user, "<span class='notice'>You take the fire axe from the [name].</span>")
			add_fingerprint(user)
			update_icon()
		else
			if(smashed)
				return
			else
				toggle_close_open()

	else
		toggle_close_open()

/obj/structure/fireaxecabinet/attack_tk(mob/user as mob)
	if(open && fireaxe)
		fireaxe.forceMove(loc)
		to_chat(user, "<span class='notice'>You telekinetically remove the fire axe.</span>")
		fireaxe = null
		update_icon()
		return
	attack_hand(user)

/obj/structure/fireaxecabinet/proc/toggle_close_open()
	open = !open
	if(open)
		update_icon()
		flick("[icon_state]opening", src)
	else
		update_icon()
		flick("[icon_state]closing", src)

/obj/structure/fireaxecabinet/verb/toggle_openness() //nice name, huh? HUH?! -Erro //YEAH -Agouri
	set name = "Open/Close"
	set category = "Object"

	if (isrobot(usr) || locked || smashed)
		if(locked)
			to_chat(usr, "<span class='warning'>The cabinet won't budge!</span>")
		else if(smashed)
			to_chat(usr, "<span class='notice'>The protective glass is broken!</span>")
		return

	toggle_close_open()
	update_icon()

/obj/structure/fireaxecabinet/verb/remove_fire_axe()
	set name = "Remove Fire Axe"
	set category = "Object"

	if (isrobot(usr))
		return

	if (open)
		if(fireaxe)
			usr.put_in_hands(fireaxe)
			fireaxe = null
			to_chat(usr, "<span class='notice'>You take the Fire axe from the [name].</span>")
		else
			to_chat(usr, "<span class='notice'>The [name] is empty.</span>")
	else
		to_chat(usr, "<span class='notice'>The [name] is closed.</span>")
	update_icon()

/obj/structure/fireaxecabinet/attack_ai(mob/user as mob)
	if(smashed)
		to_chat(user, "<span class='warning'>The security of the cabinet is compromised.</span>")
		return
	else
		locked = !locked
		if(locked)
			to_chat(user, "<span class='warning'>Cabinet locked.</span>")
		else
			to_chat(user, "<span class='notice'>Cabinet unlocked.</span>")
		return

/obj/structure/fireaxecabinet/update_icon() //Template: fireaxe[has fireaxe][is opened][hits taken][is smashed]. If you want the opening or closing animations, add "opening" or "closing" right after the numbers
	var/hasaxe = 0
	if(fireaxe)
		hasaxe = 1
	icon_state = text("fireaxe[][][][]",hasaxe,open,hitstaken,smashed)
