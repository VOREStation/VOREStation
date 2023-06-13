#define TO_HEX_DIGIT(n) ascii2text((n&15) + ((n&15)<10 ? 48 : 87))

/icon/proc/MakeLying()
	var/icon/I = new(src,dir=SOUTH)
	I.BecomeLying()
	return I

/icon/proc/BecomeLying()
	Turn(90)
	Shift(SOUTH,6)
	Shift(EAST,1)

// Multiply all alpha values by this float
/icon/proc/ChangeOpacity(opacity = 1.0)
	MapColors(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,opacity, 0,0,0,0)

// Convert to grayscale
/icon/proc/GrayScale()
	MapColors(0.3,0.3,0.3, 0.59,0.59,0.59, 0.11,0.11,0.11, 0,0,0)

/icon/proc/ColorTone(tone)
	GrayScale()

	var/list/TONE = rgb2num(tone)
	var/gray = round(TONE[1]*0.3 + TONE[2]*0.59 + TONE[3]*0.11, 1)

	var/icon/upper = (255-gray) ? new(src) : null

	if(gray)
		MapColors(255/gray,0,0, 0,255/gray,0, 0,0,255/gray, 0,0,0)
		Blend(tone, ICON_MULTIPLY)
	else SetIntensity(0)
	if(255-gray)
		upper.Blend(rgb(gray,gray,gray), ICON_SUBTRACT)
		upper.MapColors((255-TONE[1])/(255-gray),0,0,0, 0,(255-TONE[2])/(255-gray),0,0, 0,0,(255-TONE[3])/(255-gray),0, 0,0,0,0, 0,0,0,1)
		Blend(upper, ICON_ADD)

// Take the minimum color of two icons; combine transparency as if blending with ICON_ADD
/icon/proc/MinColors(icon)
	var/icon/I = new(src)
	I.Opaque()
	I.Blend(icon, ICON_SUBTRACT)
	Blend(I, ICON_SUBTRACT)

// Take the maximum color of two icons; combine opacity as if blending with ICON_OR
/icon/proc/MaxColors(icon)
	var/icon/I
	if(isicon(icon))
		I = new(icon)
	else
		// solid color
		I = new(src)
		I.Blend("#000000", ICON_OVERLAY)
		I.SwapColor("#000000", null)
		I.Blend(icon, ICON_OVERLAY)
	var/icon/J = new(src)
	J.Opaque()
	I.Blend(J, ICON_SUBTRACT)
	Blend(I, ICON_OR)

// make this icon fully opaque--transparent pixels become black
/icon/proc/Opaque(background = "#000000")
	SwapColor(null, background)
	MapColors(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,0, 0,0,0,1)

// Change a grayscale icon into a white icon where the original color becomes the alpha
// I.e., black -> transparent, gray -> translucent white, white -> solid white
/icon/proc/BecomeAlphaMask()
	SwapColor(null, "#000000ff")	// don't let transparent become gray
	MapColors(0,0,0,0.3, 0,0,0,0.59, 0,0,0,0.11, 0,0,0,0, 1,1,1,0)

/icon/proc/UseAlphaMask(mask)
	Opaque()
	AddAlphaMask(mask)

/icon/proc/AddAlphaMask(mask)
	var/icon/M = new(mask)
	M.Blend("#ffffff", ICON_SUBTRACT)
	// apply mask
	Blend(M, ICON_ADD)

/proc/BlendRGB(rgb1, rgb2, amount)
	var/list/RGB1 = rgb2num(rgb1)
	var/list/RGB2 = rgb2num(rgb2)

	// add missing alpha if needed
	if(RGB1.len < RGB2.len) RGB1 += 255
	else if(RGB2.len < RGB1.len) RGB2 += 255
	var/usealpha = RGB1.len > 3

	var/r = round(RGB1[1] + (RGB2[1] - RGB1[1]) * amount, 1)
	var/g = round(RGB1[2] + (RGB2[2] - RGB1[2]) * amount, 1)
	var/b = round(RGB1[3] + (RGB2[3] - RGB1[3]) * amount, 1)
	var/alpha = usealpha ? round(RGB1[4] + (RGB2[4] - RGB1[4]) * amount, 1) : null

	return isnull(alpha) ? rgb(r, g, b) : rgb(r, g, b, alpha)

