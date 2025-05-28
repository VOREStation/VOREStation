// Station ranks
#define RANK_HEADS "Heads"
#define RANK_SECURITY "Security"
#define RANK_ENGINEERING "Engineering"
#define RANK_RESEARCH "Research"
#define RANK_MEDICAL "Medical"
#define RANK_CE_STATION_ENGINEER "CE_Station_Engineer"
#define RANK_CE_ATMOSPHERIC_TECH "CE_Atmospheric_Tech"
#define RANK_CE_SHAFT_MINER "CE_Shaft_Miner"
#define RANK_CHEMIST_RD_CMO "Chemist_RD_CMO"
#define RANK_GENETIST_RD_CMO "Geneticist_RD_CMO"
#define RANK_MD_CMO "MD_CMO"
#define RANK_SCIENTIST_RD "Scientist_RD"
#define RANK_AI_CYBORG "AI_Cyborg"
#define RANK_DETECTIVE_HOS "Detective_HoS"
#define RANK_VIROLOGIST_RD_CMO "Virologist_RD_CMO"

var/savefile/Banlistjob


/proc/_jobban_isbanned(var/client/clientvar, var/rank)
	if(!clientvar) return 1
	ClearTempbansjob()
	var/id = clientvar.computer_id
	var/key = clientvar.ckey
	if (guest_jobbans(rank))
		if(config.guest_jobban && IsGuestKey(key))
			return 1
	Banlistjob.cd = "/base"
	if (Banlistjob.dir.Find("[key][id][rank]"))
		return 1

	Banlistjob.cd = "/base"
	for (var/A in Banlistjob.dir)
		Banlistjob.cd = "/base/[A]"
		if ((id == Banlistjob["id"] || key == Banlistjob["key"]) && rank == Banlistjob["rank"])
			return 1
	return 0

/proc/LoadBansjob()

	Banlistjob = new("data/job_fullnew.bdb")
	log_admin("Loading Banlistjob")

	if (!length(Banlistjob.dir)) log_admin("Banlistjob is empty.")

	if (!Banlistjob.dir.Find("base"))
		log_admin("Banlistjob missing base dir.")
		Banlistjob.dir.Add("base")
		Banlistjob.cd = "/base"
	else if (Banlistjob.dir.Find("base"))
		Banlistjob.cd = "/base"

	ClearTempbansjob()
	return 1

/proc/ClearTempbansjob()
	UpdateTime()

	Banlistjob.cd = "/base"
	for (var/A in Banlistjob.dir)
		Banlistjob.cd = "/base/[A]"
		//if (!Banlistjob["key"] || !Banlistjob["id"])
		//	RemoveBanjob(A, "full")
		//	log_admin("Invalid Ban.")
		//	message_admins("Invalid Ban.")
		//	continue

		if (!Banlistjob["temp"]) continue
		if (CMinutes >= Banlistjob["minutes"]) RemoveBanjob(A)

	return 1


