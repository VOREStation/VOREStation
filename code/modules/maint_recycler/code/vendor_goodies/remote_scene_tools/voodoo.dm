#define DATA_SCALE "scale"
#define DATA_X_OFFSET "x"
#define DATA_Y_OFFSET "y"
#define DATA_ROTATION "rotation"
#define DEFAULT_RGB_OUTLINE rgb(50,50,50)

/obj/item/remote_scene_tool/voodoo_doll
	name = "voodoo doll"
	desc = "A dubiously cursed-esq Voodoo doll that mimics whoever is wearing its matching necklace via built in hardlight projection."
	icon = 'code/modules/maint_recycler/icons/goodies/remote_scene_tools.dmi'
	icon_state = "voodoo_doll_inactive"
	icon_root = "voodoo_doll"
	description_info = "The Doll acts as a remote scene tool - any sort of emotes or subtles that the wearer does will go DIRECTLY to the necklace! It's vague, so use it how you want in RP! Just remember bystander consent!"

	replacementType = /obj/item/remote_scene_tool/voodoo_necklace

	//this is just a copy of the remote scene tool, but with a different icon
	//and a different name

	var/underlayRotation = 45
	//TODO: make this generic so it's easier for other stuff to use. ideally there's a magical thing that just has all the various greebles set up so u can pick and choose which ones are rendered traditionally
	var/list/tail_data = list( DATA_X_OFFSET = 2, DATA_Y_OFFSET = -2,DATA_SCALE = 1.6, DATA_ROTATION = 45)
	var/list/taur_data = list( DATA_X_OFFSET = 2, DATA_Y_OFFSET = 2, DATA_SCALE = 1.1, DATA_ROTATION = 45)
	var/list/wing_data = list( DATA_X_OFFSET = 2, DATA_Y_OFFSET = -2,DATA_SCALE = 1,   DATA_ROTATION = 45)
	var/list/ear_data =  list( DATA_X_OFFSET = 0, DATA_Y_OFFSET = 1, DATA_SCALE = 1.5,   DATA_ROTATION = 45)
	var/list/hat_data =  list( DATA_X_OFFSET = 0, DATA_Y_OFFSET = 3, DATA_SCALE = 1,   DATA_ROTATION = 45)
	var/outline_size = 1

	var/list/discarded_layer_indicies = list(
		VORE_BELLY_LAYER, //not even gonna try with this lmfao
		TAIL_LOWER_LAYER,
		TAIL_UPPER_LAYER,
		TAIL_UPPER_LAYER_LOW,
		TAIL_UPPER_LAYER_HIGH, //drawn manually
		FIRE_LAYER, //not relevant
		TARGETED_LAYER, //not relevant
		MOB_WATER_LAYER, //not relevant
		L_HAND_LAYER, //not drawn, looks like ass
		R_HAND_LAYER,
		EARS_LAYER, //drawn manually
		WING_LAYER,
		WING_LOWER_LAYER, //drawn manually
		HEAD_LAYER, //drawn manually
	)
	appearance_flags = KEEP_TOGETHER
	var/no_fun_mode = FALSE //if true, we just draw the mob as an overlay

/obj/item/remote_scene_tool/voodoo_necklace
	name = "Gem-Encrusted Necklace"
	desc = "A bitingly cold metal necklace with a swirling gem in the center. Haters will say it's not magical"
	icon_state = "necklace_inactive"
	icon_root = "necklace"
	slot_flags = SLOT_MASK
	description_info = "The necklace and the associated doll act as remote scene tools - any sort of emotes or subtles that the wearer does will go DIRECTLY to the other! It's vague, so use it how you want in RP! Just remember bystander consent!"
	replacementType = /obj/item/remote_scene_tool/voodoo_doll

/obj/item/storage/box/remote_scene_tools/voodoo
	icon_state = "voodoobox"
	name = "Voodoo Supplies Box"
	desc = "a horribly dusty box from 'magici-corp' with a ludicrously corny image of a voodoo doll on the front."
	description_fluff = "originally marketed as part of a DIY magician routine, the company making them went under due to countless lawsuits from people who broke their nose upon the doll being dropped, and tesh filing descrimination suits. they haven't been made in well over a decade."
	primary =/obj/item/remote_scene_tool/voodoo_doll
	secondary =/obj/item/remote_scene_tool/voodoo_necklace

/obj/item/remote_scene_tool/voodoo_doll/verb/toggle_fun_mode()
	set name = "Disable Special Rendering"
	set desc = "Disables the displacement-based rendering on the doll, leaving it as just a doll at all times."
	no_fun_mode = !no_fun_mode
	to_chat(usr,span_notice("you turn the dial on the back of \the [src], and turn the advanced projection matrix [no_fun_mode ? "off" : "on"]"))
	update_icon() //force a refresh


/obj/item/remote_scene_tool/voodoo_doll/Move(atom/newloc, direct, movetime)
	. = ..()
	dir = SOUTH //we need to do this

/obj/item/remote_scene_tool/voodoo_doll/proc/get_outline_color(r,g,b,a, offset = 30)
	var/new_rgba = rgb(r-offset,g-offset,b-offset,a)
	return new_rgba

