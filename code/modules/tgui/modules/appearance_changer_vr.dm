/datum/tgui_module/appearance_changer/vore
	name = "Appearance Editor (Vore)"
	flags = APPEARANCE_ALL

/datum/tgui_module/appearance_changer/vore/tgui_state(mob/user)
	return GLOB.tgui_conscious_state

/datum/tgui_module/appearance_changer/vore/tgui_status(mob/user, datum/tgui_state/state)
	if(!isbelly(owner.loc))
		return STATUS_CLOSE
	return ..()

/datum/tgui_module/appearance_changer/vore/update_active_camera_screen()
	cam_screen.vis_contents = list(owner)
	cam_background.icon_state = "clear"
	cam_background.fill_rect(1, 1, 1, 1)
	local_skybox.cut_overlays()

/datum/tgui_module/appearance_changer/vore/tgui_close(mob/user)
	. = ..()
	QDEL_IN(src, 1)

/datum/tgui_module/appearance_changer/vore/changed_hook(flag)
	var/mob/living/carbon/human/M = owner
	var/mob/living/O = usr

	switch(flag)
		if(APPEARANCECHANGER_CHANGED_RACE)
			to_chat(M, span_notice("You lose sensation of your body, feeling only the warmth of everything around you... "))
			to_chat(O, span_notice("Your body shifts as you make dramatic changes to your captive's body."))
		if(APPEARANCECHANGER_CHANGED_GENDER)
			to_chat(M, span_notice("Your body feels very strange..."))
			to_chat(O, span_notice("You feel strange as you alter your captive's gender."))
		if(APPEARANCECHANGER_CHANGED_GENDER_ID)
			to_chat(M, span_notice("You start to feel... [capitalize(M.gender)]?"))
			to_chat(O, span_notice("You feel strange as you alter your captive's gender identity."))
		if(APPEARANCECHANGER_CHANGED_SKINTONE, APPEARANCECHANGER_CHANGED_SKINCOLOR)
			to_chat(M, span_notice("Your body tingles all over..."))
			to_chat(O, span_notice("You tingle as you make noticeable changes to your captive's body."))
		if(APPEARANCECHANGER_CHANGED_HAIRSTYLE, APPEARANCECHANGER_CHANGED_HAIRCOLOR, APPEARANCECHANGER_CHANGED_F_HAIRSTYLE, APPEARANCECHANGER_CHANGED_F_HAIRCOLOR)
			to_chat(M, span_notice("Your body tingles all over..."))
			to_chat(O, span_notice("You tingle as you make noticeable changes to your captive's body."))
		if(APPEARANCECHANGER_CHANGED_EYES)
			to_chat(M, span_notice("You feel lightheaded and drowsy..."))
			to_chat(O, span_notice("You feel warm as you make subtle changes to your captive's body."))

// Cocoon Stuff
/datum/tgui_module/appearance_changer/cocoon
	name ="Appearance Editor (Cocoon)"
	flags = APPEARANCE_ALL_HAIR
	customize_usr = TRUE

/datum/tgui_module/appearance_changer/cocoon/tgui_status(mob/user, datum/tgui_state/state)
	//if(!istype(owner.loc, /obj/item/storage/vore_egg/bugcocoon))
	if(!owner.transforming)
		return STATUS_CLOSE
	return ..()
