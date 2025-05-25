///Changeling component.
///Stores changeling powers, changeling recharge thingie, changeling absorbed DNA and changeling ID (for changeling hivemind)
GLOBAL_LIST_INIT(possible_changeling_IDs,list("Alpha","Beta","Chi","Delta","Epsilon","Eta","Gamma","Iota","Kappa","Lambda","Mu","Nu","Omega","Omicron","Phi","Pi","Psi","Rho","Sigma","Tau","Theta","Upsilon","Xi","Zeta")) //ALPHABETICAL ORDER.


/datum/component/antag/changeling
	var/list/datum/absorbed_dna/absorbed_dna = list()
	var/list/absorbed_languages = list() // Necessary because of set_species stuff
	var/absorbedcount = 0
	var/lingabsorbedcount = 1	//Starts at one, because that's us
	var/chem_charges = 20
	var/chem_recharge_rate = 0.5
	var/chem_storage = 50
	var/sting_range = 1
	var/changelingID = "Changeling"
	var/geneticdamage = 0
	var/isabsorbing = 0
	var/geneticpoints = 7
	var/max_geneticpoints = 7
	var/readapts = 1
	var/max_readapts = 2
	var/list/purchased_powers = list()
	var/mimicing = ""
	var/cloaked = 0
	var/armor_deployed = 0 //This is only used for changeling_generic_equip_all_slots() at the moment.
	var/recursive_enhancement = 0 //Used to power up other abilities from the ling power with the same name.
	var/list/purchased_powers_history = list() //Used for round-end report, includes respec uses too.
	var/last_shriek = null // world.time when the ling last used a shriek.
	var/next_escape = 0	// world.time when the ling can next use Escape Restraints
	var/thermal_sight = FALSE	// Is our Vision Augmented? With thermals?

/datum/component/antag/changeling/Initialize()
	if(GLOB.possible_changeling_IDs.len)
		changelingID = pick(possible_changeling_IDs)
		possible_changeling_IDs -= changelingID
		changelingID = "[changelingID]"
	else
		changelingID = "[rand(1,999)]"
	..()

/datum/component/antag/changeling/Destroy(force = FALSE)
	. = ..()

//Former /datum/changeling procs
/datum/changeling/proc/regenerate()
	chem_charges = min(max(0, chem_charges+chem_recharge_rate), chem_storage)
	geneticdamage = max(0, geneticdamage-1)

/datum/changeling/proc/GetDNA(var/dna_owner)
	for(var/datum/absorbed_dna/DNA in absorbed_dna)
		if(dna_owner == DNA.name)
			return DNA

//Former /mob procs
/mob/proc/absorbDNA(var/datum/absorbed_dna/newDNA)
	var/datum/changeling/changeling = null
	if(src.mind && src.mind.changeling)
		changeling = src.mind.changeling
	if(!changeling)
		return

	for(var/language in newDNA.languages)
		changeling.absorbed_languages |= language

	changeling_update_languages(changeling.absorbed_languages)

	if(!changeling.GetDNA(newDNA.name)) // Don't duplicate - I wonder if it's possible for it to still be a different DNA? DNA code could use a rewrite
		changeling.absorbed_dna += newDNA

//Restores our verbs. It will only restore verbs allowed during lesser (monkey) form if we are not human
/mob/proc/make_changeling()

	if(!mind)				return
	if(!mind.changeling)	mind.changeling = new /datum/changeling(gender)

	add_verb(src, /datum/changeling/proc/EvolutionMenu)
	add_verb(src, /mob/proc/changeling_respec)
	add_language("Changeling")

	var/lesser_form = !ishuman(src)

	if(!powerinstances.len)
		for(var/P in powers)
			powerinstances += new P()

	// Code to auto-purchase free powers.
	for(var/datum/power/changeling/P in powerinstances)
		if(!P.genomecost) // Is it free?
			if(!(P in mind.changeling.purchased_powers)) // Do we not have it already?
				mind.changeling.purchasePower(mind, P.name, 0)// Purchase it. Don't remake our verbs, we're doing it after this.

	for(var/datum/power/changeling/P in mind.changeling.purchased_powers)
		if(P.isVerb)
			if(lesser_form && !P.allowduringlesserform)	continue
			if(!(P in src.verbs))
				add_verb(src, P.verbpath)
			if(P.make_hud_button)
				if(!src.ability_master)
					src.ability_master = new /obj/screen/movable/ability_master(src)
				src.ability_master.add_ling_ability(
					object_given = src,
					verb_given = P.verbpath,
					name_given = P.name,
					ability_icon_given = P.ability_icon_state,
					arguments = list()
					)

	for(var/language in languages)
		mind.changeling.absorbed_languages |= language

	var/mob/living/carbon/human/H = src
	if(istype(H))
		var/saved_dna = H.dna.Clone() /// Prevent transform from breaking.
		var/datum/absorbed_dna/newDNA = new(H.real_name, saved_dna, H.species.name, H.languages, H.identifying_gender, H.flavor_texts, H.modifiers)
		absorbDNA(newDNA)

	return 1