/proc/AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, rank)
	UpdateTime()
	var/bantimestamp
	if (temp)
		UpdateTime()
		bantimestamp = CMinutes + minutes
	if(rank == RANK_HEADS)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_HEAD_OF_PERSONNEL)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_SITE_MANAGER)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_HEAD_OF_SECURITY)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_CHIEF_ENGINEER)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_RESEARCH_DIRECTOR)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_CHIEF_MEDICAL_OFFICER)
		return 1
	if(rank == RANK_SECURITY)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_HEAD_OF_SECURITY)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_WARDEN)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_DETECTIVE)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_SECURITY_OFFICER)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_CYBORG)
		return 1
	if(rank == RANK_ENGINEERING)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_ENGINEER)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_ATMOSPHERIC_TECHNICIAN)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_CHIEF_ENGINEER)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_CYBORG)
		return 1
	if(rank == RANK_RESEARCH)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_SCIENTIST)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_GENETICIST)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_CHIEF_MEDICAL_OFFICER)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_RESEARCH_DIRECTOR)
		return 1
	if(rank == RANK_MEDICAL)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_GENETICIST)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_MEDICAL_DOCTOR)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_CHIEF_MEDICAL_OFFICER)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_CHEMIST)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_CYBORG)
		return 1
	if(rank == RANK_CE_STATION_ENGINEER)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_ENGINEER)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_CHIEF_ENGINEER)
		return 1
	if(rank == RANK_CE_ATMOSPHERIC_TECH)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_ATMOSPHERIC_TECHNICIAN)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_CHIEF_ENGINEER)
		return 1
	if(rank == RANK_CE_SHAFT_MINER)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_SHAFT_MINER)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_CHIEF_ENGINEER)
		return 1
	if(rank == RANK_CHEMIST_RD_CMO)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_CHIEF_MEDICAL_OFFICER)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_RESEARCH_DIRECTOR)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_CHEMIST)
		return 1
	if(rank == RANK_GENETIST_RD_CMO)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_CHIEF_MEDICAL_OFFICER)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_RESEARCH_DIRECTOR)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_GENETICIST)
		return 1
	if(rank == RANK_MD_CMO)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_CHIEF_MEDICAL_OFFICER)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_MEDICAL_DOCTOR)
		return 1
	if(rank == RANK_SCIENTIST_RD)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_RESEARCH_DIRECTOR)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_SCIENTIST)
		return 1
	if(rank == RANK_AI_CYBORG)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_CYBORG)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_AI)
		return 1
	if(rank == RANK_DETECTIVE_HOS)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_DETECTIVE)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_HEAD_OF_SECURITY)
		return 1
	if(rank == RANK_VIROLOGIST_RD_CMO)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_CHIEF_MEDICAL_OFFICER)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_RESEARCH_DIRECTOR)
		AddBanjob(ckey, computerid, reason, bannedby, temp, minutes, JOB_ALT_VIROLOGIST)
		return 1

	Banlistjob.cd = "/base"
	if ( Banlistjob.dir.Find("[ckey][computerid][rank]") )
		to_chat(usr, span_red("Banjob already exists."))
		return 0
	else
		Banlistjob.dir.Add("[ckey][computerid][rank]")
		Banlistjob.cd = "/base/[ckey][computerid][rank]"
		Banlistjob["key"] << ckey
		Banlistjob["id"] << computerid
		Banlistjob["rank"] << rank
		Banlistjob["reason"] << reason
		Banlistjob["bannedby"] << bannedby
		Banlistjob["temp"] << temp
		if (temp)
			Banlistjob["minutes"] << bantimestamp
	admin_action_message(bannedby, ckey, "jobbanned-"+rank, reason, temp ? minutes : -1) //VOREStation Add
	return 1

/proc/RemoveBanjob(foldername)
	var/key
	var/id
	var/rank
	Banlistjob.cd = "/base/[foldername]"
	Banlistjob["key"] >> key
	Banlistjob["id"] >> id
	Banlistjob["rank"] >> rank
	Banlistjob.cd = "/base"

	if (!Banlistjob.dir.Remove(foldername)) return 0

	if(!usr)
		log_admin("Banjob Expired: [key]")
		message_admins("Banjob Expired: [key]")
	else
		log_admin("[key_name_admin(usr)] unjobbanned [key] from [rank]")
		message_admins("[key_name_admin(usr)] unjobbanned:[key] from [rank]")
		ban_unban_log_save("[key_name_admin(usr)] unjobbanned [key] from [rank]")
		feedback_inc("ban_job_unban",1)
		feedback_add_details("ban_job_unban","- [rank]")

	for (var/A in Banlistjob.dir)
		Banlistjob.cd = "/base/[A]"
		if ((key == Banlistjob["key"] || id == Banlistjob["id"]) && (rank == Banlistjob["rank"]))
			Banlistjob.cd = "/base"
			Banlistjob.dir.Remove(A)
			continue
	admin_action_message(usr.key, key, "unjobbanned-"+rank, "\[Unban\]", 0) //VOREStation Add
	return 1

/proc/GetBanExpjob(minutes as num)
	UpdateTime()
	var/exp = minutes - CMinutes
	if (exp <= 0)
		return 0
	else
		var/timeleftstring
		if (exp >= 1440) //1440 = 1 day in minutes
			timeleftstring = "[round(exp / 1440, 0.1)] Days"
		else if (exp >= 60) //60 = 1 hour in minutes
			timeleftstring = "[round(exp / 60, 0.1)] Hours"
		else
			timeleftstring = "[exp] Minutes"
		return timeleftstring

