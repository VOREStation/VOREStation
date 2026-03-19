//Define a macro that we can use to assemble all the circuit board names
#define T_BOARD(name)	"circuit board (" + (name) + ")"

// Macro for techweb design consistency
#define SET_CIRCUIT_DESIGN_NAMEDESC(dispname) name = (dispname) + " circuit";desc = "The circuit board for a " + (dispname) + ".";
