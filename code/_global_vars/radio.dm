GLOBAL_LIST_INIT(radiochannels, list(
	CHANNEL_COMMON			= PUB_FREQ,
	CHANNEL_SCIENCE			= SCI_FREQ,
	CHANNEL_COMMAND			= COMM_FREQ,
	CHANNEL_MEDICAL			= MED_FREQ,
	CHANNEL_ENGINEERING		= ENG_FREQ,
	CHANNEL_SECURITY		= SEC_FREQ,
	CHANNEL_RESPONSE_TEAM	= ERT_FREQ,
	CHANNEL_SPECIAL_OPS		= DTH_FREQ,
	CHANNEL_MERCENARY		= SYND_FREQ,
	CHANNEL_RAIDER			= RAID_FREQ,
	CHANNEL_SUPPLY	 		= SUP_FREQ,
	CHANNEL_SERVICE 		= SRV_FREQ,
	CHANNEL_EXPLORATION		= EXP_FREQ,
	CHANNEL_AI_PRIVATE		= AI_FREQ,
	CHANNEL_ENTERTAINMENT	= ENT_FREQ,
	CHANNEL_MEDICAL_1		= MED_I_FREQ,
	CHANNEL_SECURITY_1		= SEC_I_FREQ,
	CHANNEL_TALON			= TALON_FREQ, //VOREStation Add
	CHANNEL_CASINO			= CSN_FREQ,
))

// Hey, if anyone ever needs to update tgui/packages/tgui/constants.js with new radio channels
// I've kept this around just for you.
/* /client/verb/generate_tgui_radio_constants()
	set name = "Generate TGUI Radio Constants"
	set category = "Generate TGUI Radio Constants"
	var/list/channel_info = list()
	for(var/i in RADIO_LOW_FREQ to RADIO_HIGH_FREQ)
		for(var/key in GLOB.radiochannels)
			if(i == GLOB.radiochannels[key])
				channel_info.Add(list(list("name" = key, "freq" = i, "color" = frequency_span_class(i))))
	for(var/list/channel in channel_info)
		switch(channel["color"])
			if("deadsay") channel["color"] = "#530FAD"
			if("radio") channel["color"] = "#008000"
			if("deptradio") channel["color"] = "#ff00ff"
			if("newscaster") channel["color"] = "#750000"
			if("comradio") channel["color"] = "#193A7A"
			if("syndradio") channel["color"] = "#6D3F40"
			if("centradio") channel["color"] = "#5C5C8A"
			if("airadio") channel["color"] = "#FF00FF"
			if("entradio") channel["color"] = "#339966"
			if("secradio") channel["color"] = "#A30000"
			if("engradio") channel["color"] = "#A66300"
			if("medradio") channel["color"] = "#008160"
			if("sciradio") channel["color"] = "#993399"
			if("supradio") channel["color"] = "#5F4519"
			if("srvradio") channel["color"] = "#6eaa2c"
			if("expradio") channel["color"] = "#555555"
	to_chat(src, json_encode(channel_info)) */


// central command channels, i.e deathsquid & response teams
GLOBAL_LIST_INIT(cent_frequencies, list(ERT_FREQ, DTH_FREQ))

// Antag channels, i.e. Syndicate
GLOBAL_LIST_INIT(antag_frequencies, list(SYND_FREQ, RAID_FREQ))

//Department channels, arranged lexically
GLOBAL_LIST_INIT(department_frequencies, list(AI_FREQ, COMM_FREQ, ENG_FREQ, ENT_FREQ, MED_FREQ, SEC_FREQ, SCI_FREQ, SRV_FREQ, SUP_FREQ))

GLOBAL_LIST_INIT(offmap_frequencies, list(TALON_FREQ, CSN_FREQ))

/proc/frequency_span_class(var/frequency)
	// Antags!
	if (frequency in GLOB.antag_frequencies)
		return "syndradio"
	// CentCom channels (deathsquid and ert)
	if(frequency in GLOB.cent_frequencies)
		return "centradio"
	// command channel
	if(frequency == COMM_FREQ)
		return "comradio"
	// AI private channel
	if(frequency == AI_FREQ)
		return "airadio"
	// department radio formatting (poorly optimized, ugh)
	if(frequency == SEC_FREQ)
		return "secradio"
	if (frequency == ENG_FREQ)
		return "engradio"
	if(frequency == SCI_FREQ)
		return "sciradio"
	if(frequency == MED_FREQ)
		return "medradio"
	if(frequency == SUP_FREQ) // cargo
		return "supradio"
	if(frequency == SRV_FREQ) // service
		return "srvradio"
	if(frequency == EXP_FREQ) // explorer
		return "expradio"
	if(frequency == ENT_FREQ) // entertainment
		return "entradio"
	if(frequency in GLOB.department_frequencies)
		return "deptradio"
	if(frequency in GLOB.offmap_frequencies)
		return "expradio"
	return "radio"
