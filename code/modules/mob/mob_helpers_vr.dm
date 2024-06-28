/mob/recalculate_vis()
	. = ..()

	if(stomach_vision && !(VIS_CH_STOMACH in vis_enabled))
		plane_holder.set_vis(VIS_CH_STOMACH,TRUE)
		vis_enabled += VIS_CH_STOMACH
	else if(!stomach_vision && (VIS_CH_STOMACH in vis_enabled))
		plane_holder.set_vis(VIS_CH_STOMACH,FALSE)
		vis_enabled -= VIS_CH_STOMACH

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


/mob/verb/toggle_stomach_vision()
	set name = "Toggle Stomach Sprites"
	set category = "Preferences"
	set desc = "Toggle the ability to see stomachs or not"

	var/toggle
	toggle = tgui_alert(src, "Would you like to see visible stomachs?", "Visible Tummy?", list("Yes", "No"))
	if(toggle =="Yes")
		stomach_vision = 1 //Simple! Easy!
		if(!(VIS_CH_STOMACH in vis_enabled))
			plane_holder.set_vis(VIS_CH_STOMACH,TRUE)
			vis_enabled += VIS_CH_STOMACH
		to_chat("You can now see stomachs!")
	else
		stomach_vision = 0
		if(VIS_CH_STOMACH in vis_enabled)
			plane_holder.set_vis(VIS_CH_STOMACH,FALSE)
			vis_enabled -= VIS_CH_STOMACH
		to_chat("You will no longer see stomachs!")

/* //Leaving this in as an example of 'how to properly enable a plane to hide/show itself' for future PRs.
if(stomach_vision && !(VIS_CH_STOMACH in vis_enabled))
	plane_holder.set_vis(VIS_CH_STOMACH,TRUE)
	vis_enabled += VIS_CH_STOMACH
else if(!stomach_vision && (VIS_CH_STOMACH in vis_enabled))
	plane_holder.set_vis(VIS_CH_STOMACH,FALSE)
	vis_enabled -= VIS_CH_STOMACH
*/