// Ported from /tg/station
// Creates a single icon from a given /atom or /image.  Only the first argument is required.
/proc/getFlatIcon(image/A, defdir, deficon, defstate, defblend, start = TRUE, no_anim = FALSE)
	//Define... defines.
	var/static/icon/flat_template = icon('icons/effects/effects.dmi', "nothing")

	#define BLANK icon(flat_template)
	#define SET_SELF(SETVAR) do { \
		var/icon/SELF_ICON=icon(icon(curicon, curstate, base_icon_dir),"",SOUTH,no_anim?1:null); \
		if(A.alpha<255) { \
			SELF_ICON.Blend(rgb(255,255,255,A.alpha),ICON_MULTIPLY);\
		} \
		if(A.color) { \
			if(islist(A.color)){ \
				SELF_ICON.MapColors(arglist(A.color))} \
			else{ \
				SELF_ICON.Blend(A.color,ICON_MULTIPLY)} \
		} \
		##SETVAR=SELF_ICON;\
		} while (0)
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

	if(!A || A.alpha <= 0)
		return BLANK

	var/noIcon = FALSE
	if(start)
		if(!defdir)
			defdir = A.dir
		if(!deficon)
			deficon = A.icon
		if(!defstate)
			defstate = A.icon_state
		if(!defblend)
			defblend = A.blend_mode

	var/curicon = A.icon || deficon
	var/curstate = A.icon_state || defstate

	if(!((noIcon = (!curicon))))
		var/curstates = cached_icon_states(curicon)
		if(!(curstate in curstates))
			if("" in curstates)
				curstate = ""
			else
				noIcon = TRUE // Do not render this object.

	var/curdir
	var/base_icon_dir	//We'll use this to get the icon state to display if not null BUT NOT pass it to overlays as the dir we have

	// Use the requested dir or the atom's current dir
	curdir = defdir || A.dir

	//Try to remove/optimize this section ASAP, CPU hog. //Slightly mitigated by implementing caching using cached_icon_states
	//Determines if there's directionals.
	if(!noIcon && curdir != SOUTH)
		var/exist = FALSE
		var/static/list/checkdirs = list(NORTH, EAST, WEST)
		for(var/i in checkdirs)		//Not using GLOB for a reason.
			if(length(cached_icon_states(icon(curicon, curstate, i))))
				exist = TRUE
				break
		if(!exist)
			base_icon_dir = SOUTH
	//

	if(!base_icon_dir)
		base_icon_dir = curdir

	ASSERT(!BLEND_DEFAULT)		//I might just be stupid but lets make sure this define is 0.

	var/curblend = A.blend_mode || defblend

	if(A.overlays.len || A.underlays.len)
		var/icon/flat = BLANK
		// Layers will be a sorted list of icons/overlays, based on the order in which they are displayed
		var/list/layers = list()
		var/image/copy
		// Add the atom's icon itself, without pixel_x/y offsets.
		if(!noIcon)
			copy = image(icon=curicon, icon_state=curstate, layer=A.layer, dir=base_icon_dir)
			copy.color = A.color
			copy.alpha = A.alpha
			copy.blend_mode = curblend
			layers[copy] = A.layer

		// Loop through the underlays, then overlays, sorting them into the layers list
		for(var/process_set in 0 to 1)
			var/list/process = process_set? A.overlays : A.underlays
			for(var/i in 1 to process.len)
				var/image/current = process[i]
				if(!current)
					continue
				if(current.plane != FLOAT_PLANE && current.plane != A.plane)
					continue
				var/current_layer = current.layer
				if(current_layer < 0)
					//if(current_layer <= -1000)
						//return flat
					current_layer = process_set + A.layer + current_layer / 1000

				for(var/p in 1 to layers.len)
					var/image/cmp = layers[p]
					if(current_layer < layers[cmp])
						layers.Insert(p, current)
						break
				layers[current] = current_layer

		//sortTim(layers, GLOBAL_PROC_REF(cmp_image_layer_asc))

		var/icon/add // Icon of overlay being added

		// Current dimensions of flattened icon
		var/list/flat_size = list(1, flat.Width(), 1, flat.Height())
		// Dimensions of overlay being added
		var/list/add_size[4]

		for(var/V in layers)
			var/image/I = V
			if(I.alpha == 0)
				continue

			if(I == copy) // 'I' is an /image based on the object being flattened.
				curblend = BLEND_OVERLAY
				add = icon(I.icon, I.icon_state, base_icon_dir)
			else // 'I' is an appearance object.
				add = getFlatIcon(image(I), curdir, curicon, curstate, curblend, FALSE, no_anim)
			if(!add)
				continue
			// Find the new dimensions of the flat icon to fit the added overlay
			add_size = list(
				min(flatX1, I.pixel_x+1),
				max(flatX2, I.pixel_x+add.Width()),
				min(flatY1, I.pixel_y+1),
				max(flatY2, I.pixel_y+add.Height())
			)

			if(flat_size ~! add_size)
				// Resize the flattened icon so the new icon fits
				flat.Crop(
				addX1 - flatX1 + 1,
				addY1 - flatY1 + 1,
				addX2 - flatX1 + 1,
				addY2 - flatY1 + 1
				)
				flat_size = add_size.Copy()

			// Blend the overlay into the flattened icon
			flat.Blend(add, blendMode2iconMode(curblend), I.pixel_x + 2 - flatX1, I.pixel_y + 2 - flatY1)

		if(A.color)
			if(islist(A.color))
				flat.MapColors(arglist(A.color))
			else
				flat.Blend(A.color, ICON_MULTIPLY)

		if(A.alpha < 255)
			flat.Blend(rgb(255, 255, 255, A.alpha), ICON_MULTIPLY)

		if(no_anim)
			//Clean up repeated frames
			var/icon/cleaned = new /icon()
			cleaned.Insert(flat, "", SOUTH, 1, 0)
			. = cleaned
		else
			. = icon(flat, "", SOUTH)
	else	//There's no overlays.
		if(!noIcon)
			SET_SELF(.)

	//Clear defines
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
	#undef SET_SELF

