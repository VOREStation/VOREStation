/obj/item/device/megaphone
	name = "megaphone"
	desc = "A device used to project your voice. Loudly."
	icon_state = "megaphone"
	w_class = ITEMSIZE_SMALL
	flags = CONDUCT

	var/spamcheck = 0
	var/emagged = 0
	var/insults = 0
	var/list/insultmsg = list("FUCK EVERYONE!", "I'M A TERRORIST!", "ALL SECURITY TO SHOOT ME ON SIGHT!", "I HAVE A BOMB!", "CAPTAIN IS A COMDOM!", "GLORY TO ALMACH!")

/obj/item/device/megaphone/attack_self(mob/living/user as mob)
	if (user.client)
		if(user.client.prefs.muted & MUTE_IC)
			src << "<span class='warning'>You cannot speak in IC (muted).</span>"
			return
	if(!ishuman(user))
		user << "<span class='warning'>You don't know how to use this!</span>"
		return
	if(user.silent)
		return
	if(spamcheck)
		user << "<span class='warning'>\The [src] needs to recharge!</span>"
		return

	var/message = sanitize(input(user, "Shout a message?", "Megaphone", null)  as text)
	if(!message)
		return
	message = capitalize(message)
<<<<<<< HEAD
=======

	do_broadcast(user, message)

/obj/item/device/megaphone/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		to_chat(user, "<span class='warning'>You overload \the [src]'s voice synthesizer.</span>")
		emagged = 1
		insults = rand(1, 3)//to prevent caps spam.
		return 1

/obj/item/device/megaphone/super
	name = "gigaphone"
	desc = "A device used to project your voice. Loudly-er."
	icon_state = "gigaphone"

	var/broadcast_font = "verdana"
	var/broadcast_size = 3
	var/broadcast_color = "#000000" //Black by default.
	var/list/volume_options = list(2, 3, 4)
	var/list/font_options = list("times new roman", "times", "verdana", "sans-serif", "serif", "georgia")
	var/list/color_options= list("#000000", "#ff0000", "#00ff00", "#0000ff")

	insultmsg = list("HONK?!", "HONK!", "HOOOOOOOONK!", "...!", "HUNK.", "Honk?")

/obj/item/device/megaphone/super/emag_act(var/remaining_charges, var/mob/user)
	..()
	if(emagged)
		if(!(11 in volume_options))
			volume_options = list(11)
			broadcast_size = 11
		if(!("comic sans ms" in font_options))
			font_options = list("comic sans ms")
			broadcast_font = "comic sans ms"
			to_chat(user, "<span class='notice'>\The [src] emits a <font face='comic sans ms' color='#ff69b4'>silly</font> sound.</span>")
		if(!("#ff69b4" in color_options))
			color_options = list("#ff69b4")
			broadcast_color = "#ff69b4"
		if(insults <= 0)
			insults = rand(1,3)
			to_chat(user, "<span class='warning'>You re-scramble \the [src]'s voice synthesizer.</span>")
		return 1

/obj/item/device/megaphone/super/verb/turn_volume_dial()
	set name = "Change Volume"
	set desc = "Allows you to change the megaphone's volume."
	set category = "Object"

	adjust_volume(usr)

/obj/item/device/megaphone/super/proc/adjust_volume(var/mob/living/user)
	var/new_volume = input(user, "Set Volume") as null|anything in volume_options

	if(new_volume && Adjacent(user))
		broadcast_size = new_volume

/obj/item/device/megaphone/super/verb/change_font()
	set name = "Change... Pronunciation?"
	set desc = "Allows you to change the megaphone's font."
	set category = "Object"

	adjust_font(usr)

/obj/item/device/megaphone/super/proc/adjust_font(var/mob/living/user)
	var/new_font = input(user, "Set Volume") as null|anything in font_options

	if(new_font && Adjacent(user))
		broadcast_font = new_font

/obj/item/device/megaphone/super/verb/change_color()
	set name = "Change... Tune?"
	set desc = "Allows you to change the megaphone's color."
	set category = "Object"

	adjust_color(usr)

/obj/item/device/megaphone/super/proc/adjust_color(var/mob/living/user)
	var/new_color = input(user, "Set Volume") as null|anything in color_options

	if(new_color && Adjacent(user))
		broadcast_color = new_color

/obj/item/device/megaphone/super/do_broadcast(var/mob/living/user, var/message)
>>>>>>> 386bea3... Merge pull request #5456 from Mechoid/Fix_Gigaphones
	if ((src.loc == user && usr.stat == 0))
		if(emagged)
			if(insults)
				for(var/mob/O in (viewers(user)))
					O.show_message("<B>[user]</B> broadcasts, <FONT size=3>\"[pick(insultmsg)]\"</FONT>",2) // 2 stands for hearable message
				insults--
			else
				user << "<span class='warning'>*BZZZZzzzzzt*</span>"
		else
			for(var/mob/O in (viewers(user)))
				O.show_message("<B>[user]</B> broadcasts, <FONT size=3>\"[message]\"</FONT>",2) // 2 stands for hearable message

		spamcheck = 1
		spawn(20)
			spamcheck = 0
		return

/obj/item/device/megaphone/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		user << "<span class='warning'>You overload \the [src]'s voice synthesizer.</span>"
		emagged = 1
		insults = rand(1, 3)//to prevent dickflooding
		return 1
