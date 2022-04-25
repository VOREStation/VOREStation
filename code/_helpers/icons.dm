<<<<<<< HEAD
=======
/*
IconProcs README

A BYOND library for manipulating icons and colors

by Lummox JR

version 1.0

The IconProcs library was made to make a lot of common icon operations much easier. BYOND's icon manipulation
routines are very capable but some of the advanced capabilities like using alpha transparency can be unintuitive to beginners.

CHANGING ICONS

Several new procs have been added to the /icon datum to simplify working with icons. To use them,
remember you first need to setup an /icon var like so:

	var/icon/my_icon = new('iconfile.dmi')

icon/ChangeOpacity(amount = 1)
    A very common operation in DM is to try to make an icon more or less transparent. Making an icon more
    transparent is usually much easier than making it less so, however. This proc basically is a frontend
    for MapColors() which can change opacity any way you like, in much the same way that SetIntensity()
    can make an icon lighter or darker. If amount is 0.5, the opacity of the icon will be cut in half.
    If amount is 2, opacity is doubled and anything more than half-opaque will become fully opaque.
icon/GrayScale()
    Converts the icon to grayscale instead of a fully colored icon. Alpha values are left intact.
icon/ColorTone(tone)
    Similar to GrayScale(), this proc converts the icon to a range of black -> tone -> white, where tone is an
    RGB color (its alpha is ignored). This can be used to create a sepia tone or similar effect.
    See also the global ColorTone() proc.
icon/MinColors(icon)
    The icon is blended with a second icon where the minimum of each RGB pixel is the result.
    Transparency may increase, as if the icons were blended with ICON_ADD. You may supply a color in place of an icon.
icon/MaxColors(icon)
    The icon is blended with a second icon where the maximum of each RGB pixel is the result.
    Opacity may increase, as if the icons were blended with ICON_OR. You may supply a color in place of an icon.
icon/Opaque(background = "#000000")
    All alpha values are set to 255 throughout the icon. Transparent pixels become black, or whatever background color you specify.
icon/BecomeAlphaMask()
    You can convert a simple grayscale icon into an alpha mask to use with other icons very easily with this proc.
    The black parts become transparent, the white parts stay white, and anything in between becomes a translucent shade of white.
icon/AddAlphaMask(mask)
    The alpha values of the mask icon will be blended with the current icon. Anywhere the mask is opaque,
    the current icon is untouched. Anywhere the mask is transparent, the current icon becomes transparent.
    Where the mask is translucent, the current icon becomes more transparent.
icon/UseAlphaMask(mask, mode)
    Sometimes you may want to take the alpha values from one icon and use them on a different icon.
    This proc will do that. Just supply the icon whose alpha mask you want to use, and src will change
    so it has the same colors as before but uses the mask for opacity.

COLOR MANAGEMENT AND HSV

RGB isn't the only way to represent color. Sometimes it's more useful to work with a model called HSV, which stands for hue, saturation, and value.

    * The hue of a color describes where it is along the color wheel. It goes from red to yellow to green to
    cyan to blue to magenta and back to red.
    * The saturation of a color is how much color is in it. A color with low saturation will be more gray,
    and with no saturation at all it is a shade of gray.
    * The value of a color determines how bright it is. A high-value color is vivid, moderate value is dark,
    and no value at all is black.

Just as BYOND uses "#rrggbb" to represent RGB values, a similar format is used for HSV: "#hhhssvv". The hue is three
hex digits because it ranges from 0 to 0x5FF.

    * 0 to 0xFF - red to yellow
    * 0x100 to 0x1FF - yellow to green
    * 0x200 to 0x2FF - green to cyan
    * 0x300 to 0x3FF - cyan to blue
    * 0x400 to 0x4FF - blue to magenta
    * 0x500 to 0x5FF - magenta to red

Knowing this, you can figure out that red is "#000ffff" in HSV format, which is hue 0 (red), saturation 255 (as colorful as possible),
value 255 (as bright as possible). Green is "#200ffff" and blue is "#400ffff".

More than one HSV color can match the same RGB color.

Here are some procs you can use for color management:

ReadRGB(rgb)
    Takes an RGB string like "#ffaa55" and converts it to a list such as list(255,170,85). If an RGBA format is used
    that includes alpha, the list will have a fourth item for the alpha value.
hsv(hue, sat, val, apha)
    Counterpart to rgb(), this takes the values you input and converts them to a string in "#hhhssvv" or "#hhhssvvaa"
    format. Alpha is not included in the result if null.
ReadHSV(rgb)
    Takes an HSV string like "#100FF80" and converts it to a list such as list(256,255,128). If an HSVA format is used that
    includes alpha, the list will have a fourth item for the alpha value.
RGBtoHSV(rgb)
    Takes an RGB or RGBA string like "#ffaa55" and converts it into an HSV or HSVA color such as "#080aaff".
HSVtoRGB(hsv)
    Takes an HSV or HSVA string like "#080aaff" and converts it into an RGB or RGBA color such as "#ff55aa".
BlendRGB(rgb1, rgb2, amount)
    Blends between two RGB or RGBA colors using regular RGB blending. If amount is 0, the first color is the result;
    if 1, the second color is the result. 0.5 produces an average of the two. Values outside the 0 to 1 range are allowed as well.
    The returned value is an RGB or RGBA color.
BlendHSV(hsv1, hsv2, amount)
    Blends between two HSV or HSVA colors using HSV blending, which tends to produce nicer results than regular RGB
    blending because the brightness of the color is left intact. If amount is 0, the first color is the result; if 1,
    the second color is the result. 0.5 produces an average of the two. Values outside the 0 to 1 range are allowed as well.
    The returned value is an HSV or HSVA color.
BlendRGBasHSV(rgb1, rgb2, amount)
    Like BlendHSV(), but the colors used and the return value are RGB or RGBA colors. The blending is done in HSV form.
HueToAngle(hue)
    Converts a hue to an angle range of 0 to 360. Angle 0 is red, 120 is green, and 240 is blue.
AngleToHue(hue)
    Converts an angle to a hue in the valid range.
RotateHue(hsv, angle)
    Takes an HSV or HSVA value and rotates the hue forward through red, green, and blue by an angle from 0 to 360.
    (Rotating red by 60deg produces yellow.) The result is another HSV or HSVA color with the same saturation and value
    as the original, but a different hue.
GrayScale(rgb)
    Takes an RGB or RGBA color and converts it to grayscale. Returns an RGB or RGBA string.
ColorTone(rgb, tone)
    Similar to GrayScale(), this proc converts an RGB or RGBA color to a range of black -> tone -> white instead of
    using strict shades of gray. The tone value is an RGB color; any alpha value is ignored.
*/

