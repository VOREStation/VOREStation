/obj/screen/endoware
	icon = 'code/modules/cybernetics/assets/ui_elements.dmi'
	icon_state = ""

	//color = "#FF0800"
	plane = PLANE_ENDOWARE
	alpha = 0
	layer = 1

/obj/screen/endoware/warning
	icon_state = "!"
	pixel_x = -32

/obj/screen/endoware/greeble
	icon_state = "greebletxt"

/obj/screen/endoware/greeble/flicker()
	.=..()
	flick("greebletxt_anim",src)

/obj/screen/endoware/logo
	icon_state = "logo"


/obj/screen/endoware/warning_bg
	icon_state = "warn_bg"
	pixel_x = -32

/obj/screen/endoware/bracket/proc/adjust_to_height(var/height)
	height = max(height,32)
	var/matrix/scale_matrix = matrix()
	scale_matrix.Scale(1,height/32)
	animate(src, transform = scale_matrix, time = 5)

/obj/screen/endoware/bracket/l_bracket
	icon_state = "lbracket"
	pixel_x = 0

/obj/screen/endoware/bracket/r_bracket
	icon_state = "rbracket"
	pixel_x = 0

/obj/screen/endoware/text_background
	icon_state = "background"
	layer = 0

/obj/screen/endoware/text_background/proc/adjust_to_scale(var/x, var/y)
	var/matrix/scale_matrix = matrix()
	x = max(x,32)
	y = max(y,32)
	scale_matrix.Scale(x / 32, y / 32)
	animate(src, transform = scale_matrix, time = 5)

/obj/screen/endoware/maptextholder
	maptext_height = 64
	maptext_width = 9*32 //pixels
	maptext_x = ((9*32) - 32) * -0.5

/obj/screen/endoware/maptextholder/proc/set_maptext(var/newmaptext = "",var/size = 6, var/newcolor)
	var/end_text = sanitizeSafe(newmaptext)
	if(newcolor)
		src.maptext = MAPTEXT("<span style='text-align: center; font-size: [size]px; color: [newcolor];'>[end_text]</span>")
	else
		src.maptext = MAPTEXT("<span style='text-align: center; font-size: [size]px; '>[end_text]</span>")


/obj/screen/endoware/proc/flicker(var/wait_time = 3 SECONDS)
	var/matrix/standard = new
	var/matrix/flat_transform = new
	flat_transform.Scale(1,0)
	src.transform = flat_transform
	animate(src, transform = standard, time = 1, alpha = 255, easing = ELASTIC_EASING)
	//flicker
	animate(src, alpha=50, time = 0.5, loop = 3)
	animate(alpha = 255, time = 1)

	var/newfilter = filter(type = "bloom", size = 2, alpha = 128)
	filters += newfilter

	animate(filters[filters.len], alpha=50, time = 0.5, loop = 3)
	animate(alpha = 255, time = 1)
	//animate(src, alpha = 255, time = wait_time)


/mob/living/carbon/human/verb/fuck()

	var/text = input(src, "txt","txt") as text
	var/size = input(src, "num") as num
	var/newcolor = input(src,"fsdfsd") as color

	var/obj/screen/endoware/warning/warn = new
	var/obj/screen/endoware/warning_bg/bg = new
	var/obj/screen/endoware/bracket/l_bracket/lb = new
	var/obj/screen/endoware/bracket/r_bracket/rb = new
	var/obj/screen/endoware/text_background/tb = new
	var/obj/screen/endoware/maptextholder/mt = new
	var/obj/screen/endoware/greeble/greeble = new



	var/obj/screen/endoware/holder = new
	holder.alpha = 255


	mt.set_maptext(text, size, newcolor)
	var/textsize = client.MeasureText("<span style='text-align: center; font-size: [size]px;'>[sanitizeSafe(text)]</span>")
	world.log << text
	world.log << textsize

	var/width = text2num(splittext(textsize,"x")[1]) + 8
	var/height = text2num(splittext(textsize,"x")[2])
	if(width > (32*9))
		width = 32*9
		textsize = client.MeasureText("<span style='text-align: center; font-size: [size]px;'>[sanitizeSafe(text)]</span>",32*9)
		height = text2num(splittext(textsize,"x")[2])
		world.log << textsize
	if(height > 32)
		mt.maptext_y = height * -0.25
	holder.screen_loc = "CENTER"

	var/list/visuals = list(warn,bg,lb,rb,tb,mt,greeble)
	for(var/obj/screen/visual in visuals)
		holder.vis_contents += visual
		visual.color = newcolor


	src.client.screen += holder

	warn.flicker()
	bg.flicker()
	sleep(0.5 SECONDS)
	lb.flicker(0)
	rb.flicker(0)
	tb.flicker()
	sleep(0.5 SECONDS)

	animate(bg,pixel_x = -(width)/2 - 20, time = 5)
	animate(warn,pixel_x = -(width)/2 -20, time = 5)
	animate(lb,pixel_x = -width/2 + 16, time = 5)
	animate(rb,pixel_x = width/2 - 16, time = 5)



	tb.adjust_to_scale(width,height)
	lb.adjust_to_height(height)
	rb.adjust_to_height(height)
	sleep(5)
	greeble.pixel_x = -width/2 + 16
	greeble.pixel_y = 0 -32 - (((max(height,32) - 32)/2)+2)

	greeble.flicker()

	sleep(1 SECOND)
	mt.flicker()



	//sleep(10 SECONDS)
	//src.client.screen -= bg
	//src.client.screen -= warn
//	src.client.screen -= rb
//	src.client.screen -= lb
//	src.client.screen -= mt
