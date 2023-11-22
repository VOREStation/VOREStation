/datum/disease2/disease/Topic(href, href_list)
	. = ..()
	if(.) return

	if(href_list["info"])
		// spawn or admin privileges to see info about viruses
		if(!check_rights(R_ADMIN|R_SPAWN|R_EVENT)) return

		to_chat(usr, "Infection chance: [infectionchance]; Speed: [speed]; Spread type: [spreadtype]")
		to_chat(usr, "Affected species: [english_list(affected_species)]")
		to_chat(usr, "Effects:")
		for(var/datum/disease2/effectholder/E in effects)
			to_chat(usr, "[E.stage]: [E.effect.name]; chance=[E.chance]; multiplier=[E.multiplier]")
		to_chat(usr, "Antigens: [antigens2string(antigen)]; Resistance: [resistance]")

		return 1

/datum/disease2/disease/vv_get_header()
	. = list()
	for(var/datum/disease2/effectholder/E in effects)
		. += "[E.stage]: [E.effect.name]"
	return {"
		<b>[name()]</b><br><font size=1>
		[jointext(., "<br>")]</font>
	"}

/datum/disease2/disease/get_view_variables_options()
	return ..() + {"
		<option value='?src=\ref[src];info=1'>Show info</option>
	"}

/datum/admins/var/datum/virus2_editor/virus2_editor_datum = new
/client/proc/virus2_editor()
	set name = "Virus Editor"
	set category = "Admin"
	if(!holder || !check_rights(R_SPAWN)) return // spawn privileges to create viruses

	holder.virus2_editor_datum.show_ui(src)

/datum/virus2_editor
	var/list/s = list(/datum/disease2/effect/invisible,/datum/disease2/effect/invisible,/datum/disease2/effect/invisible,/datum/disease2/effect/invisible)
	var/list/s_chance = list(1,1,1,1)
	var/list/s_multiplier = list(1,1,1,1)
	var/species = list()
	var/infectionchance = 70
	var/spreadtype = "Contact"
	var/list/antigens = list()
	var/speed = 1
	var/resistance = 10
	var/mob/living/carbon/infectee = null

	// this holds spawned viruses so that the "Info" links work after the proc exits
	var/list/spawned_viruses = list()

/datum/virus2_editor/proc/select(mob/user, stage)
	if(stage < 1 || stage > 4) return

	var/list/L = list()

	for(var/datum/disease2/effect/f as anything in subtypesof(/datum/disease2/effect))
		if(initial(f.stage) <= stage)
			L[initial(f.name)] = f

	var/datum/disease2/effect/Eff = s[stage]

	var/C = tgui_input_list(usr, "Select effect for stage [stage]:", "Stage [stage]", L, Eff)
	if(!C) return
	return L[C]

/datum/virus2_editor/proc/show_ui(mob/user)
	var/H = {"
	<center><h3>Virus2 Virus Editor</h3></center><br />
	<b>Effects:</b><br />
	"}
	for(var/i = 1 to 4)
		var/datum/disease2/effect/Eff = s[i]
		H += {"
				<a href='?src=\ref[src];[HrefToken()];what=effect;stage=[i];effect=1'>[initial(Eff.name)]</a>
				Chance: <a href='?src=\ref[src];[HrefToken()];what=effect;stage=[i];chance=1'>[s_chance[i]]</a>
				Multiplier: <a href='?src=\ref[src];[HrefToken()];what=effect;stage=[i];multiplier=1'>[s_multiplier[i]]</a>
				<br />
			"}
	H += {"
	<br />
	<b>Infectable Species:</b><br />
	"}
	var/f = 1
	for(var/k in GLOB.all_species)
		var/datum/species/S = GLOB.all_species[k]
		if(S.get_virus_immune())
			continue
		if(!f) H += " | "
		else f = 0
		H += "<a href='?src=\ref[src];[HrefToken()];what=species;toggle=[k]' style='color:[(k in species) ? "#006600" : "#ff0000"]'>[k]</a>"
	H += {"
	<a href="?src=\ref[src];[HrefToken()];what=species;reset=1" style="color:#0000aa">Reset</a>
	<br />
	<b>Infection Chance:</b> <a href="?src=\ref[src];[HrefToken()];what=ichance">[infectionchance]</a><br />
	<b>Spread Type:</b> <a href="?src=\ref[src];[HrefToken()];what=stype">[spreadtype]</a><br />
	<b>Speed:</b> <a href="?src=\ref[src];[HrefToken()];what=speed">[speed]</a><br />
	<b>Resistance:</b> <a href="?src=\ref[src];[HrefToken()];what=resistance">[resistance]</a><br />
	<br />
	"}
	f = 1
	for(var/k in ALL_ANTIGENS)
		if(!f) H += " | "
		else f = 0
		H += "<a href='?src=\ref[src];[HrefToken()];what=antigen;toggle=[k]' style='color:[(k in antigens) ? "#006600" : "#ff0000"]'>[k]</a>"
	H += {"
	<a href="?src=\ref[src];[HrefToken()];what=antigen;reset=1" style="color:#0000aa">Reset</a>
	<br />
	<hr />
	<b>Initial infectee:</b> <a href="?src=\ref[src];[HrefToken()];what=infectee">[infectee ? infectee : "(choose)"]</a>
	<a href="?src=\ref[src];[HrefToken()];what=go" style="color:#ff0000">RELEASE</a>
	"}

	user << browse(H, "window=virus2edit")

/datum/virus2_editor/Topic(href, href_list)
	switch(href_list["what"])
		if("effect")
			var/stage = text2num(href_list["stage"])
			if(href_list["effect"])
				var/datum/disease2/effect/E = select(usr,stage)
				if(!E) return
				s[stage] = E
				// set a default chance and multiplier of half the maximum (roughly average)
				s_chance[stage] = max(1, round(initial(E.chance_maxm)/2))
				s_multiplier[stage] = max(1, round(initial(E.maxm)/2))
			else if(href_list["chance"])
				var/datum/disease2/effect/Eff = s[stage]
				var/I = tgui_input_number(usr, "Chance, per tick, of this effect happening (min 0, max [initial(Eff.chance_maxm)])", "Effect Chance", s_chance[stage], initial(Eff.chance_maxm), 0)
				if(I == null || I < 0 || I > initial(Eff.chance_maxm)) return
				s_chance[stage] = I
			else if(href_list["multiplier"])
				var/datum/disease2/effect/Eff = s[stage]
				var/I = tgui_input_number(usr, "Multiplier for this effect (min 1, max [initial(Eff.maxm)])", "Effect Multiplier", s_multiplier[stage], initial(Eff.maxm), 1)
				if(I == null || I < 1 || I > initial(Eff.maxm)) return
				s_multiplier[stage] = I
		if("species")
			if(href_list["toggle"])
				var/T = href_list["toggle"]
				if(T in species)
					species -= T
				else
					species |= T
			else if(href_list["reset"])
				species = list()
			if(infectee)
				if(!infectee.species || !(infectee.species.get_bodytype() in species))
					infectee = null
		if("ichance")
			var/I = tgui_input_number(usr, "Input infection chance", "Infection Chance", infectionchance)
			if(!I) return
			infectionchance = I
		if("stype")
			var/S = tgui_alert(usr, "Which spread type?", "Spread Type", list("Contact", "Airborne", "Blood"))
			if(!S) return
			spreadtype = S
		if("speed")
			var/S = tgui_input_number(usr, "Input speed", "Speed", speed)
			if(!S) return
			speed = S
		if("antigen")
			if(href_list["toggle"])
				var/T = href_list["toggle"]
				if(length(T) != 1) return
				if(T in antigens)
					antigens -= T
				else
					antigens |= T
			else if(href_list["reset"])
				antigens = list()
		if("resistance")
			var/S = tgui_input_number(usr, "Input % resistance to antibiotics", "Resistance", resistance)
			if(!S) return
			resistance = S
		if("infectee")
			var/list/candidates = list()
			for(var/mob/living/carbon/G in living_mob_list)
				if(G.stat != DEAD && G.species && !G.absorbed)
					if(G.species.get_bodytype() in species)
						candidates["[G.name][G.client ? "" : " (no client)"]"] = G
					else
						candidates["[G.name] ([G.species.get_bodytype()])[G.client ? "" : " (no client)"]"] = G
			if(!candidates.len)
				to_chat(usr, "No possible candidates found!")

			var/I = tgui_input_list(usr, "Choose initial infectee", "Infectee", candidates)
			if(!I || !candidates[I]) return
			infectee = candidates[I]
			species |= infectee.species.get_bodytype()
		if("go")
			if(!antigens.len)
				var/a = tgui_alert(usr, "This disease has no antigens; it will be impossible to permanently immunise anyone without them.\
								It is strongly recommended to set at least one antigen. Do you want to go back and edit your virus?", "Antigens", list("Yes", "No"))
				if(a == "Yes") return
			var/datum/disease2/disease/D = new
			D.infectionchance = infectionchance
			D.spreadtype = spreadtype
			D.antigen = antigens
			D.affected_species = species
			D.speed = speed
			D.resistance = resistance
			for(var/i in 1 to 4)
				var/datum/disease2/effectholder/E = new
				var/Etype = s[i]
				E.effect = new Etype()
				E.effect.generate()
				E.chance = s_chance[i]
				E.multiplier = s_multiplier[i]
				E.stage = i

				D.effects += E

			spawned_viruses += D

			message_admins("<span class='danger'>[key_name_admin(usr)] infected [key_name_admin(infectee)] with a virus (<a href='?src=\ref[D];[HrefToken()];info=1'>Info</a>)</span>")
			log_admin("[key_name_admin(usr)] infected [key_name_admin(infectee)] with a virus!")
			infect_virus2(infectee, D, forced=1)

	show_ui(usr)
