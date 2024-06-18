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
	return

/mob/verb/toggle_stomach_vision() //Debug ATM. Will always turn vision on.
	set name = "Toggle Stomach Vision"
	set category = "Preferences"
	var/toggle
	toggle = tgui_alert(src, "Would you like to see visible stomachs?", "Visible Tummy?", list("Yes", "No"))
	if(toggle =="Yes")
		stomach_vision = 1 //Simple! Easy!
		to_chat("You can now see stomachs!")
	else
		stomach_vision = 0
		to_chat("You will no longer see stomachs!")
	if(stomach_vision)
		if(!(VIS_CH_STOMACH in vis_enabled))
			plane_holder.set_vis(VIS_CH_STOMACH,TRUE)
			vis_enabled += VIS_CH_STOMACH
	else
		if(VIS_CH_STOMACH in vis_enabled)
			plane_holder.set_vis(VIS_CH_STOMACH,FALSE)
			vis_enabled -= VIS_CH_STOMACH
