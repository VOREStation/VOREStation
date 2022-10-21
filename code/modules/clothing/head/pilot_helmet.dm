//Pilot

/obj/item/clothing/head/pilot
	name = "pilot helmet"
	desc = "Standard pilot gear. Protects the head from impacts."
	icon_state = "pilot_helmet1"
	item_icons = list(slot_head_str = 'icons/mob/pilot_helmet.dmi')
	sprite_sheets = list(
		SPECIES_TESHARI = 'icons/inventory/head/mob_teshari.dmi'
		)
	item_flags = THICKMATERIAL
	armor = list(melee = 20, bullet = 10, laser = 10, energy = 5, bomb = 10, bio = 0, rad = 0)
	flags_inv = HIDEEARS
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	w_class = ITEMSIZE_NORMAL

	var/obj/machinery/computer/shuttle_control/web/shuttle_comp
	var/obj/screen/pilot_hud
	var/list/images
	var/list/raw_images
	var/last_status

/obj/item/clothing/head/pilot/Initialize()
	. = ..()

	images = list()
	raw_images = list()

	pilot_hud = new(src)
	pilot_hud.screen_loc = "1,1"
	pilot_hud.icon = 'icons/obj/piloting_overlay.dmi'
	pilot_hud.icon_state = "dimmer"
	pilot_hud.layer = SCREEN_LAYER
	pilot_hud.plane = PLANE_FULLSCREEN
	pilot_hud.mouse_opacity = 0
	pilot_hud.alpha = 0

	var/image/I
	I = image(pilot_hud.icon,pilot_hud,"top_bar",layer=SCREEN_LAYER+1)
	I.appearance_flags = RESET_ALPHA
	I.alpha = 145
	images["top_bar"] = I
	raw_images += I

	I = image(pilot_hud.icon,pilot_hud,"top_dots",layer=SCREEN_LAYER+1)
	I.appearance_flags = RESET_ALPHA
	I.alpha = 200
	images["topdots"] = I
	raw_images += I

	I = image(pilot_hud.icon,pilot_hud,"words_discon",layer=SCREEN_LAYER+1) //words_standby, words_flying, words_spool, words_discon
	I.appearance_flags = RESET_ALPHA
	I.alpha = 200
	images["top_words"] = I
	raw_images += I

	I = image(pilot_hud.icon,pilot_hud,"",layer=SCREEN_LAYER+1)
	I.appearance_flags = RESET_ALPHA
	I.alpha = 200
	images["charging"] = I
	raw_images += I

	I = image(pilot_hud.icon,pilot_hud,"left_bar",layer=SCREEN_LAYER+1)
	I.appearance_flags = RESET_ALPHA
	I.alpha = 0
	images["left_bar"] = I
	raw_images += I

	I = image(pilot_hud.icon,pilot_hud,"right_bar",layer=SCREEN_LAYER+1)
	I.appearance_flags = RESET_ALPHA
	I.alpha = 0
	images["right_bar"] = I
	raw_images += I

	I = image(pilot_hud.icon,pilot_hud,"flyboxes",layer=SCREEN_LAYER+1)
	I.appearance_flags = RESET_ALPHA
	I.alpha = 0
	images["flyboxes"] = I
	raw_images += I

	I = image(pilot_hud.icon,pilot_hud,"horizon",layer=SCREEN_LAYER+1)
	I.appearance_flags = RESET_ALPHA
	I.alpha = 0
	images["horizon"] = I
	raw_images += I

/obj/item/clothing/head/pilot/proc/update_hud(var/status)
	if(last_status == status)
		return

	last_status = status

	if(status == SHUTTLE_INTRANSIT)
		var/image/I = images["top_words"]
		I.icon_state = "words_flying"
		I = images["left_bar"]
		I.alpha = 200
		I = images["right_bar"]
		I.alpha = 200
		I = images["flyboxes"]
		I.alpha = 200
		I = images["horizon"]
		I.alpha = 200
		I = images["charging"]
		I.icon_state = ""
		animate(pilot_hud,alpha=255,time=3 SECONDS)

	else if(status == SHUTTLE_IDLE)
		var/image/I = images["top_words"]
		I.icon_state = "words_standby"
		I = images["left_bar"]
		I.alpha = 0
		I = images["right_bar"]
		I.alpha = 0
		I = images["flyboxes"]
		I.alpha = 0
		I = images["horizon"]
		I.alpha = 0
		I = images["charging"]
		I.icon_state = ""
		animate(pilot_hud,alpha=0,time=3 SECONDS)

	else if(status == SHUTTLE_WARMUP)
		var/image/I = images["top_words"]
		I.icon_state = "words_spool"
		I = images["left_bar"]
		I.alpha = 200
		I = images["right_bar"]
		I.alpha = 200
		I = images["flyboxes"]
		I.alpha = 0
		I = images["horizon"]
		I.alpha = 0
		I = images["charging"]
		I.icon_state = "charging"
		animate(pilot_hud,alpha=255,time=3 SECONDS)

	else if(status == "discon")
		var/image/I = images["top_words"]
		I.icon_state = "words_discon"
		I = images["left_bar"]
		I.alpha = 0
		I = images["right_bar"]
		I.alpha = 0
		I = images["flyboxes"]
		I.alpha = 0
		I = images["horizon"]
		I.alpha = 0
		I = images["charging"]
		I.icon_state = ""
		animate(pilot_hud,alpha=0,time=3 SECONDS)

/obj/item/clothing/head/pilot/verb/hud_colors()
	set name = "Alter HUD color"
	set desc = "Change the color of the piloting HUD."
	set category = "Object"
	set src in usr

	var/newcolor = input(usr,"Pick a color!","HUD Color") as null|color
	if(newcolor)
		for(var/img in list("top_words","left_bar","right_bar","flyboxes"))
			var/image/I = images[img]
			I.color = newcolor

/obj/item/clothing/head/pilot/Destroy()
	for(var/image/I as anything in raw_images)
		I.loc = null
	shuttle_comp = null
	qdel(pilot_hud)
	return ..()

/obj/item/clothing/head/pilot/equipped(var/mob/user,var/slot)
	. = ..()
	if(slot == slot_head && user.client)
		user.client.screen |= pilot_hud
		user.client.images |= raw_images

/obj/item/clothing/head/pilot/dropped(var/mob/user)
	. = ..()
	if(user.client)
		user.client.screen -= pilot_hud
		user.client.images -= raw_images

/obj/item/clothing/head/pilot/alt
	name = "pilot helmet"
	desc = "Standard pilot gear. Protects the head from impacts. This one has a retractable visor"
	icon_state = "pilot_helmet2"
	action_button_name = "Toggle Visor"

/obj/item/clothing/head/pilot/alt/attack_self(mob/user as mob)
	if(src.icon_state == initial(icon_state))
		src.icon_state = "[icon_state]up"
		to_chat(user, "You raise the visor on the pilot helmet.")
	else
		src.icon_state = initial(icon_state)
		to_chat(user, "You lower the visor on the pilot helmet.")
	update_clothing_icon() //so our mob-overlays update
