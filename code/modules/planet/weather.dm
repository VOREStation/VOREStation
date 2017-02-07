#define WEATHER_CLEAR				"clear"
#define WEATHER_OVERCAST			"overcast"
#define WEATHER_LIGHT_SNOW			"light snow"
#define WEATHER_SNOW				"snow"
#define WEATHER_BLIZZARD			"blizzard"
#define WEATHER_RAIN				"rain"
#define WEATHER_STORM				"storm"
#define WEATHER_HAIL				"hail"
#define WEATHER_WINDY				"windy"
#define WEATHER_HOT					"hot"

/datum/weather_holder
	var/current_weather = WEATHER_CLEAR
	var/temperature = T20C
	var/wind_dir = 0
	var/wind_speed = 0
	var/list/allowed_weather_types = list()
	var/planetary_wall_type = null // Which walls to look for when updating temperature.

/datum/weather_holder/proc/update()
	//TODO: Do actual weather.

	update_temperature()
	world << "Temperature is now [temperature]."

/datum/weather_holder/proc/update_temperature()
	for(var/turf/unsimulated/wall/planetary/wall in planetary_walls)
		if(ispath(wall.type, planetary_wall_type))
			wall.temperature = temperature
			wall.make_air()

/datum/weather_holder/sif
	temperature = T0C
	allowed_weather_types = list(
		WEATHER_CLEAR,
		WEATHER_OVERCAST,
		WEATHER_LIGHT_SNOW,
		WEATHER_SNOW,
		WEATHER_BLIZZARD,
		WEATHER_RAIN,
		WEATHER_STORM,
		WEATHER_HAIL,
		WEATHER_WINDY
		)
	planetary_wall_type = /turf/unsimulated/wall/planetary/sif
