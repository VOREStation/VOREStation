//? File contains functions to generate flat /icon's from things.
//? This is obviously expensive. Very, very expensive.
//? new get_flat_icon is faster, but, really, don't use these unless you need to.
//? Chances are unless you are:
//? - sending to html/browser (for non character preview purposes)
//? - taking photos
//? - doing complex icon operations that can't be done with filters/overlays
//? you probably don't need to use these.

/**
 * Generates an icon with all 4 directions of something.
 *
 * @params
 * - A - appearancelike object.
 * - no_anim - flatten out animations
 */
/proc/get_compound_icon(atom/A, no_anim)
	var/mutable_appearance/N = new
	N.appearance = A
	N.dir = NORTH
	var/icon/north = get_flat_icon(N, NORTH, no_anim = no_anim)
	N.dir = SOUTH
	var/icon/south = get_flat_icon(N, SOUTH, no_anim = no_anim)
	N.dir = EAST
	var/icon/east = get_flat_icon(N, EAST, no_anim = no_anim)
	N.dir = WEST
	var/icon/west = get_flat_icon(N, WEST, no_anim = no_anim)
	qdel(N)
	//Starts with a blank icon because of byond bugs.
	var/icon/full = icon('icons/system/blank_32x32.dmi', "")
	full.Insert(north, dir = NORTH)
	full.Insert(south, dir = SOUTH)
	full.Insert(east, dir = EAST)
	full.Insert(west, dir = WEST)
	qdel(north)
	qdel(south)
	qdel(east)
	qdel(west)
	return full

/proc/get_flat_icon(appearance/appearancelike, dir, no_anim)
	if(!dir && isloc(appearancelike))
		dir = appearancelike.dir
	return _get_flat_icon(appearancelike, dir, no_anim, null, TRUE)