/proc/getIconMask(atom/A)//By yours truly. Creates a dynamic mask for a mob/whatever. /N
	var/icon/alpha_mask = new(A.icon,A.icon_state)//So we want the default icon and icon state of A.
	for(var/I in A.overlays)//For every image in overlays. var/image/I will not work, don't try it.
		if(I:layer>A.layer)	continue//If layer is greater than what we need, skip it.
		var/icon/image_overlay = new(I:icon,I:icon_state)//Blend only works with icon objects.
		//Also, icons cannot directly set icon_state. Slower than changing variables but whatever.
		alpha_mask.Blend(image_overlay,ICON_OR)//OR so they are lumped together in a nice overlay.
	return alpha_mask//And now return the mask.

//getFlatIcon but generates an icon that can face ALL four directions. The only four.
/proc/getCompoundIcon(atom/A)
	var/icon/north = getFlatIcon(A,defdir=NORTH)
	var/icon/south = getFlatIcon(A,defdir=SOUTH)
	var/icon/east = getFlatIcon(A,defdir=EAST)
	var/icon/west = getFlatIcon(A,defdir=WEST)

	//Starts with a blank icon because of byond bugs.
	var/icon/full = icon('icons/effects/effects.dmi', "icon_state"="nothing")

	full.Insert(north,dir=NORTH)
	full.Insert(south,dir=SOUTH)
	full.Insert(east,dir=EAST)
	full.Insert(west,dir=WEST)
	qdel(north)
	qdel(south)
	qdel(east)
	qdel(west)
	return full

/proc/downloadImage(atom/A, dir)
	var/icon/this_icon = getFlatIcon(A,defdir=dir)

	usr << ftp(this_icon,"[A.name].png")

