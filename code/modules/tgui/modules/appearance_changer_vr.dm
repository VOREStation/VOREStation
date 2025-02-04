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

// Body design console
/datum/tgui_module/appearance_changer/body_designer
	name ="Appearance Editor (Body Designer)"
	flags = APPEARANCE_ALL
	var/datum/weakref/linked_body_design_console = null
	var/mob/living/carbon/human/designer_mob

/datum/tgui_module/appearance_changer/body_designer/tgui_status(mob/user, datum/tgui_state/state)
	if(!istype(host,/obj/machinery/computer/transhuman/designer))
		return STATUS_CLOSE
	return ..()

/datum/tgui_module/appearance_changer/body_designer/Destroy()
	qdel_null(designer_mob)
	var/obj/machinery/computer/transhuman/designer/DC = linked_body_design_console?.resolve()
	if(DC)
		DC.selected_record = FALSE
	. = ..()

/datum/tgui_module/appearance_changer/body_designer/proc/make_fake_owner()
	// checks for monkey to tell if on the menu
	qdel(designer_mob)
	designer_mob = new(src)
	designer_mob.set_species(SPECIES_MONKEY)
	designer_mob.species.produceCopy(designer_mob.species.traits.Copy(),designer_mob,null,FALSE)
	designer_mob.invisibility = 101 // Invisible monkey
	return designer_mob

/datum/tgui_module/appearance_changer/body_designer/proc/create_body(var/datum/transhuman/body_record/current_project)
	//Get the DNA and generate a new mob
	qdel(designer_mob)
	var/datum/dna2/record/R = current_project.mydna
	designer_mob = new /mob/living/carbon/human(src, R.dna.species)
	//Fix the external organs
	for(var/part in current_project.limb_data)
		var/status = current_project.limb_data[part]
		if(status == null) continue //Species doesn't have limb? Child of amputated limb?
		var/obj/item/organ/external/O = designer_mob.organs_by_name[part]
		if(!O) continue //Not an organ. Perhaps another amputation removed it already.
		if(status == 1) //Normal limbs
			continue
		else if(status == 0) //Missing limbs
			O.remove_rejuv()
		else if(status) //Anything else is a manufacturer
			O.remove_rejuv() //Don't robotize them, leave them removed so robotics can attach a part.
	for(var/part in current_project.organ_data)
		var/status = current_project.organ_data[part]
		if(status == null) continue //Species doesn't have organ? Child of missing part?
		var/obj/item/organ/I = designer_mob.internal_organs_by_name[part]
		if(!I) continue//Not an organ. Perhaps external conversion changed it already?
		if(status == 0) //Normal organ
			continue
		else if(status == 1) //Assisted organ
			I.mechassist()
		else if(status == 2) //Mechanical organ
			I.robotize()
		else if(status == 3) //Digital organ
			I.digitize()
	//Set the name or generate one
	designer_mob.real_name = R.dna.real_name
	//Apply DNA
	designer_mob.dna = R.dna.Clone()
	designer_mob.original_player = current_project.ckey
	//Apply legs
	designer_mob.digitigrade = R.dna.digitigrade // ensure clone mob has digitigrade var set appropriately
	if(designer_mob.dna.digitigrade <> R.dna.digitigrade)
		designer_mob.dna.digitigrade = R.dna.digitigrade // ensure cloned DNA is set appropriately from record??? for some reason it doesn't get set right despite the override to datum/dna/Clone()
	//Update appearance, remake icons
	designer_mob.UpdateAppearance()
	designer_mob.sync_dna_traits(FALSE) // Traitgenes edit - Sync traits to genetics if needed
	designer_mob.sync_organ_dna()
	designer_mob.regenerate_icons()
	// Traitgenes edit begin - Moved breathing equipment to AFTER the genes set it
	designer_mob.flavor_texts = current_project.mydna.flavor.Copy()
	designer_mob.resize(current_project.sizemult, FALSE)
	designer_mob.appearance_flags = current_project.aflags
	designer_mob.weight = current_project.weight
	if(current_project.speciesname)
		designer_mob.custom_species = current_project.speciesname
	return designer_mob
