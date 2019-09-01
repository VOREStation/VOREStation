/proc/AverageColor(var/icon/I, var/accurate = 0, var/ignoreGreyscale = 0)
//Accurate: Use more accurate color averaging, usually has better results and prevents muddied or overly dark colors. Mad thanks to wwjnc.
//ignoreGreyscale: Excempts greyscale colors from the color list, useful for filtering outlines or plate overlays.
	var/list/colors = ListColors(I, ignoreGreyscale)
	if(!colors.len)
		return null

	var/list/colorsum = list(0, 0, 0) //Holds the sum of the RGB values to calculate the average
	var/list/RGB = list(0, 0, 0) //Temp list for each color
	var/total = colors.len

	var/final_average
	if (accurate) //keeping it legible
		for(var/i = 1 to total)
			RGB = ReadRGB(colors[i])
			colorsum[1] += RGB[1]*RGB[1]
			colorsum[2] += RGB[2]*RGB[2]
			colorsum[3] += RGB[3]*RGB[3]
		final_average = rgb(sqrt(colorsum[1]/total), sqrt(colorsum[2]/total), sqrt(colorsum[3]/total))
	else
		for(var/i = 1 to total)
			RGB = ReadRGB(colors[i])
			colorsum[1] += RGB[1]
			colorsum[2] += RGB[2]
			colorsum[3] += RGB[3]
		final_average = rgb(colorsum[1]/total, colorsum[2]/total, colorsum[3]/total)
	return final_average

/proc/ListColors(var/icon/I, var/ignoreGreyscale = 0)
	var/list/colors = list()
	for(var/x_pixel = 1 to I.Width())
		for(var/y_pixel = 1 to I.Height())
			var/this_color = I.GetPixel(x_pixel, y_pixel)
			if(this_color)
				if (ignoreGreyscale && ReadHSV(RGBtoHSV(this_color))[2] == 0) //If saturation is 0, must be greyscale
					continue
				colors.Add(this_color)
	return colors

/proc/empty_Y_space(var/icon/I) //Returns the amount of lines containing only transparent pixels in an icon, starting from the bottom
	for(var/y_pixel = 1 to I.Height())
		for(var/x_pixel = 1 to I.Width())
			if (I.GetPixel(x_pixel, y_pixel))
				return y_pixel - 1
	return null

//Standard behaviour is to cut pixels from the main icon that are covered by pixels from the mask icon unless passed mask_ready, see below.
/proc/get_icon_difference(var/icon/main, var/icon/mask, var/mask_ready)
	/*You should skip prep if the mask is already sprited properly. This significantly improves performance by eliminating most of the realtime icon work.
	e.g. A 'ready' mask is a mask where the part you want cut out is missing (no pixels, 0 alpha) from the sprite, and everything else is solid white.*/

	if(istype(main) && istype(mask))
		if(!mask_ready) //Prep the mask if we're using a regular old sprite and not a special-made mask.
			mask.Blend(rgb(255,255,255), ICON_SUBTRACT) //Make all pixels on the mask as black as possible.
			mask.Opaque(rgb(255,255,255)) //Make the transparent pixels (background) white.
			mask.BecomeAlphaMask() //Make all the black pixels vanish (fully transparent), leaving only the white background pixels.

		main.AddAlphaMask(mask) //Make the pixels in the main icon that are in the transparent zone of the mask icon also vanish (fully transparent).
		return main
