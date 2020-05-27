
/obj/item/weapon/blobcore_chunk
	name = "core chunk"
	desc = "The remains of some strange life-form. It smells awful."
	description_info = "Some blob types will have core effects when the chunk is used in-hand, toggled with an alt click, or constantly active."
	icon = 'icons/mob/blob.dmi'
	icon_state = "blobcore"
	var/datum/blob_type/blob_type	// The blob type this dropped from.

	var/active_ability_cooldown = 20 SECONDS
	var/last_active_use = 0

	var/should_tick = TRUE	// Incase it's a toggle.

	var/passive_ability_cooldown = 5 SECONDS
	var/last_passive_use = 0

	drop_sound = 'sound/effects/slime_squish.ogg'

/obj/item/weapon/blobcore_chunk/New(var/atom/newloc, var/datum/blob_type/parentblob = null)
	..(newloc)

	setup_blobtype(parentblob)

/obj/item/weapon/blobcore_chunk/Destroy()
	STOP_PROCESSING(SSobj, src)

	blob_type = null

	..()

/obj/item/weapon/blobcore_chunk/proc/setup_blobtype(var/datum/blob_type/parentblob = null)
	if(!parentblob)
		name = "inert [initial(name)]"

	else
		blob_type = parentblob
		name = "[blob_type.name] [initial(name)]"

	if(blob_type)
		color = blob_type.color
		if(LAZYLEN(blob_type.core_tech))
			origin_tech = blob_type.core_tech.Copy()

		if(blob_type.chunk_active_type == BLOB_CHUNK_CONSTANT)
			should_tick = TRUE
		else if(blob_type.chunk_active_type == BLOB_CHUNK_TOGGLE)
			should_tick = FALSE

		active_ability_cooldown = blob_type.chunk_active_ability_cooldown
		passive_ability_cooldown = blob_type.chunk_passive_ability_cooldown

		blob_type.chunk_setup(src)

		START_PROCESSING(SSobj, src)

/obj/item/weapon/blobcore_chunk/proc/call_chunk_unique()
	if(blob_type)
		blob_type.chunk_unique(src, args)
	return

/obj/item/weapon/blobcore_chunk/proc/get_carrier(var/atom/target)
	var/atom/A = target ? target.loc : src
	if(!istype(A, /mob/living))
		A = get_carrier(A)

	if(isturf(A) || isarea(A))	// Something has gone horribly wrong if the second is true.
		return FALSE	// No mob is carrying us.

	return A

/obj/item/weapon/blobcore_chunk/blob_act(obj/structure/blob/B)
	if(B.overmind && !blob_type)
		setup_blobtype(B.overmind.blob_type)

	return

/obj/item/weapon/blobcore_chunk/attack_self(var/mob/user)
	if(blob_type && world.time > active_ability_cooldown + last_active_use)
		last_active_use = world.time
		to_chat(user, "<span class='alien'>\icon [src] \The [src] gesticulates.</span>")
		blob_type.on_chunk_use(src, user)
	else
		to_chat(user, "<span class='notice'>\The [src] doesn't seem to respond.</span>")
	..()

/obj/item/weapon/blobcore_chunk/process()
	if(blob_type && should_tick && world.time > passive_ability_cooldown + last_passive_use)
		last_passive_use = world.time
		blob_type.on_chunk_tick(src)

/obj/item/weapon/blobcore_chunk/AltClick(mob/living/carbon/user)
	if(blob_type &&blob_type.chunk_active_type == BLOB_CHUNK_TOGGLE)
		should_tick = !should_tick

		if(should_tick)
			to_chat(user, "<span class='alien'>\The [src] shudders with life.</span>")
		else
			to_chat(user, "<span class='alien'>\The [src] stills, returning to a death-like state.</span>")
