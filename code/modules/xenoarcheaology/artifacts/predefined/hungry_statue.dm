/obj/machinery/artifact/predefined/hungry_statue
	name = "alien artifact"
	desc = "A large alien device."

	artifact_master = /datum/component/artifact_master/hungry_statue

	predefined_icon_num = 14

/datum/component/artifact_master/hungry_statue
	make_effects = list(
		/datum/artifact_effect/common/animate_anomaly,
		/datum/artifact_effect/rare/vampire
	)
