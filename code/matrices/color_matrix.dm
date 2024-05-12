/////////////////////
// COLOUR MATRICES //
/////////////////////

/* Documenting a couple of potentially useful color matrices here to inspire ideas.
// Greyscale - indentical to saturation @ 0
list(LUMA_R,LUMA_R,LUMA_R,0, LUMA_G,LUMA_G,LUMA_G,0, LUMA_B,LUMA_B,LUMA_B,0, 0,0,0,1, 0,0,0,0)

// Color inversion
list(-1,0,0,0, 0,-1,0,0, 0,0,-1,0, 0,0,0,1, 1,1,1,0)

// Sepiatone
list(0.393,0.349,0.272,0, 0.769,0.686,0.534,0, 0.189,0.168,0.131,0, 0,0,0,1, 0,0,0,0)
*/

/// Does nothing.
/proc/color_matrix_identity()
	return list(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1, 0,0,0,0)

/**
 * Adds/subtracts overall lightness.
 * 0 is identity, 1 makes everything white, -1 makes everything black.
 */
/proc/color_matrix_lightness(power)
	return list(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1, power,power,power,0)

/**
 * Changes distance hues have from grey while maintaining the overall lightness. Greys are unaffected.
 * 1 is identity, 0 is greyscale, >1 oversaturates colors.
 */
/proc/color_matrix_saturation(value)
	var/inv = 1 - value
	var/R = round(LUMA_R * inv, 0.001)
	var/G = round(LUMA_G * inv, 0.001)
	var/B = round(LUMA_B * inv, 0.001)

	return list(R + value,R,R,0, G,G + value,G,0, B,B,B + value,0, 0,0,0,1, 0,0,0,0)

/**
 * Exxagerates or removes colors.
 */
/proc/color_matrix_saturation_percent(percent)
	if(percent == 0)
		return color_matrix_identity()
	percent = clamp(percent, -100, 100)
	if(percent > 0)
		percent *= 3
	var/x = 1 + percent / 100
	var/inv = 1 - x
	var/R = LUMA_R * inv
	var/G = LUMA_G * inv
	var/B = LUMA_B * inv

	return list(R + x,R,R, G,G + x,G, B,B,B + x)

/**
 * Greyscale matrix.
 */
/proc/color_matrix_greyscale()
	return list(LUMA_R, LUMA_R, LUMA_R, LUMA_G, LUMA_G, LUMA_G, LUMA_B, LUMA_B, LUMA_B)

/**
 * Changes distance colors have from rgb(127,127,127) grey.
 * 1 is identity. 0 makes everything grey >1 blows out colors and greys.
 */
/proc/color_matrix_contrast(value)
	var/add = (1 - value) / 2
	return list(value,0,0,0, 0,value,0,0, 0,0,value,0, 0,0,0,1, add,add,add,0)

/**
 * Exxagerates or removes brightness.
 */
/proc/color_matrix_contrast_percent(percent)
	var/static/list/delta_index = list(
		0,    0.01, 0.02, 0.04, 0.05, 0.06, 0.07, 0.08, 0.1,  0.11,
		0.12, 0.14, 0.15, 0.16, 0.17, 0.18, 0.20, 0.21, 0.22, 0.24,
		0.25, 0.27, 0.28, 0.30, 0.32, 0.34, 0.36, 0.38, 0.40, 0.42,
		0.44, 0.46, 0.48, 0.5,  0.53, 0.56, 0.59, 0.62, 0.65, 0.68,
		0.71, 0.74, 0.77, 0.80, 0.83, 0.86, 0.89, 0.92, 0.95, 0.98,
		1.0,  1.06, 1.12, 1.18, 1.24, 1.30, 1.36, 1.42, 1.48, 1.54,
		1.60, 1.66, 1.72, 1.78, 1.84, 1.90, 1.96, 2.0,  2.12, 2.25,
		2.37, 2.50, 2.62, 2.75, 2.87, 3.0,  3.2,  3.4,  3.6,  3.8,
		4.0,  4.3,  4.7,  4.9,  5.0,  5.5,  6.0,  6.5,  6.8,  7.0,
		7.3,  7.5,  7.8,  8.0,  8.4,  8.7,  9.0,  9.4,  9.6,  9.8,
		10.0)
	percent = clamp(percent, -100, 100)
	if(percent == 0)
		return color_matrix_identity()

	var/x = 0
	if (percent < 0)
		x = 127 + percent / 100 * 127;
	else
		x = percent % 1
		if(x == 0)
			x = delta_index[percent]
		else
			x = delta_index[percent] * (1-x) + delta_index[percent+1] * x//use linear interpolation for more granularity.
		x = x * 127 + 127

	var/mult = x / 127
	var/add = 0.5 * (127-x) / 255
	return list(mult,0,0, 0,mult,0, 0,0,mult, add,add,add)

