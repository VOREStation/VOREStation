/mob/living/simple_mob/animal/sif/grafadreka/trained
	desc = "A large, sleek snow drake with heavy claws, powerful jaws and many pale spines along its body. This one is wearing some kind of harness; maybe it belongs to someone."
	player_msg = "You are a large Sivian pack predator in symbiosis with the local bioluminescent bacteria. You can eat glowing \
	tree fruit to fuel your <b>ranged spitting attack</b> and <b>poisonous bite</b> (on <span class = 'danger'>harm intent</span>), as well as <b>healing saliva</b> \
	(on <b><font color = '#009900'>help intent</font></b>).<br>Using <font color='#e0a000'>grab intent</font> you can pick up and drop items on by clicking them or yourself, \
	and can interact with some simple machines like buttons and levers.<br>Unlike your wild kin, you are <b>trained</b> and work happily with your two-legged packmates."
	faction = "station"
	ai_holder_type = null // These guys should not exist without players.
	gender = PLURAL // Will take gender from prefs = set to non-NEUTER here to avoid randomizing in Initialize().
	movement_cooldown = 1.5 // ~Red~ trained ones go faster.
	dexterity = MOB_DEXTERITY_SIMPLE_MACHINES
	harness = /obj/item/storage/internal/animal_harness/grafadreka/trained
	trained_drake = TRUE

	/// On clicking with an item, stuff that should use behaviors instead of being placed in storage.
	var/static/list/allow_type_to_pass = list(
		/obj/item/healthanalyzer,
		/obj/item/stack/medical,
		/obj/item/reagent_containers/syringe
	)


/mob/living/simple_mob/animal/sif/grafadreka/trained/Destroy()
	if (istype(harness))
		QDEL_NULL(harness)
	return ..()


/mob/living/simple_mob/animal/sif/grafadreka/trained/add_glow()
	. = ..()
	if (. && harness)
		var/image/I = .
		I.icon_state = "[I.icon_state]-pannier"


/mob/living/simple_mob/animal/sif/grafadreka/trained/Logout()
	..()
	if (stat != DEAD)
		lying = TRUE
		resting = TRUE
		sitting = FALSE
		Sleeping(2)
		update_icon()


/mob/living/simple_mob/animal/sif/grafadreka/trained/Login()
	..()
	SetSleeping(0)
	update_icon()


/mob/living/simple_mob/animal/sif/grafadreka/trained/attack_hand(mob/living/user)
	// Permit headpats/smacks
	if (!harness || user.a_intent == I_HURT || (user.a_intent == I_HELP && user.zone_sel?.selecting == BP_HEAD))
		return ..()
	return harness.handle_attack_hand(user)


// universal_understand is buggy and produces double lines, so we'll just do this hack instead.
/mob/living/simple_mob/animal/sif/grafadreka/trained/say_understands(mob/other, datum/language/speaking)
	if (!speaking || speaking.name == LANGUAGE_GALCOM)
		return TRUE
	return ..()


/mob/living/simple_mob/animal/sif/grafadreka/trained/update_icon()
	. = ..()
	if (harness)
		var/image/I = image(icon, "[current_icon_state]-pannier")
		I.color = harness.color
		I.appearance_flags |= (RESET_COLOR|PIXEL_SCALE|KEEP_APART)
		if (offset_compiled_icon)
			I.pixel_x = offset_compiled_icon
		add_overlay(I)


/mob/living/simple_mob/animal/sif/grafadreka/trained/attackby(obj/item/item, mob/user)
	if (user.a_intent == I_HURT)
		return ..()
	if (user.a_intent == I_HELP)
		for (var/pass_type in allow_type_to_pass)
			if (istype(item, pass_type))
				return ..()
	if (harness?.attackby(item, user))
		return TRUE
	return ..()


/mob/living/simple_mob/animal/sif/grafadreka/trained/proc/DropItem()
	if (!length(harness?.contents))
		to_chat(src, SPAN_WARNING("You have nothing to drop."))
		return
	var/obj/item/response = input(src, "Select an item to drop:") as null | anything in harness.contents
	if (!response)
		return
	var/datum/gender/gender = gender_datums[get_visible_gender()]
	visible_message(
		SPAN_ITALIC("\The [src] begins rooting around in the pouch on [gender.his] harness."),
		SPAN_ITALIC("You begin working \the [response] out of your harness pouch."),
		SPAN_ITALIC("You hear something rustling."),
		runemessage = CHAT_MESSAGE_DEFAULT_ACTION
	)
	if (!do_after(src, 3 SECONDS, ignore_movement = TRUE))
		return
	harness.remove_from_storage(response, loc)
	visible_message(
		SPAN_ITALIC("\The [src] pulls \a [response] from [gender.his] harness and drops it."),
		SPAN_NOTICE("You pull \the [response] from your harness and drop it."),
		SPAN_WARNING("Clank!"),
		runemessage = CHAT_MESSAGE_DEFAULT_ACTION
	)
	return


/mob/living/simple_mob/animal/sif/grafadreka/trained/proc/CollectItem(obj/item/item)
	if (!item.simulated || item.abstract || !item.Adjacent(src))
		return
	if (!harness)
		to_chat(src, SPAN_WARNING("Your harness is missing; you cannot store \the [item]."))
		return
	if (item.anchored)
		to_chat(src, SPAN_WARNING("\The [item] is securely anchored; you can't take it."))
		return
	face_atom(item)
	if (!do_after(src, 3 SECONDS, item))
		return
	var/datum/gender/gender = gender_datums[get_visible_gender()]
	if (harness?.attackby(item, src, TRUE))
		visible_message(
			SPAN_ITALIC("\The [src] grabs \a [item] in [gender.his] teeth and noses it into [gender.his] harness pouch."),
			SPAN_NOTICE("You grab \the [item] in your teeth and push it into your harness pouch."),
			SPAN_ITALIC("You hear something rustling."),
			runemessage = CHAT_MESSAGE_DEFAULT_ACTION
		)
		return
	to_chat(src, SPAN_WARNING("There's not enough space in your harness pouch for \the [item] to fit!"))
