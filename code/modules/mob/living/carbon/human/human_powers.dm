// These should all be procs, you can add them to humans/subspecies by
// species.dm's inherent_verbs ~ Z

/mob/living/carbon/human/proc/tie_hair()
	set name = "Tie Hair"
	set desc = "Style your hair."
	set category = "IC"

	if(incapacitated())
		to_chat(src, span_warning("You can't mess with your hair right now!"))
		return

	if(h_style)
		var/datum/sprite_accessory/hair/hair_style = hair_styles_list[h_style]
		var/selected_string
		if(!(hair_style.flags & HAIR_TIEABLE))
			to_chat(src, "<span class ='warning'>Your hair isn't long enough to tie.</span>")
			return
		else
			var/list/datum/sprite_accessory/hair/valid_hairstyles = list()
			for(var/hair_string in hair_styles_list)
				var/datum/sprite_accessory/hair/test = hair_styles_list[hair_string]
				if(test.flags & HAIR_TIEABLE)
					valid_hairstyles.Add(hair_string)
			selected_string = tgui_input_list(usr, "Select a new hairstyle", "Your hairstyle", valid_hairstyles)
		if(incapacitated())
			to_chat(src, span_warning("You can't mess with your hair right now!"))
			return
		else if(selected_string && h_style != selected_string)
			h_style = selected_string
			regenerate_icons()
			visible_message(span_notice("[src] pauses a moment to style their hair."))
		else
			to_chat(src, "<span class ='notice'>You're already using that style.</span>")

/mob/living/carbon/human/proc/tackle()
	set category = "Abilities"
	set name = "Tackle"
	set desc = "Tackle someone down."

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		to_chat(src, "You cannot tackle someone in your current state.")
		return

	var/list/choices = list()
	for(var/mob/living/M in view(1,src))
		if(!istype(M,/mob/living/silicon) && Adjacent(M))
			choices += M
	choices -= src

	var/mob/living/T = tgui_input_list(src, "Who do you wish to tackle?", "Target Choice", choices)

	if(!T || !src || src.stat) return

	if(!Adjacent(T)) return

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		to_chat(src, span_filter_notice("You cannot tackle in your current state."))
		return

	last_special = world.time + 50

	var/failed
	if(prob(75))
		T.Weaken(rand(0.5,3))
	else
		failed = 1

	playsound(src, 'sound/weapons/pierce.ogg', 25, 1, -1)
	if(failed)
		src.Weaken(rand(2,4))

	for(var/mob/O in viewers(src, null))
		if ((O.client && !( O.blinded )))
			O.show_message(span_filter_warning("[span_red("<B>[src] [failed ? "tried to tackle" : "has tackled"] down [T]!</B>")]"), 1)

