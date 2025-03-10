var/global/defer_powernet_rebuild = 0      // True if net rebuild will be called manually after an event.

#define CELLRATE 0.002 // Multiplier for watts per tick <> cell storage (e.g., 0.02 means if there is a load of 1000 watts, 20 units will be taken from a cell per second)
   					// It's a conversion constant. power_used*CELLRATE = charge_provided, or charge_used/CELLRATE = power_provided
#define SMESRATE 0.03333 // Same for SMESes. A different number for some reason.

#define KILOWATTS *1000
#define MEGAWATTS *1000000
#define GIGAWATTS *1000000000

// Doors!
#define DOOR_CRUSH_DAMAGE 20
#define ALIEN_SELECT_AFK_BUFFER  1    // How many minutes that a person can be AFK before not being allowed to be an alien.

// Constants for machine's use_power
#define USE_POWER_OFF    0	// No continuous power use
#define USE_POWER_IDLE   1	// Machine is using power at its idle power level
#define USE_POWER_ACTIVE 2	// Machine is using power at its active power level

// Channel numbers for power.
#define CURRENT_CHANNEL -1 // Passed as an argument this means "use whatever current channel is"
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

// Remote control states
#define RCON_NO		1
#define RCON_AUTO	2
#define RCON_YES	3

// Used by firelocks
#define FIREDOOR_OPEN 1
#define FIREDOOR_CLOSED 2

#define AI_CAMERA_LUMINOSITY 6

// Camera networks
#define NETWORK_CRESCENT "Spaceport"
// #define NETWORK_CAFE_DOCK "Cafe Dock"
#define NETWORK_CARGO "Cargo"
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

// Those networks can only be accessed by pre-existing terminals. AIs and new terminals can't use them.
var/list/restricted_camera_networks = list(NETWORK_ERT,NETWORK_MERCENARY,"Secret", NETWORK_COMMUNICATORS)

#define TRANSMISSION_WIRE		0 //Is this ever used? I don't think it is.
#define TRANSMISSION_RADIO		1 //Radio transmissions (like airlock controller to pump)
#define TRANSMISSION_SUBSPACE	2 //Like headsets
#define TRANSMISSION_BLUESPACE	3 //Point-to-point links

#define SIGNAL_NORMAL	0 //Normal subspace signals
#define SIGNAL_SIMPLE	1 //Normal inter-machinery(?) signals
#define SIGNAL_FAKE		2 //Untrackable signals
#define SIGNAL_TEST		4 //Unlogged signals

#define DATA_NORMAL		0 //Normal data
#define DATA_INTERCOM	1 //Intercoms only
#define DATA_LOCAL		2 //Intercoms and SBRs
#define DATA_ANTAG		3 //Antag interception
#define DATA_FAKE		4 //Not from a real mob

//singularity defines
#define STAGE_ONE 	1
#define STAGE_TWO 	3
#define STAGE_THREE	5
#define STAGE_FOUR	7
#define STAGE_FIVE	9
#define STAGE_SUPER	11

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

// These are used by supermatter and supermatter monitor program, mostly for UI updating purposes. Higher should always be worse!
#define SUPERMATTER_ERROR -1		// Unknown status, shouldn't happen but just in case.
#define SUPERMATTER_INACTIVE 0		// No or minimal energy
#define SUPERMATTER_NORMAL 1		// Normal operation
#define SUPERMATTER_NOTIFY 2		// Ambient temp > 80% of CRITICAL_TEMPERATURE
#define SUPERMATTER_WARNING 3		// Ambient temp > CRITICAL_TEMPERATURE OR integrity damaged
#define SUPERMATTER_DANGER 4		// Integrity < 50%
#define SUPERMATTER_EMERGENCY 5		// Integrity < 25%
#define SUPERMATTER_DELAMINATING 6	// Pretty obvious.

//wIP - PORT ALL OF THESE TO SUBSYSTEMS AND GET RID OF THE WHOLE LIST PROCESS THING
// Fancy-pants START/STOP_PROCESSING() macros that lets us custom define what the list is.
#define START_PROCESSING_IN_LIST(DATUM, LIST) \
if (!(DATUM.datum_flags & DF_ISPROCESSING)) {\
	LIST += DATUM;\
	DATUM.datum_flags |= DF_ISPROCESSING\
}

#define STOP_PROCESSING_IN_LIST(DATUM, LIST) LIST.Remove(DATUM);DATUM.datum_flags &= ~DF_ISPROCESSING

// Note - I would prefer these be defined machines.dm, but some are used prior in file order. ~Leshana
#define START_MACHINE_PROCESSING(Datum) START_PROCESSING_IN_LIST(Datum, SSmachines.processing_machines)
#define STOP_MACHINE_PROCESSING(Datum) STOP_PROCESSING_IN_LIST(Datum, SSmachines.processing_machines)

#define START_PROCESSING_PIPENET(Datum) START_PROCESSING_IN_LIST(Datum, SSmachines.networks)
#define STOP_PROCESSING_PIPENET(Datum) STOP_PROCESSING_IN_LIST(Datum, SSmachines.networks)

#define START_PROCESSING_POWERNET(Datum) START_PROCESSING_IN_LIST(Datum, SSmachines.powernets)
#define STOP_PROCESSING_POWERNET(Datum) STOP_PROCESSING_IN_LIST(Datum, SSmachines.powernets)

#define START_PROCESSING_POWER_OBJECT(Datum) START_PROCESSING_IN_LIST(Datum, SSmachines.powerobjs)
#define STOP_PROCESSING_POWER_OBJECT(Datum) STOP_PROCESSING_IN_LIST(Datum, SSmachines.powerobjs)

// Computer login types
#define LOGIN_TYPE_NORMAL 1
#define LOGIN_TYPE_AI 2
#define LOGIN_TYPE_ROBOT 3

// Computer Hardware
#define  PART_CPU  		/obj/item/computer_hardware/processor_unit				// CPU. Without it the computer won't run. Better CPUs can run more programs at once.
#define  PART_NETWORK  	/obj/item/computer_hardware/network_card					// Network Card component of this computer. Allows connection to NTNet
#define  PART_HDD 		/obj/item/computer_hardware/hard_drive					// Hard Drive component of this computer. Stores programs and files.

// Optional hardware (improves functionality, but is not critical for computer to work in most cases)
#define  PART_BATTERY  	/obj/item/computer_hardware/battery_module				// An internal power source for this computer. Can be recharged.
#define  PART_CARD  	/obj/item/computer_hardware/card_slot				// ID Card slot component of this computer. Mostly for HoP modification console that needs ID slot for modification.
#define  PART_PRINTER  	/obj/item/computer_hardware/nano_printer					// Nano Printer component of this computer, for your everyday paperwork needs.
//#define  PART_DRIVE  	/obj/item/computer_hardware/hard_drive/portable			// Portable data storage
//#define  PART_AI  		/obj/item/computer_hardware/ai_slot						// AI slot, an intellicard housing that allows modifications of AIs.
#define  PART_TESLA  	/obj/item/computer_hardware/tesla_link					// Tesla Link, Allows remote charging from nearest APC.
//#define  PART_SCANNER  	/obj/item/computer_hardware/scanner						// One of several optional scanner attachments.