/mob/proc/AddCamoOverlay(atom/A)//A is the atom which we are using as the overlay.
	var/icon/opacity_icon = new(A.icon, A.icon_state)//Don't really care for overlays/underlays.
	//Now we need to culculate overlays+underlays and add them together to form an image for a mask.
	//var/icon/alpha_mask = getFlatIcon(src)//Accurate but SLOW. Not designed for running each tick. Could have other uses I guess.
	var/icon/alpha_mask = getIconMask(src)//Which is why I created that proc. Also a little slow since it's blending a bunch of icons together but good enough.
	opacity_icon.AddAlphaMask(alpha_mask)//Likely the main source of lag for this proc. Probably not designed to run each tick.
	opacity_icon.ChangeOpacity(0.4)//Front end for MapColors so it's fast. 0.5 means half opacity and looks the best in my opinion.
	for(var/i=0,i<5,i++)//And now we add it as overlays. It's faster than creating an icon and then merging it.
		var/image/I = image("icon" = opacity_icon, "icon_state" = A.icon_state, "layer" = layer+0.8)//So it's above other stuff but below weapons and the like.
		switch(i)//Now to determine offset so the result is somewhat blurred.
			if(1)	I.pixel_x--
			if(2)	I.pixel_x++
			if(3)	I.pixel_y--
			if(4)	I.pixel_y++
		overlays += I//And finally add the overlay.

/proc/getHologramIcon(icon/A, safety=1, no_color = FALSE)//If safety is on, a new icon is not created.
	var/icon/flat_icon = safety ? A : new(A)//Has to be a new icon to not constantly change the same icon.
	/* VOREStation Removal - For AI Vore effects
	if(!no_color)
		flat_icon.ColorTone(rgb(125,180,225))//Let's make it bluish.
	flat_icon.ChangeOpacity(0.5)//Make it half transparent.
	*/ //VOREStation Removal End
	var/icon/alpha_mask = new('icons/effects/effects.dmi', "scanline")//Scanline effect.
	flat_icon.AddAlphaMask(alpha_mask)//Finally, let's mix in a distortion effect.
	return flat_icon

//For photo camera.
/proc/build_composite_icon(atom/A)
	var/icon/composite = icon(A.icon, A.icon_state, A.dir, 1)
	for(var/O in A.overlays)
		var/image/I = O
		composite.Blend(icon(I.icon, I.icon_state, I.dir, 1), ICON_OVERLAY)
	return composite

GLOBAL_LIST_EMPTY(icon_state_lists)
/proc/cached_icon_states(var/icon/I)
	if(!I)
		return list()
	var/key = I
	var/returnlist = GLOB.icon_state_lists[key]
	if(!returnlist)
		returnlist = icon_states(I)
		if(isfile(I)) // It's something that will stick around
			GLOB.icon_state_lists[key] = returnlist
	return returnlist

/proc/expire_states_cache(var/key)
	if(GLOB.icon_state_lists[key])
		GLOB.icon_state_lists -= key
		return TRUE
	return FALSE

GLOBAL_LIST_EMPTY(cached_examine_icons)
/proc/set_cached_examine_icon(var/atom/A, var/icon/I, var/expiry = 12000)
	GLOB.cached_examine_icons[WEAKREF(A)] = I
	if(expiry)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(uncache_examine_icon), WEAKREF(A)), expiry, TIMER_UNIQUE)

/proc/get_cached_examine_icon(var/atom/A)
	var/datum/weakref/WR = WEAKREF(A)
	return GLOB.cached_examine_icons[WR]

/proc/uncache_examine_icon(var/datum/weakref/WR)
	GLOB.cached_examine_icons -= WR

/proc/adjust_brightness(var/color, var/value)
	if (!color) return "#FFFFFF"
	if (!value) return color

	var/list/RGB = rgb2num(color)
	RGB[1] = CLAMP(RGB[1]+value,0,255)
	RGB[2] = CLAMP(RGB[2]+value,0,255)
	RGB[3] = CLAMP(RGB[3]+value,0,255)
	return rgb(RGB[1],RGB[2],RGB[3])

