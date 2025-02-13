//Note that gas heat damage is only applied once every FOUR ticks.
#define HEAT_GAS_DAMAGE_LEVEL_1 2 //Amount of damage applied when the current breath's temperature just passes the 360.15k safety point
#define HEAT_GAS_DAMAGE_LEVEL_2 4 //Amount of damage applied when the current breath's temperature passes the 400K point
#define HEAT_GAS_DAMAGE_LEVEL_3 8 //Amount of damage applied when the current breath's temperature passes the 1000K point

#define COLD_GAS_DAMAGE_LEVEL_1 0.5 //Amount of damage applied when the current breath's temperature just passes the 260.15k safety point
#define COLD_GAS_DAMAGE_LEVEL_2 1.5 //Amount of damage applied when the current breath's temperature passes the 200K point
#define COLD_GAS_DAMAGE_LEVEL_3 3 //Amount of damage applied when the current breath's temperature passes the 120K point

#define COLD_ALERT_SEVERITY_LOW         1 // Constants passed to the cold and heat alerts.
#define COLD_ALERT_SEVERITY_MODERATE    2
#define COLD_ALERT_SEVERITY_MAX         3
#define ENVIRONMENT_COMFORT_MARKER_COLD 1

#define HOT_ALERT_SEVERITY_LOW          1
#define HOT_ALERT_SEVERITY_MODERATE     2
#define HOT_ALERT_SEVERITY_MAX          3
#define ENVIRONMENT_COMFORT_MARKER_HOT  2

#define TECHNOMANCER_INSTABILITY_MIN_GLOW			10		// When above this number, the entity starts glowing, affecting others.

#define RADIATION_SPEED_COEFFICIENT 0.1
