
/datum/hud/proc/unplayer_hud()
	return

/datum/hud/proc/ghost_hud()
	return

/datum/hud/proc/blob_hud(ui_style = 'icons/mob/screen1_Midnight.dmi')

	blobpwrdisplay = new /obj/screen()
	blobpwrdisplay.name = "blob power"
	blobpwrdisplay.icon_state = "block"
	blobpwrdisplay.screen_loc = ui_health
	blobpwrdisplay.layer = HUD_LAYER

	blobhealthdisplay = new /obj/screen()
	blobhealthdisplay.name = "blob health"
	blobhealthdisplay.icon_state = "block"
	blobhealthdisplay.screen_loc = ui_internal
	blobhealthdisplay.layer = HUD_LAYER

	mymob.client.screen = list()

	mymob.client.screen += list(blobpwrdisplay, blobhealthdisplay)
	mymob.client.screen += mymob.client.void
/*
/datum/hud/proc/slime_hud(ui_style = 'icons/mob/screen1_Midnight.dmi')

	src.adding = list()

	var/obj/screen/using

	using = new /obj/screen()
	using.name = "act_intent"
	using.set_dir(SOUTHWEST)
	using.icon = ui_style
	using.icon_state = "intent_"+mymob.a_intent
	using.screen_loc = ui_zonesel
	using.layer = HUD_LAYER
	src.adding += using
	action_intent = using

	//intent small hud objects
	var/icon/ico

	ico = new(ui_style, "black")
	ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
	ico.DrawBox(rgb(255,255,255,1),1,ico.Height()/2,ico.Width()/2,ico.Height())
	using = new /obj/screen( src )
	using.name = "help"
	using.icon = ico
	using.screen_loc = ui_zonesel
	using.layer = HUD_LAYER+0.01
	src.adding += using
	help_intent = using

	ico = new(ui_style, "black")
	ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
	ico.DrawBox(rgb(255,255,255,1),ico.Width()/2,ico.Height()/2,ico.Width(),ico.Height())
	using = new /obj/screen( src )
	using.name = "disarm"
	using.icon = ico
	using.screen_loc = ui_zonesel
	using.layer = HUD_LAYER+0.01
	src.adding += using
	disarm_intent = using

	ico = new(ui_style, "black")
	ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
	ico.DrawBox(rgb(255,255,255,1),ico.Width()/2,1,ico.Width(),ico.Height()/2)
	using = new /obj/screen( src )
	using.name = "grab"
	using.icon = ico
	using.screen_loc = ui_zonesel
	using.layer = HUD_LAYER+0.01
	src.adding += using
	grab_intent = using

	ico = new(ui_style, "black")
	ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
	ico.DrawBox(rgb(255,255,255,1),1,1,ico.Width()/2,ico.Height()/2)
	using = new /obj/screen( src )
	using.name = I_HURT
	using.icon = ico
	using.screen_loc = ui_zonesel
	using.layer = HUD_LAYER+0.01
	src.adding += using
	hurt_intent = using

	mymob.client.screen = list()
	mymob.client.screen += src.adding
	mymob.client.screen += mymob.client.void

	return
*/

//	HUD.construct_hud() //Archaic.
/*
/datum/hud/proc/construct_hud()
	var/constructtype

	if(istype(mymob,/mob/living/simple_mob/construct/armoured) || istype(mymob,/mob/living/simple_mob/construct/behemoth))
		constructtype = "juggernaut"
	else if(istype(mymob,/mob/living/simple_mob/construct/builder))
		constructtype = "artificer"
	else if(istype(mymob,/mob/living/simple_mob/construct/wraith))
		constructtype = "wraith"
	else if(istype(mymob,/mob/living/simple_mob/construct/harvester))
		constructtype = "harvester"

	if(constructtype)

		mymob.fire.icon = 'icons/mob/screen1_construct.dmi'
		mymob.fire.icon_state = "fire0"
		mymob.fire.name = "fire"
		mymob.fire.screen_loc = ui_construct_fire

		mymob.healths.icon = 'icons/mob/screen1_construct.dmi'
		mymob.healths.icon_state = "[constructtype]_health0"
		mymob.healths.name = "health"
		mymob.healths.screen_loc = ui_construct_health

		mymob.pullin.icon = 'icons/mob/screen1_construct.dmi'
		mymob.pullin.icon_state = "pull0"
		mymob.pullin.name = "pull"
		mymob.pullin.screen_loc = ui_construct_pull


		mymob.zone_sel.icon = 'icons/mob/screen1_construct.dmi'
		mymob.zone_sel.overlays.len = 0
		mymob.zone_sel.overlays += image('icons/mob/zone_sel.dmi', "[mymob.zone_sel.selecting]")


		mymob.purged.icon = 'icons/mob/screen1_construct.dmi'
		mymob.purged.icon_state = "purge0"
		mymob.purged.name = "purged"
		mymob.purged.screen_loc = ui_construct_purge

	mymob.client.screen = list()

	mymob.client.screen += list(mymob.fire, mymob.healths, mymob.pullin, mymob.zone_sel, mymob.purged)
	mymob.client.screen += mymob.client.void
*/