/proc/sort_atoms_by_layer(var/list/atoms)
	// Comb sort icons based on levels
	var/list/result = atoms.Copy()
	var/gap = result.len
	var/swapped = 1
	while (gap > 1 || swapped)
		swapped = 0
		if(gap > 1)
			gap = round(gap / 1.3) // 1.3 is the emperic comb sort coefficient
		if(gap < 1)
			gap = 1
		for(var/i = 1; gap + i <= result.len; i++)
			var/atom/l = result[i]		//Fucking hate
			var/atom/r = result[gap+i]	//how lists work here
			if(l.layer > r.layer)		//no "result[i].layer" for me
				result.Swap(i, gap + i)
				swapped = 1
	return result

/proc/gen_hud_image(var/file, var/person, var/state, var/plane)
	var/image/img = image(file, person, state)
	img.plane = plane //Thanks Byond.
	img.layer = MOB_LAYER-0.2
	img.appearance_flags = APPEARANCE_UI
	return img

/**
* Animate a 'halo' around an object.
*
* This proc is not exactly cheap. You'd be well advised to set up many-loops rather than call this super-often. getCompoundIcon is
* mostly to blame for this. If Byond ever implements a way to get something's icon more 'gently' than this, do that instead.
*
* @param A This is the atom to put the halo on
* @param simple_icons If set to TRUE, will just perform a very basic icon and icon_state steal. DO USE when possible.
* @param color This is the color for the halo
* @param anim_duration This decides how fast (or slow) the animation plays
* @param offset Mysterious variable that determines size of the halo's gap from icon
* @param loops How many times the animation loops
* @param grow_to Relative to the size of the icon, how big the halo grows while fading (don't use negatives for inward halos, use < 1)
* @param pixel_scale If you'd like the halo to use pixel scale or the default 'fuzzy' scale
*/
/proc/animate_aura(var/atom/A, var/simple_icons, var/color = "#00FF22", var/anim_duration = 5, var/offset = 1, var/loops = 1, var/grow_to = 2, var/pixel_scale = FALSE)
	ASSERT(A)

	//Take a guess at this, if they didn't set it
	if(isnull(simple_icons))
		if(ismob(A))
			simple_icons = FALSE
		else
			simple_icons = TRUE

	//Get their icon
	var/icon/hole

	if(simple_icons)
		hole = icon(A.icon, A.icon_state)
	else
		hole = getCompoundIcon(A)

	hole.MapColors(0,0,0, 0,0,0, 0,0,0, 1,1,1) //White.

	//Make a bigger version
	var/icon/grower = new(hole)
	var/orig_width = grower.Width()
	var/orig_height = grower.Height()
	var/end_width = orig_width+(offset*2)
	var/end_height = orig_height+(offset*2)
	var/half_diff_width = (end_width-orig_width)*0.5
	var/half_diff_height = (end_height-orig_height)*0.5

	//Make icon black
	grower.SwapColor("#FFFFFF","#000000") //Black.

	//Scale both icons big so we don't have to deal with low-pixel garbage issues
	grower.Scale(orig_width*10,orig_height*10)
	hole.Scale(orig_width*9,orig_height*9)

	//Blend the hole in
	grower.Blend(hole,ICON_OVERLAY, x = ((orig_width*10-orig_width*9)*0.5)+1, y = ((orig_height*10-orig_height*9)*0.5)+1)

	//Swap white to zero alpha
	grower.SwapColor("#FFFFFF","#00000000")

	//Color it
	grower.SwapColor("#000000",color)

	//Scale it to final height
	grower.Scale(end_width,end_height)

	//Flick it onto them
	var/image/img = image(grower,A)
	if(pixel_scale)
		img.appearance_flags |= PIXEL_SCALE
	img.pixel_x = half_diff_width*-1
	img.pixel_y = half_diff_height*-1
	flick_overlay_view(img, A, anim_duration*loops, TRUE)

	//Animate it growing
	animate(img, alpha = 0, transform = matrix()*grow_to, time = anim_duration, loop = loops)

