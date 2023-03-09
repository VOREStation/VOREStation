/mob/living/simple_mob/animal/sif/grafadreka/trained
	desc = "A sleek snow drake with heavy claws, powerful jaws and many sharp spines along its body. This one is wearing some kind of harness; maybe it belongs to someone."
	player_msg = {"<b>You are a large Sivian pack predator.</b>
Unlike your wild kin, you are <b>trained</b> and work happily with your two-legged packmates.
You can eat glowing tree fruit to fuel your <b>ranged spitting attack</b> and <b>poisonous bite</b> (on <span class = 'danger'>harm intent</span>), as well as <b>healing saliva</b> (on <b><font color = '#009900'>help intent</font></b>).
Using <font color='#e0a000'>grab intent</font> you can pick up and drop items by clicking them or yourself, and can interact with some simple machines like buttons and levers."}
	faction = "station"
	ai_holder_type = null // These guys should not exist without players.
	gender = PLURAL // Will take gender from prefs = set to non-NEUTER here to avoid randomizing in Initialize().
	movement_cooldown = 1.5 // ~~Red~~ trained ones go faster.
	dexterity = MOB_DEXTERITY_SIMPLE_MACHINES
	harness = /obj/item/storage/animal_harness/grafadreka/trained
	trained_drake = TRUE
	understands_languages = list(
		LANGUAGE_GALCOM,
		LANGUAGE_SIVIAN
	)

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