/**
 * Moves all colors angle degrees around the color wheel while maintaining intensity of the color and not affecting greys.
 * 0 is identity, 120 moves reds to greens, 240 moves reds to blues.
 */
//
//
/proc/color_matrix_rotate_hue(angle)
	var/sin = sin(angle)
	var/cos = cos(angle)
	var/cos_inv_third = 0.333*(1-cos)
	var/sqrt3_sin = sqrt(3)*sin
	return list(
		round(cos+cos_inv_third, 0.001), round(cos_inv_third+sqrt3_sin, 0.001), round(cos_inv_third-sqrt3_sin, 0.001), 0,
		round(cos_inv_third-sqrt3_sin, 0.001), round(cos+cos_inv_third, 0.001), round(cos_inv_third+sqrt3_sin, 0.001), 0,
		round(cos_inv_third+sqrt3_sin, 0.001), round(cos_inv_third-sqrt3_sin, 0.001), round(cos+cos_inv_third, 0.001), 0,
		0,0,0,1,
		0,0,0,0,
	)

/**
 * Moves all colors angle degrees around the color wheel while maintaining intensity of the color and not affecting whites.
 * TODO: Need a version that only affects one color (ie shift red to blue but leave greens and blues alone)
 */
/proc/color_matrix_rotation(angle)
	if(angle == 0)
		return color_matrix_identity()
	angle = clamp(angle, -180, 180)
	var/cos = cos(angle)
	var/sin = sin(angle)

	var/constA = 0.143
	var/constB = 0.140
	var/constC = -0.283
	return list(
		LUMA_R + cos * (1-LUMA_R) + sin * -LUMA_R, LUMA_R + cos * -LUMA_R + sin * constA, LUMA_R + cos * -LUMA_R + sin * -(1-LUMA_R),
		LUMA_G + cos * -LUMA_G + sin * -LUMA_G, LUMA_G + cos * (1-LUMA_G) + sin * constB, LUMA_G + cos * -LUMA_G + sin * LUMA_G,
		LUMA_B + cos * -LUMA_B + sin * (1-LUMA_B), LUMA_B + cos * -LUMA_B + sin * constC, LUMA_B + cos * (1-LUMA_B) + sin * LUMA_B
	)

/**
 * These next three rotate values about one axis only.
 * x is the red axis, y is the green axis, z is the blue axis.
 */
/proc/color_matrix_rotate_x(angle)
	var/sinval = round(sin(angle), 0.001)
	var/cosval = round(cos(angle), 0.001)
	return list(1,0,0,0, 0,cosval,sinval,0, 0,-sinval,cosval,0, 0,0,0,1, 0,0,0,0)

/proc/color_matrix_rotate_y(angle)
	var/sinval = round(sin(angle), 0.001)
	var/cosval = round(cos(angle), 0.001)
	return list(cosval,0,-sinval,0, 0,1,0,0, sinval,0,cosval,0, 0,0,0,1, 0,0,0,0)

/proc/color_matrix_rotate_z(angle)
	var/sinval = round(sin(angle), 0.001)
	var/cosval = round(cos(angle), 0.001)
	return list(cosval,sinval,0,0, -sinval,cosval,0,0, 0,0,1,0, 0,0,0,1, 0,0,0,0)

/**
 * Builds a color matrix that transforms the hue, saturation, and value, all in one operation.
 */
