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

//VOREStation Addition Start
// Disposals Construction and RPD Additions
#define DISPOSAL_PIPE_STRAIGHT 0
#define DISPOSAL_PIPE_CORNER 1
#define DISPOSAL_PIPE_JUNCTION 2
#define DISPOSAL_PIPE_JUNCTION_FLIPPED 3
#define DISPOSAL_PIPE_JUNCTION_Y 4
#define DISPOSAL_PIPE_TRUNK 5
#define DISPOSAL_PIPE_BIN 6
#define DISPOSAL_PIPE_OUTLET 7
#define DISPOSAL_PIPE_CHUTE 8
#define DISPOSAL_PIPE_SORTER 9
#define DISPOSAL_PIPE_SORTER_FLIPPED 10
#define DISPOSAL_PIPE_UPWARD 11
#define DISPOSAL_PIPE_DOWNWARD 12
#define DISPOSAL_PIPE_TAGGER 13
#define DISPOSAL_PIPE_TAGGER_PARTIAL 14
//VOREStation Addition End

#define DISPOSAL_SORT_NORMAL 0
#define DISPOSAL_SORT_WILDCARD 1
#define DISPOSAL_SORT_UNTAGGED 2

// Macro for easy use of boilerplate code for searching for a valid node connection.
#define STANDARD_ATMOS_CHOOSE_NODE(node_num, direction) \
	for(var/obj/machinery/atmospherics/target in get_step(src, direction)) { \
		if(can_be_node(target, node_num)) { \
			node##node_num = target; \
			break; \
		} \
	}
