/*
 * Microphone
 */
/obj/item/device/microphone
	name = "microphone"
	icon = 'icons/obj/microphones.dmi'
	icon_state = "mic"
	w_class = ITEMSIZE_SMALL
	desc = "A microphone, for speaking in."
	var/max_font = 8
	var/font_amp = 4
	var/on = 1

/obj/item/device/microphone/proc/can_broadcast(var/mob/living/user)
	var/turf/T = get_turf(src)
	var/speakers = 0
	for(var/obj/loudspeaker/S in range(7, T))
			speakers ++
	if(!speakers)
		to_chat(user, "<span class='warning'>You realise that there's no loudspeaker nearby for this to project to.</span>")
		return FALSE
	if(user.client)
		if(user.client.prefs.muted & MUTE_IC)
			to_chat(user, "<span class='warning'>You cannot speak in IC (muted).</span>")
			return FALSE
	if(!(ishuman(user) || user.isSynthetic()))
		to_chat(user, "<span class='warning'>You don't know how to use this!</span>")
		return FALSE
	if(user.silent)
		return FALSE
	if(loc != user)
		return FALSE
	if(user.stat != CONSCIOUS)
		return FALSE
	return TRUE

/obj/item/device/microphone/examine()
	..()
	. += "It's currently [src.on ? "on" : "off"]."

/obj/item/device/microphone/proc/do_broadcast(var/mob/living/user, var/message)
	user.audible_message("<B>[user.GetVoice()]</B>[user.GetAltName()] broadcasts, <FONT size=5>\"[message]\"</FONT>", runemessage = message)

/obj/item/device/microphone/verb/toggle_microphone(var/mob/living/user)
	set name = "Toggle Microphone"
	set category = "Object"

	src.on = !(src.on)
	to_chat(user,"You switch [src] [src.on ? "on" : "off"].")

/obj/item/device/microphone/AltClick(var/mob/living/user)
	toggle_microphone(user)

/obj/item/device/microphone/attack_self(var/mob/living/user)
	var/message = sanitize(input(usr, "What is your message?", "Microphone", null)  as text)
	if(!message)
		return
	message = capitalize(message)

	if(!can_broadcast(user))
		return

	do_broadcast(user, message)

/*
 * Microphone Stand
 */
/obj/item/device/mic_stand
	name = "microphone stand"
	icon = 'icons/obj/microphones.dmi'
	icon_state = "micstand"
	desc = "A stand that typically holds a mic in it."
	var/obj/item/device/microphone/myMic = null
	var/mic_type = /obj/item/device/microphone

/obj/item/device/mic_stand/New()
	spawn(1)
		if (!myMic)
			myMic = new mic_type(src)
	return ..()

/obj/item/device/mic_stand/attackby(obj/item/W as obj, mob/user as mob)
	if (istype(W, /obj/item/device/microphone))
		if (myMic)
			user << "<span class='warning'>There's already a microphone on [src]!</span>"
			return
		user << "You place the [W] on [src]."
		myMic = W
		user.drop_from_inventory(W, src)
		W.forceMove(src)
		src.update_icon()
	else
		return ..()

/obj/item/device/mic_stand/attack_hand(mob/living/user)
	if (!myMic)
		user << "<span class='warning'>There's no microphone on [src]!</span>"
		return ..()
	playsound(loc, 'sound/items/mic_feedback.ogg', 30, 1)

	user.put_in_hands(myMic)
	myMic = null
	update_icon()

	return ..()

/obj/item/device/mic_stand/update_icon()
	if (myMic)
		src.icon_state = "micstand"
	else
		src.icon_state = "micstand-empty"

/*
 * Loudspeaker
 */
/obj/loudspeaker
	name = "loudspeaker"
	icon = 'icons/obj/microphones.dmi'
	icon_state = "tower-speaker"
	anchored = 1
	density = 1

/obj/loudspeaker/small
	icon_state = "brick-speaker"

/obj/loudspeaker/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(W.is_wrench())
		playsound(src, W.usesound, 100, 1)
		if(anchored)
			user.visible_message("[user] begins unsecuring \the [src] from the floor.", "You start unsecuring \the [src] from the floor.")
		else
			user.visible_message("[user] begins securing \the [src] to the floor.", "You start securing \the [src] to the floor.")

		if(do_after(user, 20 * W.toolspeed))
			if(!src) return
			to_chat(user, "<span class='notice'>You [anchored? "un" : ""]secured \the [src]!</span>")
			anchored = !anchored
		return