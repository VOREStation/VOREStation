/datum/job/hos
	disallow_jobhop = TRUE
	pto_type = PTO_SECURITY

	access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory,
						access_forensics_lockers, access_morgue, access_maint_tunnels, access_all_personal_lockers,
						access_research, access_engine, access_mining, access_construction, access_mailsorting,
						access_heads, access_hos, access_RC_announce, access_keycard_auth, access_gateway, access_external_airlocks)
	minimal_access = list(access_security, access_eva, access_sec_doors, access_brig, access_armory,
						access_forensics_lockers, access_morgue, access_maint_tunnels, access_all_personal_lockers,
						access_research, access_engine, access_mining, access_construction, access_mailsorting,
						access_heads, access_hos, access_RC_announce, access_keycard_auth, access_gateway, access_external_airlocks)

/datum/job/warden
	pto_type = PTO_SECURITY

/datum/job/detective
	pto_type = PTO_SECURITY

/datum/job/officer
	total_positions = 5
	spawn_positions = 5
	pto_type = PTO_SECURITY