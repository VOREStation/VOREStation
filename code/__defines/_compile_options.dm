#define BACKGROUND_ENABLED 0    // The default value for all uses of set background. Set background can cause gradual lag and is recommended you only turn this on if necessary.
								// 1 will enable set background. 0 will disable set background.

#define PRELOAD_RSC 1			/*set to:
								0 to allow using external resources or on-demand behaviour;
								1 to use the default behaviour (preload compiled in recourses, not player uploaded ones);
								2 for preloading absolutely everything;
								*/