//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

//  Beacon randomly spawns in space
//	When a non-traitor (no special role in /mind) uses it, he is given the choice to become a traitor
//	If he accepts there is a random chance he will be accepted, rejected, or rejected and killed
//	Bringing certain items can help improve the chance to become a traitor

/obj/machinery/syndicate_beacon
	name = "ominous beacon"
	desc = "This looks suspicious..."
	icon = 'icons/obj/device.dmi'
	icon_state = "syndbeacon"
	anchored = TRUE
	density = TRUE
	var/temptext = ""
	var/selfdestructing = 0
	var/charges = 1

/obj/machinery/syndicate_beacon/attack_hand(var/mob/user as mob)
	user.set_machine(src)
	var/dat = span_darkgreen(span_italics("Scanning [pick("retina pattern", "voice print", "fingerprints", "dna sequence")]...<br>Identity confirmed,<br>"))
	if(ishuman(user) || isAI(user))
		if(is_special_character(user))
			dat += span_darkgreen(span_italics("Operative record found. Greetings, Agent [user.name].<br>"))
		else if(charges < 1)
			dat += "<TT>Connection severed.</TT><BR>"
		else
			var/honorific = "Mr."
			if(user.gender == FEMALE)
				honorific = "Ms."
			dat += span_red(span_italics("Identity not found in operative database. What can the Syndicate do for you today, [honorific] [user.name]?<br>"))
			if(!selfdestructing)
				dat += "<br><br><A href='byond://?src=\ref[src];betraitor=1;traitormob=\ref[user]'>\"[pick("I want to switch teams.", "I want to work for you.", "Let me join you.", "I can be of use to you.", "You want me working for you, and here's why...", "Give me an objective.", "How's the 401k over at the Syndicate?")]\"</A><BR>"
	dat += temptext
	user << browse("<html>[dat]</html>", "window=syndbeacon")
	onclose(user, "syndbeacon")

/obj/machinery/syndicate_beacon/Topic(href, href_list)
	if(..())
		return
	if(href_list["betraitor"])
		if(charges < 1)
			updateUsrDialog(usr)
			return
		var/mob/M = locate(href_list["traitormob"])
		if(M.mind.special_role || jobban_isbanned(M, JOB_SYNDICATE))
			temptext = span_italics("We have no need for you at this time. Have a pleasant day.") + "<br>"
			updateUsrDialog(usr)
			return
		charges -= 1
		switch(rand(1,2))
			if(1)
				temptext = span_red(span_italics(span_bold("Double-crosser. You planned to betray us from the start. Allow us to repay the favor in kind.")))
				updateUsrDialog(usr)
				spawn(rand(50,200)) selfdestruct()
				return
			if(2)
				return
		if(ishuman(M))
			var/mob/living/carbon/human/N = M
			to_chat(N, span_infoplain(span_bold("You have joined the ranks of the Syndicate and become a traitor to the station!")))
			traitors.add_antagonist(N.mind)
			traitors.equip(N)
			message_admins("[N]/([N.ckey]) has accepted a traitor objective from a syndicate beacon.")

	updateUsrDialog(usr)
	return

/obj/machinery/syndicate_beacon/proc/selfdestruct()
	selfdestructing = 1
	spawn() explosion(src.loc, 1, rand(1,3), rand(3,8), 10)

////////////////////////////////////////
//Singularity beacon
////////////////////////////////////////
/obj/machinery/power/singularity_beacon
	name = "ominous beacon"
	desc = "This looks suspicious..."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "beacon"

	anchored = FALSE
	density = TRUE
	layer = MOB_LAYER - 0.1 //so people can't hide it and it's REALLY OBVIOUS
	stat = 0

	var/active = 0
	var/icontype = "beacon"

/obj/machinery/power/singularity_beacon/proc/Activate(mob/user = null)
	if(surplus() < 1500)
		if(user)
			to_chat(user, span_notice("The connected wire doesn't have enough current."))
		return
	for(var/obj/singularity/singulo in all_singularities)
		if(singulo.z == z)
			singulo.target = src
	icon_state = "[icontype]1"
	active = 1
	START_MACHINE_PROCESSING(src)
	if(user)
		to_chat(user, span_notice("You activate the beacon."))

/obj/machinery/power/singularity_beacon/proc/Deactivate(mob/user = null)
	for(var/obj/singularity/singulo in all_singularities)
		if(singulo.target == src)
			singulo.target = null
	icon_state = "[icontype]0"
	active = 0
	if(user)
		to_chat(user, span_notice("You deactivate the beacon."))

/obj/machinery/power/singularity_beacon/attack_ai(mob/user as mob)
	return

/obj/machinery/power/singularity_beacon/attack_hand(var/mob/user as mob)
	if(anchored)
		return active ? Deactivate(user) : Activate(user)
	else
		to_chat(user, span_danger("You need to screw the beacon to the floor first!"))
		return

/obj/machinery/power/singularity_beacon/attackby(obj/item/W as obj, mob/user as mob)
	if(W.has_tool_quality(TOOL_SCREWDRIVER))
		if(active)
			to_chat(user, span_danger("You need to deactivate the beacon first!"))
			return

		if(anchored)
			anchored = FALSE
			to_chat(user, span_notice("You unscrew the beacon from the floor."))
			playsound(src, W.usesound, 50, 1)
			disconnect_from_network()
			return
		else
			if(!connect_to_network())
				to_chat(user, "This device must be placed over an exposed cable.")
				return
			anchored = TRUE
			to_chat(user, span_notice("You screw the beacon to the floor and attach the cable."))
			playsound(src, W.usesound, 50, 1)
			return
	..()
	return

/obj/machinery/power/singularity_beacon/Destroy()
	if(active)
		Deactivate()
	. = ..()

//stealth direct power usage
/obj/machinery/power/singularity_beacon/process()
	if(!active)
		return PROCESS_KILL
	else
		if(draw_power(1500) < 1500)
			Deactivate()

/obj/machinery/power/singularity_beacon/syndicate
	icontype = "beaconsynd"
	icon_state = "beaconsynd0"
