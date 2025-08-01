/*
voice control size implant
*/
/obj/item/endoware/size_voice
	name = "Local Scale Regulator"
	desc = "A small (or large) implant usually installed at the base of the spine. It makes use of Quasi-Particles to enable the user to adust their relative scale on demand, in a moderately safe fashion. This one looks nonstandard."
	icon_state = "sizespine"
	var/list/whitelisted_mobs //who can do the talking

	var/list/components_added = list()

/obj/item/endoware/size_voice/build_human_components(var/mob/living/carbon/human/human)
	human.AddComponent(/datum/component/resize_by_verbal_command,whitelisted_mobs,src)
	.=..()

/obj/item/endoware/size_voice/dissolve_human_components(var/mob/living/carbon/human/human)
	for(var/datum/component/x in components_added)
		qdel(x)
