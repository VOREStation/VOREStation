/obj/item/holowarrant
	name = "warrant projector"
	desc = "The practical paperwork replacement for the officer on the go."
	icon = 'icons/obj/device.dmi'
	pickup_sound = 'sound/items/pickup/device.ogg'
	drop_sound = 'sound/items/drop/device.ogg'
	icon_state = "holowarrant"
	item_state = "flashtool"
	throwforce = 5
	w_class = ITEMSIZE_SMALL
	throw_speed = 4
	throw_range = 10
	var/datum/data/record/warrant/active

//look at it
/obj/item/holowarrant/examine(mob/user)
	. = ..()
	if(active)
		. += "It's a holographic warrant for '[active.fields["namewarrant"]]'."
	if(in_range(user, src) || istype(user, /mob/observer/dead))
		show_content(user) //Opens a browse window, not chatbox related
	else
		. += "<span class='notice'>You have to go closer if you want to read it.</span>"

//hit yourself with it
/obj/item/holowarrant/attack_self(mob/living/user as mob)
	active = null
	var/list/warrants = list()
	if(!isnull(data_core.general))
		for(var/datum/data/record/warrant/W in data_core.warrants)
			warrants += W.fields["namewarrant"]
	if(warrants.len == 0)
		to_chat(user,"<span class='notice'>There are no warrants available</span>")
		return
	var/temp
	temp = tgui_input_list(user, "Which warrant would you like to load?", "Warrant Selection", warrants)
	for(var/datum/data/record/warrant/W in data_core.warrants)
		if(W.fields["namewarrant"] == temp)
			active = W
	update_icon()

/obj/item/holowarrant/attackby(obj/item/W, mob/user)
	if(active)
		var/obj/item/card/id/I = W.GetIdCard()
		if(access_hos in I.access) // VOREStation edit
			var/choice = tgui_alert(user, "Would you like to authorize this warrant?","Warrant authorization",list("Yes","No"))
			if(choice == "Yes")
				active.fields["auth"] = "[I.registered_name] - [I.assignment ? I.assignment : "(Unknown)"]"
			user.visible_message("<span class='notice'>You swipe \the [I] through the [src].</span>", \
					"<span class='notice'>[user] swipes \the [I] through the [src].</span>")
			return 1
		to_chat(user, "<span class='warning'>You don't have the access to do this!</span>") // VOREStation edit
		return 1
	..()

//hit other people with it
/obj/item/holowarrant/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	user.visible_message("<span class='notice'>You show the warrant to [M].</span>", \
			"<span class='notice'>[user] holds up a warrant projector and shows the contents to [M].</span>")
	M.examinate(src)

/obj/item/holowarrant/update_icon()
	if(active)
		icon_state = "holowarrant_filled"
	else
		icon_state = "holowarrant"

/obj/item/holowarrant/proc/show_content(mob/user, forceshow)
	if(!active)
		return
	if(active.fields["arrestsearch"] == "arrest")
		var/output = {"
		<HTML><HEAD><TITLE>[active.fields["namewarrant"]]</TITLE></HEAD>
		<BODY bgcolor='#FFFFFF'><center><large><b>Commonwealth Security Bond Association</b></large></br>
		in the jurisdiction of the</br>
		[using_map.boss_name] in [using_map.station_name]</br>
		</br>
		<b>ARREST WARRANT</b></center></br>
		</br>
		This document serves as authorization and notice for the arrest of _<u>[active.fields["namewarrant"]]</u>____ for the crime(s) of:</br>[active.fields["charges"]]</br>
		</br>
		Vessel or habitat: _<u>[using_map.station_name]</u>____</br>
		</br>_<u>[active.fields["auth"]]</u>____</br>
		<small>Person authorizing arrest</small></br>
		</BODY></HTML>
		"}

		show_browser(user, output, "window=Warrant for the arrest of [active.fields["namewarrant"]]")
	if(active.fields["arrestsearch"] ==  "search")
		var/output= {"
		<HTML><HEAD><TITLE>Search Warrant: [active.fields["namewarrant"]]</TITLE></HEAD>
		<BODY bgcolor='#FFFFFF'><center>in the jurisdiction of the</br>
		[using_map.boss_name] in [using_map.station_name]</br>
		</br>
		<b>SEARCH WARRANT</b></center></br>
		</br>
		<small><i>The Security Officer(s) bearing this Warrant are hereby authorized by the Issuer </br>
		to conduct a one time lawful search of the Suspect's person/belongings/premises and/or Department </br>
		for any items and materials that could be connected to the suspected criminal act described below, </br>
		pending an investigation in progress. The Security Officer(s) are obligated to remove any and all</br>
		such items from the Suspects posession and/or Department and file it as evidence. The Suspect/Department </br>
		staff is expected to offer full co-operation. In the event of the Suspect/Department staff attempting </br>
		to resist/impede this search or flee, they must be taken into custody immediately! </br>
		All confiscated items must be filed and taken to Evidence!</small></i></br>
		</br>
		<b>Suspect's/location name: </b>[active.fields["namewarrant"]]</br>
		</br>
		<b>For the following reasons: </b> [active.fields["charges"]]</br>
		</br>
		<b>Warrant issued by: </b> [active.fields ["auth"]]</br>
		</br>
		Vessel or habitat: _<u>[using_map.station_name]</u>____</br>
		</BODY></HTML>
		"}
		show_browser(user, output, "window=Search warrant for [active.fields["namewarrant"]]")

/obj/item/storage/box/holowarrants // VOREStation addition starts
	name = "holowarrant devices"
	desc = "A box of holowarrant diplays for security use."

/obj/item/storage/box/holowarrants/New()
	..()
	for(var/i = 0 to 3)
		new /obj/item/holowarrant(src) // VOREStation addition ends
