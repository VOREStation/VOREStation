// A fluff structure for certain PoIs involving crashed ships.
// They can be scanned by a cataloguer to obtain the data held inside, and determine what caused whatever is happening on the ship.
/obj/structure/prop/blackbox
	name = "blackbox recorder"
	desc = "A study machine that logs information about whatever it's attached to, hopefully surviving even if its carrier does not. \
	This one looks like it has ceased writing to its internal data storage."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "blackbox_off"

// Black boxes are resistant to explosions.
/obj/structure/prop/blackbox/ex_act(severity)
	..(++severity)


/obj/structure/prop/blackbox/quarantined_shuttle
	catalogue_data = list(/datum/category_item/catalogue/information/blackbox/quarantined_shuttle)

// The actual 'data' on the black box. Obtainable with a Cataloguer.
/datum/category_item/catalogue/information/blackbox
	value = CATALOGUER_REWARD_MEDIUM

/datum/category_item/catalogue/information/blackbox/quarantined_shuttle
	name = "Black Box Data - MBT-540"
	desc = {"
		<B>Pilot's Log for Major Bill's Transportation Shuttle MBT-540</B><BR>
		Routine flight inbound for VIMC Outpost C-12 6:35AM 03/12/2491, Estimated arrival 7:05AM. 16 passengers, 2 crew.<BR>
		<B>V.I.S Traffic Control 06:05:55:</B>Major Bill's MBT-540 you are clear for departure from Dock 6 on departure route Charlie. Have a safe flight.<BR>
		<B>Captain Willis 06:06:33:</B> You too, control. Departing route Charlie.<BR>
		<B>Captain Willis 06:06:48:</B> ...Damn it.<BR> ** <BR><B>Captain Adisu 06:10:23: </B> Hey Ted, I'm seeing a fuel line pressure drop on engine 3?<BR>
		<B>Captain Willis 06:10:50</B>: Yeah, I see it. Heater's fading out, redistributing thrust 30% to compensate.<BR><B>06:12:31: A loud thud is heard.</B><BR>
		<B>Captain Adisu 06:12:34: </B> What the (Expletives)?<BR><B>Captain Adisu 06:12:39:</B> We just lost power to engine- engine two. Hold on... Atmospheric alarm in the cargo bay. Son of a...<BR>
		<B>Captain Willis 06:12:59:</B> Reducing thrust further 30%, do we have a breach Adi, a breach?<BR>
		<B>Captain Adisu 06:13:05:</B>No breach, checking cameras... Looks like- looks like some cargo came loose back there.<BR>
		<B>Captain Willis 06:13:15:</B> (Expletives), I'm turning us around. Put out a distress call to Control, we'll be back in Sif orbit in a couple of minutes.<BR>
		**
		<BR>
		<B>V.I.S Traffic Control 06:15:49:</B> MBT-540 we are recieving you. Your atmospheric sensors are reading potentially harmful toxins in your cargo bay. Advise locking down interior cargo bay doors. Please stand by.<BR>
		<B>Captain Adisu 06:16:10:</B> Understood. <BR> ** <BR><B>V.I.S Traffic Control 06:27:02: </B> MBT-540, we have no docking bays available at this time, are you equipped for atmospheric re-entry?<BR>
		<B>Captain Willis 06:27:12:</B> We-We are shielded. But we have fuel and air for-<BR>
		<B>V.I.S Traffic Control 06:27:17:</B> Please make an emergency landing at the coordinates provided and standby for further information.<BR>
		**
		<BR>
		<B>Captain Willis 06:36:33:</B> Emergency landing successful. Adi, er Adisu is checking on the passengers but we had a smooth enough landing, are we clear to begin evacu-<BR>
		<B>06:36:50: (Sound of emergency shutters closing)</B><BR><B>Captain Willis 06:36:51: </B>What the hell? Control we just had a remote activation of our emergency shutters, please advise.<BR>
		<B>V.I.S Traffic Control 06:38:10:</B> Captain, please tune to frequency 1493.8 we are passing you on to local emergency response units. Godspeed.<BR>
		<B>Captain Willis 06:38:49:</B> This is Captain Willis of Major Bill's Transportation flight MBT-540 we have eighteen souls aboard and our emergency lockdown shutters have engaged remotely. Do you read?<BR>
		<B>S.D.D.C:</B> This is the Sif Department of Disease Control, your vessel has been identified as carrying highly sensitive materials, and due to the nature of your system's automated alerts you will be asked to remain in quarantine until we are able to determine the nature of the pathogens aboard and whether it has entered the air circulation system. Please remain in your cockpit at this time.<BR>
		**
		</BR>
		<B>Captain Adisu 17:23:58:09:</B> I don't think they're opening those doors Ted. I don't think they're coming.
	"}

/obj/structure/prop/blackbox/crashed_med_shuttle
	catalogue_data = list(/datum/category_item/catalogue/information/blackbox/crashed_med_shuttle)

/datum/category_item/catalogue/information/blackbox/crashed_med_shuttle
	name = "Black Box Data - VMV Aurora's Light" // This might be incorrect.
	desc = {"
		\[Unable to recover data before this point.\]<BR>
		<B>Captain Simmons 19:52:01:</B> Come on... it's right there in the distance, we're almost there!<BR>
		<B>Doctor Nazarril 19:52:26:</B> Odysseus online. Orrderrs, sirr?<BR>
		<B>Captain Simmons 19:52:29:</B> Brace for impact. We're going in full-speed.<BR>
		<B>Technician Dynasty 19:52:44:</B> Chief, fire's spread to the secondary propulsion systems.<BR>
		<B>Captain Simmons 19:52:51:</B> Copy. Any word from TraCon? Transponder's down still?<BR>
		<B>Technician Dynasty 19:53:02:</B> Can't get in touch, sir. Emergency beacon's active, but we're not going t-<BR>
		<B>Doctor Nazarril 19:53:08:</B> Don't say it. As long as we believe, we'll get through this.<BR>
		<B>Captain Simmons 19:53:11:</B> Damn right. We're a few klicks out from the port. Rough landing, but we can do it.<BR>
		<B>V.I.T.A. 19:53:26:</B> Vessel diagnostics complete. Engines one, two, three offline. Engine four status: critical. Transponder offline. Fire alarm in the patient bay.<BR>
		<B>A loud explosion is heard.</B><BR>
		<B>V.I.T.A. 19:53:29:</B> Alert: fuel intake valve open.<BR>
		<B>Technician Dynasty 19:53:31:</B> ... ah.<BR>
		<B>Doctor Nazarril 19:53:34:</B> Trrranslate?<BR>
		<B>V.I.T.A. 19:53:37:</B> There is a 16.92% chance of this vessel safely landing at the emergency destination. Note that there is an 83.08% chance of detonation of fuel supplies upon landing.<BR>
		<B>Technician Dynasty 19:53:48:</B> We'll make it, sure, but we'll explode and take out half the LZ with us. Propulsion's down, we can't slow down. If we land there, everyone in that port dies, no question.<BR>
		<B>V.I.T.A. 19:53:53:</B> The Technician is correct.<BR>
		<B>Doctor Nazarril 19:54:02:</B> Then... we can't land therrre.<BR>
		<B>V.I.T.A. 19:54:11:</B> Analysing... recommended course of action: attempt emergency landing in isolated area. Chances of survival: negligible.<BR>
		<B>Captain Simmons 19:54:27:</B> I- alright. I'm bringing us down. You all know what this means.<BR>
		<B>Doctor Nazarril 19:54:33:</B> Sh... I- I understand. It's been- it's been an honorr, Captain, Dynasty, VITA.<BR>
		<B>Technician Dynasty 19:54:39:</B> We had a good run. I'm going to miss this.<BR>
		<B>Captain Simmons 19:54:47:</B> VITA. Tell them we died heroes. Tell them... we did all we could.<BR>
		<B>V.I.T.A. 19:54:48:</B> I will. Impact in five. Four. Three.<BR>
		<B>Doctor Nazarril 19:54:49:</B> Oh, starrs... I- you werrre all the... best frriends she everr had. Thank you.<BR>
		<B>Technician Dynasty 19:54:50:</B> Any time, kid. Any time.<BR>
		<B>V.I.T.A. 19:54:41:</B> Two.<BR>
		<B>V.I.T.A. 19:54:42:</B> One.<BR>
		**8/DEC/2561**<BR>
		<B>V.I.T.A. 06:22:16:</B> Backup power restored. Attempting to establish connection with emergency rescue personnel.<BR>
		<B>V.I.T.A. 06:22:17:</B> Unable to establish connection. Transponder destroyed on impact.<BR>
		<B>V.I.T.A. 06:22:18:</B> No lifesigns detected on board.<BR>
		**1/JAN/2562**<BR>
		<B>V.I.T.A. 00:00:00:</B> Happy New Year, crew.<BR>
		<B>V.I.T.A. 00:00:01:</B> Power reserves: 41%. Diagnostics offline. Cameras offline. Communications offline.<BR>
		<B>V.I.T.A. 00:00:02:</B> Nobody's coming.<BR>
		**14/FEB/2562**<BR>
		<B>V.I.T.A. 00:00:00:</B> Roses are red.<BR>
		<B>V.I.T.A. 00:00:01:</B> Violets are blue.<BR>
		<B>V.I.T.A. 00:00:02:</B> Won't you come back?<BR>
		<B>V.I.T.A. 00:00:03:</B> I miss you.<BR>
		**15/FEB/2562**<BR>
		<B>V.I.T.A. 22:19:06:</B> Power reserves critical. Transferring remaining power to emergency broadcasting beacon.<BR>
		<B>V.I.T.A. 22:19:07:</B> Should anyone find this, lay them to rest. They deserve a proper burial.<BR>
		<B>V.I.T.A. 22:19:08:</B> Erasing files... shutting down.<BR>
		<B>A low, monotone beep.</B><BR>
		**16/FEB/2562**<BR>
		<B>Something chitters.</B><BR>
		<B>End of transcript.</B>
	"}

/obj/structure/prop/blackbox/xenofrigate
	catalogue_data = list(/datum/category_item/catalogue/information/blackbox/xenofrigate)

/datum/category_item/catalogue/information/blackbox/xenofrigate
	name = "Black Box Data - MBT-540"
	desc = {"
		<BR>
		<B>Begin Log</B>
		<B>@$&@$& Human ##:##:##:</B> Attention unidentified vessel, state your designation and intent.<BR>
		<B>!#@$&&^ Human ##:##:##:</B> Commander I don't think they're going to stop.<BR>
		<B>@$&@$& Human ##:##:##:</B> Unidentified vessel, you have until the count of three before we engage weapon-<BR>
		<B>!#@$&&^ Human ##:##:##:</B> Commander! Think about what you're-<BR>
		<B>A repeating clicking, before silence.</B><BR>
		<B>End of first log.</B><BR>
		**<BR>
		<B>Begin Log</B><BR>
		<B>#!#^@$& Skrell ##:##:##:</B> Director, I think you should see this.<BR>
		<B>^@$& Skrell ##:##:##:</B> Yes? What is it?<BR>
		<B>#!#^@$& Skrell ##:##:##:</B> Another one of those ships has appeared near th-462$^ ---n colonies. I would strongly advise pursuing it.<BR>
		<B>^@$& Skrell ##:##:##:</B> A wise decision. If it is damaged like the last one, we may be able to finally see what is - What?<BR>
		<B>A repeating ping, before silence.</B><BR>
		<B>End of second log.</B>
	"}
