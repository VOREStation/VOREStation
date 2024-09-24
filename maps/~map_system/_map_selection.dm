#ifndef CITESTING

/*********************/
/* MAP SELECTION     */
/* FOR LIVE SERVER   */
/*********************/

// #define USE_MAP_TETHER
#define USE_MAP_STELLARDELIGHT
// #define USE_MAP_GROUNDBASE

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
