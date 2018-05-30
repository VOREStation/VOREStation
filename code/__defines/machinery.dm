var/global/defer_powernet_rebuild = 0      // True if net rebuild will be called manually after an event.

#define CELLRATE 0.002 // Multiplier for watts per tick <> cell storage (e.g., 0.02 means if there is a load of 1000 watts, 20 units will be taken from a cell per second)
                       // It's a conversion constant. power_used*CELLRATE = charge_provided, or charge_used/CELLRATE = power_provided

#define KILOWATTS *1000
#define MEGAWATTS *1000000
#define GIGAWATTS *1000000000

// Doors!
#define DOOR_CRUSH_DAMAGE 20
#define ALIEN_SELECT_AFK_BUFFER  1    // How many minutes that a person can be AFK before not being allowed to be an alien.

// Channel numbers for power.
#define EQUIP   1
#define LIGHT   2
#define ENVIRON 3
#define TOTAL   4 // For total power used only.

// Bitflags for machine stat variable.
#define BROKEN   0x1
#define NOPOWER  0x2
#define POWEROFF 0x4  // TBD.
#define MAINT    0x8  // Under maintenance.
#define EMPED    0x10 // Temporary broken by EMP pulse.

// Used by firelocks
#define FIREDOOR_OPEN 1
#define FIREDOOR_CLOSED 2

#define AI_CAMERA_LUMINOSITY 6

// Camera networks
#define NETWORK_CRESCENT "Spaceport"
// #define NETWORK_CAFE_DOCK "Cafe Dock"
#define NETWORK_CARGO "Cargo"
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
#define NETWORK_TELECOM "Tcomms"
#define NETWORK_THUNDER "Thunderdome"
#define NETWORK_COMMUNICATORS "Communicators"

// Those networks can only be accessed by pre-existing terminals. AIs and new terminals can't use them.
var/list/restricted_camera_networks = list(NETWORK_ERT,NETWORK_MERCENARY,"Secret", NETWORK_COMMUNICATORS)


//singularity defines
#define STAGE_ONE 	1
#define STAGE_TWO 	3
#define STAGE_THREE	5
#define STAGE_FOUR	7
#define STAGE_FIVE	9
#define STAGE_SUPER	11

// computer3 error codes, move lower in the file when it passes dev -Sayu
#define PROG_CRASH          0x1  // Generic crash.
#define MISSING_PERIPHERAL  0x2  // Missing hardware.
#define BUSTED_ASS_COMPUTER 0x4  // Self-perpetuating error.  BAC will continue to crash forever.
#define MISSING_PROGRAM     0x8  // Some files try to automatically launch a program. This is that failing.
#define FILE_DRM            0x10 // Some files want to not be copied/moved. This is them complaining that you tried.
#define NETWORK_FAILURE     0x20

// NanoUI flags
#define STATUS_INTERACTIVE 2 // GREEN Visability
#define STATUS_UPDATE 1 // ORANGE Visability
#define STATUS_DISABLED 0 // RED Visability
#define STATUS_CLOSE -1 // Close the interface

/*
 *	Atmospherics Machinery.
*/
#define MAX_SIPHON_FLOWRATE   2500 // L/s. This can be used to balance how fast a room is siphoned. Anything higher than CELL_VOLUME has no effect.
#define MAX_SCRUBBER_FLOWRATE 200  // L/s. Max flow rate when scrubbing from a turf.

// These balance how easy or hard it is to create huge pressure gradients with pumps and filters.
// Lower values means it takes longer to create large pressures differences.
// Has no effect on pumping gasses from high pressure to low, only from low to high.
#define ATMOS_PUMP_EFFICIENCY   2.5
#define ATMOS_FILTER_EFFICIENCY 2.5

// Will not bother pumping or filtering if the gas source as fewer than this amount of moles, to help with performance.
#define MINIMUM_MOLES_TO_PUMP   0.01
#define MINIMUM_MOLES_TO_FILTER 0.04

// The flow rate/effectiveness of various atmos devices is limited by their internal volume,
// so for many atmos devices these will control maximum flow rates in L/s.
#define ATMOS_DEFAULT_VOLUME_PUMP   200 // Liters.
#define ATMOS_DEFAULT_VOLUME_FILTER 200 // L.
#define ATMOS_DEFAULT_VOLUME_MIXER  200 // L.
#define ATMOS_DEFAULT_VOLUME_PIPE   70  // L.

// Fancy-pants START/STOP_PROCESSING() macros that lets us custom define what the list is.
#define START_PROCESSING_IN_LIST(DATUM, LIST) \
if (DATUM.is_processing) {\
	if(DATUM.is_processing != #LIST)\
	{\
		crash_with("Failed to start processing. [log_info_line(DATUM)] is already being processed by [DATUM.is_processing] but queue attempt occured on [#LIST]."); \
	}\
} else {\
	DATUM.is_processing = #LIST;\
	LIST += DATUM;\
}

#define STOP_PROCESSING_IN_LIST(DATUM, LIST) \
if(DATUM.is_processing) {\
	if(LIST.Remove(DATUM)) {\
		DATUM.is_processing = null;\
	} else {\
		crash_with("Failed to stop processing. [log_info_line(DATUM)] is being processed by [is_processing] and not found in SSmachines.[#LIST]"); \
	}\
}

// Note - I would prefer these be defined machines.dm, but some are used prior in file order. ~Leshana
#define START_MACHINE_PROCESSING(Datum) START_PROCESSING_IN_LIST(Datum, global.processing_machines)
#define STOP_MACHINE_PROCESSING(Datum) STOP_PROCESSING_IN_LIST(Datum, global.processing_machines)

#define START_PROCESSING_PIPENET(Datum) START_PROCESSING_IN_LIST(Datum, global.pipe_networks)
#define STOP_PROCESSING_PIPENET(Datum) STOP_PROCESSING_IN_LIST(Datum, global.pipe_networks)

#define START_PROCESSING_POWERNET(Datum) START_PROCESSING_IN_LIST(Datum, global.powernets)
#define STOP_PROCESSING_POWERNET(Datum) STOP_PROCESSING_IN_LIST(Datum, global.powernets)

#define START_PROCESSING_POWER_OBJECT(Datum) START_PROCESSING_IN_LIST(Datum, global.processing_power_items)
#define STOP_PROCESSING_POWER_OBJECT(Datum) STOP_PROCESSING_IN_LIST(Datum, global.processing_power_items)
