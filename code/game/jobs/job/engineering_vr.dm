/datum/job/chief_engineer
	disallow_jobhop = TRUE
	pto_type = PTO_ENGINEERING
	dept_time_required = 60

	access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
			            access_teleporter, access_external_airlocks, access_atmospherics, access_emergency_storage, access_eva,
			            access_heads, access_construction,
			            access_ce, access_RC_announce, access_keycard_auth, access_tcomsat, access_ai_upload)

	minimal_access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
			            access_teleporter, access_external_airlocks, access_atmospherics, access_emergency_storage, access_eva,
			            access_heads, access_construction,
			            access_ce, access_RC_announce, access_keycard_auth, access_tcomsat, access_ai_upload)

/datum/job/engineer
	pto_type = PTO_ENGINEERING

/datum/job/atmos
	spawn_positions = 3
	pto_type = PTO_ENGINEERING