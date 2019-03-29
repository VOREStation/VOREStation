// Helper macros to aid in optimizing lazy instantiation of lists.
// All of these are null-safe, you can use them without knowing if the list var is initialized yet

//Picks from the list, with some safeties, and returns the "default" arg if it fails
#define DEFAULTPICK(L, default) ((istype(L, /list) && L:len) ? pick(L) : default)
// Ensures L is initailized after this point
#define LAZYINITLIST(L) if (!L) L = list()
// Sets a L back to null iff it is empty
#define UNSETEMPTY(L) if (L && !length(L)) L = null
// Removes I from list L, and sets I to null if it is now empty
#define LAZYREMOVE(L, I) if(L) { L -= I; if(!length(L)) { L = null; } }
// Adds I to L, initalizing I if necessary
#define LAZYADD(L, I) if(!L) { L = list(); } L += I;
#define LAZYOR(L, I) if(!L) { L = list(); } L |= I;
#define LAZYFIND(L, V) L ? L.Find(V) : 0
// Reads I from L safely - Works with both associative and traditional lists.
#define LAZYACCESS(L, I) (L ? (isnum(I) ? (I > 0 && I <= length(L) ? L[I] : null) : L[I]) : null)
// Turns LAZYINITLIST(L) L[K] = V into ...  for associated lists
#define LAZYSET(L, K, V) if(!L) { L = list(); } L[K] = V;
// Reads the length of L, returning 0 if null
#define LAZYLEN(L) length(L)
// Null-safe L.Cut()
#define LAZYCLEARLIST(L) if(L) L.Cut()
// Reads L or an empty list if L is not a list.  Note: Does NOT assign, L may be an expression.
#define SANITIZE_LIST(L) ( islist(L) ? L : list() )
#define reverseList(L) reverseRange(L.Copy())

// binary search sorted insert
// IN: Object to be inserted
// LIST: List to insert object into
// TYPECONT: The typepath of the contents of the list
// COMPARE: The variable on the objects to compare
#define BINARY_INSERT(IN, LIST, TYPECONT, COMPARE) \
	var/__BIN_CTTL = length(LIST);\
	if(!__BIN_CTTL) {\
		LIST += IN;\
	} else {\
		var/__BIN_LEFT = 1;\
		var/__BIN_RIGHT = __BIN_CTTL;\
		var/__BIN_MID = (__BIN_LEFT + __BIN_RIGHT) >> 1;\
		var/##TYPECONT/__BIN_ITEM;\
		while(__BIN_LEFT < __BIN_RIGHT) {\
			__BIN_ITEM = LIST[__BIN_MID];\
			if(__BIN_ITEM.##COMPARE <= IN.##COMPARE) {\
				__BIN_LEFT = __BIN_MID + 1;\
			} else {\
				__BIN_RIGHT = __BIN_MID;\
			};\
			__BIN_MID = (__BIN_LEFT + __BIN_RIGHT) >> 1;\
		};\
		__BIN_ITEM = LIST[__BIN_MID];\
		__BIN_MID = __BIN_ITEM.##COMPARE > IN.##COMPARE ? __BIN_MID : __BIN_MID + 1;\
		LIST.Insert(__BIN_MID, IN);\
	}

#define islist(L) istype(L, /list)
