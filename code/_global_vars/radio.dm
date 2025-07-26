
/*
Frequency range: 1200 to 1600
Radiochat range: 1441 to 1489 (most devices refuse to be tune to other frequency, even during mapmaking)
Radio:
1459 - standard radio chat
1351 - Science
1353 - Command
1355 - Medical
1357 - Engineering
1359 - Security
1341 - deathsquad
1443 - Confession Intercom
1347 - Cargo techs
1349 - Service people
Devices:
1451 - tracking implant
1457 - RSD default
On the map:
1311 for prison shuttle console (in fact, it is not used)
1433 for engine components
1435 for status displays
1437 for atmospherics/fire alerts
1439 for air pumps, air scrubbers, atmo control
1441 for atmospherics - supply tanks
1443 for atmospherics - distribution loop/mixed air tank
1445 for bot nav beacons
1447 for mulebot, secbot and ed209 control
1449 for airlock controls, electropack, magnets
1451 for toxin lab access
1453 for engineering access
1455 for AI access
*/

var/const/RADIO_LOW_FREQ	= 1200
var/const/PUBLIC_LOW_FREQ	= 1441
var/const/PUBLIC_HIGH_FREQ	= 1489
var/const/RADIO_HIGH_FREQ	= 1600

var/const/BOT_FREQ	= 1447
var/const/COMM_FREQ = 1353
var/const/ERT_FREQ	= 1345
var/const/AI_FREQ	= 1343
var/const/DTH_FREQ	= 1341
var/const/SYND_FREQ = 1213
var/const/RAID_FREQ	= 1277
var/const/ENT_FREQ	= 1461 //entertainment frequency. This is not a diona exclusive frequency.

// department channels
var/const/PUB_FREQ = 1459
var/const/SEC_FREQ = 1359
var/const/ENG_FREQ = 1357
var/const/MED_FREQ = 1355
var/const/SCI_FREQ = 1351
var/const/SRV_FREQ = 1349
var/const/SUP_FREQ = 1347
var/const/EXP_FREQ = 1361

// internal department channels
var/const/MED_I_FREQ = 1485
var/const/SEC_I_FREQ = 1475

var/const/TALON_FREQ = 1363 //VOREStation Add
var/const/CSN_FREQ = 1365 //VOREStation Add

var/list/radiochannels = list(
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
)

// Hey, if anyone ever needs to update tgui/packages/tgui/constants.js with new radio channels
// I've kept this around just for you.
/* /client/verb/generate_tgui_radio_constants()
	set name = "Generate TGUI Radio Constants"
	set category = "Generate TGUI Radio Constants"
	var/list/channel_info = list()
	for(var/i in RADIO_LOW_FREQ to RADIO_HIGH_FREQ)
		for(var/key in radiochannels)
			if(i == radiochannels[key])
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
var/list/CENT_FREQS = list(ERT_FREQ, DTH_FREQ)

// Antag channels, i.e. Syndicate
var/list/ANTAG_FREQS = list(SYND_FREQ, RAID_FREQ)

//Department channels, arranged lexically
var/list/DEPT_FREQS = list(AI_FREQ, COMM_FREQ, ENG_FREQ, ENT_FREQ, MED_FREQ, SEC_FREQ, SCI_FREQ, SRV_FREQ, SUP_FREQ)

var/list/OFFMAP_FREQS = list(TALON_FREQ, CSN_FREQ) //VOREStation Add

/proc/frequency_span_class(var/frequency)
	// Antags!
	if (frequency in ANTAG_FREQS)
		return "syndradio"
	// CentCom channels (deathsquid and ert)
	if(frequency in CENT_FREQS)
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
	if(frequency in DEPT_FREQS)
		return "deptradio"
	//VOREStation Add
	if(frequency in OFFMAP_FREQS)
		return "expradio"
	//VOREStation Add End
	return "radio"

/* filters */
//When devices register with the radio controller, they might register under a certain filter.
//Other devices can then choose to send signals to only those devices that belong to a particular filter.
//This is done for performance, so we don't send signals to lots of machines unnecessarily.

//This filter is special because devices belonging to default also recieve signals sent to any other filter.
var/const/RADIO_DEFAULT = "radio_default"

var/const/RADIO_TO_AIRALARM = "radio_airalarm" //air alarms
var/const/RADIO_FROM_AIRALARM = "radio_airalarm_rcvr" //devices interested in recieving signals from air alarms
var/const/RADIO_CHAT = "radio_telecoms"
var/const/RADIO_ATMOSIA = "radio_atmos"
var/const/RADIO_NAVBEACONS = "radio_navbeacon"
var/const/RADIO_AIRLOCK = "radio_airlock"
var/const/RADIO_SECBOT = "radio_secbot"
var/const/RADIO_MULEBOT = "radio_mulebot"
var/const/RADIO_MAGNETS = "radio_magnet"
