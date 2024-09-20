/obj/item/generic_item
	name = "unusual object"
	desc = "An unusual object of some sort."
	icon = 'icons/obj/props/items.dmi'
	icon_state = "old_handheld"
	var/on = 0
	var/icon_state_off = "old_handheld"
	var/icon_state_on = "old_handheld_on"
	var/activatable_hand = 1
	var/togglable = 1
	var/text_activated = "The item turns on."
	var/text_deactivated = "The item turns off."
	var/effect = 0
	var/object = 0
	var/sound_activated = 0
	var/delay_time = 0
	var/icon_off = 0
	var/icon_on = 0

/obj/item/generic_item/attack_self(mob/user)
	if(activatable_hand)
		if(!on)
			if(delay_time)
				if(!do_after(user, delay_time, src, exclusive = TASK_USER_EXCLUSIVE))
					return 0
			on = 1
			if(icon_on)
				icon = icon_on
			else
				icon = 'icons/obj/props/items.dmi'
			icon_state = icon_state_on
			if(user)
				user.visible_message("<span class='notice'>[text_activated]</span>")
			update_icon()
			if(effect == 1)
				var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
				s.set_up(3, 1, src)
				s.start()
			if(effect == 2)
				for(var/obj/machinery/light/L in machines)
					if(L.z != user.z || get_dist(user,L) > 10)
						continue
					else
						L.flicker(10)
			if(effect == 3)
				for (var/mob/O in viewers(user, null))
					if(get_dist(user, O) > 3)
						continue

					var/flash_time = 10
					if(istype(O, /mob/living/carbon/human))
						var/mob/living/carbon/human/H = O
						//VOREStation Edit Start
						if(H.nif && H.nif.flag_check(NIF_V_FLASHPROT,NIF_FLAGS_VISION))
							H.nif.notify("High intensity light detected, and blocked!",TRUE)
							continue
						//VOREStation Edit End
						if(!H.eyecheck() <= 0)
							continue
						flash_time *= H.species.flash_mod
						var/obj/item/organ/internal/eyes/E = H.internal_organs_by_name[O_EYES]
						if(!E)
							return
						if(E.is_bruised() && prob(E.damage + 50))
							H.flash_eyes()
							E.damage += rand(1, 5)
					else
						if(!O.blinded && isliving(O))
							var/mob/living/L = O
							L.flash_eyes()
					O.Weaken(flash_time)
			if(effect == 4)
				var/atom/o = new object(get_turf(user))
				src.visible_message("<span class='notice'>[src] has produced [o]!</span>")
			if(sound_activated)
				playsound(src, sound_activated, 50, 1)
		else if(togglable)
			if(delay_time)
				if(!do_after(user, delay_time, src, exclusive = TASK_USER_EXCLUSIVE))
					return 0
			on = 0
			icon_state = icon_state_off
			if(icon_off)
				icon = icon_off
			else
				icon = 'icons/obj/props/items.dmi'
			if(user)
				user.visible_message("<span class='notice'>[text_deactivated]</span>")
			update_icon()
	return ..()