/mob/living/carbon/human/proc/commune()
	set category = "Abilities"
	set name = "Commune with creature"
	set desc = "Send a telepathic message to an unlucky recipient."

	var/list/targets = list()
	var/target = null
	var/text = null

	targets += getmobs() //Fill list, prompt user with list
	target = tgui_input_list(usr, "Select a creature!", "Speak to creature", targets)

	if(!target) return

	text = tgui_input_text(usr, "What would you like to say?", "Speak to creature", null, MAX_MESSAGE_LEN)

	text = sanitize(text, MAX_MESSAGE_LEN)

	if(!text) return

	var/mob/M = targets[target]

	if(istype(M, /mob/observer/dead) || M.stat == DEAD)
		to_chat(src, span_filter_notice("Not even a [src.species.name] can speak to the dead."))
		return

	log_say("(COMMUNE to [key_name(M)]) [text]",src)

	to_chat(M, span_filter_say("[span_blue("Like lead slabs crashing into the ocean, alien thoughts drop into your mind: [text]")]"))
	if(istype(M,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if(H.species.name == src.species.name)
			return
		to_chat(H, span_filter_notice("[span_red("Your nose begins to bleed...")]"))
		H.drip(1)

/mob/living/carbon/human/proc/regurgitate()
	set name = "Regurgitate"
	set desc = "Empties the contents of your stomach"
	set category = "Abilities"

	if(stomach_contents.len)
		for(var/mob/M in src)
			if(M in stomach_contents)
				stomach_contents.Remove(M)
				M.loc = loc
		src.visible_message(span_filter_warning("[span_red("<B>[src] hurls out the contents of their stomach!</B>")]"))
	return

/mob/living/carbon/human/proc/psychic_whisper(mob/M as mob in oview())
	set name = "Psychic Whisper"
	set desc = "Whisper silently to someone over a distance."
	set category = "Abilities"

	var/msg = sanitize(tgui_input_text(usr, "Message:", "Psychic Whisper"))
	if(msg)
		log_say("(PWHISPER to [key_name(M)]) [msg]", src)
		to_chat(M, span_filter_say("[span_green("You hear a strange, alien voice in your head... <i>[msg]</i>")]"))
		to_chat(src, span_filter_say("[span_green("You said: \"[msg]\" to [M]")]"))
	return

/mob/living/carbon/human/proc/diona_split_nymph()
	set name = "Split"
	set desc = "Split your humanoid form into its constituent nymphs."
	set category = "Abilities"
	diona_split_into_nymphs(5)	// Separate proc to void argments being supplied when used as a verb

/mob/living/carbon/human/proc/diona_split_into_nymphs(var/number_of_resulting_nymphs)
	var/turf/T = get_turf(src)

	var/mob/living/carbon/alien/diona/S = new(T)
	S.set_dir(dir)
	transfer_languages(src, S)

	if(mind)
		mind.transfer_to(S)

	message_admins("\The [src] has split into nymphs; player now controls [key_name_admin(S)]")
	log_admin("\The [src] has split into nymphs; player now controls [key_name(S)]")

	var/nymphs = 1

	for(var/mob/living/carbon/alien/diona/D in src)
		nymphs++
		D.forceMove(T)
		transfer_languages(src, D, WHITELISTED|RESTRICTED)
		D.set_dir(pick(NORTH, SOUTH, EAST, WEST))

	if(nymphs < number_of_resulting_nymphs)
		for(var/i in nymphs to (number_of_resulting_nymphs - 1))
			var/mob/M = new /mob/living/carbon/alien/diona(T)
			transfer_languages(src, M, WHITELISTED|RESTRICTED)
			M.set_dir(pick(NORTH, SOUTH, EAST, WEST))


	for(var/obj/item/W in src)
		drop_from_inventory(W)

	var/obj/item/organ/external/Chest = organs_by_name[BP_TORSO]

	if(Chest.robotic >= 2)
		visible_message(span_warning("\The [src] shudders slightly, then ejects a cluster of nymphs with a wet slithering noise."))
		species = GLOB.all_species[SPECIES_HUMAN] // This is hard-set to default the body to a normal FBP, without changing anything.

		// Bust it
		src.death()

		for(var/obj/item/organ/internal/diona/Org in internal_organs) // Remove Nymph organs.
			qdel(Org)

		// Purge the diona verbs.
		remove_verb(src, /mob/living/carbon/human/proc/diona_split_nymph)
		remove_verb(src, /mob/living/carbon/human/proc/regenerate)

		for(var/obj/item/organ/external/E in organs) // Just fall apart.
			E.droplimb(TRUE)

	else
		visible_message(span_warning("\The [src] quivers slightly, then splits apart with a wet slithering noise."))
		qdel(src)

/mob/living/carbon/human/proc/self_diagnostics()
	set name = "Self-Diagnostics"
	set desc = "Run an internal self-diagnostic to check for damage."
	set category = "IC"

	if(stat == DEAD) return

	to_chat(src, span_notice("Performing self-diagnostic, please wait..."))

	spawn(50)
		var/output = span_filter_notice("<span class='notice'>Self-Diagnostic Results:\n")

		output += "Internal Temperature: [convert_k2c(bodytemperature)] Degrees Celsius\n"

		if(isSynthetic())
			output += "Current Battery Charge: [nutrition]\n"

			var/toxDam = getToxLoss()
			if(toxDam)
				output += "System Instability: <span class='warning'>[toxDam > 25 ? "Severe" : "Moderate"]</span>. Seek charging station for cleanup.\n"
			else
				output += "System Instability: <span style='color:green;'>OK</span>\n"

		for(var/obj/item/organ/external/EO in organs)
			if(EO.robotic >= ORGAN_ASSISTED)
				if(EO.brute_dam || EO.burn_dam)
					output += "[EO.name] - <span class='warning'>[EO.burn_dam + EO.brute_dam > EO.min_broken_damage ? "Heavy Damage" : "Light Damage"]</span>\n" //VOREStation Edit - Makes robotic limb damage scalable
				else
					output += "[EO.name] - <span style='color:green;'>OK</span>\n"

		for(var/obj/item/organ/IO in internal_organs)
			if(IO.robotic >= ORGAN_ASSISTED)
				if(IO.damage)
					output += "[IO.name] - <span class='warning'>[IO.damage > 10 ? "Heavy Damage" : "Light Damage"]</span>\n"
				else
					output += "[IO.name] - <span style='color:green;'>OK</span>\n"
		output += "</span>"

		to_chat(src,output)

/mob/living/carbon/human
	var/next_sonar_ping = 0

/mob/living/carbon/human/proc/sonar_ping()
	set name = "Listen In"
	set desc = "Allows you to listen in to movement and noises around you."
	set category = "Abilities"

	if(incapacitated())
		to_chat(src, span_warning("You need to recover before you can use this ability."))
		return
	if(world.time < next_sonar_ping)
		to_chat(src, span_warning("You need another moment to focus."))
		return
	if(is_deaf() || is_below_sound_pressure(get_turf(src)))
		to_chat(src, span_warning("You are for all intents and purposes currently deaf!"))
		return
	next_sonar_ping += 10 SECONDS
	var/heard_something = FALSE
	to_chat(src, span_notice("You take a moment to listen in to your environment..."))
	for(var/mob/living/L in range(client.view, src))
		var/turf/T = get_turf(L)
		if(!T || L == src || L.stat == DEAD || is_below_sound_pressure(T))
			continue
		heard_something = TRUE
		var/feedback = list()
		feedback += "<span class='notice'>There are noises of movement "
		var/direction = get_dir(src, L)
		if(direction)
			feedback += "towards the [dir2text(direction)], "
			switch(get_dist(src, L) / client.view)
				if(0 to 0.2)
					feedback += "very close by."
				if(0.2 to 0.4)
					feedback += "close by."
				if(0.4 to 0.6)
					feedback += "some distance away."
				if(0.6 to 0.8)
					feedback += "further away."
				else
					feedback += "far away."
		else // No need to check distance if they're standing right on-top of us
			feedback += "right on top of you."
		feedback += "</span>"
		to_chat(src,jointext(feedback,null))
	if(!heard_something)
		to_chat(src, span_notice("You hear no movement but your own."))

/mob/living/carbon/human/proc/regenerate()
	set name = "Regenerate"
	set desc = "Allows you to regrow limbs and heal organs after a period of rest."
	set category = "Abilities"

	if(nutrition < 250)
		to_chat(src, span_warning("You lack the biomass to begin regeneration!"))
		return

	if(active_regen)
		to_chat(src, span_warning("You are already regenerating tissue!"))
		return
	else
		active_regen = TRUE
		src.visible_message(span_filter_notice("<B>[src]</B>'s flesh begins to mend..."))

	var/delay_length = round(active_regen_delay * species.active_regen_mult)
	if(do_after(src,delay_length))
		adjust_nutrition(-200)

		for(var/obj/item/organ/I in internal_organs)
			if(I.robotic >= ORGAN_ROBOT) // No free robofix.
				continue
			if(I.damage > 0)
				I.damage = max(I.damage - 30, 0) //Repair functionally half of a dead internal organ.
				I.status = 0	// Wipe status, as it's being regenerated from possibly dead.
				to_chat(src, span_notice("You feel a soothing sensation within your [I.name]..."))

		// Replace completely missing limbs.
		for(var/limb_type in src.species.has_limbs)
			var/obj/item/organ/external/E = src.organs_by_name[limb_type]

			if(E && E.disfigured)
				E.disfigured = 0
			if(E && (E.is_stump() || (E.status & (ORGAN_DESTROYED|ORGAN_DEAD|ORGAN_MUTATED))))
				E.removed()
				qdel(E)
				E = null
			if(!E)
				var/list/organ_data = src.species.has_limbs[limb_type]
				var/limb_path = organ_data["path"]
				var/obj/item/organ/O = new limb_path(src)
				organ_data["descriptor"] = O.name
				to_chat(src, span_notice("You feel a slithering sensation as your [O.name] reform."))

				var/agony_to_apply = round(0.66 * O.max_damage) // 66% of the limb's health is converted into pain.
				src.apply_damage(agony_to_apply, HALLOSS)

		for(var/organtype in species.has_organ) // Replace completely missing internal organs. -After- external ones, so they all should exist.
			if(!src.internal_organs_by_name[organtype])
				var/organpath = species.has_organ[organtype]
				var/obj/item/organ/Int = new organpath(src, TRUE)

				Int.rejuvenate(TRUE)

		handle_organs() // Update everything

		update_icons_body()
		active_regen = FALSE
	else
		to_chat(src, span_critical("Your regeneration is interrupted!"))
		adjust_nutrition(-75)
		active_regen = FALSE

/mob/living/carbon/human/proc/setmonitor_state()
	set name = "Set monitor display"
	set desc = "Set your monitor display"
	set category = "IC"
	if(stat)
		to_chat(src,span_warning("You must be awake and standing to perform this action!"))
		return
	var/obj/item/organ/external/head/E = organs_by_name[BP_HEAD]
	if(!E)
		to_chat(src,span_warning("You don't seem to have a head!"))
		return
	var/datum/robolimb/robohead = all_robolimbs[E.model]
	if(!robohead.monitor_styles || !robohead.monitor_icon)
		to_chat(src,span_warning("Your head doesn't have a monitor, or it doesn't support being changed!"))
		return
	var/list/states
	if(!states)
		states = params2list(robohead.monitor_styles)
	var/choice = tgui_input_list(usr, "Select a screen icon:", "Screen Icon Choice", states)
	if(choice)
		E.eye_icon_location = robohead.monitor_icon
		E.eye_icon = states[choice]
		E.eye_icon_override = TRUE
		to_chat(src,span_warning("You set your monitor to display [choice]!"))
		update_icons_body()
