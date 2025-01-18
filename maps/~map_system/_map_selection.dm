#if !defined(CITESTING)

/*********************/
/* MAP SELECTION     */
/* FOR LIVE SERVER   */
/*********************/

//#define USE_MAP_TETHER
#define USE_MAP_STELLARDELIGHT
//#define USE_MAP_GROUNDBASE

// Debug
//#define USE_MAP_MINITEST

/*********************/
/* End Map Selection */
/*********************/

#endif

// Tether
#ifdef USE_MAP_TETHER
#include "../tether/tether.dm"
#endif

// Stellar Delight
#ifdef USE_MAP_STELLARDELIGHT
#include "../stellar_delight/stellar_delight.dm"
#endif

// Groundbase
#ifdef USE_MAP_GROUNDBASE
#include "../groundbase/groundbase.dm"
#endif

// Debug: Minitest
#ifdef USE_MAP_MINITEST
#include "../virgo_minitest/virgo_minitest.dm"
#endif
