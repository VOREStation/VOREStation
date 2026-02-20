#define DESTRUCTIVE_DEVICES list(/obj/machinery/rnd/destructive_analyzer, /obj/item/dogborg/sleeper)

///Example of a destructive experiment.
/datum/experiment/scanning/random/artifact_destruction
	name = "Artifact Analysis"
	description = "Destructively analyze several small artifact research samples to assess their exotic molecular properties."
	possible_types = list(/obj/item/research_sample/common)
	allowed_experimentors = DESTRUCTIVE_DEVICES
	total_requirement = 3
	traits = EXPERIMENT_TRAIT_DESTRUCTIVE
	exp_tag = EXPERIMENT_TAG_PHYSICAL

/datum/experiment/scanning/random/artifact_destruction/serialize_progress_stage(atom/target, list/seen_instances)
	return EXPERIMENT_PROG_INT("Destroy artifacts.", \
		traits & EXPERIMENT_TRAIT_DESTRUCTIVE ? scanned[target] : seen_instances.len, required_atoms[target])

/// Bluespace crystal
/datum/experiment/scanning/bluespace_crystal
	name = "Bluespace Crystal Analysis"
	description = "Destructively analyze a bluespace crystal to examine it's exotic molecular shape."
	required_atoms = list(/obj/item/bluespace_crystal = 1)
	allowed_experimentors = DESTRUCTIVE_DEVICES
	traits = EXPERIMENT_TRAIT_DESTRUCTIVE
	exp_tag = EXPERIMENT_TAG_PHYSICAL

/datum/experiment/scanning/bluespace_crystal/serialize_progress_stage(atom/target, list/seen_instances)
	return EXPERIMENT_PROG_INT("Destroy bluespace crystal.", \
		traits & EXPERIMENT_TRAIT_DESTRUCTIVE ? scanned[target] : seen_instances.len, required_atoms[target])

/// Mech parts to start off robotics
/datum/experiment/scanning/random/destruct_ripley_parts
	name = "Mechatronics Part Analysis"
	description = "Destructively analyze one of several basic mechatronics parts."
	possible_types = list(
							/obj/item/circuitboard/mecha/ripley/main = 1,
							/obj/item/circuitboard/mecha/ripley/peripherals = 1,
							/obj/item/mecha_parts/chassis/ripley = 1,
							/obj/item/mecha_parts/part/ripley_torso = 1,
							/obj/item/mecha_parts/part/ripley_left_arm = 1,
							/obj/item/mecha_parts/part/ripley_right_arm = 1,
							/obj/item/mecha_parts/part/ripley_left_leg = 1,
							/obj/item/mecha_parts/part/ripley_right_leg = 1
						)
	total_requirement = 2
	allowed_experimentors = DESTRUCTIVE_DEVICES
	traits = EXPERIMENT_TRAIT_DESTRUCTIVE
	exp_tag = EXPERIMENT_TAG_PHYSICAL

/datum/experiment/scanning/random/destruct_ripley_parts/serialize_progress_stage(atom/target, list/seen_instances)
	return EXPERIMENT_PROG_INT("Destroy basic mechatronics components.", \
		traits & EXPERIMENT_TRAIT_DESTRUCTIVE ? scanned[target] : seen_instances.len, required_atoms[target])

/// Basic circuitboard
/datum/experiment/scanning/destruct_circuitboard
	name = "Circuitboard Analysis"
	description = "Destructively analyze some basic circuitry to assist in planning your own complex assemblies."
	required_atoms = list(
							/obj/item/circuitboard = 1
						)
	allowed_experimentors = DESTRUCTIVE_DEVICES
	traits = EXPERIMENT_TRAIT_DESTRUCTIVE
	exp_tag = EXPERIMENT_TAG_PHYSICAL

/datum/experiment/scanning/destruct_circuitboard/serialize_progress_stage(atom/target, list/seen_instances)
	return EXPERIMENT_PROG_INT("Destroy a circuitboard.", \
		traits & EXPERIMENT_TRAIT_DESTRUCTIVE ? scanned[target] : seen_instances.len, required_atoms[target])

#undef DESTRUCTIVE_DEVICES
