/mob/living/silicon/robot/proc/transform_with_anim()
	INVOKE_ASYNC(src, PROC_REF(do_transform_animation))

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
	addtimer(CALLBACK(src, PROC_REF(transform_animation_sounds), 6, prev_lockcharge), 0.2 SECONDS)

/mob/living/silicon/robot/proc/transform_animation_sounds(var/recall, var/prev_lockcharge)
	if(recall > 0)
		playsound(src, pick('sound/items/drill_use.ogg', 'sound/items/jaws_cut.ogg', 'sound/items/jaws_pry.ogg', 'sound/items/Welder.ogg', 'sound/items/Wirecutter.ogg', 'sound/items/Crowbar.ogg', 'sound/items/Ratchet.ogg'), 80, 1, -1)
		recall--
		addtimer(CALLBACK(src, PROC_REF(transform_animation_sounds), recall, prev_lockcharge), 0.8 SECONDS)
		return
	transform_animation_end_lockdown(prev_lockcharge)

/mob/living/silicon/robot/proc/transform_animation_end_lockdown(var/prev_lockcharge)
	if(!prev_lockcharge)
		SetLockdown(0)
	anchored = FALSE
	notransform = FALSE
