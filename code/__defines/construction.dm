//
// Frame construction
//

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

//
// Pipe Construction
//

//Construction Orientation Types - Each of these categories has a different selection of how pipes can rotate and flip. Used for RPD.
#define PIPE_STRAIGHT			0 //2 directions: N/S, E/W
#define PIPE_BENDABLE			1 //6 directions: N/S, E/W, N/E, N/W, S/E, S/W
#define PIPE_TRINARY			2 //4 directions: N/E/S, E/S/W, S/W/N, W/N/E
#define PIPE_TRIN_M				3 //8 directions: N->S+E, S->N+E, N->S+W, S->N+W, E->W+S, W->E+S, E->W+N, W->E+N
#define PIPE_DIRECTIONAL		4 //4 directions: N, S, E, W
#define PIPE_ONEDIR				5 //1 direction: N/S/E/W
#define PIPE_UNARY_FLIPPABLE	6 //8 directions: N, S, E, W, N-flipped, S-flipped, E-flipped, W-flipped
#define PIPE_TRIN_T				7 //8 directions: N->S+E, S->N+E, N->S+W, S->N+W, E->W+S, W->E+S, E->W+N, W->E+N

// Pipe connectivity bit flags
#define CONNECT_TYPE_REGULAR	1
#define CONNECT_TYPE_SUPPLY		2
#define CONNECT_TYPE_SCRUBBER	4
#define CONNECT_TYPE_HE			8
#define CONNECT_TYPE_FUEL		16 // TODO - Implement this! Its piping so better ask Leshana

// We are based on the three named layers of supply, regular, and scrubber.
#define PIPING_LAYER_SUPPLY		1
#define PIPING_LAYER_REGULAR	2
#define PIPING_LAYER_SCRUBBER	3
#define PIPING_LAYER_DEFAULT	PIPING_LAYER_REGULAR

// We offset the layer values of the different pipe types to ensure they look nice
#define PIPES_SCRUBBER_LAYER	(PIPES_LAYER - 0.02)
#define PIPES_SUPPLY_LAYER		(PIPES_LAYER - 0.01)
#define PIPES_HE_LAYER			(PIPES_LAYER + 0.01)

// Pipe flags
#define PIPING_ALL_LAYER 1					//intended to connect with all layers, check for all instead of just one.
#define PIPING_ONE_PER_TURF 2 				//can only be built if nothing else with this flag is on the tile already.
#define PIPING_DEFAULT_LAYER_ONLY 4			//can only exist at PIPING_LAYER_DEFAULT
#define PIPING_CARDINAL_AUTONORMALIZE 8		//north/south east/west doesn't matter, auto normalize on build.

// Macro for easy use of boilerplate code for searching for a valid node connection.
#define STANDARD_ATMOS_CHOOSE_NODE(node_num, direction) \
	for(var/obj/machinery/atmospherics/target in get_step(src, direction)) { \
		if(can_be_node(target, node_num)) { \
			node##node_num = target; \
			break; \
		} \
	}
