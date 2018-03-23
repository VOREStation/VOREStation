/mob/living/silicon/robot/proc/transform_with_anim()
	INVOKE_ASYNC(src, .proc/do_transform_animation)

/mob/living/silicon/robot/proc/do_transform_animation()
	notransform = TRUE
	dir = SOUTH
	var/obj/effect/temp_visual/decoy/fading/fivesecond/ANM = new /obj/effect/temp_visual/decoy/fading/fivesecond(loc, src)
	ANM.layer = layer - 0.01
	new /obj/effect/temp_visual/small_smoke(loc)
	alpha = 0
	animate(src, alpha = 255, time = 50)
	var/prev_lockcharge = lockcharge
	SetLockdown(1)
	anchored = TRUE
	sleep(2)
	for(var/i in 1 to 6)
		playsound(src, pick('sound/items/drill_use.ogg', 'sound/items/jaws_cut.ogg', 'sound/items/jaws_pry.ogg', 'sound/items/Welder.ogg', 'sound/items/Wirecutter.ogg', 'sound/items/Crowbar.ogg', 'sound/items/Ratchet.ogg'), 80, 1, -1)
		sleep(8)
	if(!prev_lockcharge)
		SetLockdown(0)
	anchored = FALSE
	notransform = FALSE