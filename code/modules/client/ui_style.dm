

/var/all_ui_styles = list(
	"Midnight"     = 'icons/mob/screen/midnight.dmi',
	"Orange"       = 'icons/mob/screen/orange.dmi',
	"old"          = 'icons/mob/screen/old.dmi',
	"White"        = 'icons/mob/screen/white.dmi',
	"old-noborder" = 'icons/mob/screen/old-noborder.dmi',
	"minimalist"   = 'icons/mob/screen/minimalist.dmi',
	"Hologram"     = 'icons/mob/screen/holo.dmi'
	)

/var/all_ui_styles_robot = list(
	"Midnight"     = 'icons/mob/screen1_robot.dmi',
	"Orange"       = 'icons/mob/screen1_robot.dmi',
	"old"          = 'icons/mob/screen1_robot.dmi',
	"White"        = 'icons/mob/screen1_robot.dmi',
	"old-noborder" = 'icons/mob/screen1_robot.dmi',
	"minimalist"   = 'icons/mob/screen1_robot_minimalist.dmi',
	"Hologram"     = 'icons/mob/screen1_robot_minimalist.dmi'
	)

var/global/list/all_tooltip_styles = list(
	"Midnight",		//Default for everyone is the first one,
	"Plasmafire",
	"Retro",
	"Slimecore",
	"Operative",
	"Clockwork"
	)

/proc/ui_style2icon(ui_style)
	if(ui_style in all_ui_styles)
		return all_ui_styles[ui_style]
	return all_ui_styles["White"]


/client/verb/change_ui()
	set name = "Change UI"
	set category = "Preferences.Game"
	set desc = "Configure your user interface"

	if(!ishuman(usr))
		if(!isrobot(usr))
			to_chat(usr, span_warning("You must be a human or a robot to use this verb."))
			return

	var/UI_style_new = tgui_input_list(usr, "Select a style. White is recommended for customization", "UI Style Choice", all_ui_styles)
	if(!UI_style_new) return

	var/UI_style_alpha_new = tgui_input_number(usr, "Select a new alpha (transparency) parameter for your UI, between 50 and 255", null, null, 255, 50)
	if(!UI_style_alpha_new || !(UI_style_alpha_new <= 255 && UI_style_alpha_new >= 50)) return

	var/UI_style_color_new = input(usr, "Choose your UI color. Dark colors are not recommended!") as color|null
	if(!UI_style_color_new) return

	//update UI
	usr.update_ui_style(UI_style_new, UI_style_alpha_new, UI_style_color_new)

	if(tgui_alert(usr, "Like it? Save changes?","Save?",list("Yes", "No")) == "Yes")
		usr.write_preference_directly(/datum/preference/choiced/ui_style, UI_style_new)
		usr.write_preference_directly(/datum/preference/numeric/ui_style_alpha, UI_style_alpha_new)
		usr.write_preference_directly(/datum/preference/color/ui_style_color, UI_style_color_new)
		SScharacter_setup.queue_preferences_save(prefs)
		to_chat(usr, "UI was saved")
