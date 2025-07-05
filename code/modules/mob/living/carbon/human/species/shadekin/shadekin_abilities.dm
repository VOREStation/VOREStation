/datum/power/shadekin

/mob/living/carbon/human/is_incorporeal()
	var/datum/component/shadekin/SK = get_shadekin_component()
	if(SK && SK.in_phase) //Shadekin
		return TRUE
	return ..()

// force dephase proc, to be called by other procs to dephase the shadekin. T is the target to force dephase them to.
/mob/living/carbon/human/proc/attack_dephase(var/turf/T = null, atom/dephaser)
	var/datum/component/shadekin/SK = get_shadekin_component()
	if(!SK)
		return FALSE
	// no assigned dephase-target, just use our own
	if(!T)
		T = get_turf(src)

	// make sure it's possible to be dephased (and we're in phase)
	if(SK.doing_phase || !T.CanPass(src,T) || loc != T || !(SK.in_phase) )
		return FALSE


	log_admin("[key_name_admin(src)] was stunned out of phase at [T.x],[T.y],[T.z] by [dephaser.name], last touched by [dephaser.forensic_data?.get_lastprint()].")
	message_admins("[key_name_admin(src)] was stunned out of phase at [T.x],[T.y],[T.z] by [dephaser.name], last touched by [dephaser.forensic_data?.get_lastprint()]. (<A href='byond://?_src_=holder;[HrefToken()];adminplayerobservecoodjump=1;X=[T.x];Y=[T.y];Z=[T.z]'>JMP</a>)", 1)
	// start the dephase
	phase_in(T)
	SK.shadekin_adjust_energy(-20) // loss of energy for the interception
	// apply a little extra stun for good measure
	src.Weaken(3)
