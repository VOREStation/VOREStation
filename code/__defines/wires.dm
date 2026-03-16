// Wire defines for all machines/items.

// Miscellaneous
#define WIRE_DUD_PREFIX "__dud"

// General
#define WIRE_IDSCAN "ID Scan"
#define WIRE_MAIN_POWER1 "Primary Power"
#define WIRE_MAIN_POWER2 "Secondary Power"
#define WIRE_AI_CONTROL "AI Control"
#define WIRE_ELECTRIFY "Electrification"
#define WIRE_SAFETY "Safety"

// Vendors and smartfridges
#define WIRE_THROW_ITEM "Item Throw"
#define WIRE_CONTRABAND "Contraband"

// Airlock
#define WIRE_DOOR_BOLTS "Door Bolts"
#define WIRE_BACKUP_POWER1 "Primary Backup Power"
#define WIRE_BACKUP_POWER2 "Secondary Backup Power"
#define WIRE_OPEN_DOOR "Door State"
#define WIRE_SPEED "Door Timing"
#define WIRE_BOLT_LIGHT "Bolt Lights"

// Air alarm
#define WIRE_SYPHON "Siphon"
#define WIRE_AALARM "Atmospherics Alarm"

// Camera
#define WIRE_FOCUS "Focus"
#define WIRE_CAM_LIGHT "Camera Light"
#define WIRE_CAM_ALARM "Camera Alarm"

// Grid Check
#define WIRE_REBOOT "Reboot"
#define WIRE_LOCKOUT "Lockout"
#define WIRE_ALLOW_MANUAL1 "Manual Override 1"
#define WIRE_ALLOW_MANUAL2 "Manual Override 2"
#define WIRE_ALLOW_MANUAL3 "Manual Override 3"

// Jukebox
#define WIRE_POWER "Power"
#define WIRE_JUKEBOX_HACK "Hack"
#define WIRE_SPEEDUP "Speedup"
#define WIRE_SPEEDDOWN "Speeddown"
#define WIRE_REVERSE "Reverse"
#define WIRE_START "Start"
#define WIRE_STOP "Stop"
#define WIRE_PREV "Prev"
#define WIRE_NEXT "Next"

// Mulebot
#define WIRE_MOB_AVOIDANCE "Mob Avoidance"
#define WIRE_LOADCHECK "Load Checking"
#define WIRE_MOTOR1 "Primary Motor"
#define WIRE_MOTOR2 "Secondary Motor"
#define WIRE_REMOTE_RX "Signal Receiver"
#define WIRE_REMOTE_TX "Signal Sender"
#define WIRE_BEACON_RX "Beacon Receiver"

// Explosives, bombs
#define WIRE_EXPLODE "Explode" // Explodes if pulsed or cut while active, defuses a bomb that isn't active on cut.
#define WIRE_EXPLODE_DELAY "Explode Delay" // Explodes immediately if cut, explodes 3 seconds later if pulsed.
#define WIRE_DISARM "Disarm" // Explicit "disarming" wire.
#define WIRE_BADDISARM "Bad Disarm" // Disarming wire, except it blows up anyways.
#define WIRE_BOMB_UNBOLT "Unbolt" // Unbolts the bomb if cut, hint on pulsed.
#define WIRE_BOMB_DELAY "Delay" // Raises the timer on pulse, does nothing on cut.
#define WIRE_BOMB_PROCEED "Proceed" // Lowers the timer, explodes if cut while the bomb is active.
#define WIRE_BOMB_ACTIVATE "Activate" // Will start a bombs timer if pulsed, will hint if pulsed while already active, will stop a timer a bomb on cut.

// Nuclear bomb
#define WIRE_BOMB_LIGHT "Bomb Light"
#define WIRE_BOMB_TIMING "Bomb Timing"
#define WIRE_BOMB_SAFETY "Bomb Safety"

// Particle accelerator
#define WIRE_PARTICLE_POWER "Power Toggle" // Toggles whether the PA is on or not.
#define WIRE_PARTICLE_STRENGTH "Strength" // Determines the strength of the PA.
#define WIRE_PARTICLE_INTERFACE "Interface" // Determines the interface showing up.
#define WIRE_PARTICLE_POWER_LIMIT "Maximum Power" // Determines how strong the PA can be.

// Autolathe
#define WIRE_AUTOLATHE_HACK "Hack"
#define WIRE_AUTOLATHE_DISABLE "Disable"

// Radio
#define WIRE_RADIO_SIGNAL "Signal"
#define WIRE_RADIO_RECEIVER "Receiver"
#define WIRE_RADIO_TRANSMIT "Transmitter"

// Cyborg
#define WIRE_BORG_LOCKED "Lockdown"
#define WIRE_BORG_CAMERA "Camera"
#define WIRE_BORG_LAWCHECK "Law Check"

// Seed Storage
#define WIRE_SEED_SMART "Smart"
#define WIRE_SEED_LOCKDOWN "Lockdown"

// Shield Generator
#define WIRE_SHIELD_CONTROL "Shield Controls" // Cut to lock most shield controls. Mend to unlock them. Pulse does nothing.

// SMES
#define WIRE_SMES_RCON "RCon"		// Remote control (AI and consoles), cut to disable
#define WIRE_SMES_INPUT "Input"		// Input wire, cut to disable input, pulse to disable for 60s
#define WIRE_SMES_OUTPUT "Output"		// Output wire, cut to disable output, pulse to disable for 60s
#define WIRE_SMES_GROUNDING "Grounding"	// Cut to quickly discharge causing sparks, pulse to only create few sparks
#define WIRE_SMES_FAILSAFES "Failsafes"	// Cut to disable failsafes, mend to reenable

// Suit storage unit
#define WIRE_SSU_UV "UV wire"

// Tesla coil
#define WIRE_TESLACOIL_ZAP "Zap"

// RIGsuits
#define WIRE_RIG_SECURITY "Security"
#define WIRE_RIG_AI_OVERRIDE "AI Override"
#define WIRE_RIG_SYSTEM_CONTROL "System Control"
#define WIRE_RIG_INTERFACE_LOCK "Interface Lock"
#define WIRE_RIG_INTERFACE_SHOCK "Interface Shock"

// Disposal Sorting Junctions
#define WIRE_SORT_FORWARD "Sort Forward"
#define WIRE_SORT_SIDE "Sort Side"
#define WIRE_SORT_SCAN "Sort Scan"
