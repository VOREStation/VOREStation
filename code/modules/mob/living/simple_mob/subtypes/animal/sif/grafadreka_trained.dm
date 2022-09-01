/mob/living/simple_mob/animal/sif/grafadreka/trained
	desc = "A large, sleek snow drake with heavy claws, powerful jaws and many pale spines along its body. This one is wearing some kind of harness; maybe it belongs to someone."
	player_msg = "You are a large Sivian pack predator in symbiosis with the local bioluminescent bacteria. You can eat glowing \
	tree fruit to fuel your <b>ranged spitting attack</b> and <b>poisonous bite</b> (on <span class = 'danger'>harm intent</span>), as well as <b>healing saliva</b> \
	(on <b><font color = '#009900'>help intent</font></b>).<br>Unlike your wild kin, you are <b>trained</b> and work happily with your two-legged packmates."
	faction = "station"
	ai_holder_type = null // These guys should not exist without players.
	gender = PLURAL // Will take gender from prefs = set to non-NEUTER here to avoid randomizing in Initialize().
	var/obj/item/storage/internal/animal_harness/harness = /obj/item/storage/internal/animal_harness

/mob/living/simple_mob/animal/sif/grafadreka/trained/Initialize()
	if(ispath(harness))
		harness = new harness(src)
		harness.attached_radio = new /obj/item/radio(src)
		regenerate_harness_verbs()
	. = ..()

/mob/living/simple_mob/animal/sif/grafadreka/trained/Destroy()
	if(istype(harness))
		QDEL_NULL(harness)
	return ..()

/mob/living/simple_mob/animal/sif/grafadreka/trained/examine(mob/living/user)
	. = ..()
	if(harness)
		. += "\The [src] is wearing \a [harness]."
		for(var/obj/item/thing in list(harness.attached_gps, harness.attached_plate, harness.attached_radio))
			. += "There is \a [thing] attached."

/mob/living/simple_mob/animal/sif/grafadreka/trained/add_glow()
	. = ..()
	if(. && harness)
		var/image/I = .
		I.icon_state = "[I.icon_state]-pannier"

/mob/living/simple_mob/animal/sif/grafadreka/trained/Logout()
	..()
	if(stat != DEAD)
		lying = TRUE
		resting = TRUE
		sitting = FALSE
		Sleeping(2)
		update_icon()

/mob/living/simple_mob/animal/sif/grafadreka/trained/Login()
	..()
	SetSleeping(0)
	update_icon()

/mob/living/simple_mob/animal/sif/grafadreka/trained/attack_hand(mob/living/L)
	// Permit headpats/smacks
	if(!harness || L.a_intent == I_HURT || (L.a_intent == I_HELP && L.zone_sel?.selecting == BP_HEAD))
		return ..()
	return harness.handle_attack_hand(L)

// universal_understand is buggy and produces double lines, so we'll just do this hack instead.
/mob/living/simple_mob/animal/sif/grafadreka/trained/say_understands(var/mob/other, var/datum/language/speaking = null)
	if(!speaking || speaking.name == LANGUAGE_GALCOM)
		return TRUE
	return ..()

/mob/living/simple_mob/animal/sif/grafadreka/trained/update_icon()
	. = ..()
	if(harness)
		var/image/I = image(icon, "[current_icon_state]-pannier")
		I.color = harness.color
		I.appearance_flags |= (RESET_COLOR|PIXEL_SCALE|KEEP_APART)
		if(offset_compiled_icon)
			I.pixel_x = offset_compiled_icon
		add_overlay(I)

/mob/living/simple_mob/animal/sif/grafadreka/trained/attackby(obj/item/O, mob/user)

	// bonk
	if(user.a_intent == I_HURT)
		return ..()

	// Pass some items down to heal or run injection etc.
	var/static/list/allow_type_to_pass = list(
		/obj/item/healthanalyzer,
		/obj/item/stack/medical,
		/obj/item/reagent_containers/syringe
	)
	if(user.a_intent == I_HELP)
		for(var/pass_type in allow_type_to_pass)
			if(istype(O, pass_type))
				return ..()

	// Open our storage, if we have it.
	if(harness?.attackby(O, user))
		regenerate_harness_verbs()
		return TRUE

	return ..()

/mob/living/simple_mob/animal/sif/grafadreka/trained/proc/regenerate_harness_verbs()
	if(!harness)
		verbs -= list(
			/mob/living/simple_mob/animal/sif/grafadreka/trained/proc/remove_attached_gps,
			/mob/living/simple_mob/animal/sif/grafadreka/trained/proc/remove_attached_plate,
			/mob/living/simple_mob/animal/sif/grafadreka/trained/proc/remove_attached_radio
		)
		return

	if(harness.attached_gps)
		verbs |= /mob/living/simple_mob/animal/sif/grafadreka/trained/proc/remove_attached_gps
	else
		verbs -= /mob/living/simple_mob/animal/sif/grafadreka/trained/proc/remove_attached_gps

	if(harness.attached_plate)
		verbs |= /mob/living/simple_mob/animal/sif/grafadreka/trained/proc/remove_attached_plate
	else
		verbs -= /mob/living/simple_mob/animal/sif/grafadreka/trained/proc/remove_attached_plate

	if(harness.attached_radio)
		verbs |= /mob/living/simple_mob/animal/sif/grafadreka/trained/proc/remove_attached_radio
	else
		verbs -= /mob/living/simple_mob/animal/sif/grafadreka/trained/proc/remove_attached_radio
