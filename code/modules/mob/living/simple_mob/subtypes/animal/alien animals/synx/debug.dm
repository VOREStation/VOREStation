//////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////// DEBUG ////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////

/mob/living/simple_mob/animal/synx/ai/pet/debug
	name = "Syntox"
	desc = "ERROR Connection to translation server could not be established!"

/mob/living/simple_mob/animal/synx/ai/pet/debug/proc/rename()
	set name = "rename"
	set desc = "Renames the synx"
	set category = "DEBUG"
	name = input(usr, "What would you like to change name to?", "Renaming", null)

/mob/living/simple_mob/animal/synx/ai/pet/debug/proc/redesc()
	set name = "redesc"
	set desc = "Redescribes the synx"
	set category = "DEBUG"
	desc = input(usr, "What would you like to change desc to?", "Redescribing", null)

/mob/living/simple_mob/animal/synx/ai/pet/debug/proc/resprite()
	set name = "resprite"
	set desc = "Resprite the synx"
	set category = "DEBUG"
	icon_state = input(usr, "What would you like to change icon_state to?", "Respriting", null)

/mob/living/simple_mob/animal/synx/ai/pet/debug/Initialize(mapload)
	. = ..(mapload, TRUE)
	add_verb(src,/mob/living/simple_mob/animal/synx/ai/pet/debug/proc/rename)
	add_verb(src,/mob/living/simple_mob/animal/synx/ai/pet/debug/proc/resprite)
	add_verb(src,/mob/living/simple_mob/animal/synx/ai/pet/debug/proc/redesc)
