
/obj/item/blobcore_chunk
	name = "core chunk"
	desc = "The remains of some strange life-form. It smells awful."
	description_info = "Some blob types will have core effects when the chunk is used in-hand, toggled with an alt click, or constantly active."
	icon = 'icons/mob/blob.dmi'
	icon_state = "blobcore"
	flags = OPENCONTAINER
	var/datum/blob_type/blob_type	// The blob type this dropped from.

	var/active_ability_cooldown = 20 SECONDS
	var/last_active_use = 0

	var/should_tick = TRUE	// Incase it's a toggle.

	var/passive_ability_cooldown = 5 SECONDS
	var/last_passive_use = 0

	var/can_genesis = TRUE	// Can the core chunk be used to grow a new blob?

	drop_sound = 'sound/effects/slime_squish.ogg'

/obj/item/blobcore_chunk/is_open_container()
	return 1

/obj/item/blobcore_chunk/New(var/atom/newloc, var/datum/blob_type/parentblob = null)
	..(newloc)

	create_reagents(120)
	setup_blobtype(parentblob)

/obj/item/blobcore_chunk/Destroy()
	STOP_PROCESSING(SSobj, src)

	blob_type = null

	..()

/obj/item/blobcore_chunk/proc/setup_blobtype(var/datum/blob_type/parentblob = null)
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

/obj/item/blobcore_chunk/proc/call_chunk_unique()
	if(blob_type)
		blob_type.chunk_unique(src, args)
	return

/obj/item/blobcore_chunk/proc/get_carrier(var/atom/target)
	var/atom/A = target ? target.loc : src

	if(isturf(A) || isarea(A))	// Something has gone horribly wrong if the second is true.
		return FALSE	// No mob is carrying us.

	if(!isliving(A))
		A = get_carrier(A)

	return A

/obj/item/blobcore_chunk/blob_act(obj/structure/blob/B)
	if(B.overmind && !blob_type)
		setup_blobtype(B.overmind.blob_type)

	return

/obj/item/blobcore_chunk/attack_self(var/mob/user)
	if(blob_type && world.time > active_ability_cooldown + last_active_use)
		last_active_use = world.time
		to_chat(user, span_alien("[icon2html(src, user.client)] \The [src] gesticulates."))
		blob_type.on_chunk_use(src, user)
	else
		to_chat(user, span_notice("\The [src] doesn't seem to respond."))
	..()

/obj/item/blobcore_chunk/process()
	if(blob_type && should_tick && world.time > passive_ability_cooldown + last_passive_use)
		last_passive_use = world.time
		blob_type.on_chunk_tick(src)

/obj/item/blobcore_chunk/AltClick(mob/living/carbon/user)
	if(blob_type && blob_type.chunk_active_type == BLOB_CHUNK_TOGGLE)
		should_tick = !should_tick

		if(should_tick)
			to_chat(user, span_alien("\The [src] shudders with life."))
		else
			to_chat(user, span_alien("\The [src] stills, returning to a death-like state."))

/obj/item/blobcore_chunk/proc/regen(var/newfaction = null)
	if(istype(blob_type))
		if(newfaction)
			blob_type.faction = newfaction

		var/obj/structure/blob/core/NC = new (get_turf(src))
		NC.overmind.blob_type = blob_type
		NC.overmind.blob_core.update_icon()
		return TRUE

	return FALSE

/decl/chemical_reaction/instant/blob_reconstitution
	name = "Hostile Blob Revival"
	id = "blob_revival"
	result = null
	required_reagents = list(REAGENT_ID_PHORON = 60)
	result_amount = 1

/decl/chemical_reaction/instant/blob_reconstitution/can_happen(var/datum/reagents/holder)
	if(holder.my_atom && istype(holder.my_atom, /obj/item/blobcore_chunk))
		return ..()
	return FALSE

/decl/chemical_reaction/instant/blob_reconstitution/on_reaction(var/datum/reagents/holder)
	var/obj/item/blobcore_chunk/chunk = holder.my_atom
	if(chunk.can_genesis && chunk.regen())
		chunk.visible_message(span_notice("[chunk] bubbles, surrounding itself with a rapidly expanding mass of [chunk.blob_type.name]!"))
		chunk.can_genesis = FALSE
	else
		chunk.visible_message(span_warning("[chunk] shifts strangely, but falls still."))

/decl/chemical_reaction/instant/blob_reconstitution/domination
	name = "Allied Blob Revival"
	id = "blob_friend"
	result = null
	required_reagents = list(REAGENT_ID_HYDROPHORON = 40, REAGENT_ID_PERIDAXON = 20, REAGENT_ID_MUTAGEN = 20)
	result_amount = 1

/decl/chemical_reaction/instant/blob_reconstitution/domination/on_reaction(var/datum/reagents/holder)
	var/obj/item/blobcore_chunk/chunk = holder.my_atom
	if(chunk.can_genesis && chunk.regen("neutral"))
		chunk.visible_message(span_notice("[chunk] bubbles, surrounding itself with a rapidly expanding mass of [chunk.blob_type.name]!"))
		chunk.can_genesis = FALSE
	else
		chunk.visible_message(span_warning("[chunk] shifts strangely, but falls still."))
