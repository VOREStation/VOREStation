// These should all be procs, you can add them to humans/subspecies by
// species.dm's inherent_verbs ~ Z

/mob/living/carbon/human/proc/tackle()
	set category = "Abilities"
	set name = "Tackle"
	set desc = "Tackle someone down."

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		src << "You cannot tackle someone in your current state."
		return

	var/list/choices = list()
	for(var/mob/living/M in view(1,src))
		if(!istype(M,/mob/living/silicon) && Adjacent(M))
			choices += M
	choices -= src

	var/mob/living/T = input(src,"Who do you wish to tackle?") as null|anything in choices

	if(!T || !src || src.stat) return

	if(!Adjacent(T)) return

	if(last_special > world.time)
		return

	if(stat || paralysis || stunned || weakened || lying || restrained() || buckled)
		src << "You cannot tackle in your current state."
		return

	last_special = world.time + 50

	var/failed
	if(prob(75))
		T.Weaken(rand(0.5,3))
	else
		src.Weaken(rand(2,4))
		failed = 1

	playsound(loc, 'sound/weapons/pierce.ogg', 25, 1, -1)
	if(failed)
		src.Weaken(rand(2,4))

	for(var/mob/O in viewers(src, null))
		if ((O.client && !( O.blinded )))
			O.show_message(text("<font color='red'><B>[] [failed ? "tried to tackle" : "has tackled"] down []!</font></B>", src, T), 1)

/mob/living/carbon/human/proc/commune()
	set category = "Abilities"
	set name = "Commune with creature"
	set desc = "Send a telepathic message to an unlucky recipient."

	var/list/targets = list()
	var/target = null
	var/text = null

	targets += getmobs() //Fill list, prompt user with list
	target = input("Select a creature!", "Speak to creature", null, null) as null|anything in targets

	if(!target) return

	text = input("What would you like to say?", "Speak to creature", null, null)

	text = sanitize(text)

	if(!text) return

	var/mob/M = targets[target]

	if(istype(M, /mob/observer/dead) || M.stat == DEAD)
		src << "Not even a [src.species.name] can speak to the dead."
		return

	log_say("[key_name(src)] communed to [key_name(M)]: [text]")

	M << "<font color='blue'>Like lead slabs crashing into the ocean, alien thoughts drop into your mind: [text]</font>"
	if(istype(M,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if(H.species.name == src.species.name)
			return
		H << "<font color='red'>Your nose begins to bleed...</font>"
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
		src.visible_message("<font color='red'><B>[src] hurls out the contents of their stomach!</B></font>")
	return

/mob/living/carbon/human/proc/psychic_whisper(mob/M as mob in oview())
	set name = "Psychic Whisper"
	set desc = "Whisper silently to someone over a distance."
	set category = "Abilities"

	var/msg = sanitize(input("Message:", "Psychic Whisper") as text|null)
	if(msg)
		log_say("PsychicWhisper: [key_name(src)]->[M.key] : [msg]")
		M << "<font color='green'>You hear a strange, alien voice in your head... <i>[msg]</i></font>"
		src << "<font color='green'>You said: \"[msg]\" to [M]</font>"
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

	visible_message("<span class='warning'>\The [src] quivers slightly, then splits apart with a wet slithering noise.</span>")

	qdel(src)

/mob/living/carbon/human/proc/self_diagnostics()
	set name = "Self-Diagnostics"
	set desc = "Run an internal self-diagnostic to check for damage."
	set category = "IC"

	if(stat == DEAD) return

	src << "<span class='notice'>Performing self-diagnostic, please wait...</span>"
	sleep(50)
	var/output = "<span class='notice'>Self-Diagnostic Results:\n</span>"

	for(var/obj/item/organ/external/EO in organs)
		if(EO.brute_dam || EO.burn_dam)
			output += "[EO.name] - <span class='warning'>[EO.burn_dam + EO.brute_dam > ROBOLIMB_REPAIR_CAP ? "Heavy Damage" : "Light Damage"]</span>\n"
		else
			output += "[EO.name] - <span style='color:green;'>OK</span>\n"

	for(var/obj/item/organ/IO in internal_organs)
		if(IO.damage)
			output += "[IO.name] - <span class='warning'>[IO.damage > 10 ? "Heavy Damage" : "Light Damage"]</span>\n"
		else
			output += "[IO.name] - <span style='color:green;'>OK</span>\n"

	src << output

/mob/living/carbon/human
	var/next_sonar_ping = 0

/mob/living/carbon/human/proc/sonar_ping()
	set name = "Listen In"
	set desc = "Allows you to listen in to movement and noises around you."
	set category = "Abilities"

	if(incapacitated())
		src << "<span class='warning'>You need to recover before you can use this ability.</span>"
		return
	if(world.time < next_sonar_ping)
		src << "<span class='warning'>You need another moment to focus.</span>"
		return
	if(is_deaf() || is_below_sound_pressure(get_turf(src)))
		src << "<span class='warning'>You are for all intents and purposes currently deaf!</span>"
		return
	next_sonar_ping += 10 SECONDS
	var/heard_something = FALSE
	src << "<span class='notice'>You take a moment to listen in to your environment...</span>"
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
		src << jointext(feedback,null)
	if(!heard_something)
		src << "<span class='notice'>You hear no movement but your own.</span>"

/mob/living/carbon/human/proc/regenerate()
	set name = "Regenerate"
	set desc = "Allows you to regrow limbs and heal organs."
	set category = "Abilities"

	if(nutrition < 250)
		to_chat(src, "<span class='warning'>You lack the biomass regrow anything!</span>")
		return

	nutrition -= 200

	for(var/obj/item/organ/I in internal_organs)
		if(I.damage > 0)
			I.damage = 0
			to_chat(src, "<span class='notice'>You feel a soothing sensation within your [I.name]...</span>")

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
			to_chat(src, "<span class='notice'>You feel a slithering sensation as your [O.name] reform.</span>")
			src.update_body()
