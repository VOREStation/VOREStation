// Override/Replace me downstream if you need different chatter, call parent at end if you want this dialog too! Returns a subtype path of /datum/atc_chatter!
/datum/atc_chatter_type/proc/chatter_box(var/org_type,var/org_type2)
	if((org_type == "government" || org_type == "neutral" || org_type == "military" || org_type == "corporate" || org_type == "system defense" || org_type == "spacer") && org_type2 == "pirate") //this is ugly but when I tried to do it with !='s it fired for pirate-v-pirate, still not sure why. might as well stick it up here so it takes priority over other combos.
		return /datum/atc_chatter/distress
	if(org_type == "corporate") //corporate-specific subset for the slogan event. despite the relatively high weight it was still quite rare in tests.
		return pick(5;/datum/atc_chatter/emerg,
					25;/datum/atc_chatter/policescan,
					25;/datum/atc_chatter/traveladvisory,
					30;/datum/atc_chatter/pathwarning,
					180;/datum/atc_chatter/dockingrequestgeneric,
					30;/datum/atc_chatter/undockingrequest,
					/datum/atc_chatter/misc,
					30;/datum/atc_chatter/undockingdenied,
					50;/datum/atc_chatter/slogan,
					25;/datum/atc_chatter/civvieleaks,
					25;/datum/atc_chatter/report_to_dock)
	if((org_type == "government" || org_type == "neutral" || org_type == "military"))
		return pick(5;/datum/atc_chatter/emerg,
					25;/datum/atc_chatter/policescan,
					25;/datum/atc_chatter/traveladvisory,
					30;/datum/atc_chatter/pathwarning,
					180;/datum/atc_chatter/dockingrequestgeneric,
					30;/datum/atc_chatter/undockingrequest,
					/datum/atc_chatter/misc,
					30;/datum/atc_chatter/undockingdenied,
					25;/datum/atc_chatter/civvieleaks,
					25;/datum/atc_chatter/report_to_dock)
	if(org_type == "spacer")
		return pick(5;/datum/atc_chatter/emerg,
					15;/datum/atc_chatter/policescan,
					15;/datum/atc_chatter/traveladvisory,
					5;/datum/atc_chatter/pathwarning,
					150;/datum/atc_chatter/dockingrequestgeneric,
					30;/datum/atc_chatter/undockingrequest,
					/datum/atc_chatter/misc,
					10;/datum/atc_chatter/undockingdenied,
					25;/datum/atc_chatter/civvieleaks,
					25;/datum/atc_chatter/report_to_dock)
	//the following filters *always* fire their 'unique' event when they're tripped, simply because the conditions behind them are quite rare to begin with
	if(org_type == "smuggler" && org_type2 != "system defense") //just straight up funnel smugglers into always being caught, otherwise we get them asking for traffic info and stuff
		return /datum/atc_chatter/policeflee
	if(org_type == "smuggler" && org_type2 == "system defense") //ditto, if an SDF ship catches them
		return /datum/atc_chatter/policeshipflee
	if((org_type == "smuggler" || org_type == "pirate") && (org_type2 == "system defense" || org_type2 == "military")) //if we roll this combo instead, time for the SDF or Mercs to do their fucking jobs
		return /datum/atc_chatter/policeshipcombat
	if((org_type == "smuggler" || org_type == "pirate") && org_type2 != "system defense") //but if we roll THIS combo, time to alert the SDF to get off their asses
		return /datum/atc_chatter/hostiledetected
	//SDF-specific events that need to filter based on the second party (basically just the following SDF-unique list with the soft-result ship scan thrown in)
	if(org_type == "system defense" && (org_type2 == "government" || org_type2 == "neutral" || org_type2 == "military" || org_type2 == "corporate" || org_type2 == "spacer")) //let's see if we can narrow this down, I didn't see many ship-to-ship scans
		return pick(75;/datum/atc_chatter/policeshipscan,
					/datum/atc_chatter/sdfpatrolupdate,
					75;/datum/atc_chatter/sdfendingpatrol,
					180;/datum/atc_chatter/dockingrequestgeneric,
					20;/datum/atc_chatter/undockingrequest,
					75;/datum/atc_chatter/sdfbeginpatrol,
					50;/datum/atc_chatter/misc,
					10;/datum/atc_chatter/civvieleaks,
					70;/datum/atc_chatter/sdfchatter)
	//SDF-specific events that don't require the secondary at all, in the event that we manage to roll SDF + hostile/smuggler or something
	if(org_type == "system defense")
		return pick(/datum/atc_chatter/sdfpatrolupdate,
					60;/datum/atc_chatter/sdfendingpatrol,
					120;/datum/atc_chatter/dockingrequestgeneric,
					20;/datum/atc_chatter/undockingrequest,
					80;/datum/atc_chatter/sdfbeginpatrol,
					/datum/atc_chatter/misc,
					/datum/atc_chatter/sdfchatter)
	//if we somehow don't match any of the other existing filters once we've run through all of them
	return pick(5;/datum/atc_chatter/emerg,
				25;/datum/atc_chatter/policescan,
				25;/datum/atc_chatter/traveladvisory,
				30;/datum/atc_chatter/pathwarning,
				90;/datum/atc_chatter/dockingrequestgeneric,
				30;/datum/atc_chatter/undockingrequest,
				30;/datum/atc_chatter/undockingdenied,
				/datum/atc_chatter/misc,
				25;/datum/atc_chatter/civvieleaks)
