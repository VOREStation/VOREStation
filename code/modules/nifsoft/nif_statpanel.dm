/mob/living/carbon/human/Stat()
	. = ..()
	if(nif && statpanel("NIF"))
		SetupNifStat()

/mob/living/carbon/human/proc/SetupNifStat()
	var/nif_status = ""
	var/nif_percent = round((nif.durability/initial(nif.durability))*100)
	switch(nif.stat)
		if(NIF_WORKING)
			if(nif_percent < 20)
				nif_status = "Service Needed Soon"
			else
				nif_status = "Operating Normally"
		if(NIF_POWFAIL)
			nif_status = "Insufficient Energy!"
		if(NIF_TEMPFAIL)
			nif_status = "System Failure!"
		if(NIF_INSTALLING)
			nif_status = "Adapting To User"
		else
			nif_status = "Unknown - Error"
	nif_status += " (Condition: [nif_percent]%)"
	stat("NIF Status", nif_status)

	if(nif.stat == NIF_WORKING)
		stat("- Modules -", "LMB: Toggle, Shift+LMB: Info/Uninstall")
		for(var/nifsoft in nif.nifsofts)
			if(!nifsoft) continue
			var/datum/nifsoft/NS = nifsoft
			var/obj/effect/nif_stat/stat_line = NS.stat_line
			stat("[stat_line.nifsoft_name]",stat_line.atom_button_text())

///////////////////
// Stat Line Object
/obj/effect/nif_stat
	name = ""
	var/nifsoft_name			//Prevents deeper lookups, and the name won't change
	var/datum/nifsoft/nifsoft	//Reference to our nifsoft
	var/toggleable = FALSE		//Won't change, prevents looking it up deeper

/obj/effect/nif_stat/New(var/datum/nifsoft/new_soft)
	..()
	nifsoft = new_soft
	nifsoft_name = new_soft.name
	name = new_soft.name

/obj/effect/nif_stat/Destroy()
	nifsoft = null
	return ..()

/obj/effect/nif_stat/proc/atom_button_text()
	name = nifsoft.stat_text()
	return src

/obj/effect/nif_stat/Click(var/location, var/control, var/params)
	if(usr != nifsoft.nif.human) return

	var/list/clickprops = params2list(params)
	var/opts = clickprops["shift"]

	if(opts)
		var/choice = alert("Select an option","[nifsoft_name]","Display Info","Cancel","Uninstall")
		switch(choice)
			if("Display Info")
				nifsoft.nif.notify("[nifsoft_name]: [nifsoft.desc] - It consumes [nifsoft.p_drain] energy units \
				while installed, and [nifsoft.a_drain] additionally while active. It is [nifsoft.illegal ? "NOT " : ""]\
				a legal software package. The MSRP of the package is [nifsoft.cost] Thalers. The difficulty to construct \
				the associated implant is Rating [nifsoft.wear].")
			if("Uninstall")
				var/confirm = alert("Really uninstall [nifsoft_name]?","Are you sure?","Cancel","Uninstall","Cancel")
				if(confirm == "Uninstall")
					nifsoft.uninstall()
	else if(nifsoft.activates)
		if(nifsoft.active)
			nifsoft.deactivate()
		else
			nifsoft.activate()
