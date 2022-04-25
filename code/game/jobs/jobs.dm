
var/global/const/ENGSEC			=(1<<0)

<<<<<<< HEAD
var/const/CAPTAIN			=(1<<0)
var/const/HOS				=(1<<1)
var/const/WARDEN			=(1<<2)
var/const/DETECTIVE			=(1<<3)
var/const/OFFICER			=(1<<4)
var/const/CHIEF				=(1<<5)
var/const/ENGINEER			=(1<<6)
var/const/ATMOSTECH			=(1<<7)
var/const/AI				=(1<<8)
var/const/CYBORG			=(1<<9)
var/const/CLOWN				=(1<<13) //VOREStation Add
var/const/MIME				=(1<<14) //VOREStation Add
var/const/INTERN			=(1<<15) //VOREStation Add
=======
var/global/const/CAPTAIN			=(1<<0)
var/global/const/HOS				=(1<<1)
var/global/const/WARDEN			=(1<<2)
var/global/const/DETECTIVE			=(1<<3)
var/global/const/OFFICER			=(1<<4)
var/global/const/CHIEF				=(1<<5)
var/global/const/ENGINEER			=(1<<6)
var/global/const/ATMOSTECH			=(1<<7)
var/global/const/AI				=(1<<8)
var/global/const/CYBORG			=(1<<9)

>>>>>>> 21bd8477c7e... Merge pull request #8531 from Spookerton/spkrtn/sys/global-agenda

var/global/const/MEDSCI			=(1<<1)

<<<<<<< HEAD
var/const/RD				=(1<<0)
var/const/SCIENTIST			=(1<<1)
var/const/CHEMIST			=(1<<2)
var/const/CMO				=(1<<3)
var/const/DOCTOR			=(1<<4)
var/const/GENETICIST		=(1<<5)
var/const/VIROLOGIST		=(1<<6)
var/const/PSYCHIATRIST		=(1<<7)
var/const/ROBOTICIST		=(1<<8)
var/const/XENOBIOLOGIST		=(1<<9)
var/const/PARAMEDIC			=(1<<10)
var/const/PATHFINDER 		=(1<<11) //VOREStation Add
var/const/EXPLORER 			=(1<<12) //VOREStation Add
var/const/SAR 				=(1<<13) //VOREStation Add
var/const/XENOBOTANIST		=(1<<14) //VOREStation Add
=======
var/global/const/RD				=(1<<0)
var/global/const/SCIENTIST			=(1<<1)
var/global/const/CHEMIST			=(1<<2)
var/global/const/CMO				=(1<<3)
var/global/const/DOCTOR			=(1<<4)
var/global/const/GENETICIST		=(1<<5)
var/global/const/VIROLOGIST		=(1<<6)
var/global/const/PSYCHIATRIST		=(1<<7)
var/global/const/ROBOTICIST		=(1<<8)
var/global/const/XENOBIOLOGIST		=(1<<9)
var/global/const/PARAMEDIC			=(1<<10)

>>>>>>> 21bd8477c7e... Merge pull request #8531 from Spookerton/spkrtn/sys/global-agenda

var/global/const/CIVILIAN			=(1<<2)

<<<<<<< HEAD
var/const/HOP				=(1<<0)
var/const/BARTENDER			=(1<<1)
var/const/BOTANIST			=(1<<2)
var/const/CHEF				=(1<<3)
var/const/JANITOR			=(1<<4)
var/const/LIBRARIAN			=(1<<5)
var/const/QUARTERMASTER		=(1<<6)
var/const/CARGOTECH			=(1<<7)
var/const/MINER				=(1<<8)
var/const/LAWYER			=(1<<9)
var/const/CHAPLAIN			=(1<<10)
var/const/ASSISTANT			=(1<<11)
var/const/BRIDGE			=(1<<12)
var/const/PILOT 			=(1<<13) //VOREStation Add
var/const/ENTERTAINER		=(1<<14) //VOREStation Add

//VOREStation Add
var/const/TALON				=(1<<3)

var/const/TALCAP			=(1<<0)
var/const/TALPIL			=(1<<1)
var/const/TALDOC			=(1<<2)
var/const/TALSEC			=(1<<3)
var/const/TALENG			=(1<<4)
var/const/TALMIN			=(1<<5)
//VOREStation Add End
=======
var/global/const/HOP				=(1<<0)
var/global/const/BARTENDER			=(1<<1)
var/global/const/BOTANIST			=(1<<2)
var/global/const/CHEF				=(1<<3)
var/global/const/JANITOR			=(1<<4)
var/global/const/LIBRARIAN			=(1<<5)
var/global/const/QUARTERMASTER		=(1<<6)
var/global/const/CARGOTECH			=(1<<7)
var/global/const/MINER				=(1<<8)
var/global/const/LAWYER			=(1<<9)
var/global/const/CHAPLAIN			=(1<<10)
var/global/const/ASSISTANT			=(1<<11)
var/global/const/BRIDGE			=(1<<12)
>>>>>>> 21bd8477c7e... Merge pull request #8531 from Spookerton/spkrtn/sys/global-agenda

/proc/guest_jobbans(var/job)
	return ( (job in SSjob.get_job_titles_in_department(DEPARTMENT_COMMAND)) || (job in SSjob.get_job_titles_in_department(DEPARTMENT_SYNTHETIC)) || (job in SSjob.get_job_titles_in_department(DEPARTMENT_SECURITY)) )

/proc/get_job_datums()
	var/list/occupations = list()
	var/list/all_jobs = typesof(/datum/job)

	for(var/A in all_jobs)
		var/datum/job/job = new A()
		if(!job)	continue
		occupations += job

	return occupations

/proc/get_alternate_titles(var/job)
	var/list/jobs = get_job_datums()
	var/list/titles = list()

	for(var/datum/job/J in jobs)
		if(J.title == job)
			titles = J.alt_titles

	return titles
