#define BACKGROUND_ENABLED 0    // The default value for all uses of set background. Set background can cause gradual lag and is recommended you only turn this on if necessary.
								// 1 will enable set background. 0 will disable set background.

#define PRELOAD_RSC 1			/*set to:
								0 to allow using external resources or on-demand behaviour;
								1 to use the default behaviour (preload compiled in recourses, not player uploaded ones);
								2 for preloading absolutely everything;
								*/

#define RUST_G "rust_g"			// If uncommented, we will use the rust-g (https://github.com/tgstation/rust-g) native library for fast
								// logging. This requires you to have the rust_g.dll or rust_g (renamed from librust_g.so) installed in the root folder or BYOND/bin
								// The define's value should be the name of library file.

// ZAS Compile Options
//#define ZASDBG	 	// Uncomment to turn on super detailed ZAS debugging that probably won't even compile.
#define MULTIZAS		// Uncomment to turn on Multi-Z ZAS Support!

// Comment/Uncomment this to turn off/on shuttle code debugging logs
#define DEBUG_SHUTTLES

// If we are doing the map test build, do not include the main maps, only the submaps.
#if MAP_TEST
	#define USING_MAP_DATUM /datum/map
	#define MAP_OVERRIDE 1
#endif