/*
Get Flat Icon DEMO by DarkCampainger

This is a test for the get flat icon proc, modified approprietly for icons and their states.
Probably not a good idea to run this unless you want to see how the proc works in detail.
mob
	icon = 'old_or_unused.dmi'
	icon_state = "green"

	Login()
		// Testing image underlays
		underlays += image(icon='old_or_unused.dmi',icon_state="red")
		underlays += image(icon='old_or_unused.dmi',icon_state="red", pixel_x = 32)
		underlays += image(icon='old_or_unused.dmi',icon_state="red", pixel_x = -32)

		// Testing image overlays
		overlays += image(icon='old_or_unused.dmi',icon_state="green", pixel_x = 32, pixel_y = -32)
		overlays += image(icon='old_or_unused.dmi',icon_state="green", pixel_x = 32, pixel_y = 32)
		overlays += image(icon='old_or_unused.dmi',icon_state="green", pixel_x = -32, pixel_y = -32)

		// Testing icon file overlays (defaults to mob's state)
		overlays += '_flat_demoIcons2.dmi'

		// Testing icon_state overlays (defaults to mob's icon)
		overlays += "white"

		// Testing dynamic icon overlays
		var/icon/I = icon('old_or_unused.dmi', icon_state="aqua")
		I.Shift(NORTH,16,1)
		overlays+=I

		// Testing dynamic image overlays
		I=image(icon=I,pixel_x = -32, pixel_y = 32)
		overlays+=I

		// Testing object types (and layers)
		overlays+=/obj/effect/overlayTest

		loc = locate (10,10,1)
	verb
		Browse_Icon()
			set name = "1. Browse Icon"
			// Give it a name for the cache
			var/iconName = "[ckey(src.name)]_flattened.dmi"
			// Send the icon to src's local cache
			src<<browse_rsc(getFlatIcon(src), iconName)
			// Display the icon in their browser
			src<<browse("<body bgcolor='#000000'><p><img src='[iconName]'></p></body>")

		Output_Icon()
			set name = "2. Output Icon"
			to_chat(src, "Icon is: [bicon(getFlatIcon(src))]")

		Label_Icon()
			set name = "3. Label Icon"
			// Give it a name for the cache
			var/iconName = "[ckey(src.name)]_flattened.dmi"
			// Copy the file to the rsc manually
			var/icon/I = fcopy_rsc(getFlatIcon(src))
			// Send the icon to src's local cache
			src<<browse_rsc(I, iconName)
			// Update the label to show it
			winset(src,"imageLabel","image='\ref[I]'");

		Add_Overlay()
			set name = "4. Add Overlay"
			overlays += image(icon='old_or_unused.dmi',icon_state="yellow",pixel_x = rand(-64,32), pixel_y = rand(-64,32))

		Stress_Test()
			set name = "5. Stress Test"
			for(var/i = 0 to 1000)
				// The third parameter forces it to generate a new one, even if it's already cached
				getFlatIcon(src,0,2)
				if(prob(5))
					Add_Overlay()
			Browse_Icon()

		Cache_Test()
			set name = "6. Cache Test"
			for(var/i = 0 to 1000)
				getFlatIcon(src)
			Browse_Icon()

/obj/effect/overlayTest
	icon = 'old_or_unused.dmi'
	icon_state = "blue"
	pixel_x = -24
	pixel_y = 24
	layer = TURF_LAYER // Should appear below the rest of the overlays

world
	view = "7x7"
	maxx = 20
	maxy = 20
	maxz = 1
*/

>>>>>>> 21bd8477c7e... Merge pull request #8531 from Spookerton/spkrtn/sys/global-agenda
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

		//sortTim(layers, /proc/cmp_image_layer_asc)

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
				add = getFlatIcon(image(I), I.dir||curdir, curicon, curstate, curblend, FALSE, no_anim)
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
	GLOB.cached_examine_icons[weakref(A)] = I
	if(expiry)
		addtimer(CALLBACK(GLOBAL_PROC, .proc/uncache_examine_icon, weakref(A)), expiry, TIMER_UNIQUE)

/proc/get_cached_examine_icon(var/atom/A)
	var/weakref/WR = weakref(A)
	return GLOB.cached_examine_icons[WR]

/proc/uncache_examine_icon(var/weakref/WR)
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