/// generates a filename for a given asset.
/// like generate_asset_name(), except returns the rsc reference and the rsc file hash as well as the asset name (sans extension)
/// used so that certain asset files dont have to be hashed twice
/proc/generate_and_hash_rsc_file(file, dmi_file_path)
	var/rsc_ref = fcopy_rsc(file)
	var/hash
	//if we have a valid dmi file path we can trust md5'ing the rsc file because we know it doesnt have the bug described in http://www.byond.com/forum/post/2611357
	if(dmi_file_path)
		hash = md5(rsc_ref)
	else //otherwise, we need to do the expensive fcopy() workaround
		hash = md5asfile(rsc_ref)

	return list(rsc_ref, hash, "asset.[hash]")

///given a text string, returns whether it is a valid dmi icons folder path
/proc/is_valid_dmi_file(icon_path)
	if(!istext(icon_path) || !length(icon_path))
		return FALSE

	var/is_in_icon_folder = findtextEx(icon_path, "icons/")
	var/is_dmi_file = findtextEx(icon_path, ".dmi")

	if(is_in_icon_folder && is_dmi_file)
		return TRUE
	return FALSE

/// given an icon object, dmi file path, or atom/image/mutable_appearance, attempts to find and return an associated dmi file path.
/// a weird quirk about dm is that /icon objects represent both compile-time or dynamic icons in the rsc,
/// but stringifying rsc references returns a dmi file path
/// ONLY if that icon represents a completely unchanged dmi file from when the game was compiled.
/// so if the given object is associated with an icon that was in the rsc when the game was compiled, this returns a path. otherwise it returns ""
/proc/get_icon_dmi_path(icon/icon)
	/// the dmi file path we attempt to return if the given object argument is associated with a stringifiable icon
	/// if successful, this looks like "icons/path/to/dmi_file.dmi"
	var/icon_path = ""

	if(isatom(icon) || istype(icon, /image) || istype(icon, /mutable_appearance))
		var/atom/atom_icon = icon
		icon = atom_icon.icon
		//atom icons compiled in from 'icons/path/to/dmi_file.dmi' are weird and not really icon objects that you generate with icon().
		//if theyre unchanged dmi's then they're stringifiable to "icons/path/to/dmi_file.dmi"

	if(isicon(icon) && isfile(icon))
		//icons compiled in from 'icons/path/to/dmi_file.dmi' at compile time are weird and arent really /icon objects,
		///but they pass both isicon() and isfile() checks. theyre the easiest case since stringifying them gives us the path we want
		var/icon_ref = "\ref[icon]"
		var/locate_icon_string = "[locate(icon_ref)]"

		icon_path = locate_icon_string

	else if(isicon(icon) && "[icon]" == "/icon")
		// icon objects generated from icon() at runtime are icons, but they ARENT files themselves, they represent icon files.
		// if the files they represent are compile time dmi files in the rsc, then
		// the rsc reference returned by fcopy_rsc() will be stringifiable to "icons/path/to/dmi_file.dmi"
		var/rsc_ref = fcopy_rsc(icon)

		var/icon_ref = "\ref[rsc_ref]"

		var/icon_path_string = "[locate(icon_ref)]"

		icon_path = icon_path_string

	else if(istext(icon))
		var/rsc_ref = fcopy_rsc(icon)
		//if its the text path of an existing dmi file, the rsc reference returned by fcopy_rsc() will be stringifiable to a dmi path

		var/rsc_ref_ref = "\ref[rsc_ref]"
		var/rsc_ref_string = "[locate(rsc_ref_ref)]"

		icon_path = rsc_ref_string

	if(is_valid_dmi_file(icon_path))
		return icon_path

	return FALSE

