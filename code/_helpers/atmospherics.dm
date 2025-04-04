/obj/proc/analyze_gases(var/atom/A, var/mob/user)
	if(src != A)
		user.visible_message(span_notice("\The [user] has used \an [src] on \the [A]"))

	A.add_fingerprint(user)
	var/list/result = A.atmosanalyze(user)
	if(result && result.len)
		to_chat(user, span_notice("Results of the analysis[src == A ? "" : " of \the [A]"]"))
		for(var/line in result)
			to_chat(user, span_notice("[line]"))
		return 1

	to_chat(user, span_warning("Your [src] flashes a red light as it fails to analyze \the [A]."))
	return 0

/proc/atmosanalyzer_scan(var/atom/target, var/datum/gas_mixture/mixture, var/mob/user)
	var/list/results = list()

	if(mixture && mixture.total_moles > 0)
		var/pressure = mixture.return_pressure()
		var/total_moles = mixture.total_moles
		results += span_notice("Pressure: [round(pressure,0.1)] kPa")
		for(var/mix in mixture.gas)
			results += span_notice("[gas_data.name[mix]]: [round((mixture.gas[mix] / total_moles) * 100)]% ([round(mixture.gas[mix], 0.01)] moles)")
		results += span_notice("Temperature: [round(mixture.temperature-T0C)]&deg;C")
		results += span_notice("Heat Capacity: [round(mixture.heat_capacity(),0.1)]")
	else
		results += span_notice("\The [target] is empty!")

	return results

/turf/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.air, user)

/atom/proc/atmosanalyze(var/mob/user)
	return

/obj/item/tank/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.air_contents, user)

/obj/machinery/portable_atmospherics/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.air_contents, user)

/obj/machinery/atmospherics/pipe/atmosanalyze(var/mob/user)
	if(parent && parent.air) //Sometimes we may have a pipe that has no parent. This seems to happen if you add a pipe onto a pipeline, causing it to delete the parent for every pipe on that pipeline...Yeah. It's complicated and a bug.
		return atmosanalyzer_scan(src, src.parent.air, user)

// This one is strange. The connector is not guaranteed to have a network (if you placed it down by itself)
// 'gases' is also a list. But the atmos analyzer wants you to give it a gas mixture.
// The 'gases' list holds ONE gas mixture.
/obj/machinery/atmospherics/portables_connector/atmosanalyze(var/mob/user)
	if(network && network.gases)
		var/list/datum/gas_mixture/analyzed_gas = network.gases[1]
		return atmosanalyzer_scan(src, analyzed_gas, user)

/obj/machinery/atmospherics/unary/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.air_contents, user)

/obj/machinery/atmospherics/binary/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.air1, user)

/obj/machinery/atmospherics/trinary/atmos_filter/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.air1, user)

/obj/machinery/atmospherics/trinary/mixer/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.air3, user)

/obj/machinery/atmospherics/omni/atmos_filter/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.input.air, user)

/obj/machinery/atmospherics/omni/mixer/atmosanalyze(var/mob/user)
	return atmosanalyzer_scan(src, src.output.air, user)

/obj/machinery/meter/atmosanalyze(var/mob/user)
	var/datum/gas_mixture/mixture = null
	if(target && target.parent)
		mixture = src.target.parent.air
	return atmosanalyzer_scan(src, mixture, user)

/obj/machinery/power/rad_collector/atmosanalyze(var/mob/user)
	if(P)	return atmosanalyzer_scan(src, src.P.air_contents, user)

/obj/item/flamethrower/atmosanalyze(var/mob/user)
	if(ptank)	return atmosanalyzer_scan(src, ptank.air_contents, user)
