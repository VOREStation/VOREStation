/datum/job/hos
	disallow_jobhop = TRUE
	pto_type = PTO_SECURITY
	dept_time_required = 60

	access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory,
						access_forensics_lockers, access_morgue, access_maint_tunnels, access_all_personal_lockers,
						access_construction,
						access_heads, access_hos, access_RC_announce, access_keycard_auth, access_external_airlocks)
	minimal_access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory,
						access_forensics_lockers, access_morgue, access_maint_tunnels, access_all_personal_lockers,
						access_construction,
						access_heads, access_hos, access_RC_announce, access_keycard_auth, access_external_airlocks)

/datum/job/warden
	pto_type = PTO_SECURITY
	dept_time_required = 20

/datum/job/detective
	pto_type = PTO_SECURITY

/datum/job/officer
	total_positions = 5
	spawn_positions = 5
	pto_type = PTO_SECURITY