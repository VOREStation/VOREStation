// Needs to be constant because we need to know how many turfs out to update chunks from our source
#define MAX_CAMERA_RANGE 7

/// We only want chunk sizes that are to the power of 2. E.g: 2, 4, 8, 16, etc..
#define CHUNK_SIZE 8
/// Takes a position, transforms it into a chunk bounded position. Indexes at 1 so it'll land on actual turfs always
#define GET_CHUNK_COORD(v) max((FLOOR((v), CHUNK_SIZE)), 1)

//List of different camera nets, cameras are given this in the map and camera consoles can only view them if
//they share this network with them.
#define NETWORK_CRESCENT "Spaceport"
// #define NETWORK_CAFE_DOCK "Cafe Dock"
#define NETWORK_CARGO "Cargo"
#define NETWORK_SUPPLY "Supply"
#define NETWORK_CIRCUITS "Circuits"
#define NETWORK_CIVILIAN "Civilian"
// #define NETWORK_CIVILIAN_EAST "Civilian East"
// #define NETWORK_CIVILIAN_WEST "Civilian West"
#define NETWORK_COMMAND "Command"
#define NETWORK_ENGINE "Engine"
#define NETWORK_ENGINEERING "Engineering"
#define NETWORK_ENGINEERING_OUTPOST "Engineering Outpost"
#define NETWORK_ERT "ZeEmergencyResponseTeam"
#define NETWORK_DEFAULT "Station"
#define NETWORK_MEDICAL "Medical"
#define NETWORK_MERCENARY "MercurialNet"
#define NETWORK_MINE "Mining Outpost"
#define NETWORK_NORTHERN_STAR "Northern Star"
#define NETWORK_RESEARCH "Research"
#define NETWORK_RESEARCH_OUTPOST "Research Outpost"
#define NETWORK_ROBOTS "Robots"
#define NETWORK_PRISON "Prison"
#define NETWORK_SECURITY "Security"
#define NETWORK_INTERROGATION "Interrogation"
#define NETWORK_TELECOM "Telecomms"
#define NETWORK_EXPLORATION "Exploration"
#define NETWORK_XENOBIO "Xenobiology"
#define NETWORK_THUNDER "Entertainment"		//VOREStation Edit: broader definition
#define NETWORK_COMMUNICATORS "Communicators"
#define NETWORK_ALARM_ATMOS "Atmosphere Alarms"
#define NETWORK_ALARM_POWER "Power Alarms"
#define NETWORK_ALARM_FIRE "Fire Alarms"
#define NETWORK_TALON_HELMETS "TalonHelmets" //VOREStation Add
#define NETWORK_TALON_SHIP "TalonShip" //VOREStation Add

//Camera networks
#define NETWORK_TETHER "Tether"
#define NETWORK_OUTSIDE "Outside"
#define NETWORK_HALLS "Halls"

// SC Networks
#define NETWORK_FIRST_DECK  "First Deck"
#define NETWORK_SECOND_DECK "Second Deck"
#define NETWORK_THIRD_DECK  "Third Deck"
#define NETWORK_MAIN_OUTPOST "Main Outpost"
#define NETWORK_CARRIER "Exploration Carrier"
#define NETWORK_MAINT_DECK "Maintenance Deck"
