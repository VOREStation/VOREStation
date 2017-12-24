/obj/structure/blob/factory
	name = "factory blob"
	base_name = "factory"
	icon = 'icons/mob/blob.dmi'
	icon_state = "blob_factory"
	desc = "A thick spire of tendrils."
	description_info = "A section of the blob that creates numerous hostile entities to attack enemies of the blob.  \
	It requires a 'node' blob be nearby, or it will cease functioning."
	max_integrity = 40
	health_regen = 1
	point_return = 25
	var/list/spores = list()
	var/max_spores = 3
	var/spore_delay = 0
	var/spore_cooldown = 8 SECONDS

/obj/structure/blob/factory/Destroy()
	for(var/mob/living/simple_animal/hostile/blob/spore/spore in spores)
		if(spore.factory == src)
			spore.factory = null
	spores = null
	return ..()

/obj/structure/blob/factory/pulsed()
	. = ..()
	if(spores.len >= max_spores)
		return
	if(spore_delay > world.time)
		return
	flick("blob_factory_glow", src)
	spore_delay = world.time + spore_cooldown
	var/mob/living/simple_animal/hostile/blob/spore/S = null
	if(overmind)
		S = new overmind.blob_type.spore_type(src.loc, src)
		S.overmind = overmind
		S.update_icons()
		overmind.blob_mobs.Add(S)