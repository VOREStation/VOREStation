/obj/item/robot_module/proc/do_transform_animation()
	var/mob/living/silicon/robot/R = loc
	R.notransform = TRUE
	var/obj/effect/temp_visual/decoy/fading/fivesecond/ANM = new /obj/effect/temp_visual/decoy/fading/fivesecond(R.loc, R)
	ANM.layer = R.layer - 0.01
	new /obj/effect/temp_visual/small_smoke(R.loc)
	/*
	if(R.hat)
		R.hat.forceMove(get_turf(R))
		R.hat = null
	*/
	//R.update_headlamp()
	R.alpha = 0
	animate(R, alpha = 255, time = 50)
	var/prev_lockcharge = R.lockcharge
	R.SetLockdown(1)
	R.anchored = TRUE
	sleep(2)
	for(var/i in 1 to 4)
		playsound(R, pick('sound/items/drill_use.ogg', 'sound/items/jaws_cut.ogg', 'sound/items/jaws_pry.ogg', 'sound/items/Welder.ogg', 'sound/items/Ratchet.ogg'), 80, 1, -1)
		sleep(12)
	if(!prev_lockcharge)
		R.SetLockdown(0)
	R.anchored = FALSE
	R.notransform = FALSE