GLOBAL_LIST_BOILERPLATE(all_pai_cards, /obj/item/device/paicard)

/obj/item/device/paicard
	name = "personal AI device"
	icon = 'icons/obj/pda.dmi'
	icon_state = "pai"
	item_state = "electronic"
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_DATA = 2)
	show_messages = 0
	preserve_item = 1

	var/obj/item/device/radio/radio
	var/looking_for_personality = 0
	var/mob/living/silicon/pai/pai
	var/image/screen_layer
	var/screen_color = "#00ff0d"
	var/last_notify = 0
	var/screen_msg

/obj/item/device/paicard/relaymove(var/mob/user, var/direction)
	if(user.stat || user.stunned)
		return
	var/obj/item/weapon/rig/rig = src.get_rig()
	if(istype(rig))
		rig.forced_move(direction, user)

/obj/item/device/paicard/New()
	..()
	add_overlay("pai-off")

/obj/item/device/paicard/Destroy()
	//Will stop people throwing friend pAIs into the singularity so they can respawn
	if(!isnull(pai))
		pai.death(0)
	QDEL_NULL(radio)
	return ..()

// VOREStation Edit - Allow everyone to become a pAI
/obj/item/device/paicard/attack_ghost(mob/user as mob)
	if(pai != null) //Have a person in them already?
		return ..()

	var/choice = tgui_alert(user, "You sure you want to inhabit this PAI?", "Confirmation", list("Yes", "No"))
	if(choice == "No")
		return ..()

	choice = tgui_alert(user, "Do you want to load your pAI data?", "Load", list("Yes", "No"))
	var/actual_pai_name
	var/turf/location = get_turf(src)
	if(choice == "No")
		var/pai_name = tgui_input_text(user, "Choose your character's name", "Character Name")
		actual_pai_name = sanitize_name(pai_name, ,1)
		if(isnull(actual_pai_name))
			return ..()
		if(istype(src , /obj/item/device/paicard/typeb))
			var/obj/item/device/paicard/typeb/card = new(location)
			var/mob/living/silicon/pai/new_pai = new(card)
			new_pai.key = user.key
			card.setPersonality(new_pai)
			new_pai.SetName(actual_pai_name)
		else
			var/obj/item/device/paicard/card = new(location)
			var/mob/living/silicon/pai/new_pai = new(card)
			new_pai.key = user.key
			card.setPersonality(new_pai)
			new_pai.SetName(actual_pai_name)

	if(choice == "Yes")
		if(istype(src , /obj/item/device/paicard/typeb))
			var/obj/item/device/paicard/typeb/card = new(location)
			var/mob/living/silicon/pai/new_pai = new(card)
			new_pai.key = user.key
			card.setPersonality(new_pai)
			if(!new_pai.savefile_load(new_pai))
				var/pai_name = tgui_input_text(new_pai, "Choose your character's name", "Character Name")
				actual_pai_name = sanitize_name(pai_name, ,1)
				if(isnull(actual_pai_name))
					return ..()
		else
			var/obj/item/device/paicard/card = new(location)
			var/mob/living/silicon/pai/new_pai = new(card)
			new_pai.key = user.key
			card.setPersonality(new_pai)
			if(!new_pai.savefile_load(new_pai))
				var/pai_name = tgui_input_text(new_pai, "Choose your character's name", "Character Name")
				actual_pai_name = sanitize_name(pai_name, ,1)
				if(isnull(actual_pai_name))
					return ..()

	qdel(src)
	return ..()

// VOREStation Edit End

