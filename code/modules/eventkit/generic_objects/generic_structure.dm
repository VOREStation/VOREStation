/obj/structure/generic_structure
	name = "unusual object"
	desc = "An unusual object of some sort."
	icon = 'icons/obj/props/decor.dmi'
	icon_state = "bsb_off"
	anchored = 1
	density = 1
	climbable = 0
	breakable = 0
	var/on = 0
	var/icon_state_off = "bsb_off"
	var/icon_state_on = "bsb_on"
	var/wrenchable = 0
	var/activatable_hand = 1
	var/togglable = 1
	var/text_activated = "The strucutre turns on."
	var/text_deactivated = "The structure turns off."
	var/effect = 0
	var/sound_activated = 0
	var/delay_time = 0

/obj/structure/generic_structure/attack_hand(mob/user)
	if(activatable_hand)
		if(!on)
			if(delay_time)
				if(!do_after(user, delay_time, src, exclusive = TASK_USER_EXCLUSIVE))
					return 0
			on = 1
			icon_state = icon_state_on
			src.visible_message("<span class='notice'>[text_activated]</span>")
			update_icon()
			if(effect)
				var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
				s.set_up(3, 1, src)
				s.start()
			if(sound_activated)
				playsound(src, sound_activated, 50, 1)
		else if(togglable)
			if(delay_time)
				if(!do_after(user, delay_time, src, exclusive = TASK_USER_EXCLUSIVE))
					return 0
			on = 0
			icon_state = icon_state_off
			src.visible_message("<span class='notice'>[text_deactivated]</span>")
			update_icon()
	return ..()

/obj/structure/generic_structure/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(wrenchable && W.has_tool_quality(TOOL_WRENCH))
		add_fingerprint(user)
		anchored = !anchored
		to_chat(user, "<span class='notice'>You [anchored? "un" : ""]secured \the [src]!</span>")

/client/proc/generic_structure()
	set category = "EventKit"
	set name = "Spawn Generic Structure"
	set desc = "Spawn a customisable structure with a range of different options."

	var/s_wrenchable = 0
	var/s_anchored = 0
	var/s_density = 0
	var/s_activatable = 0
	var/s_togglable = 0
	var/s_icon_state_on = 0
	var/s_delay = 0
	var/s_text_activated = 0
	var/s_text_deactivated = 0
	var/s_effect = 0
	var/s_sound = 0
	var/list/icon_state_options = list("bsb_off",
										"bsb_on",
										"bsc",
										"bsc_dust",
										"biosyphon",
										"von_krabin",
										"last_shelter",
										"complicator",
										"random_radio",
										"nt_pedestal0_old",
										"nt_pedestal1_old",
										"nt_reader_off",
										"nt_reader_on",
										"nt_biocan",
										"nt_optable-idle",
										"nt_optable-active",
										"nt_obelisk",
										"nt_obelisk_on",
										"nt_cruciforge",
										"nt_cruciforge_start",
										"nt_cruciforge_work",
										"nt_solidifier",
										"nt_solidifier_on",
										"artwork_statue_1",
										"artwork_statue_2",
										"artwork_statue_3",
										"artwork_statue_4",
										"artwork_statue_5",
										"artwork_statue",
										"dominator",
										"dominator-broken",
										"gel_cocoon",
										"tank_broken",
										"tank_larva",
										"stump",
										"conduit_off",
										"conduit_spin",
										"core_empty",
										"core_inactive",
										"core_active",
										"tradebeacon",
										"tradebeacon_active",
										"tradebeacon_sending",
										"treadebeacon_sending_active",
										"smelter",
										"smelter-process",
										"sorter",
										"sorter-process",
										"stamper",
										"stamper_on",
										"tgmc_console1",
										"tgmc_console1_on",
										"tgmc_console2",
										"tgmc_console2_on",
										"tgmc_console3",
										"tgmc_console3_on",
										"tgmc_console4",
										"tgmc_console4_on",
										"tgmc_console5",
										"tgmc_console5_on",
										"tgmc_sentry",
										"minirocket_pod",
										"ob_warhead_1",
										"ob_warhead_2",
										"ob_warhead_3",
										"ob_warhead_4",
										"angel")
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

	var/s_name = tgui_input_text(src, "Structure Name:", "Name")
	var/s_desc = tgui_input_text(src, "Structure Description:", "Description")
	var/check_anchored = tgui_alert(src, "Start anchored?", "anchored", list("Yes", "No", "Cancel"))
	if(check_anchored == "Cancel")
		return
	if(check_anchored == "No")
		s_anchored = 0
	if(check_anchored == "Yes")
		s_anchored = 1
	var/check_density = tgui_alert(src, "Start dense?", "density", list("Yes", "No", "Cancel"))
	if(check_density == "Cancel")
		return
	if(check_density == "No")
		s_density = 0
	if(check_density == "Yes")
		s_density = 1
	var/check_wrenchable = tgui_alert(src, "Allow it to be fastened and unfastened with a wrench?", "wrenchable", list("Yes", "No", "Cancel"))
	if(check_wrenchable == "Cancel")
		return
	if(check_wrenchable == "No")
		s_wrenchable = 0
	if(check_wrenchable == "Yes")
		s_wrenchable = 1
	var/s_icon_state_off = tgui_input_list(src, "Choose starting icon state:", "icon_state_off", icon_state_options)
	var/check_activatable = tgui_alert(src, "Allow it to be turned on?", "activatable", list("Yes", "No", "Cancel"))
	if(check_activatable == "Cancel")
		return
	if(check_activatable == "No")
		s_activatable = 0
	if(check_activatable == "Yes")
		s_activatable = 1
		s_text_activated = tgui_input_text(src, "Activation text:", "Activation Text")
		check_togglable = tgui_alert(src, "Allow it to be turned back off again?", "togglable", list("Yes", "No", "Cancel"))
		if(check_togglable == "Cancel")
			return
		if(check_togglable == "No")
			s_togglable = 0
		if(check_togglable == "Yes")
			s_text_deactivated = tgui_input_text(src, "Deactivation text:", "Deactivation Text")
			s_togglable = 1
		s_icon_state_on = tgui_input_list(src, "Choose activated icon state:", "icon_state_on", icon_state_options)
		s_delay = tgui_input_number(src, "Do you want it to take time to put turn on? Choose a number of deciseconds to activate, or 0 for instant.", "Delay")
		var/check_effect = tgui_alert(src, "Spark when turning on?", "Spark?", list("Yes", "No", "Cancel"))
		if(check_effect == "Cancel")
			return
		if(check_effect == "No")
			s_effect = 0
		if(check_effect == "Yes")
			s_effect = 1
		var/check_sound = tgui_alert(src, "Play a sound when turning on?", "Sound", list("Yes", "No", "Cancel"))
		if(check_sound == "Cancel")
			return
		if(check_sound == "Yes")
			s_sound = tgui_input_list(src, "Choose a sound to play on activation:", "Sound", sound_options)

	var/spawnloc = get_turf(src.mob)
	var/obj/structure/generic_structure/P = new(spawnloc)
	P.name = s_name
	P.desc = s_desc
	P.anchored = s_anchored
	P.density = s_density
	P.icon_state_off = s_icon_state_off
	P.icon_state_on = s_icon_state_on
	P.wrenchable = s_wrenchable
	P.activatable_hand = s_activatable
	P.togglable = s_togglable
	P.text_activated = s_text_activated
	P.text_deactivated = s_text_deactivated
	P.effect = s_effect
	P.sound_activated = s_sound
	P.delay_time = s_delay
	P.update_icon()