/client/proc/generic_item()
	set category = "EventKit"
	set name = "Spawn Generic Item"
	set desc = "Spawn a customisable item with a range of different options."

	var/s_activatable = 0
	var/s_togglable = 0
	var/s_icon_state_on = 0
	var/s_icon = 0
	var/s_icon2 = 0
	var/s_delay = 0
	var/s_text_activated = 0
	var/s_text_deactivated = 0
	var/s_effect = 0
	var/s_sound = 0
	var/s_object = 0
	var/list/icon_state_options = list("old_handheld",
										"old_handheld_on",
										"switch",
										"switch_on",
										"chalice",
										"staffofnothing",
										"staffofchange",
										"staffofanimation",
										"staffofchaos",
										"scroll_rolledup",
										"scroll_blank",
										"scroll_text",
										"scroll_textseal",
										"scroll_rolledupseal",
										"revolver",
										"universal_id",
										"universal_id_glow",
										"partypopper",
										"partypopper_e",
										"screwdriver",
										"screwdriver_glow",
										"crystal",
										"crystal_red",
										"old_phone",
										"old_phone_on",
										"flash",
										"flash_red",
										"flash_burnt",
										"techball_green",
										"techball_yellow",
										"techball_red",
										"techball_blue",
										"fleshorb",
										"fleshorb_moving",
										"Upload Own Sprite")
	var/list/sound_options = list('sound/effects/alert.ogg',
								'sound/effects/bamf.ogg',
								'sound/effects/bang.ogg',
								'sound/effects/blobattack.ogg',
								'sound/effects/cascade.ogg',
								'sound/effects/clockcult_gateway_disrupted.ogg',
								'sound/effects/closet_close.ogg',
								'sound/effects/confetti_ball.ogg',
								'sound/effects/deskbell.ogg',
								'sound/effects/EMPulse.ogg',
								'sound/effects/Explosion1.ogg',
								'sound/effects/ghost.ogg',
								'sound/effects/Glassbr1.ogg',
								'sound/effects/lightningshock.ogg',
								'sound/effects/lighton.ogg',
								'sound/effects/magnetclamp.ogg',
								'sound/effects/pai_boot.ogg',
								'sound/effects/pai_login.ogg',
								'sound/effects/pai-restore.ogg',
								'sound/effects/radio_common.ogg',
								'sound/effects/refill.ogg',
								'sound/effects/siren.ogg',
								'sound/effects/smoke.ogg',
								'sound/effects/sparks1.ogg',
								'sound/effects/spray.ogg',
								'sound/effects/squelch1.ogg',
								'sound/effects/supermatter.ogg',
								'sound/effects/Whipcrack.ogg',
								'sound/effects/woodcutting.ogg')

	var/check_togglable


	if(!holder)
		return

	var/s_name = tgui_input_text(src, "Item Name:", "Name")
	var/s_desc = tgui_input_text(src, "Item Description:", "Description")
	var/s_icon_state_off = tgui_input_list(src, "Choose starting icon state:", "icon_state_off", icon_state_options)
	if(s_icon_state_off == "Upload Own Sprite")
		s_icon = input(usr, "Choose an image file to upload. Images that are not 32x32 will need to have their positions offset.","Upload Icon") as null|file
	var/check_activatable = tgui_alert(src, "Allow it to be turned on?", "activatable", list("Yes", "No", "Cancel"))
	if(!check_activatable || check_activatable == "Cancel")
		return
	if(check_activatable == "No")
		s_activatable = 0
	if(check_activatable == "Yes")
		s_activatable = 1
		s_text_activated = tgui_input_text(src, "Activation text:", "Activation Text")
		check_togglable = tgui_alert(src, "Allow it to be turned back off again?", "togglable", list("Yes", "No", "Cancel"))
		if(!check_togglable || check_togglable == "Cancel")
			return
		if(check_togglable == "No")
			s_togglable = 0
		if(check_togglable == "Yes")
			s_text_deactivated = tgui_input_text(src, "Deactivation text:", "Deactivation Text")
			s_togglable = 1
		s_icon_state_on = tgui_input_list(src, "Choose activated icon state:", "icon_state_on", icon_state_options)
		if(s_icon_state_on == "Upload Own Sprite")
			s_icon2 = input(usr, "Choose an image file to upload. Images that are not 32x32 will need to have their positions offset.","Upload Icon") as null|file
		s_delay = tgui_input_number(src, "Do you want it to take time to put turn on? Choose a number of deciseconds to activate, or 0 for instant.", "Delay")
		var/check_effect = tgui_alert(src, "Produce an effect on activation?", "Effect?", list("No", "Spark", "Flicker Lights", "Flash", "Spawn Item", "Cancel"))
		if(!check_effect || check_effect == "Cancel")
			return
		if(check_effect == "No")
			s_effect = 0
		if(check_effect == "Spark")
			s_effect = 1
		if(check_effect == "Flicker Lights")
			s_effect = 2
		if(check_effect == "Flash")
			s_effect = 3
		if(check_effect == "Spawn Item")
			s_effect = 4
			s_object = get_path_from_partial_text()
		var/check_sound = tgui_alert(src, "Play a sound when turning on?", "Sound", list("Yes", "No", "Cancel"))
		if(!check_sound || check_sound == "Cancel")
			return
		if(check_sound == "Yes")
			s_sound = tgui_input_list(src, "Choose a sound to play on activation:", "Sound", sound_options)

	var/spawnloc = get_turf(src.mob)
	var/obj/item/generic_item/P = new(spawnloc)
	P.name = s_name
	P.desc = s_desc
	P.icon_state_off = s_icon_state_off
	P.icon_state_on = s_icon_state_on
	P.activatable_hand = s_activatable
	P.togglable = s_togglable
	P.text_activated = s_text_activated
	P.text_deactivated = s_text_deactivated
	P.effect = s_effect
	P.sound_activated = s_sound
	P.delay_time = s_delay
	P.object = s_object
	P.icon_state = s_icon_state_off
	P.icon_off = s_icon
	P.icon_on = s_icon2
	if(s_icon)
		P.icon = s_icon
	P.update_icon()
