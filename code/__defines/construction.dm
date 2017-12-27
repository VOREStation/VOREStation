

// Frame construction states
#define FRAME_PLACED 0		// Has been placed (can be anchored or not).
#define FRAME_UNFASTENED 1	// Circuit added.
#define FRAME_FASTENED 2	// Circuit fastened.
#define FRAME_WIRED 3		// Frame wired.
#define FRAME_PANELED 4		// Glass panel added.

// The frame classes define a sequence of construction steps.
#define FRAME_CLASS_ALARM "alarm"
#define FRAME_CLASS_COMPUTER "computer"
#define FRAME_CLASS_DISPLAY "display"
#define FRAME_CLASS_MACHINE "machine"

// Does the frame get built on the floor or a wall?
#define FRAME_STYLE_FLOOR "floor"
#define FRAME_STYLE_WALL "wall"