/datum/admins/proc/unjobbanpanel()
	var/count = 0
	var/dat
	//var/dat = "<HR>" + span_bold("Unban Player: ") + span_blue("(U) = Unban , (E) = Edit Ban") + span_green("(Total<HR><table border=1 rules=all frame=void cellspacing=0 cellpadding=3 >")
	Banlistjob.cd = "/base"
	for (var/A in Banlistjob.dir)
		count++
		Banlistjob.cd = "/base/[A]"
		dat += text("<tr><td><A href='byond://?src=\ref[src];[HrefToken()];unjobbanf=[Banlistjob["key"]][Banlistjob["id"]][Banlistjob["rank"]]'>(U)</A> Key: <B>[Banlistjob["key"]] </B>Rank: <B>[Banlistjob["rank"]]</B></td><td> ([Banlistjob["temp"] ? "[GetBanExpjob(Banlistjob["minutes"]) ? GetBanExpjob(Banlistjob["minutes"]) : "Removal pending" ]" : "Permaban"])</td><td>(By: [Banlistjob["bannedby"]])</td><td>(Reason: [Banlistjob["reason"]])</td></tr>")

	dat += "</table>"
	dat = "<HR>" + span_bold("Bans:") + " " span_blue("(U) = Unban , ") + " - " + span_green("([count] Bans)") + "<HR><table border=1 rules=all frame=void cellspacing=0 cellpadding=3 >[dat]"
	usr << browse("<html>[dat]</html>", "window=unbanp;size=875x400")

/*/datum/admins/proc/permjobban(ckey, computerid, reason, bannedby, temp, minutes, rank)
	if(AddBanjob(ckey, computerid, reason, usr.ckey, 0, 0, job))
		to_chat(M, span_large(span_red(span_bold("You have been banned from [job] by [usr.client.ckey].\nReason: [reason]."))))
		to_chat(M, span_red("This is a permanent ban."))
		if(config.banappeals)
			to_chat(M, span_red("To try to resolve this matter head to [config.banappeals]"))
		else
			to_chat(M, span_red("No ban appeals URL has been set."))
		log_admin("[usr.client.ckey] has banned from [job] [ckey].\nReason: [reason]\nThis is a permanent ban.")
		message_admins(span_blue("[usr.client.ckey] has banned from [job] [ckey].\nReason: [reason]\nThis is a permanent ban."))
/datum/admins/proc/timejobban(ckey, computerid, reason, bannedby, temp, minutes, rank)
	if(AddBanjob(ckey, computerid, reason, usr.ckey, 1, mins, job))
		to_chat(M, span_large(span_red(span_bold("You have been jobbanned from [job] by [usr.client.ckey].\nReason: [reason]."))))
		to_chat(M, span_red("This is a temporary ban, it will be removed in [mins] minutes."))
		if(config.banappeals)
			to_chat(M, span_red("To try to resolve this matter head to [config.banappeals]"))
		else
			to_chat(M, span_red("No ban appeals URL has been set."))
		log_admin("[usr.client.ckey] has jobbanned from [job] [ckey].\nReason: [reason]\nThis will be removed in [mins] minutes.")
		message_admins(span_blue("[usr.client.ckey] has banned from [job] [ckey].\nReason: [reason]\nThis will be removed in [mins] minutes."))*/
//////////////////////////////////// DEBUG ////////////////////////////////////

/proc/CreateBansjob()

	UpdateTime()

	var/i
	var/last

	for(i=0, i<1001, i++)
		var/a = pick(1,0)
		var/b = pick(1,0)
		if(b)
			Banlistjob.cd = "/base"
			Banlistjob.dir.Add("trash[i]trashid[i]")
			Banlistjob.cd = "/base/trash[i]trashid[i]"
			to_chat(Banlistjob["key"], "trash[i]")
		else
			Banlistjob.cd = "/base"
			Banlistjob.dir.Add("[last]trashid[i]")
			Banlistjob.cd = "/base/[last]trashid[i]"
			Banlistjob["key"] << last
		to_chat(Banlistjob["id"], "trashid[i]")
		to_chat(Banlistjob["reason"], "Trashban[i].")
		Banlistjob["temp"] << a
		Banlistjob["minutes"] << CMinutes + rand(1,2000)
		to_chat(Banlistjob["bannedby"], "trashmin")
		last = "trash[i]"

	Banlistjob.cd = "/base"

/proc/ClearAllBansjob()
	Banlistjob.cd = "/base"
	for (var/A in Banlistjob.dir)
		RemoveBanjob(A, "full")

#undef RANK_HEADS
#undef RANK_SECURITY
#undef RANK_ENGINEERING
#undef RANK_RESEARCH
#undef RANK_MEDICAL
#undef RANK_CE_STATION_ENGINEER
#undef RANK_CE_ATMOSPHERIC_TECH
#undef RANK_CE_SHAFT_MINER
#undef RANK_CHEMIST_RD_CMO
#undef RANK_GENETIST_RD_CMO
#undef RANK_MD_CMO
#undef RANK_SCIENTIST_RD
#undef RANK_AI_CYBORG
#undef RANK_DETECTIVE_HOS
#undef RANK_VIROLOGIST_RD_CMO
