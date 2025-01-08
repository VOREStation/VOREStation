/mob/living/carbon/alien/create_mob_hud(datum/hud/HUD, apply_to_client = TRUE)
	..()

	HUD.ui_style = 'icons/mob/screen1_alien.dmi'

	HUD.adding = list()
	HUD.other = list()

	var/obj/screen/using

	using = new /obj/screen()
	using.name = "mov_intent"
	using.set_dir(SOUTHWEST)
	using.icon = HUD.ui_style
	using.icon_state = (m_intent == I_RUN ? "running" : "walking")
	using.screen_loc = ui_acti
	using.layer = HUD_LAYER
	HUD.adding += using
	HUD.move_intent = using

	healths = new /obj/screen()
	healths.icon = HUD.ui_style
	healths.icon_state = "health0"
	healths.name = "health"
	healths.screen_loc = ui_alien_health

	if(client && apply_to_client)
		client.screen = list()
		client.screen += list(healths)
		client.screen += HUD.adding + HUD.other
		client.screen += client.void