/obj/item/device/paicard/attack_self(mob/user)
	if (!in_range(src, user))
		return
	user.set_machine(src)
	var/dat = {"
		<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
		<html>
			<head>
				<style>
					body {
					    margin-top:5px;
					    font-family:Verdana;
					    color:white;
					    font-size:13px;
					    background-image:url('uiBackground.png');
					    background-repeat:repeat-x;
					    background-color:#272727;
						background-position:center top;
					}
					table {
					    font-size:13px;
					    margin-left:-2px;
					}
					table.request {
					    border-collapse:collapse;
					}
					table.desc {
					    border-collapse:collapse;
					    font-size:13px;
					    border: 1px solid #161616;
					    width:100%;
					}
					table.download {
					    border-collapse:collapse;
					    font-size:13px;
					    border: 1px solid #161616;
					    width:100%;
					}
					tr.d0 td, tr.d0 th {
					    background-color: #506070;
					    color: white;
					}
					tr.d1 td, tr.d1 th {
					    background-color: #708090;
					    color: white;
					}
					tr.d2 td {
					    background-color: #00FF00;
					    color: white;
					    text-align:center;
					}
					td.button {
					    border: 1px solid #161616;
					    background-color: #40628a;
					}
					td.button {
					    border: 1px solid #161616;
					    background-color: #40628a;
					    text-align: center;
					}
					td.button_red {
					    border: 1px solid #161616;
					    background-color: #B04040;
					    text-align: center;
					}
					td.download {
					    border: 1px solid #161616;
					    background-color: #40628a;
					    text-align: center;
					}
					th {
					    text-align:left;
					    width:125px;
					}
					td.request {
					    width:140px;
					    vertical-align:top;
					}
					td.radio {
					    width:90px;
					    vertical-align:top;
					}
					td.request {
					    vertical-align:top;
					}
					a {
					    color:#4477E0;
					}
					a.button {
					    color:white;
					    text-decoration: none;
					}
					h2 {
					    font-size:15px;
					}
				</style>
			</head>
			<body>
	"}

	if(pai)
		dat += {"
			<b><font size='3px'>Personal AI Device</font></b><br><br>
			<table class="request">
				<tr>
					<td class="request">Installed Personality:</td>
					<td>[pai.name]</td>
				</tr>
				<tr>
					<td class="request">Prime directive:</td>
					<td>[pai.pai_law0]</td>
				</tr>
				<tr>
					<td class="request">Additional directives:</td>
					<td>[pai.pai_laws]</td>
				</tr>
			</table>
			<br>
		"}
		dat += {"
			<table>
				<td class="button">
					<a href='byond://?src=\ref[src];setlaws=1' class='button'>Configure Directives</a>
				</td>
			</table>
		"}
		if(pai && (!pai.master_dna || !pai.master))
			dat += {"
				<table>
					<td class="button">
						<a href='byond://?src=\ref[src];setdna=1' class='button'>Imprint Master DNA</a>
					</td>
				</table>
			"}
		dat += "<br>"
		if(radio)
			dat += "<b>Radio Uplink</b>"
			dat += {"
				<table class="request">
					<tr>
						<td class="radio">Transmit:</td>
						<td><a href='byond://?src=\ref[src];wires=4'>[radio.broadcasting ? "<font color=#55FF55>En" : "<font color=#FF5555>Dis" ]abled</font></a>

						</td>
					</tr>
					<tr>
						<td class="radio">Receive:</td>
						<td><a href='byond://?src=\ref[src];wires=2'>[radio.listening ? "<font color=#55FF55>En" : "<font color=#FF5555>Dis" ]abled</font></a>

						</td>
					</tr>
				</table>
				<br>
			"}
		else //</font></font>
			dat += "<b>Radio Uplink</b><br>"
			dat += "<font color=red><i>Radio firmware not loaded. Please install a pAI personality to load firmware.</i></font><br>"
		/* - //A button for instantly deleting people from the game is lame, especially considering that pAIs on our server tend to activate without a master.
		dat += {"
			<table>
				<td class="button_red"><a href='byond://?src=\ref[src];wipe=1' class='button'>Wipe current pAI personality</a>

				</td>
			</table>
		"}
		*/
		if(screen_msg)
			dat += "<b>Message from [pai.name]</b><br>[screen_msg]"
	else
		if(looking_for_personality)
			dat += {"
				<b><font size='3px'>pAI Request Module</font></b><br><br>
				<p>Requesting AI personalities from central database... If there are no entries, or if a suitable entry is not listed, check again later as more personalities may be added.</p>
				<img src='loading.gif' /> Searching for personalities<br><br>

				<table>
					<tr>
						<td class="button">
							<a href='byond://?src=\ref[src];request=1' class="button">Refresh available personalities</a>
						</td>
					</tr>
				</table><br>
			"}
		else
			dat += {"
				<b><font size='3px'>pAI Request Module</font></b><br><br>
			    <p>No personality is installed.</p>
				<table>
					<tr>
						<td class="button"><a href='byond://?src=\ref[src];request=1' class="button">Request personality</a>
						</td>
					</tr>
				</table>
				<br>
				<p>Each time this button is pressed, a request will be sent out to any available personalities. Check back often give plenty of time for personalities to respond. This process could take anywhere from 15 seconds to several minutes, depending on the available personalities' timeliness.</p>
			"}
	user << browse(dat, "window=paicard")
	onclose(user, "paicard")
	return

/obj/item/device/paicard/Topic(href, href_list)

	if(!usr || usr.stat)
		return

	if(href_list["setdna"])
		if(pai.master_dna)
			return
		var/mob/M = usr
		if(!istype(M, /mob/living/carbon))
			to_chat(usr, "<font color=blue>You don't have any DNA, or your DNA is incompatible with this device.</font>")
		else
			var/datum/dna/dna = usr.dna
			pai.master = M.real_name
			pai.master_dna = dna.unique_enzymes
			to_chat(pai, "<font color = red><h3>You have been bound to a new master.</h3></font>")
	if(href_list["request"])
		src.looking_for_personality = 1
		paiController.findPAI(src, usr)
	if(href_list["wipe"])
		var/confirm = tgui_alert(usr, "Are you CERTAIN you wish to delete the current personality? This action cannot be undone.", "Personality Wipe", list("Yes", "No"))
		if(confirm == "Yes")
			for(var/mob/M in src)
				to_chat(M, "<font color = #ff0000><h2>You feel yourself slipping away from reality.</h2></font>")
				to_chat(M, "<font color = #ff4d4d><h3>Byte by byte you lose your sense of self.</h3></font>")
				to_chat(M, "<font color = #ff8787><h4>Your mental faculties leave you.</h4></font>")
				to_chat(M, "<font color = #ffc4c4><h5>oblivion... </h5></font>")
				M.death(0)
			removePersonality()
	if(href_list["wires"])
		var/t1 = text2num(href_list["wires"])
		switch(t1)
			if(4)
				radio.ToggleBroadcast()
			if(2)
				radio.ToggleReception()
	if(href_list["setlaws"])
		var/newlaws = sanitize(tgui_input_text(usr, "Enter any additional directives you would like your pAI personality to follow. Note that these directives will not override the personality's allegiance to its imprinted master. Conflicting directives will be ignored.", "pAI Directive Configuration", pai.pai_laws, multiline = TRUE, prevent_enter = TRUE))
		if(newlaws)
			pai.pai_laws = newlaws
			to_chat(pai, "Your supplemental directives have been updated. Your new directives are:")
			to_chat(pai, "Prime Directive: <br>[pai.pai_law0]")
			to_chat(pai, "Supplemental Directives: <br>[pai.pai_laws]")
	attack_self(usr)

// 		WIRE_SIGNAL = 1
//		WIRE_RECEIVE = 2
//		WIRE_TRANSMIT = 4

/obj/item/device/paicard/proc/setPersonality(mob/living/silicon/pai/personality)
	src.pai = personality
	setEmotion(1)

/obj/item/device/paicard/proc/removePersonality()
	src.pai = null
	cut_overlays()
	setEmotion(16)

/obj/item/device/paicard
	var/current_emotion = 1
/obj/item/device/paicard/proc/setEmotion(var/emotion)
	if(pai)
		cut_overlays()
		qdel(screen_layer)
		screen_layer = null
		switch(emotion)
			if(1) screen_layer = image(icon, "pai-neutral")
			if(2) screen_layer = image(icon, "pai-what")
			if(3) screen_layer = image(icon, "pai-happy")
			if(4) screen_layer = image(icon, "pai-cat")
			if(5) screen_layer = image(icon, "pai-extremely-happy")
			if(6) screen_layer = image(icon, "pai-face")
			if(7) screen_layer = image(icon, "pai-laugh")
			if(8) screen_layer = image(icon, "pai-sad")
			if(9) screen_layer = image(icon, "pai-angry")
			if(10) screen_layer = image(icon, "pai-silly")
			if(11) screen_layer = image(icon, "pai-nose")
			if(12) screen_layer = image(icon, "pai-smirk")
			if(13) screen_layer = image(icon, "pai-exclamation")
			if(14) screen_layer = image(icon, "pai-question")
			if(15) screen_layer = image(icon, "pai-blank")
			if(16) screen_layer = image(icon, "pai-off")

		screen_layer.color = pai.eye_color
		add_overlay(screen_layer)
		current_emotion = emotion

/obj/item/device/paicard/proc/alertUpdate()
	if(pai)
		return
	if(last_notify == 0 || (5 MINUTES <= world.time - last_notify))
		audible_message("<span class='notice'>\The [src] flashes a message across its screen, \"Additional personalities available for download.\"</span>", hearing_distance = world.view, runemessage = "bleeps!")
		last_notify = world.time

/obj/item/device/paicard/emp_act(severity)
	for(var/mob/M in src)
		M.emp_act(severity)

/obj/item/device/paicard/ex_act(severity)
	if(pai)
		pai.ex_act(severity)
	else
		qdel(src)

/obj/item/device/paicard/see_emote(mob/living/M, text)
	if(pai && pai.client && !pai.canmove)
		var/rendered = "<span class='message'>[text]</span>"
		pai.show_message(rendered, 2)
	..()

/obj/item/device/paicard/show_message(msg, type, alt, alt_type)
	if(pai && pai.client)
		var/rendered = "<span class='message'>[msg]</span>"
		pai.show_message(rendered, type)
	..()


// VoreEdit: Living Machine Stuff after this.
// This adds a var and proc for all machines to take a pAI. (The pAI can't control anything, it's just for RP.)
// You need to add usage of the proc to each machine to actually add support. For an example of this, see code\modules\food\kitchen\microwave.dm
/obj/machinery
	var/obj/item/device/paicard/paicard = null

/obj/machinery/proc/insertpai(mob/user, obj/item/device/paicard/card)
	//var/obj/item/paicard/card = I
	var/mob/living/silicon/pai/AI = card.pai
	if(paicard)
		to_chat(user, span_notice("This bot is already under PAI Control!"))
		return
	if(!istype(card)) // TODO: Add sleevecard support.
		return
	if(!card.pai)
		to_chat(user, span_notice("This card does not currently have a personality!"))
		return
	paicard = card
	user.unEquip(card)
	card.forceMove(src)
	AI.client.eye = src
	to_chat(AI, span_notice("Your location is [card.loc].")) // DEBUG. TODO: Make unfolding the chassis trigger an eject.
	name = AI.name
	to_chat(AI, span_notice("You feel a tingle in your circuits as your systems interface with \the [initial(src.name)]."))

/obj/machinery/proc/ejectpai(mob/user)
	if(paicard)
		var/mob/living/silicon/pai/AI = paicard.pai
		paicard.forceMove(src.loc)
		AI.client.eye = AI
		paicard = null
		name = initial(src.name)
		to_chat(AI, span_notice("You feel a tad claustrophobic as your mind closes back into your card, ejecting from \the [initial(src.name)]."))
		if(user)
			to_chat(user, span_notice("You eject the card from \the [initial(src.name)]."))

/obj/item/device/paicard/typeb
	name = "personal AI device"
	icon = 'icons/obj/paicard.dmi'

/obj/random/paicard
	name = "personal AI device spawner"
	icon = 'icons/obj/paicard.dmi'
	icon_state = "pai"

/obj/random/paicard/item_to_spawn()
	return pick(/obj/item/device/paicard ,/obj/item/device/paicard/typeb)

/obj/item/device/paicard/digest_act(var/atom/movable/item_storage = null)
	if(!pai.digestable)
		return
	. = ..()	
