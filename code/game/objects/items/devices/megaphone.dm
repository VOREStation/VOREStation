/obj/item/megaphone
	name = "megaphone"
	desc = "A device used to project your voice. Loudly."
	icon_state = "megaphone"
	w_class = ITEMSIZE_SMALL

	var/spamcheck = 0
	var/emagged = 0
	var/insults = 0
	var/list/insultmsg = list("FUCK EVERYONE!", "I'M A TERRORIST!", "ALL SECURITY TO SHOOT ME ON SIGHT!", "I HAVE A BOMB!", "CAPTAIN IS A COMDOM!", "GLORY TO ALMACH!")

/obj/item/megaphone/proc/can_broadcast(var/mob/living/user)
	if(user.client)
		if(user.client.prefs.muted & MUTE_IC)
			to_chat(user, "<span class='warning'>You cannot speak in IC (muted).</span>")
			return FALSE
	if(!(ishuman(user) || user.isSynthetic()))
		to_chat(user, "<span class='warning'>You don't know how to use this!</span>")
		return FALSE
	if(user.silent)
		return FALSE
	if(spamcheck > world.time)
		to_chat(user, "<span class='warning'>[src] needs to recharge!</span>")
		return FALSE
	if(loc != user)
		return FALSE
	if(user.stat != CONSCIOUS)
		return FALSE
	return TRUE

/obj/item/megaphone/proc/do_broadcast(var/mob/living/user, var/message)
	if(emagged)
		if(insults)
			var/insult = pick(insultmsg)
			user.audible_message("<B>[user.GetVoice()]</B>[user.GetAltName()] broadcasts, <FONT size=3>\"[insult]\"</FONT>", runemessage = insult)
			insults--
		else
			to_chat(user, "<span class='warning'>*BZZZZzzzzzt*</span>")
	else
		user.audible_message("<B>[user.GetVoice()]</B>[user.GetAltName()] broadcasts, <FONT size=3>\"[message]\"</FONT>", runemessage = message)

/obj/item/megaphone/attack_self(var/mob/living/user)
	var/message = sanitize(tgui_input_text(user, "Shout a message?", "Megaphone", null))
	if(!message)
		return
	message = capitalize(message)

	if(!can_broadcast(user))
		return

	spamcheck = world.time + 20
	do_broadcast(user, message)

/obj/item/megaphone/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		to_chat(user, "<span class='warning'>You overload [src]'s voice synthesizer.</span>")
		emagged = TRUE
		insults = rand(1, 3)//to prevent caps spam.
		return TRUE

/obj/item/megaphone/super
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

/obj/item/megaphone/super/emag_act(var/remaining_charges, var/mob/user)
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

/obj/item/megaphone/super/verb/turn_volume_dial()
	set name = "Change Volume"
	set desc = "Allows you to change the megaphone's volume."
	set category = "Object"

	adjust_volume(usr)

/obj/item/megaphone/super/proc/adjust_volume(var/mob/living/user)
	var/new_volume = tgui_input_list(user, "Set Volume", "Set Volume", volume_options)

	if(new_volume && Adjacent(user))
		broadcast_size = new_volume

/obj/item/megaphone/super/verb/change_font()
	set name = "Change... Pronunciation?"
	set desc = "Allows you to change the megaphone's font."
	set category = "Object"

	adjust_font(usr)

/obj/item/megaphone/super/proc/adjust_font(var/mob/living/user)
	var/new_font = tgui_input_list(user, "Set Volume", "Set Volume", font_options)

	if(new_font && Adjacent(user))
		broadcast_font = new_font

/obj/item/megaphone/super/verb/change_color()
	set name = "Change... Tune?"
	set desc = "Allows you to change the megaphone's color."
	set category = "Object"

	adjust_color(usr)

/obj/item/megaphone/super/proc/adjust_color(var/mob/living/user)
	var/new_color = tgui_input_list(user, "Set Volume", "Set Volume", color_options)

	if(new_color && Adjacent(user))
		broadcast_color = new_color

/obj/item/megaphone/super/do_broadcast(var/mob/living/user, var/message)
	if(emagged)
		if(insults)
			var/insult = pick(insultmsg)
			user.audible_message("<B>[user.GetVoice()]</B>[user.GetAltName()] broadcasts, <FONT size=[broadcast_size] face='[broadcast_font]' color='[broadcast_color]'>\"[insult]\"</FONT>", runemessage = insult)
			if(broadcast_size >= 11)
				var/turf/T = get_turf(user)
				playsound(src, 'sound/items/AirHorn.ogg', 100, 1)
				for(var/mob/living/carbon/M in oviewers(4, T))
					if(M.get_ear_protection() >= 2)
						continue
					M.SetSleeping(0)
					M.stuttering += 20
					M.ear_deaf += 30
					M.Weaken(3)
					if(prob(30))
						M.Stun(10)
						M.Paralyse(4)
					else
						M.make_jittery(50)
			insults--
		else
			user.audible_message("<span class='critical'>*BZZZZzzzzzt*</span>")
			if(prob(40) && insults <= 0)
				var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
				s.set_up(2, 1, get_turf(user))
				s.start()
				user.visible_message("<span class='warning'>\The [src] sparks violently!</span>")
				spawn(30)
					explosion(get_turf(src), -1, -1, 1, 3, adminlog = 1)
					qdel(src)
					return
	else
		user.audible_message("<B>[user.GetVoice()]</B>[user.GetAltName()] broadcasts, <FONT size=[broadcast_size] face='[broadcast_font]' color='[broadcast_color]'>\"[message]\"</FONT>", runemessage = message)
