/*
These defines are the balancing points of various parts of the radiation system.
Changes here can have widespread effects: make sure you test well.
Ask Mothblocks if they're around
*/

/// How much stored radiation to check for hair loss
#define RAD_MOB_HAIRLOSS (1 MINUTES)
/// Chance of you hair starting to fall out every second when over threshold
#define RAD_MOB_HAIRLOSS_PROB 7.5

/// How much stored radiation to check for mutation
#define RAD_MOB_MUTATE (2 MINUTES)
/// Chance of randomly mutating every second when over threshold
#define RAD_MOB_MUTATE_PROB 0.5

/// The time since irradiated before checking for vomitting
#define RAD_MOB_VOMIT (2 MINUTES)
/// Chance per second of vomitting
#define RAD_MOB_VOMIT_PROB 0.5

/// How much stored radiation to check for stunning
#define RAD_MOB_KNOCKDOWN (2 MINUTES)
/// Chance of knockdown per second when over threshold
#define RAD_MOB_KNOCKDOWN_PROB 0.5
/// Amount of knockdown when it occurs
#define RAD_MOB_KNOCKDOWN_AMOUNT 3

/**
 * Hello gathered friends, let us once again listen to the tale, of yet another major system rework!
 *
 * Radiation was updated from baycode to TG's modern subsystem in 2026. This lead to a bit of headache
 * as the systems appear very different on the surface. However, with some fanagling they can be made
 * to act very similar. The core point of friction is THRESHOLDS.
 *
 * This notice is being written here to explain what rad insulation means in the context of a radiation
 * pulse. For the radiation resistance of a wall, you don't need to think too hard. It works as expected.
 * When used as the threshold value of a radiation pulse, it will be the cut-off value that the radiation
 * will be instantly blocked by. EVEN if the radiation has extremely high energy.
 *
 * Imagine a radiation pulse as a line from its center to the edge. As it passes through turfs the STRENGTH
 * will be reduced by the combined multiplication of each turf and object it passes through. ex: light rad
 * resistance is 0.9, this multiplies the original strength by 90%, then moves onto the next step. Once it reaches
 * near 0, it's dropped to 0 and runs out of strength to keep going, like a radiation health bar!
 *
 * The confusing part about thresholds is that it is like a SECOND healthbar! If your radiation pulse's
 * threshold is the cutoff point where the strength of the radiation is irrelevant. Once the total threshold
 * calculation goes BENEATH the value set for the threshold, the radiation pulse will simply stop entirely on
 * that line.
 *
 * In effect, this means we have alpha/beta/gamma radiation types now, but this was never clearly explained.
 * A value of RAD_FULL_INSULATION will go through all walls with no cutoff except it's strength. (exactly like bay rads)
 * Values less then RAD_EXTREME_INSULATION are gamma rays and go through all walls up till it hits the threshold.
 * Values less then RAD_MEDIUM_INSULATION are beta particles will go through basic walls, anything more will stop it instantly.
 * All after that are effectively alpha particles, and are stopped easily by walls, and many objects.
 * Finally, if you set it to RAD_NO_INSULATION it usually won't even leave the first turf due to that turf's resistance.
 */

#define RAD_NO_INSULATION 1.0 // For things that shouldn't become irradiated for whatever reason
#define RAD_VERY_LIGHT_INSULATION 0.9 // What girders have
#define RAD_LIGHT_INSULATION 0.8
#define RAD_MEDIUM_INSULATION 0.7 // What common walls have
#define RAD_HEAVY_INSULATION 0.6 // What reinforced walls have
#define RAD_EXTREME_INSULATION 0.5 // What rad collectors have
#define RAD_FULL_INSULATION 0 // Completely stops radiation from coming through

/// The default chance something can be irradiated
#define DEFAULT_RADIATION_CHANCE 10

/// Converts strength to range, based on bay-rad's distance code
#define BAYRAD_RADIATION_RANGE(S) CLAMP(round(sqrt(S / 0.35)), 10, 50)

/// The default chance for uranium structures to irradiate
#define URANIUM_IRRADIATION_CHANCE DEFAULT_RADIATION_CHANCE

/// The minimum exposure time before uranium structures can irradiate
#define URANIUM_RADIATION_MINIMUM_EXPOSURE_TIME (3 SECONDS)
/// The minimum exposure time before the radioactive nebula can irradiate
#define NEBULA_RADIATION_MINIMUM_EXPOSURE_TIME (6 SECONDS)

/// Return values of [proc/get_perceived_radiation_danger]
// If you change these, update /datum/looping_sound/geiger as well.
#define PERCEIVED_RADIATION_DANGER_LOW 1
#define PERCEIVED_RADIATION_DANGER_MEDIUM 2
#define PERCEIVED_RADIATION_DANGER_HIGH 3
#define PERCEIVED_RADIATION_DANGER_EXTREME 4

/// The time before geiger counters reset back to normal without any radiation pulses
#define TIME_WITHOUT_RADIATION_BEFORE_RESET (5 SECONDS)

// Radiation exposure params

// For the radioactive nebula outside
/// Base chance the nebula has of applying irradiation
#define RADIATION_EXPOSURE_NEBULA_BASE_CHANCE 20
/// The chance we add to the base chance every time we fail to irradiate
#define RADIATION_EXPOSURE_NEBULA_CHANCE_INCREMENT 10
/// Time it takes for the next irradiation check
#define RADIATION_EXPOSURE_NEBULA_CHECK_INTERVAL 5 SECONDS