//removes our changeling verbs
/mob/proc/remove_changeling_powers()
	if(!mind || !mind.changeling)	return
	for(var/datum/power/changeling/P in mind.changeling.purchased_powers)
		if(P.isVerb)
			remove_verb(src, P.verbpath)
			var/obj/screen/ability/verb_based/changeling/C = ability_master.get_ability_by_proc_ref(P.verbpath)
			if(C)
				ability_master.remove_ability(C)


//Helper proc. Does all the checks and stuff for us to avoid copypasta
/mob/proc/changeling_power(var/required_chems=0, var/required_dna=0, var/max_genetic_damage=100, var/max_stat=0)

	if(!src.mind)		return
	if(!iscarbon(src))	return

	var/datum/changeling/changeling = src.mind.changeling
	if(!changeling)
		to_world_log("[src] has the changeling_transform() verb but is not a changeling.")
		return

	if(src.stat > max_stat)
		to_chat(src, span_warning("We are incapacitated."))
		return

	if(changeling.absorbed_dna.len < required_dna)
		to_chat(src, span_warning("We require at least [required_dna] samples of compatible DNA."))
		return

	if(changeling.chem_charges < required_chems)
		to_chat(src, span_warning("We require at least [required_chems] units of chemicals to do that!"))
		return

	if(changeling.geneticdamage > max_genetic_damage)
		to_chat(src, span_warning("Our genomes are still reassembling. We need time to recover first."))
		return

	return changeling

//Used to dump the languages from the changeling datum into the actual mob.
/mob/proc/changeling_update_languages(var/updated_languages)
	languages = list()
	for(var/language in updated_languages)
		languages += language

	//This isn't strictly necessary but just to be safe...
	add_language("Changeling")

	//////////
	//STINGS//	//They get a pretty header because there's just so fucking many of them ;_;
	//////////

/mob/proc/sting_can_reach(mob/M as mob, sting_range = 1)
	if(M.loc == src.loc)
		return 1 //target and source are in the same thing
	if(!isturf(src.loc) || !isturf(M.loc))
		to_chat(src, span_warning("We cannot reach \the [M] with a sting!"))
		return 0 //One is inside, the other is outside something.
	// Maximum queued turfs set to 25; I don't *think* anything raises sting_range above 2, but if it does the 25 may need raising
	if(!AStar(src.loc, M.loc, /turf/proc/AdjacentTurfsRangedSting, /turf/proc/Distance, max_nodes=25, max_node_depth=sting_range)) //If we can't find a path, fail
		to_chat(src, span_warning("We cannot find a path to sting \the [M] by!"))
		return 0
	return 1

//Handles the general sting code to reduce on copypasta (seeming as somebody decided to make SO MANY dumb abilities)
/mob/proc/changeling_sting(var/required_chems=0, var/verb_path)
	var/datum/changeling/changeling = changeling_power(required_chems)
	if(!changeling)								return

	var/list/victims = list()
	for(var/mob/living/carbon/C in oview(changeling.sting_range))
		victims += C
	var/mob/living/carbon/T = tgui_input_list(src, "Who will we sting?", "Sting!", victims)

	if(!T)
		return
	if(T.isSynthetic())
		to_chat(src, span_notice("We are unable to pierce the outer shell of [T]."))
		return
	if(!(T in view(changeling.sting_range))) return
	if(!sting_can_reach(T, changeling.sting_range)) return
	if(!changeling_power(required_chems)) return

	changeling.chem_charges -= required_chems
	changeling.sting_range = 1
	remove_verb(src, verb_path)
	spawn(10)	add_verb(src, verb_path) //WTF?

	to_chat(src, span_notice("We stealthily sting [T]."))
	if(!T.mind || !T.mind.changeling)	return T	//T will be affected by the sting
	to_chat(T, span_warning("You feel a tiny prick."))
	return

