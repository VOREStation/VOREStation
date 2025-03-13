//The base hooks themselves

//New() hooks
/hook/client_new

/hook/mob_new

/hook/living_new

/hook/carbon_new

/hook/human_new

/hook/simple_mob_new

//Hooks for interactions
/hook/living_attackby

// Hook for when a mob de-spawns!
/hook/despawn

//
//Hook helpers to expand hooks to others
//
/hook/mob_new/proc/chain_hooks(mob/M)
	var/result = 1
	if(isliving(M))
		if(!hook_vr("living_new",args))
			result = 0

	if(iscarbon(M))
		if(!hook_vr("carbon_new",args))
			result = 0

	if(ishuman(M))
		if(!hook_vr("human_new",args))
			result = 0

	//Return 1 to superhook
	return result