/proc/_get_flat_icon(image/A, defdir, no_anim, deficon, start)
	// start with blank image
	var/static/icon/template = icon('icons/system/blank_32x32.dmi', "")

	#define BLANK icon(template)

	#define INDEX_X_LOW 1
	#define INDEX_X_HIGH 2
	#define INDEX_Y_LOW 3
	#define INDEX_Y_HIGH 4

	#define flatX1 flat_size[INDEX_X_LOW]
	#define flatX2 flat_size[INDEX_X_HIGH]
	#define flatY1 flat_size[INDEX_Y_LOW]
	#define flatY2 flat_size[INDEX_Y_HIGH]
	#define addX1 add_size[INDEX_X_LOW]
	#define addX2 add_size[INDEX_X_HIGH]
	#define addY1 add_size[INDEX_Y_LOW]
	#define addY2 add_size[INDEX_Y_HIGH]

	// invis? skip.
	if(!A || A.alpha <= 0)
		return BLANK

	// detect if state exists
	var/icon/icon = A.icon || deficon
	var/state = A.icon_state
	var/none = !icon
	if(!none)
		var/list/states = icon_states(icon)
		if(!(state in states))
			if(!("" in states))
				none = TRUE
			else
				state = ""

	// determine if there's directionals
	// propagate forced direcitons down if and only if A has a direction
	// todo: this results in a mismatch if someone is facing east but their overlays are facing south.
	var/dir
	if(start || !A.dir)
		dir = defdir
	else
		dir = A.dir
	var/ourdir = dir
	if(!none && ourdir != SOUTH)
		if(length(icon_states(icon(icon, state, NORTH))))
		else if(length(icon_states(icon(icon, state, EAST))))
		else if(length(icon_states(icon(icon, state, WEST))))
		else
			ourdir = SOUTH

	// start generating
	if(!A.overlays.len && !A.underlays.len)
		// we don't even have ourselves!
		if(none)
			return BLANK
		// no overlays/underlays, we're done, just mix in ourselves
		var/icon/self_icon = icon(icon(icon, state, ourdir), "", SOUTH, no_anim? 1 : null)
		if(A.alpha < 255)
			self_icon.Blend(rgb(255, 255, 255, A.alpha), ICON_MULTIPLY)
		if(A.color)
			if(islist(A.color))
				self_icon.MapColors(arglist(A.color))
			else
				self_icon.Blend(A.color, ICON_MULTIPLY)
		return self_icon

	// safety/performance check
	if((A.overlays.len + A.underlays.len) > 80)
		// we use fucking insertion check
		// > 80 = death.
		CRASH("get_flat_icon tried to process more than 80 layers")

	// otherwise, we have to blend in all overlays/underlays.
	var/icon/flat = BLANK
	var/list/appearance/gathered = list()
	var/appearance/copying
	var/appearance/comparing
	var/i
	var/appearance/self
	var/current_layer

	if(!none)
		// add the atom itself
		self = image(icon = icon, icon_state = state, layer = A.layer, dir = ourdir)
		self.color = A.color
		self.alpha = A.alpha
		self.blend_mode = A.blend_mode
		gathered[self] = A.layer

	// gather
	for(copying as anything in A.overlays)
		// todo: better handling
		if(copying.plane != FLOAT_PLANE && copying.plane != A.plane)
			// we don't care probably HUD or something lol
			continue
		current_layer = copying.layer
		// if it's float layer, shove it right above atom.
		if(current_layer < 0)
			if(current_layer < -1000)
				CRASH("who the hell is using -1000 or below on float layers?")
			current_layer = A.layer + (1000 + current_layer) / 1000
		// else, add 1 so it doesn't potentially collide on float
		else
			++current_layer

		// inject with insertion sort
		for(i in 1 to gathered.len)
			comparing = gathered[i]
			if(current_layer < gathered[comparing])
				gathered.Insert(i, copying)
		// associate
		gathered[copying] = current_layer

	for(copying as anything in A.underlays)
		// todo: better handling
		if(copying.plane != FLOAT_PLANE && copying.plane != A.plane)
			// we don't care probably HUD or something lol
			continue
		current_layer = copying.layer
		// if it's float layer, shove it right below atom.
		if(current_layer < 0)
			if(current_layer < -1000)
				CRASH("who the hell is using -1000 or below on float layers?")
			current_layer = A.layer - (1000 + current_layer) / 1000
		// else, subtract 1 so it doesn't potentially collide on float
		else
			--current_layer

		// inject with insertion sort
		for(i in 1 to gathered.len)
			comparing = gathered[i]
			if(current_layer < gathered[comparing])
				gathered.Insert(i, copying)
		// associate
		gathered[copying] = current_layer

	// adding icon we're mixing in
	var/icon/adding
	// current dimensions
	var/list/flat_size = list(1, flat.Width(), 1, flat.Height())
	// adding dimensions
	var/list/add_size[4]
	// blend mode
	var/blend_mode

	// blend in layers
	for(copying as anything in gathered)
		// if invis, skip
		if(copying.alpha == 0)
			continue

		// detect if it's literally ourselves
		if(copying == self)
			// blend in normally (no sense doing otherwise unless we're on map)
			// we can't assume we're on map.
			blend_mode = BLEND_OVERLAY
			adding = icon(icon, state, ourdir)
		else
			// use full get_flat_icon
			blend_mode = copying.blend_mode
			adding = _get_flat_icon(copying, defdir, no_anim, icon)

		// if we got nothing, skip
		if(!adding)
			continue

		// detect adding size, taking into account copying overlay's pixel offsets
		add_size[INDEX_X_LOW] = min(flatX1, copying.pixel_x + 1)
		add_size[INDEX_X_HIGH] = max(flatX2, copying.pixel_x + adding.Width())
		add_size[INDEX_Y_LOW] = min(flatY1, copying.pixel_y + 1)
		add_size[INDEX_Y_HIGH] = max(flatY2, copying.pixel_y + adding.Height())

		// resize flat to fit if necessary
		if(flat_size ~! add_size)
			flat.Crop(
				addX1 - flatX1 + 1,
				addY1 - flatY1 + 1,
				addX2 - flatX1 + 1,
				addY2 - flatY1 + 1
			)
			flat_size = add_size.Copy()

		// blend the overlay/underlay in
		flat.Blend(adding, blendMode2iconMode(blend_mode), copying.pixel_x + 2 - flatX1, copying.pixel_y + 2 - flatY1)

	// apply colors
	if(A.color)
		if(islist(A.color))
			flat.MapColors(arglist(A.color))
		else
			flat.Blend(A.color, ICON_MULTIPLY)

	// apply alpha
	if(A.alpha < 255)
		flat.Blend(rgb(255, 255, 255, A.alpha), ICON_MULTIPLY)

	// finalize
	if(no_anim)
		// clean up frames
		var/icon/cleaned = icon()
		cleaned.Insert(flat, "", SOUTH, 1, 0)
		return cleaned
	else
		// just return flat as SOUTH
		return icon(flat, "", SOUTH)

	#undef flatX1
	#undef flatX2
	#undef flatY1
	#undef flatY2
	#undef addX1
	#undef addX2
	#undef addY1
	#undef addY2

	#undef INDEX_X_LOW
	#undef INDEX_X_HIGH
	#undef INDEX_Y_LOW
	#undef INDEX_Y_HIGH

	#undef BLANK
