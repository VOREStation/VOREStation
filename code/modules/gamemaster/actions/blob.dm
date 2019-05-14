/datum/gm_action/blob
	name = "blob infestation"
	departments = list(ROLE_ENGINEERING, ROLE_SECURITY, ROLE_MEDICAL)
	chaotic = 25

	var/obj/structure/blob/core/Blob

/datum/gm_action/blob/start()
	..()
	var/turf/T = pick(blobstart)

	Blob = new /obj/structure/blob/core/random_medium(T)

/datum/gm_action/blob/announce()
	spawn(rand(600, 3000))	// 1-5 minute leeway for the blob to go un-detected.
		command_announcement.Announce("Confirmed outbreak of level 7 biohazard aboard [station_name()]. All personnel must contain the outbreak.", "Biohazard Alert", new_sound = 'sound/AI/outbreak7.ogg')

/datum/gm_action/blob/get_weight()
	var/engineers = metric.count_people_in_department(ROLE_ENGINEERING)
	var/security = metric.count_people_in_department(ROLE_SECURITY)
	var/medical = metric.count_people_in_department(ROLE_MEDICAL)

	var/assigned_staff = engineers + security
	if(engineers || security)	// Medical only counts if one of the other two exists, and even then they count as half.
		assigned_staff += round(medical / 2)

	var/weight = (max(assigned_staff - 2, 0) * 20) // An assigned staff count of 2 must be had to spawn a blob.
	return weight
