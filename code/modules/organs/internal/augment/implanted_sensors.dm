/obj/item/organ/internal/augment/suit_sensors
	name = "vital sensors implant"
	desc = "An assortment of basic sensors similar to those found in jumpsuits used to monitor vital signs and transmit them to medical crew monitoring systems, \
	meant to be surgically implanted instead of inserted into a jumpsuit."

	robotic = ORGAN_ROBOT
	organ_tag = "implant_sensors"
	parent_organ = BP_TORSO

	forgiving_class = TRUE	// Will the organ give its verbs when it isn't a perfect match? I.E., assisted in organic, synthetic in organic.
	butcherable = FALSE

	organ_verbs = list(/mob/living/carbon/human/proc/sensor_implant_settings)

	var/sensor_status = SUIT_SENSORS_PRESENT //Just like jumpsuits, for the purpose of locked or EMP frying.
	var/sensor_mode = SUIT_SENSOR_OFF

// I fucking hate that the way that organ actions were implemented via mob verbs.
// This is a shitty workaround that will hopefully get replaced with action buttons in the future.
/mob/living/carbon/human/proc/sensor_implant_settings()
	set name = "Change Implanted Sensor Settings"
	set desc = "Toggle change the settings of your vital sensor implant."
	set category = "Augments"

	var/obj/item/organ/internal/augment/suit_sensors/sensor_imp = locate() in src

	if(!sensor_imp) //Shouldnt ever be able to use this verb without the organ.
		to_chat(src, span_warning("You dont have a sensor implant! Something has gone very wrong, contact a dev about this."))
		return

	if(src.stat == DEAD || sensor_imp.status == ORGAN_DEAD) //cant use this while dead
		return

	if(sensor_status >= SUIT_SENSORS_BROKEN) //locked is greater than broken, apparently.
		to_chat(src, span_warning("Your implant doesnt respond!"))
		return

	// suit sensor code copypasta. Probably fine, though.
	var/list/modes = list(
		"Off" = SUIT_SENSOR_OFF,
		"Binary sensors" = SUIT_SENSOR_BINARY,
		"Vitals tracker" = SUIT_SENSOR_VITAL,
		"Tracking beacon" = SUIT_SENSOR_TRACKING
		)
	var/default_choice
	for(var/key, value in modes)
		if(value == sensor_imp.sensor_mode)
			default_choice = key
			break
	var/switchMode = tgui_input_list(src, "Select a sensor mode:", "Suit Sensor Mode", modes, default_choice)
	if(!switchMode) //Probably closed the UI without making a choice. Silently end.
		return

	sensor_imp.sensor_mode = modes[switchMode]

	switch(sensor_mode)
		if(SUIT_SENSOR_OFF)
			to_chat(src, "You disable your [sensor_imp].")
		if(SUIT_SENSOR_BINARY)
			to_chat(src, "Your [sensor_imp] will now report whether you are live or dead.")
		if(SUIT_SENSOR_VITAL)
			to_chat(src, "Your [sensor_imp] will now report your vital lifesigns.")
		if(SUIT_SENSOR_TRACKING)
			to_chat(src, "Your [sensor_imp] will now report your vital lifesigns as well as your coordinate position.")

/obj/item/organ/internal/augment/suit_sensors/prison
	name = "prisoner vital sensor implant"
	desc = "An assortment of basic sensors similar to those found in jumpsuits used to monitor vital signs and transmit them to medical crew monitoring systems, \
	meant to be surgically implanted instead of inserted into a jumpsuit. Unlike the usual model, this one doesnt feature a way for the recipient to change the \
	settings of the sensors, and are locked at max."

	organ_verbs = null //This one doesnt let you change it's setting

	sensor_status = SUIT_SENSORS_LOCKED
	sensor_mode = SUIT_SENSOR_TRACKING