/**
 * generate an asset for the given icon or the icon of the given appearance for [thing], and send it to any clients in target.
 * Arguments:
 * * thing - either a /icon object, or an object that has an appearance (atom, image, mutable_appearance).
 * * target - either a reference to or a list of references to /client's or mobs with clients
 * * icon_state - string to force a particular icon_state for the icon to be used
 * * dir - dir number to force a particular direction for the icon to be used
 * * frame - what frame of the icon_state's animation for the icon being used
 * * moving - whether or not to use a moving state for the given icon
 * * sourceonly - if TRUE, only generate the asset and send back the asset url, instead of tags that display the icon to players
 * * extra_clases - string of extra css classes to use when returning the icon string
 */
/proc/icon2html(atom/thing, client/target, icon_state, dir = SOUTH, frame = 1, moving = FALSE, sourceonly = FALSE, extra_classes = null)
	if (!thing)
		return
	//if(SSlag_switch.measures[DISABLE_USR_ICON2HTML] && usr && !HAS_TRAIT(usr, TRAIT_BYPASS_MEASURES))
		//return

	var/key
	var/icon/icon2collapse = thing

	if (!target)
		return
	if (target == world)
		target = GLOB.clients

	var/list/targets
	if (!islist(target))
		targets = list(target)
	else
		targets = target
	if(!length(targets))
		return

	//check if the given object is associated with a dmi file in the icons folder. if it is then we dont need to do a lot of work
	//for asset generation to get around byond limitations
	var/icon_path = get_icon_dmi_path(thing)

	if (!isicon(icon2collapse))
		if (isfile(thing)) //special snowflake
			//var/name = SANITIZE_FILENAME("[generate_asset_name(thing)].png")
			var/name = "[generate_asset_name(thing)].png"
			if (!SSassets.cache[name])
				register_asset(name, thing)
			for (var/thing2 in targets)
				send_asset(thing2, name)
			if(sourceonly)
				return get_asset_url(name)
			return "<img class='[extra_classes] icon icon-misc' src='[get_asset_url(name)]'>"

		//its either an atom, image, or mutable_appearance, we want its icon var
		icon2collapse = thing.icon

		if (isnull(icon_state))
			icon_state = thing.icon_state
			//Despite casting to atom, this code path supports mutable appearances, so let's be nice to them
			//if(isnull(icon_state) || (isatom(thing) && thing.flags_1 & HTML_USE_INITAL_ICON_1))
			if(isnull(icon_state) || isatom(thing))
				icon_state = initial(thing.icon_state)
				if (isnull(dir))
					dir = initial(thing.dir)

		if (isnull(dir))
			dir = thing.dir

		if (ishuman(thing)) // Shitty workaround for a BYOND issue.
			var/icon/temp = icon2collapse
			icon2collapse = icon()
			icon2collapse.Insert(temp, dir = SOUTH)
			dir = SOUTH
	else
		if (isnull(dir))
			dir = SOUTH
		if (isnull(icon_state))
			icon_state = ""

	icon2collapse = icon(icon2collapse, icon_state, dir, frame, moving)

	var/list/name_and_ref = generate_and_hash_rsc_file(icon2collapse, icon_path)//pretend that tuples exist

	var/rsc_ref = name_and_ref[1] //weird object thats not even readable to the debugger, represents a reference to the icons rsc entry
	var/file_hash = name_and_ref[2]
	key = "[name_and_ref[3]].png"

	if(!SSassets.cache[key])
		register_asset(key, rsc_ref, file_hash, icon_path)
	for (var/client_target in targets)
		send_asset(client_target, key)
	if(sourceonly)
		return get_asset_url(key)
	return "<img class='[extra_classes] icon icon-[icon_state]' src='[get_asset_url(key)]'>"

//Costlier version of icon2html() that uses getFlatIcon() to account for overlays, underlays, etc. Use with extreme moderation, ESPECIALLY on mobs.
/proc/costly_icon2html(thing, target, sourceonly = FALSE)
	if (!thing)
		return
	//if(SSlag_switch.measures[DISABLE_USR_ICON2HTML] && usr && !HAS_TRAIT(usr, TRAIT_BYPASS_MEASURES))
		//return

	if (isicon(thing))
		return icon2html(thing, target)

	var/icon/I = getFlatIcon(thing)
	return icon2html(I, target, sourceonly = sourceonly)
