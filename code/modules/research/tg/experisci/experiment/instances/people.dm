/datum/experiment/scanning/people/big_or_smol
	required_count = 1
	required_traits_desc = "a size bigger than 125% or smaller than 75%"

/datum/experiment/scanning/people/big_or_smol/is_valid_scan_target(mob/living/carbon/human/check, datum/component/experiment_handler/experiment_handler)
	. = ..()
	if(!.)
		return
	if(check.size_multiplier < 1.25 && check.size_multiplier > 0.75)
		return FALSE
	return TRUE
