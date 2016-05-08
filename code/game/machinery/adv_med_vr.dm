/*

/obj/machinery/bodyscanner/proc/get_occupant_data_vr(list/incoming = list(),mob/living/carbon/human/H)
	incoming["Weight"] = H.weight
	return



/obj/machinery/body_scanconsole/proc/med_info2(var/list/occ, var/dat = "<font color='blue'><b>Scan performed at [occ["stationtime"]]</b></font><br>")
	dat += text("Body Weight (to scale): [occ["weight"]]lbs / [occ["weight"] / 2.20463]kg<br><HR>")

*/
//WIP sleeper code.

//attempt_vr(src,"get_occupant_data_vr",list(occupant_data,H)) //VOREStation Code

//attempt_vr(src,"med_info2",list(occupant_data,occ)) //VOREStation Code