/obj/item/remote_scene_tool/voodoo_doll/proc/generate_layer_matrix(list/data)
	var/matrix/output = matrix()
	output.Translate(data[DATA_X_OFFSET], data[DATA_Y_OFFSET])
	output.Turn(data[DATA_ROTATION])
	output.Scale(data[DATA_SCALE], data[DATA_SCALE])
	return output

/obj/item/remote_scene_tool/voodoo_doll/proc/generate_layer_image(image/input, matrix/newtransform, outline_width = 0, outline_color = DEFAULT_RGB_OUTLINE)
	if(input == null)
		return null

	// Please for the love of fuck stop kidnapping taur bodies.
	var/image/doll_img = image(input)

	doll_img.dir = SOUTH
	doll_img.transform = newtransform
	doll_img.layer = FLOAT_LAYER
	doll_img.plane = FLOAT_PLANE // Strip PLANE_CH_STOMACH or mob-specific planes!
	doll_img.appearance_flags = NONE // Strip RESET_PLANE / KEEP_TOGETHER flags!

	if(outline_width > 0)
		doll_img.filters += filter(type="outline", size = outline_width, color = outline_color)

	return doll_img

/obj/item/remote_scene_tool/voodoo_doll/update_icon()
	. = ..()
	//reset
	overlays?.Cut()
	underlays?.Cut()
	filters = null
	dir = SOUTH
	name = initial(name)
	desc = initial(desc)
	var/matrix/rotateMatrix = matrix()
	transform = rotateMatrix

	if(!linked)
		return

	var/mob/owner = linked.getWearer()
	if(!owner) return;

	name = "Voodoo doll of " + owner.name
	desc = "A small, marketable doll that looks suspiciously like [owner]... "


	if(istype(owner,/mob/living/carbon/human/teshari)) return //no flesh horror, sorry

	if(!ismob(loc) && !ismob(loc.loc)) return //only render the funny when we're on a humie

	if(no_fun_mode) return //no fun allowed

	var/image/tail_image = null
	if(ishuman(owner))	//Am I a real boy now, papa?
		var/mob/living/carbon/human/buddy = owner
		var/datum/sprite_accessory/tail/tail_style = buddy.tail_style
		var/is_tail_taur = istaurtail(tail_style)

		var/icon/displacement_map = icon(src.icon, is_tail_taur ? "taurdisplacement" : "displacement", SOUTH)
		var/image/displacement_rendered = get_humanoid_displacement_map_image(buddy, discarded_layer_indicies, displacement_map, 2, null)

		//tails need special attention because taurs
		var/tailoutlinecolor = DEFAULT_RGB_OUTLINE //default to a grey, otherwise we use a darker version of one of the tail colors
		if(tail_style?.do_colouration)
			tailoutlinecolor = get_outline_color(buddy.r_tail, buddy.g_tail, buddy.b_tail, buddy.a_tail)

		// Let's get the tail image, checks species and custom tail!
		var/image/raw_tail = buddy.get_tail_image()
		if(raw_tail)
			var/image/full_tail = buddy.apply_tailsock_layer(raw_tail, apply_to_mob = FALSE)
			var/matrix/target_matrix = generate_layer_matrix(is_tail_taur ? taur_data : tail_data)
			var/image/cooked_tail = generate_layer_image(full_tail, target_matrix, outline_size, tailoutlinecolor)

			if(is_tail_taur && cooked_tail)
				cooked_tail.filters += filter(type="alpha", flags = MASK_INVERSE)

			tail_image = cooked_tail

		//same kind of scenario for wings
		var/wingoutlinecolor = DEFAULT_RGB_OUTLINE
		if(buddy.wing_style?.do_colouration)
			wingoutlinecolor = get_outline_color(buddy.r_wing,buddy.g_wing,buddy.b_wing,buddy.a_wing)
		var/image/wing_image = generate_layer_image(buddy.get_wing_image(FALSE),generate_layer_matrix(wing_data),outline_size,wingoutlinecolor)
		var/image/under_wing_image = generate_layer_image(buddy.get_wing_image(TRUE),generate_layer_matrix(wing_data),outline_size,wingoutlinecolor)

		//the rest are pretty simple
		var/ear_icon = buddy.get_ears_overlay()
		var/image/ear_image = generate_layer_image(image(icon = ear_icon),generate_layer_matrix(ear_data))

		//hat
		var/hat_icon = buddy.head?.make_worn_icon(body_type = buddy.species.get_bodytype(src), slot_name = slot_head_str, default_icon = INV_HEAD_DEF_ICON, default_layer = HEAD_LAYER)
		var/image/hat_image = generate_layer_image(image(icon = hat_icon),generate_layer_matrix(hat_data))



		//add them all
		overlays |= displacement_rendered
		overlays += ear_image
		overlays += hat_image

		if(!is_tail_taur)
			underlays += tail_image
		else
			overlays += tail_image

		underlays |= wing_image
		underlays |= under_wing_image

		//filtering time

		rotateMatrix.Turn(2) //very slight blur. this is unironically the best way to do it, any of the blur filters are just way too strong at a minimum value.
		transform = rotateMatrix

#undef DEFAULT_RGB_OUTLINE
#undef DATA_X_OFFSET
#undef DATA_Y_OFFSET
#undef DATA_SCALE
#undef DATA_ROTATION
