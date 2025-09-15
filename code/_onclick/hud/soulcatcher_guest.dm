/atom/movable/screen/nifsc
	icon = 'icons/mob/screen_nifsc.dmi'

/atom/movable/screen/nifsc/MouseEntered(location,control,params)
	flick(icon_state + "_anim", src)
	openToolTip(usr, src, params, title = name, content = desc)

/atom/movable/screen/nifsc/MouseExited()
	closeToolTip(usr)

/atom/movable/screen/nifsc/Click()
	closeToolTip(usr)

/atom/movable/screen/nifsc/reenter
	name = "Re-enter NIF"
	desc = "Return into the NIF"
	icon_state = "reenter"

/atom/movable/screen/nifsc/reenter/Click()
	..()
	var/mob/living/carbon/brain/caught_soul/CS = usr
	CS.reenter_soulcatcher()

/atom/movable/screen/nifsc/arproj
	name = "AR project"
	desc = "Project your form into Augmented Reality for those around your predator with the appearance of your loaded character."
	icon_state = "arproj"

/atom/movable/screen/nifsc/arproj/Click()
		..()
		var/mob/living/carbon/brain/caught_soul/CS = usr
		CS.ar_project()

/atom/movable/screen/nifsc/jumptoowner
	name = "Jump back to host"
	desc = "Jumb back to the Soulcather host"
	icon_state = "jump"

/atom/movable/screen/nifsc/jumptoowner/Click()
	..()
	var/mob/living/carbon/brain/caught_soul/CS = usr
	CS.jump_to_owner()

/atom/movable/screen/nifsc/nme
	name = "Emote into Soulcatcher"
	desc = "Emote into the NIF's Soulcatcher (circumventing AR emoting)"
	icon_state = "nme"

/atom/movable/screen/nifsc/nme/Click()
	..()
	var/mob/living/carbon/brain/caught_soul/CS = usr
	CS.nme()

/atom/movable/screen/nifsc/nsay
	name = "Speak into Soulcatcher"
	desc = "Speak into the NIF's Soulcatcher (circumventing AR speaking)"
	icon_state = "nsay"

/atom/movable/screen/nifsc/nsay/Click()
	..()
	var/mob/living/carbon/brain/caught_soul/CS = usr
	CS.nsay()


/mob/living/carbon/brain/caught_soul/create_mob_hud(datum/hud/HUD, apply_to_client = TRUE)
	..()

	var/list/adding = list()
	HUD.adding = adding

	var/atom/movable/screen/using

	using = new /atom/movable/screen/nifsc/reenter()
	using.screen_loc = ui_nifsc_reenter
	using.hud = src
	adding += using

	using = new /atom/movable/screen/nifsc/arproj()
	using.screen_loc = ui_nifsc_arproj
	using.hud = src
	adding += using

	using = new /atom/movable/screen/nifsc/jumptoowner()
	using.screen_loc = ui_nifsc_jumptoowner
	using.hud = src
	adding += using

	using = new /atom/movable/screen/nifsc/nme()
	using.screen_loc = ui_nifsc_nme
	using.hud = src
	adding += using

	using = new /atom/movable/screen/nifsc/nsay()
	using.screen_loc = ui_nifsc_nsay
	using.hud = src
	adding += using


	if(client && apply_to_client)
		client.screen = list()
		client.screen += HUD.adding
		client.screen += client.void
