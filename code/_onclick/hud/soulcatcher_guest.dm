/obj/screen/nifsc
	icon = 'icons/mob/screen_nifsc.dmi'

/obj/screen/nifsc/MouseEntered(location,control,params)
	flick(icon_state + "_anim", src)
	openToolTip(usr, src, params, title = name, content = desc)

/obj/screen/nifsc/MouseExited()
	closeToolTip(usr)

/obj/screen/nifsc/Click()
	closeToolTip(usr)

/obj/screen/nifsc/reenter
	name = "Re-enter NIF"
	desc = "Return into the NIF"
	icon_state = "reenter"

/obj/screen/nifsc/reenter/Click()
	reenter_soulcatcher()

/obj/screen/nifsc/arproj
	name = "AR project"
	desc = "Project your form into Augmented Reality for those around your predator with the appearance of your loaded character."
	icon_state = "arproj"

/obj/screen/nifsc/arproj/Click()
	ar_project()

/obj/screen/nifsc/jumptoowner
	name = "Jump back to host"
	desc = "Jumb back to the Soulcather host"
	icon_state = "jump"

/obj/screen/nifsc/jumptoowner/Click()
	jump_to_owner()

/obj/screen/nifsc/nme
	name = "Emote into Soulcatcher"
	desc = "Emote into the NIF's Soulcatcher (circumventing AR emoting)"
	icon_state = "nme"

/obj/screen/nifsc/nme/Click()
	nme()

/obj/screen/nifsc/nsay
	name = "Speak into Soulcatcher"
	desc = "Speak into the NIF's Soulcatcher (circumventing AR speaking)"
	icon_state = "nsay"

/obj/screen/nifsc/nsay/Click()
	nsay()


/mob/living/carbon/brain/caught_soul/create_mob_hud(datum/hud/HUD, apply_to_client = TRUE)
	..()

	var/list/adding = list()
	HUD.adding = adding
	
	var/obj/screen/using

	using = new /obj/screen/nifsc/reenter()
	using.screen_loc = ui_nifsc_reenter
	using.hud = src
	adding += using

	using = new /obj/screen/nifsc/arproj()
	using.screen_loc = ui_nifsc_arproj
	using.hud = src
	adding += using

	using = new /obj/screen/nifsc/jumptoowner()
	using.screen_loc = ui_nifsc_jumptoowner
	using.hud = src
	adding += using

	using = new /obj/screen/nifsc/nme()
	using.screen_loc = ui_nifsc_nme
	using.hud = src
	adding += using

	using = new /obj/screen/nifsc/nsay()
	using.screen_loc = ui_nifsc_nsay
	using.hud = src
	adding += using


	if(client && apply_to_client)
		client.screen = list()
		client.screen += HUD.adding
		client.screen += client.void
