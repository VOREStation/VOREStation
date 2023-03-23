/obj/screen/popup
	name = "popup"
	desc = "NOTICE ME!"

	icon = 'icons/mob/screen1_popups.dmi'
	plane = PLANE_PLAYER_HUD_ABOVE
	layer = INFINITY

	var/close_button_x_start
	var/close_button_x_end
	var/close_button_y_start
	var/close_button_y_end

	var/client/holder

/obj/screen/popup/Click(location, control,params)
	var/list/PL = params2list(params)
	var/icon_x = text2num(PL["icon-x"])
	var/icon_y = text2num(PL["icon-y"])
	if(check_click_spot(icon_x, icon_y))
		close_popup()
	else
		popup_action()

/obj/screen/popup/proc/popup_action()
	return

/obj/screen/popup/proc/close_popup()
	holder.screen -= src
	qdel(src)

/obj/screen/popup/proc/check_click_spot(click_x, click_y)
	if((click_x <= close_button_x_end) && (click_x >= close_button_x_start))
		if((click_y <= close_button_y_end) && (click_y >= close_button_y_start))
			return TRUE
	return FALSE

/obj/screen/popup/proc/get_random_screen_location()
	var/loc_x = rand(1,11)
	var/loc_x_offset = rand(0,16)
	var/loc_y = rand(1,12)
	var/loc_y_offset = rand(0,16)
	return "[loc_x]:[loc_x_offset],[loc_y]:[loc_y_offset]"

/client/proc/create_fake_ad_popup(popup_type)
	if(!src)
		return
	var/obj/screen/popup/ad = new popup_type()
	ad.screen_loc = ad.get_random_screen_location()
	src.screen |= ad
	ad.holder = src

/client/proc/create_fake_ad_popup_multiple(popup_type, popup_amount)
	if(!src)
		return
	for(var/i = 0, i < popup_amount, i++)
		create_fake_ad_popup(popup_type)

/obj/screen/popup/default
	name = "CLICK ME"

	icon_state = "popup1"

	close_button_x_start = 118
	close_button_x_end = 126
	close_button_y_start = 86
	close_button_y_end = 94

/obj/screen/popup/default/New()
	..()
	icon_state = "popup[rand(1,10)]"