/proc/color_matrix_hsv(hue, saturation, value)
	hue = clamp(360 - hue, 0, 360)

	// This is very much a rough approximation of hueshifting. This carries some artifacting, such as negative values that simply shouldn't exist, but it does get the job done, and that's what matters.
	var/cos_a = cos(hue) // These have to be inverted from 360, otherwise the hue's inverted
	var/sin_a = sin(hue)
	var/rot_x = cos_a + (1 - cos_a) / 3
	var/rot_y = (1 - cos_a) / 3 - 0.5774 * sin_a // 0.5774 is sqrt(1/3)
	var/rot_z = (1 - cos_a) / 3 + 0.5774 * sin_a

	return list(
		round((((1-saturation) * LUMA_R) + (rot_x * saturation)) * value, 0.01), round((((1-saturation) * LUMA_R) + (rot_y * saturation)) * value, 0.01), round((((1-saturation) * LUMA_R) + (rot_z * saturation)) * value, 0.01),
		round((((1-saturation) * LUMA_G) + (rot_z * saturation)) * value, 0.01), round((((1-saturation) * LUMA_G) + (rot_x * saturation)) * value, 0.01), round((((1-saturation) * LUMA_G) + (rot_y * saturation)) * value, 0.01),
		round((((1-saturation) * LUMA_B) + (rot_y * saturation)) * value, 0.01), round((((1-saturation) * LUMA_B) + (rot_z * saturation)) * value, 0.01), round((((1-saturation) * LUMA_B) + (rot_x * saturation)) * value, 0.01),
		0, 0, 0
	)

/**
 * Returns a matrix addition of A with B.
 */
/proc/color_matrix_add(list/A, list/B)
	if(!istype(A) || !istype(B))
		return color_matrix_identity()
	if(A.len != 20 || B.len != 20)
		return color_matrix_identity()
	var/list/output = list()
	output.len = 20
	for(var/value in 1 to 20)
		output[value] = A[value] + B[value]
	return output

/**
 * Returns a matrix multiplication of A with B.
 */
/proc/color_matrix_multiply(list/A, list/B)
	if(!istype(A) || !istype(B))
		return color_matrix_identity()
	if(A.len != 20 || B.len != 20)
		return color_matrix_identity()
	var/list/output = list()
	output.len = 20
	var/x = 1
	var/y = 1
	var/offset = 0
	for(y in 1 to 5)
		offset = (y-1)*4
		for(x in 1 to 4)
			output[offset+x] = round(A[offset+1]*B[x] + A[offset+2]*B[x+4] + A[offset+3]*B[x+8] + A[offset+4]*B[x+12]+(y==5?B[x+16]:0), 0.001)
	return output

/**
 * Assembles a color matrix, defaulting to identity.
 */
/proc/rgb_construct_color_matrix(rr = 1, rg, rb, gr, gg = 1, gb, br, bg, bb = 1, cr, cg, cb)
	return list(rr, rg, rb, gr, gg, gb, br, bg, bb, cr, cg, cb)

/**
 * Assembles a color matrix, defaulting to identity.
 */
/proc/rgba_construct_color_matrix(rr = 1, rg, rb, ra, gr, gg = 1, gb, ga, br, bg, bb = 1, ba, ar, ag, ab, aa = 1, cr, cg, cb, ca)
	return list(rr, rg, rb, ra, gr, gg, gb, ga, br, bg, bb, ba, ar, ag, ab, aa, cr, cg, cb, ca)

/**
 * Constructs a colored greyscale matrix.
 * WARNING: Bad math up ahead.
 */
/proc/rgba_auto_greyscale_matrix(rgba_string)
	// process rgb(a)
	var/list/L1 = ReadRGB(rgba_string)
	ASSERT(L1.len)
	if(L1.len == 3)
		return rgba_construct_color_matrix(0.39, 0.39, 0.39, 0, 0.5, 0.5, 0.5, 0, 0.11, 0.11, 0.11, 0, 0, 0, 0, 1, max(-0.5, (L1[1] - 255) / 255), max(-0.5, (L1[2] - 255) / 255), max(-0.5, (L1[3] - 255) / 255), 0)
	else
		// alpha
		return rgba_construct_color_matrix(0.39, 0.39, 0.39, 0, 0.5, 0.5, 0.5, 0, 0.11, 0.11, 0.11, 0, 0, 0, 0, 0, max(-0.5, (L1[1] - 255) / 255), max(-0.5, (L1[2] - 255) / 255), max(-0.5, (L1[3] - 255) / 255), L1[4] / 255)
