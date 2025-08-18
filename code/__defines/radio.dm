// Station Radio Channel
#define CHANNEL_COMMON "Common"
#define CHANNEL_AI_PRIVATE "AI Private"
#define CHANNEL_ENTERTAINMENT "Entertainment"

// Departments
#define CHANNEL_COMMAND "Command"
#define CHANNEL_SECURITY "Security"
#define CHANNEL_SECURITY_1 "Security(I)"
#define CHANNEL_SUPPLY "Supply"
#define CHANNEL_SERVICE "Service"
#define CHANNEL_ENGINEERING "Engineering"
#define CHANNEL_SCIENCE "Science"
#define CHANNEL_MEDICAL "Medical"
#define CHANNEL_MEDICAL_1 "Medical(I)"
#define CHANNEL_EXPLORATION "Away Team" // was Explorer

// Special Channels
#define CHANNEL_RESPONSE_TEAM "Response Team"
#define CHANNEL_SPECIAL_OPS "Special Ops"

// Antag Channels
#define CHANNEL_RAIDER "Raider"
#define CHANNEL_MERCENARY "Mercenary"

// Other Channels
#define CHANNEL_TALON "Talon"
#define CHANNEL_CASINO "Casino"


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

#define RADIO_LOW_FREQ 1200
#define PUBLIC_LOW_FREQ 1441
#define PUBLIC_HIGH_FREQ 1489
#define RADIO_HIGH_FREQ 1600

#define BOT_FREQ 1447
#define COMM_FREQ 1353
#define ERT_FREQ 1345
#define AI_FREQ 1343
#define DTH_FREQ 1341
#define SYND_FREQ 1213
#define RAID_FREQ 1277
#define ENT_FREQ 1461 //entertainment frequency. This is not a diona exclusive frequency.

// department channels
#define PUB_FREQ 1459
#define SEC_FREQ 1359
#define ENG_FREQ 1357
#define MED_FREQ 1355
#define SCI_FREQ 1351
#define SRV_FREQ 1349
#define SUP_FREQ 1347
#define EXP_FREQ 1361

// internal department channels
#define MED_I_FREQ 1485
#define SEC_I_FREQ 1475

#define TALON_FREQ 1363
#define CSN_FREQ 1365

/* filters */
//When devices register with the radio controller, they might register under a certain filter.
//Other devices can then choose to send signals to only those devices that belong to a particular filter.
//This is done for performance, so we don't send signals to lots of machines unnecessarily.

//This filter is special because devices belonging to default also recieve signals sent to any other filter.
#define RADIO_DEFAULT "radio_default"

#define RADIO_TO_AIRALARM "radio_airalarm" //air alarms
#define RADIO_FROM_AIRALARM "radio_airalarm_rcvr" //devices interested in recieving signals from air alarms
#define RADIO_CHAT "radio_telecoms"
#define RADIO_ATMOSIA "radio_atmos"
#define RADIO_NAVBEACONS "radio_navbeacon"
#define RADIO_AIRLOCK "radio_airlock"
#define RADIO_SECBOT "radio_secbot"
#define RADIO_MULEBOT "radio_mulebot"
#define RADIO_MAGNETS "radio_magnet"
