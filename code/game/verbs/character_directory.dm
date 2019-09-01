/client/verb/show_character_directory()
	set name = "Character Directory"
	set category = "OOC"
	set desc = "Shows a listing of all active characters, along with their associated OOC notes, flavor text, and more."

	if(mob.next_move >= world.time)	//This is primarily to stop malicious users from trying to lag the server by spamming this verb
		return

	mob.next_move = world.time + 10

	var/html = "<script> function togglesection(targetsection) { var targettext = document.getElementById(targetsection); if (targettext.style.display === 'none') { targettext.style.display = ''; } else { targettext.style.display = 'none'; } } </script>"

	var/curID = 0
	for(var/client/C in GLOB.clients)
		if(C.prefs && !C.prefs.show_in_directory)
			continue
		if(ishuman(C.mob))
			var/mob/living/carbon/human/H = C.mob
			if(data_core && data_core.general)
				if(!find_general_record("name", H.real_name))
					continue
			curID++
			html += "<div class='block'>"
			html += "<h3 class='uiContent highlight' style='font-size:16px'>[H.real_name]</h3><br>"
			if(H.flavor_texts["general"])
				html += "<a onclick='togglesection(\"[ckey(H.real_name)] [curID] flavor\")'>Flavor text</a>"
				html += "<p class='uiContent' style='display:none' id='[ckey(H.real_name)] [curID] flavor'>[H.flavor_texts["general"]]</p>"
			if(H.ooc_notes)
				html += "<a onclick='togglesection(\"[ckey(H.real_name)] [curID] ooc\")'>OOC notes</a>"
				html += "<p class='uiContent' style='display:none' id='[ckey(H.real_name)] [curID] ooc'>[H.ooc_notes]</p>"
			html += "</div>"
		if(isAI(C.mob))
			var/mob/living/silicon/ai/A = C.mob
			curID++
			html += "<div class='block'>"
			html += "<h3 class='uiContent highlight' style='font-size:16px'>[A.name] (Artificial Intelligence)</h3><br>"
			if(A.ooc_notes)
				html += "<a onclick='togglesection(\"[ckey(A.name)] [curID] ooc\")'>OOC notes</a>"
				html += "<p class='uiContent' style='display:none' id='[ckey(A.name)] [curID] ooc'>[A.ooc_notes]</p>"
			html += "</div>"
		if(isrobot(C.mob))
			var/mob/living/silicon/robot/R = C.mob
			if(R.scrambledcodes || (R.module && R.module.hide_on_manifest))
				continue
			curID++
			html += "<div class='block'>"
			html += "<h3 class='uiContent highlight' style='font-size:16px'>[R.name] ([R.modtype] [R.braintype])</h3><br>"
			if(R.flavor_text)
				html += "<a onclick='togglesection(\"[ckey(R.name)] [curID] flavor\")'>Flavor text</a>"
				html += "<p class='uiContent' style='display:none' id='[ckey(R.name)] [curID] flavor'>[R.flavor_text]</p>"
			if(R.ooc_notes)
				html += "<a onclick='togglesection(\"[ckey(R.name)] [curID] ooc\")'>OOC notes</a>"
				html += "<p class='uiContent' style='display:none' id='[ckey(R.name)] [curID] ooc'>[R.ooc_notes]</p>"
			html += "</div>"
	if(!curID)
		html += "<p class='uiContent'>404: Station not found</p>"

	var/datum/browser/popup = new(mob, "chardir", "Character Directory", 640, 480)
	popup.set_content(html)
	popup.open()
