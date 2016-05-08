/*

/obj/item/borg/upgrade/reset/action/proc/resetborg(var/mob/living/silicon/robot/R)
	if(..()) return 0
	R.uneq_all()
	R.modtype = initial(R.modtype)
	R.hands.icon_state = initial(R.hands.icon_state)
	R.icon = 'icons/mob/robots.dmi'
	R.pixel_x = initial(pixel_x)
	R.pixel_y = initial(pixel_y)

	R.notify_ai(ROBOT_NOTIFICATION_MODULE_RESET, R.module.name)
	R.module.Reset(R)
	qdel(R.module)
	R.module = null
	R.updatename("Default")
*/

//Make it so reset module doesn't bug up borgs. Not a huge problem, but should be added in before launch.

//Could probably do
//if(attempt_vr(src,"resetborg(var/mob/living/silicon/robot/R)",args)) return //VOREStation Code
//or something like that