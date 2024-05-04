/// Define that just has the current in-universe year for use in whatever context you might want to display that in. (For example, 2022 -> 2562 given a 540 year offset)
#define CURRENT_STATION_YEAR (GLOB.year_integer + STATION_YEAR_OFFSET)

/// In-universe, SS13 is set 300 years in the future from the real-world day, hence this number for determining the year-offset for the in-game year.
#define STATION_YEAR_OFFSET 300

#define MILISECOND * 0.01
#define MILLISECONDS * 0.01

#define DECISECONDS *1 //the base unit all of these defines are scaled by, because byond uses that as a unit of measurement for some reason

#define SECOND *10
#define SECONDS *10

#define MINUTE *600
#define MINUTES *600

#define HOUR *36000
#define HOURS *36000

#define DAY *864000
#define DAYS *864000

#define TICK *world.tick_lag
#define TICKS *world.tick_lag

#define DS2TICKS(DS) ((DS)/world.tick_lag)

#define TICKS2DS(T) ((T) TICKS)

#define MS2DS(T) ((T) MILLISECONDS)

#define DS2MS(T) ((T) * 100)