//Former /turf procs
/turf/proc/AdjacentTurfsRangedSting()
	//Yes this is snowflakey, but I couldn't get it to work any other way.. -Luke
	var/list/allowed = list(
		/obj/structure/table,
		/obj/structure/closet,
		/obj/structure/frame,
		/obj/structure/target_stake,
		/obj/structure/cable,
		/obj/structure/disposalpipe,
		/obj/machinery,
		/mob
	)

	var/L[] = new()
	for(var/turf/simulated/t in oview(src,1))
		var/add = 1
		if(t.density)
			add = 0
		if(add && LinkBlocked(src,t))
			add = 0
		if(add && TurfBlockedNonWindow(t))
			add = 0
		for(var/obj/O in t)
			if(O.density)
				add = 0
				break
			if(istype(O, /obj/machinery/door))
				//not sure why this doesn't fire on LinkBlocked()
				add = 0
				break
			for(var/type in allowed)
				if (istype(O, type))
					add = 1
					break
			if(!add)
				break
		if(add)
			L.Add(t)
	return L
























































/*
//Legacy changeling stuff. Kept here for reference.
///Changeling Browser stuff
/client
	var/datum/managed_browser/changelingevolution/changelingevolution = null

/datum/managed_browser/changelingevolution
	base_browser_id = "evolution_tree"
	title = "Evolution Tree"
	size_x = 480
	size_y = 600
	var/textbody = null

/datum/managed_browser/changelingevolution/New(client/new_client)
	if(!new_client.mob || !new_client.mob.mind || !new_client.mob.mind.changeling)
		message_admins("[new_client] tried to access changeling evolutions while not changeling.")
		qdel(src)

	..()

/datum/managed_browser/changelingevolution/Destroy()
	if(my_client)
		my_client.changelingevolution = null
	return ..()

/datum/managed_browser/changelingevolution/get_html()
	var/list/dat = list("<html><body>")
	var/geneticpoints_current = my_client.mob.mind.changeling.geneticpoints
	var/geneticpoints_max = my_client.mob.mind.changeling.max_geneticpoints

	dat += "<center>Genetic Points Available: [geneticpoints_current] / [geneticpoints_max] <br>"
	dat += "Obtain more by feeding on your own kind. <br> <hr>"
	dat += "<a style='background-color:#c72121;' href='byond://?src=\ref[src];tutorial=1'>What am I?</a><br><hr>"
	dat += "<a style='background-color:#c72121;' href='byond://?src=\ref[src];inherent=1'>Inherent</a>"
	dat += "<a style='background-color:#c72121;' href='byond://?src=\ref[src];armor=1'>Armor</a>"
	dat += "<a style='background-color:#c72121;' href='byond://?src=\ref[src];weapons=1'>Weapons</a>"
	dat += "<a style='background-color:#c72121;' href='byond://?src=\ref[src];stings=1'>Stings</a>"
	dat += "<a style='background-color:#c72121;' href='byond://?src=\ref[src];shrieks=1'>Shrieks</a>"
	dat += "<a style='background-color:#c72121;' href='byond://?src=\ref[src];health=1'>Health</a>"
	dat += "<a style='background-color:#c72121;' href='byond://?src=\ref[src];enhancements=1'>Enhancements</a></center>"
	if(textbody)
		dat += "<table border='1' style='width:100%; background-color:#000000;'>"
		dat += "[textbody]"
		dat += "</table>"
	dat += "</body></html>"

	return dat.Join()

/datum/managed_browser/changelingevolution/Topic(href, href_list[])
	if(!my_client)
		return FALSE

	if(href_list["close"])
		return

	if(href_list["inherent"])
		generate_abilitylist(CHANGELING_POWER_INHERENT)

	if(href_list["armor"])
		generate_abilitylist(CHANGELING_POWER_ARMOR)

	if(href_list["weapons"])
		generate_abilitylist(CHANGELING_POWER_WEAPONS)

	if(href_list["stings"])
		generate_abilitylist(CHANGELING_POWER_STINGS)

	if(href_list["shrieks"])
		generate_abilitylist(CHANGELING_POWER_SHRIEKS)

	if(href_list["health"])
		generate_abilitylist(CHANGELING_POWER_HEALTH)

	if(href_list["enhancements"])
		generate_abilitylist(CHANGELING_POWER_ENHANCEMENTS)

	if(href_list["evolve"])
		var/datum/mind/M = my_client.mob.mind
		var/datum/changeling/C = my_client.mob.mind.changeling
		var/datum/power/changeling/Thepower = href_list["evolve"]

		for (var/datum/power/changeling/P in powerinstances)
			if(P.name == Thepower)
				Thepower = P
				break

		if(!istype(M))
			return

		if(Thepower == null)
			to_chat(M.current, "Purchase failed. Inform a dev of this error.")
			return

		if(Thepower in C.purchased_powers)
			to_chat(M.current, "You already have this ability! Inform a dev of this error.") /// Should not be possible
			return

		if(C.geneticpoints < Thepower.genomecost)
			to_chat(M.current, "We cannot evolve this... yet.  We must acquire more DNA.")
			return

		C.purchased_powers += Thepower /// Set it to purchased
		C.geneticpoints -= Thepower.genomecost
		generate_abilitylist(Thepower.power_category) /// Refresh the UI

		my_client.mob.mind.changeling.purchasePower(M, Thepower)

	if(href_list["tutorial"])
		textbody = "<tr><th><center>" + span_red("What am I?") + "</center><br></th></tr>"
		textbody += "<tr><td>"
		textbody += span_white("You are a changeling, a creature empowered with genetic-based abilities that change your body in bizarre ways.")
		textbody += span_white(" It's probably best the crew doesn't know about your power -- at least not right away.") + "<br><br>"
		textbody += span_white("What a changeling " + span_italics("is"), + " however, is up to you. Are you a strange alien impersonating crew? Are you a")
		textbody += span_white(" normal crewmember infected with a parasite? An experiment gone wrong? It's up to you to make the story.") + "<br><br>"
		textbody += span_white("Of course, you need to know how it works to begin with.") + "<br><br>"
		textbody += span_white("Your abilities cost chemicals that your body will slowly regenerate with varying speeds based on enhancements obtained.")
		textbody += span_white(" There are a set of inherent abilities you will always have while the rest may be purchased through genomes.") + "<br><br>"
		textbody += span_white("You may obtain more genomes if you find another changeling and absorb them, but this is not required. If you've found ")
		textbody += span_white("your abilities aren't to your liking, you have up to two re-adapts available, and these may be refilled by absorbing anyone -- including monkeys.") + "<br><br>"
		textbody += span_white("Good luck and remember, killing isn't always the end goal.")
		display()

/datum/managed_browser/changelingevolution/proc/generate_abilitylist(cat)
	var/list/ability_list = list()
	var/info = ""
	var/catname = ""
	for(var/datum/power/changeling/P in powerinstances)
		if(P.power_category == cat)
			ability_list[++ability_list.len] = P
	switch(cat)
		if(CHANGELING_POWER_INHERENT)
			catname = "Inherent"
			info = "These powers are inherent to your kind and will always be accessible, provided you have the chemicals to use them."
		if(CHANGELING_POWER_ARMOR)
			catname = "Armor"
			info = "These abilities will provide you with space protection -- and potentially armor."
		if(CHANGELING_POWER_WEAPONS)
			catname = "Weapons"
			info = "These abilities will provide you the means to fight back."
		if(CHANGELING_POWER_STINGS)
			catname = "Stings"
			info = "These abilities provide the means to sting organic beings for various effects -- though you must be close enough, and they must have exposed flesh."
		if(CHANGELING_POWER_SHRIEKS)
			catname = "Shrieks"
			info = "These abilities enhance your vocal chords, empowering your screams."
		if(CHANGELING_POWER_HEALTH)
			catname = "Health"
			info = "These abilities will enhance your health or aid you in mending your wounds."
		if(CHANGELING_POWER_ENHANCEMENTS)
			catname = "Enhancements"
			info = "These abilities enhance you in various ways."
	create_textbody(ability_list, catname, info)

/datum/managed_browser/changelingevolution/proc/create_textbody(ability_list, cat, catinfo)
	textbody = "<tr><th><center>" + span_red("[cat] Skills") + "<br></th></tr>"
	textbody += "<tr><td>" + span_white("[catinfo]") + "</center><br><hr></td></tr>"
	for(var/A in ability_list)
		var/datum/power/changeling/powerdata = A
		textbody += "<tr><td><center>" + span_red(span_bold("[initial(powerdata.name)]")) + "<br></center>"
		textbody += span_white("[initial(powerdata.desc)]") + "<br><br>"
		textbody += span_white(span_italics("[powerdata.helptext]")) + "<br>"
		if(powerdata.enhancedtext != "")
			textbody += span_white(span_bold("WHEN ENHANCED: ") + span_italics("[powerdata.enhancedtext]")) + "<br>"
		if(powerdata in my_client.mob.mind.changeling.purchased_powers)
			textbody += "<center>" + span_white(span_italics(span_bold("This ability is already evolved!"))) + "</center>"
		else if(cat != "Inherent")
			textbody += "<center>Cost: [powerdata.genomecost]</center>"
			textbody += "<center><a style='background-color:#c72121;' href='byond://?src=\ref[src];evolve=[A]'>Evolve</a></center>"
		textbody += "</td></tr>"
	display()
*/
