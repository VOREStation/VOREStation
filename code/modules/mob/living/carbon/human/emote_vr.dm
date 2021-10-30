/mob/living/carbon/human/verb/toggle_resizing_immunity()
	set name = "Toggle Resizing Immunity"
	set desc = "Toggles your ability to resist resizing attempts"
	set category = "IC"

	resizable = !resizable
	to_chat(src, "<span class='notice'>You are now [resizable ? "susceptible" : "immune"] to being resized.</span>")


/mob/living/carbon/human/proc/handle_flip_vr()
	var/original_density = density
	var/original_passflags = pass_flags

	//Briefly un-dense to dodge projectiles
	density = FALSE

	//Parkour!
	var/parkour_chance = 20 //Default
	if(species)
		parkour_chance = species.agility
	if(prob(parkour_chance))
		pass_flags |= PASSTABLE
	else
		Confuse(1) //Thud

	if(dir & WEST)
		SpinAnimation(7,1,0)
	else
		SpinAnimation(7,1,1)

	spawn(7)
		density = original_density
		pass_flags = original_passflags

/mob/living/carbon/human/verb/toggle_gender_identity_vr()
	set name = "Set Gender Identity"
	set desc = "Sets the pronouns when examined and performing an emote."
	set category = "IC"
	var/new_gender_identity = tgui_input_list(usr, "Please select a gender Identity:", "Set Gender Identity", list(FEMALE, MALE, NEUTER, PLURAL, HERM))
	if(!new_gender_identity)
		return 0
	change_gender_identity(new_gender_identity)
	return 1

/mob/living/carbon/human/verb/switch_tail_layer()
	set name = "Switch tail layer"
	set category = "IC"
	set desc = "Switch tail layer on top."
	tail_alt = !tail_alt
	update_tail_showing()

/mob/living/carbon/human/verb/hide_wings_vr()
	set name = "Show/Hide wings"
	set category = "IC"
	set desc = "Hide your wings, or show them if you already hid them."
	wings_hidden = !wings_hidden
	update_wing_showing()
	var/message = ""
	if(!wings_hidden)
		message = "reveals their wings!"
	else
		message = "hides their wings."
	visible_message("[src] [message]")
