/mob/recalculate_vis()
	. = ..()

	if(!plane_holder || !vis_enabled)
		return

	if(vantag_hud)
		if(!(VIS_CH_VANTAG in vis_enabled))
			plane_holder.set_vis(VIS_CH_VANTAG,TRUE)
			vis_enabled += VIS_CH_VANTAG
	else
		if(VIS_CH_VANTAG in vis_enabled)
			plane_holder.set_vis(VIS_CH_VANTAG,FALSE)
			vis_enabled -= VIS_CH_VANTAG

	if(soulgem?.flag_check(SOULGEM_SEE_SR_SOULS))
		plane_holder.set_vis(VIS_SOULCATCHER, TRUE)
		vis_enabled += VIS_SOULCATCHER
	else
		plane_holder.set_vis(VIS_SOULCATCHER, FALSE)
		vis_enabled -= VIS_SOULCATCHER

	return


/mob/verb/toggle_stomach_vision()
	set name = "Toggle Stomach Sprites"
	set category = "Preferences.Vore"
	set desc = "Toggle the ability to see stomachs or not"

	var/toggle
	toggle = tgui_alert(src, "Would you like to see visible stomachs?", "Visible Tummy?", list("Yes", "No"))
	if(!toggle)
		return
	if(toggle =="Yes")
		client?.prefs.write_preference_by_type(/datum/preference/toggle/tummy_sprites,TRUE) //Simple! Easy!
		to_chat(src, "You can now see stomachs!")
	else
		client?.prefs.write_preference_by_type(/datum/preference/toggle/tummy_sprites,FALSE)
		to_chat(src, "You will no longer see stomachs!")
	recalculate_vis()
