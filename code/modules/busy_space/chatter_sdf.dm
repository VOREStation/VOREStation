/datum/atc_chatter/sdfpatrolupdate/squak()
	//SDF event: patrol update
	switch(phase)
		if(1)
			var/statusupdate = pick("nothing unusual so far","nothing of note","everything looks clear so far","ran off some [pick("pirates","scavengers")] near route [pick(1,100)], [pick("no","minor")] damage sustained, continuing patrol","situation normal, no suspicious activity yet","minor incident on route [pick(1,100)]","Code 7-X [pick("on route","in sector")] [pick(1,100)], situation is under control","seeing a lot of traffic on route [pick(1,100)]","caught a couple of smugglers [pick("on route","in sector")] [pick(1,100)]","sustained some damage in a skirmish just now, we're heading back for repairs")
			SSatc.msg("[using_map.starsys_name] Defense Control,  [combined_first_name] reporting in, [statusupdate], over.","[comm_first_name]")
			next()
		else
			SSatc.msg("[using_map.starsys_name] Defense Control copies, [combined_first_name]. Keep us updated, out.","[using_map.starsys_name] Defense Control")
			finish()

/datum/atc_chatter/sdfendingpatrol/squak()
	//SDF event: end patrol
	switch(phase)
		if(1)
			SSatc.msg("[callname], [combined_first_name], returning from our system patrol route, requesting permission to [landing_short].","[comm_first_name]")
			next()
		if(2)
			SSatc.msg("[combined_first_name], [callname]. Permission granted, proceed to [landing_zone]. Follow the green lights on your way in.")
			next()
		else
			var/appreciation = pick("Copy","Understood","Affirmative","10-4","Roger that")
			var/dockingplan = pick("Starting final approach now.","Commencing landing procedures.","Autopilot engaged.","Approach vector locked in.","In the pipe, five by five.")
			SSatc.msg("[appreciation], [callname]. [dockingplan]","[comm_first_name]")
			finish()

/datum/atc_chatter/sdfchatter
	VAR_PRIVATE/chain = null

/datum/atc_chatter/sdfchatter/squak()
	//SDF event: general chatter
	if(!chain)
		chain = pick("codecheck","commscheck")
	switch(chain)
		if("codecheck")
			switch(phase)
				if(1)
					SSatc.msg("Check. Check. |Check|. Uhhh... check? Wait. Wait! Hold on. Yeah, okay, I gotta call this one in.","[comm_first_name]")
					next()
				if(2)
					SSatc.msg("[callname], confirm auth-code... [rand(1,9)][rand(1,9)][rand(1,9)]-[pick("Alpha","Beta","Gamma","Delta","Epsilon","Zeta","Eta","Theta","Iota","Kappa","Lambda","Mu","Nu","Xi","Omicron","Pi","Rho","Sigma","Tau","Upsilon","Phi","Chi","Psi","Omega")]?","[comm_first_name]")
					next()
				if(3)
					SSatc.msg("One moment...")
					next()
				if(4)
					SSatc.msg("Yeah, that code checks out [combined_first_name].")
					next()
				else
					SSatc.msg("|(sigh)| Copy that Control. You! Move along!","[comm_first_name]")
					finish()
		if("commscheck")
			switch(phase)
				if(1)
					SSatc.msg("Control this is [combined_first_name], we're getting some interference in our area. [pick("How's our line?","Do you read?","How copy, over?")]","[comm_first_name]")
					next()
				if(2)
					SSatc.msg("Control reads you loud and clear [combined_first_name].","[using_map.starsys_name] Defense Control")
					next()
				else
					SSatc.msg("[pick("Copy that","Thanks,","Roger that")] Control. [combined_first_name] out.","[comm_first_name]")
					finish()

/datum/atc_chatter/sdfbeginpatrol/squak()
	//SDF event: starting patrol
	switch(phase)
		if(1)
			var/takeoff = pick("depart","launch","take off","dust off")
			SSatc.msg("[callname], [combined_first_name], requesting permission to [takeoff] from [landing_zone] to begin system patrol.","[comm_first_name]")
			next()
		if(2)
			var/safetravels = pick("Fly safe out there","Good luck","Good hunting","Safe travels","Godspeed","Stars guide you")
			SSatc.msg("[combined_first_name], [callname]. Permission granted. Docking clamps released. [safetravels].")
			next()
		else
			var/thanks = pick("Appreciated","Thanks","Don't worry about us","We'll be fine","You too")
			SSatc.msg("[thanks], [callname]. This is [combined_first_name] beginning system patrol, out.","[comm_first_name]")
			finish()
