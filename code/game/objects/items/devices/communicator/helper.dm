/obj/item/device/communicator/proc/analyze_air()
	var/list/results = list()
	var/turf/T = get_turf(src.loc)
	if(!isnull(T))
		var/datum/gas_mixture/environment = T.return_air()
		var/pressure = environment.return_pressure()
		var/total_moles = environment.total_moles
		if (total_moles)
			var/o2_level = environment.gas["oxygen"]/total_moles
			var/n2_level = environment.gas["nitrogen"]/total_moles
			var/co2_level = environment.gas["carbon_dioxide"]/total_moles
			var/phoron_level = environment.gas["phoron"]/total_moles
			var/unknown_level =  1-(o2_level+n2_level+co2_level+phoron_level)
			results = list(
						"pressure" = "[round(pressure,0.1)]",
						"nitrogen" = "[round(n2_level*100,0.1)]",
						"oxygen" = "[round(o2_level*100,0.1)]",
						"carbon_dioxide" = "[round(co2_level*100,0.1)]",
						"phoron" = "[round(phoron_level*100,0.01)]",
						"other" = "[round(unknown_level, 0.01)]",
						"temp" = "[round(environment.temperature-T0C,0.1)]",
						"reading" = 1
						)

	if(isnull(results))
		results = list("reading" = 0)
	return results