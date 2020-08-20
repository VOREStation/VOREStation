/datum/job/cmo
	disallow_jobhop = TRUE
	pto_type = PTO_MEDICAL
	dept_time_required = 60

	access = list(access_medical, access_medical_equip, access_morgue, access_genetics, access_heads,
			access_chemistry, access_virology, access_cmo, access_surgery, access_RC_announce,
			access_keycard_auth, access_psychiatrist, access_eva, access_external_airlocks, access_maint_tunnels)

	minimal_access = list(access_medical, access_medical_equip, access_morgue, access_genetics, access_heads,
			access_chemistry, access_virology, access_cmo, access_surgery, access_RC_announce,
			access_keycard_auth, access_psychiatrist, access_eva, access_external_airlocks, access_maint_tunnels)

/datum/job/doctor
	spawn_positions = 5
	pto_type = PTO_MEDICAL

/datum/job/chemist
	pto_type = PTO_MEDICAL

/datum/job/psychiatrist
	pto_type = PTO_MEDICAL

/datum/job/paramedic
	pto_type = PTO_MEDICAL