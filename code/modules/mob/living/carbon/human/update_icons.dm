/*
	Global associative list for caching humanoid icons.
	Index format m or f, followed by a string of 0 and 1 to represent bodyparts followed by husk fat hulk skeleton 1 or 0.
*/
var/global/list/human_icon_cache = list() //key is incredibly complex, see update_icons_body()
var/global/list/tail_icon_cache = list() //key is [species.race_key][r_skin][g_skin][b_skin]
var/global/list/light_overlay_cache = list() //see make_worn_icon() on helmets
var/global/list/damage_icon_parts = list() //see UpdateDamageIcon()

////////////////////////////////////////////////////////////////////////////////////////////////
// # Human Icon Updating System
//
// This system takes care of the "icon" for human mobs.  Of course humans don't just have a single
// icon+icon_state, but a combination of dozens of little sprites including including the body,
// clothing, equipment, in-universe HUD images, etc.
//
// # Basic Operation
// Whenever you do something that should update the on-mob appearance of a worn or held item, You
// will need to call the relevant update_inv_* proc. All of these are named after the variable they
// update from. They are defined at the /mob level so you don't even need to cast to carbon/human.
//
// The new system leverages SSoverlays to actually add/remove the overlays from mob.overlays
// Since SSoverlays already manages batching updates to reduce apperance churn etc, we don't need
// to worry about that.  (In short, you can call add/cut overlay as many times as you want, it will
// only get assigned to the mob once per tick.)
// As a corrolary, this means users of this system do NOT need to tell the system when you're done
// making changes.
//
// There are also these special cases:
//  update_icons_body()	//Handles updating your mob's icon to reflect their gender/race/complexion etc
//  UpdateDamageIcon()	//Handles damage overlays for brute/burn damage //(will rename this when I geta round to it) ~Carn
//  update_skin()		//Handles updating skin for species that have a skin overlay.
//  update_bloodied()	//Handles adding/clearing the blood overlays for hands & feet.  Call when bloodied or cleaned.
//  update_underwear()	//Handles updating the sprite for underwear.
//  update_hair()		//Handles updating your hair and eyes overlay
//  update_mutations()	//Handles updating your appearance for certain mutations.  e.g TK head-glows
//  update_fire()		//Handles overlay from being on fire.
//  update_water()		//Handles overlay from being submerged.
//  update_surgery()	//Handles overlays from open external organs.
//
// # History (i.e. I'm used to the old way, what is different?)
// You used to have to call update_icons(FALSE) if you planned to make more changes, and call update_icons(TRUE)
// on the final update.  All that is gone, just call update_inv_whatever() and it handles the rest.
//
////////////////////////////////////////////////////////////////////////////////////////////////

//Add an entry to overlays, assuming it exists
/mob/living/carbon/human/proc/apply_layer(cache_index)
	if((. = overlays_standing[cache_index]))
		add_overlay(.)

//Remove an entry from overlays, and from the list
/mob/living/carbon/human/proc/remove_layer(cache_index)
	var/I = overlays_standing[cache_index]
	if(I)
		cut_overlay(I)
		overlays_standing[cache_index] = null

// These are used as the layers for the icons, as well as indexes in a list that holds onto them.
// Technically the layers used are all -100+layer to make them FLOAT_LAYER overlays.
//Human Overlays Indexes/////////
#define MUTATIONS_LAYER			1		//Mutations like fat, and lasereyes
#define SKIN_LAYER				2		//Skin things added by a call on species
#define BLOOD_LAYER				3		//Bloodied hands/feet/anything else
#define DAMAGE_LAYER			4		//Injury overlay sprites like open wounds
#define SURGERY_LAYER			5		//Overlays for open surgical sites
#define UNDERWEAR_LAYER  		6		//Underwear/bras/etc
#define SHOES_LAYER_ALT			7		//Shoe-slot item (when set to be under uniform via verb)
#define UNIFORM_LAYER			8		//Uniform-slot item
#define ID_LAYER				9		//ID-slot item
#define SHOES_LAYER				10		//Shoe-slot item
#define GLOVES_LAYER			11		//Glove-slot item
#define BELT_LAYER				12		//Belt-slot item
#define SUIT_LAYER				13		//Suit-slot item
#define TAIL_LAYER				14		//Some species have tails to render
#define GLASSES_LAYER			15		//Eye-slot item
#define BELT_LAYER_ALT			16		//Belt-slot item (when set to be above suit via verb)
#define SUIT_STORE_LAYER		17		//Suit storage-slot item
#define BACK_LAYER				18		//Back-slot item
#define HAIR_LAYER				19		//The human's hair
#define EARS_LAYER				20		//Both ear-slot items (combined image)
#define EYES_LAYER				21		//Mob's eyes (used for glowing eyes)
#define FACEMASK_LAYER			22		//Mask-slot item
#define HEAD_LAYER				23		//Head-slot item
#define HANDCUFF_LAYER			24		//Handcuffs, if the human is handcuffed, in a secret inv slot
#define LEGCUFF_LAYER			25		//Same as handcuffs, for legcuffs
#define L_HAND_LAYER			26		//Left-hand item
#define R_HAND_LAYER			27		//Right-hand item
#define WING_LAYER				28		//VOREStation edit. Simply move this up a number if things are added.
#define TAIL_LAYER_ALT			29		//VOREStation edit. Simply move this up a number if things are added.
#define MODIFIER_EFFECTS_LAYER	30		//Effects drawn by modifiers
#define FIRE_LAYER				31		//'Mob on fire' overlay layer
#define WATER_LAYER				32		//'Mob submerged' overlay layer
#define TARGETED_LAYER			33		//'Aimed at' overlay layer
#define TOTAL_LAYERS			33		//VOREStation edit. <---- KEEP THIS UPDATED, should always equal the highest number here, used to initialize a list.
//////////////////////////////////

/mob/living/carbon/human
	var/list/overlays_standing[TOTAL_LAYERS]
	var/previous_damage_appearance // store what the body last looked like, so we only have to update it if something changed

//UPDATES OVERLAYS FROM OVERLAYS_LYING/OVERLAYS_STANDING
//I'll work on removing that stuff by rewriting some of the cloaking stuff at a later date.
/mob/living/carbon/human/update_icons()
	if(QDESTROYING(src))
		return

	crash_with("CANARY: Old human update_icons was called.")

	update_hud()		//TODO: remove the need for this

	//Do any species specific layering updates, such as when hiding.
	update_icon_special()

/mob/living/carbon/human/update_icons_layers()
	crash_with("CANARY: Old human update_icons_layers was called.")

/mob/living/carbon/human/update_icons_all()
	crash_with("CANARY: Old human update_icons_all was called.")

/mob/living/carbon/human/update_icons_huds()
	crash_with("CANARY: Old human update_icons_huds was called.")

/mob/living/carbon/human/update_transform()
	/* VOREStation Edit START - TODO - Consider switching to icon_scale
	// First, get the correct size.
	var/desired_scale_x = icon_scale_x
	var/desired_scale_y = icon_scale_y

	desired_scale_x *= species.icon_scale_x
	desired_scale_y *= species.icon_scale_y

	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.icon_scale_x_percent))
			desired_scale_x *= M.icon_scale_x_percent
		if(!isnull(M.icon_scale_y_percent))
			desired_scale_y *= M.icon_scale_y_percent
	*/
	var/desired_scale_x = size_multiplier
	var/desired_scale_y = size_multiplier
	//VOREStation Edit End

	// Regular stuff again.
	var/matrix/M = matrix()
	var/anim_time = 3

	//Due to some involuntary means, you're laying now
	if(lying && !resting && !sleeping)
		anim_time = 1 //Thud

	if(lying && !species.prone_icon) //Only rotate them if we're not drawing a specific icon for being prone.
		M.Turn(90)
		M.Scale(desired_scale_x, desired_scale_y)
		M.Translate(1,-6)
		layer = MOB_LAYER -0.01 // Fix for a byond bug where turf entry order no longer matters
	else
		M.Scale(desired_scale_x, desired_scale_y)
		M.Translate(0, 16*(desired_scale_y-1))
		layer = MOB_LAYER // Fix for a byond bug where turf entry order no longer matters

	animate(src, transform = M, time = anim_time)
	update_icon_special() //May contain transform-altering things

//DAMAGE OVERLAYS
//constructs damage icon for each organ from mask * damage field and saves it in our overlays_ lists
/mob/living/carbon/human/UpdateDamageIcon()
	if(QDESTROYING(src))
		return

	remove_layer(DAMAGE_LAYER)

	// first check whether something actually changed about damage appearance
	var/damage_appearance = ""

	for(var/obj/item/organ/external/O in organs)
		if(isnull(O) || O.is_stump())
			continue
		damage_appearance += O.damage_state

	if(damage_appearance == previous_damage_appearance)
		// nothing to do here
		return

	previous_damage_appearance = damage_appearance

	var/image/standing_image = image(icon = species.damage_overlays, icon_state = "00", layer = BODY_LAYER+DAMAGE_LAYER)

	// blend the individual damage states with our icons
	for(var/obj/item/organ/external/O in organs)
		if(isnull(O) || O.is_stump())
			continue

		O.update_icon()
		if(O.damage_state == "00") continue
		var/icon/DI
		var/cache_index = "[O.damage_state]/[O.icon_name]/[species.get_blood_colour(src)]/[species.get_bodytype(src)]"
		if(damage_icon_parts[cache_index] == null)
			DI = icon(species.get_damage_overlays(src), O.damage_state)			// the damage icon for whole human
			DI.Blend(icon(species.get_damage_mask(src), O.icon_name), ICON_MULTIPLY)	// mask with this organ's pixels
			DI.Blend(species.get_blood_colour(src), ICON_MULTIPLY)
			damage_icon_parts[cache_index] = DI
		else
			DI = damage_icon_parts[cache_index]

		standing_image.overlays += DI

	overlays_standing[DAMAGE_LAYER]	= standing_image
	apply_layer(DAMAGE_LAYER)

//BASE MOB SPRITE
/mob/living/carbon/human/update_icons_body()
	if(QDESTROYING(src))
		return

	var/husk_color_mod = rgb(96,88,80)
	var/hulk_color_mod = rgb(48,224,40)

	var/husk = (HUSK in src.mutations)
	var/fat = (FAT in src.mutations)
	var/hulk = (HULK in src.mutations)
	var/skeleton = (SKELETON in src.mutations)

	robolimb_count = 0 //TODO, here, really tho?
	robobody_count = 0

	//CACHING: Generate an index key from visible bodyparts.
	//0 = destroyed, 1 = normal, 2 = robotic, 3 = necrotic.

	//Create a new, blank icon for our mob to use.
	var/icon/stand_icon = new(species.icon_template ? species.icon_template : 'icons/mob/human.dmi', icon_state = "blank")

	var/g = "male"
	if(gender == FEMALE)
		g = "female"

	var/icon_key = "[species.get_race_key(src)][g][s_tone][r_skin][g_skin][b_skin]"
	if(lip_style)
		icon_key += "[lip_style]"
	else
		icon_key += "nolips"
	var/obj/item/organ/internal/eyes/eyes = internal_organs_by_name[O_EYES]
	if(eyes)
		icon_key += "[rgb(eyes.eye_colour[1], eyes.eye_colour[2], eyes.eye_colour[3])]"
	else
		icon_key += "[r_eyes], [g_eyes], [b_eyes]"

	for(var/organ_tag in species.has_limbs)
		var/obj/item/organ/external/part = organs_by_name[organ_tag]
		if(isnull(part) || part.is_stump() || part.is_hidden_by_tail()) //VOREStation Edit allowing tails to prevent bodyparts rendering, granting more spriter freedom for taur/digitigrade stuff.
			icon_key += "0"
			continue
		if(part)
			icon_key += "[part.species.get_race_key(part.owner)]"
			icon_key += "[part.dna.GetUIState(DNA_UI_GENDER)]"
			icon_key += "[part.s_tone]"
			if(part.s_col && part.s_col.len >= 3)
				icon_key += "[rgb(part.s_col[1],part.s_col[2],part.s_col[3])]"
			if(part.body_hair && part.h_col && part.h_col.len >= 3)
				icon_key += "[rgb(part.h_col[1],part.h_col[2],part.h_col[3])]"
				//VOREStation Edit - Different way of tracking add/mult species
				if(species.color_mult)
					icon_key += "[ICON_MULTIPLY]"
				else
					icon_key += "[ICON_ADD]"
				//VOREStation Edit End
			else
				icon_key += "#000000"
			for(var/M in part.markings)
				icon_key += "[M][part.markings[M]["color"]]"

			if(part.robotic >= ORGAN_ROBOT)
				icon_key += "2[part.model ? "-[part.model]": ""]"
				robolimb_count++
				if((part.robotic == ORGAN_ROBOT || part.robotic == ORGAN_LIFELIKE) && (part.organ_tag == BP_HEAD || part.organ_tag == BP_TORSO || part.organ_tag == BP_GROIN)) //VOREStation Edit - Not for nanoform parts
					robobody_count ++
			else if(part.status & ORGAN_DEAD)
				icon_key += "3"
			else
				icon_key += "1"

	icon_key = "[icon_key][husk ? 1 : 0][fat ? 1 : 0][hulk ? 1 : 0][skeleton ? 1 : 0]"

	var/icon/base_icon
	if(human_icon_cache[icon_key])
		base_icon = human_icon_cache[icon_key]
	else
		//BEGIN CACHED ICON GENERATION.
		var/obj/item/organ/external/chest = get_organ(BP_TORSO)
		base_icon = chest.get_icon()

		for(var/obj/item/organ/external/part in organs)
			if(isnull(part) || part.is_stump() || part.is_hidden_by_tail()) //VOREStation Edit allowing tails to prevent bodyparts rendering, granting more spriter freedom for taur/digitigrade stuff.
				continue
			var/icon/temp = part.get_icon(skeleton)
			//That part makes left and right legs drawn topmost and lowermost when human looks WEST or EAST
			//And no change in rendering for other parts (they icon_position is 0, so goes to 'else' part)
			if(part.icon_position & (LEFT | RIGHT))
				var/icon/temp2 = new('icons/mob/human.dmi',"blank")
				temp2.Insert(new/icon(temp,dir=NORTH),dir=NORTH)
				temp2.Insert(new/icon(temp,dir=SOUTH),dir=SOUTH)
				if(!(part.icon_position & LEFT))
					temp2.Insert(new/icon(temp,dir=EAST),dir=EAST)
				if(!(part.icon_position & RIGHT))
					temp2.Insert(new/icon(temp,dir=WEST),dir=WEST)
				base_icon.Blend(temp2, ICON_OVERLAY)
				if(part.icon_position & LEFT)
					temp2.Insert(new/icon(temp,dir=EAST),dir=EAST)
				if(part.icon_position & RIGHT)
					temp2.Insert(new/icon(temp,dir=WEST),dir=WEST)
				base_icon.Blend(temp2, ICON_UNDERLAY)
			else if(part.icon_position & UNDER)
				base_icon.Blend(temp, ICON_UNDERLAY)
			else
				base_icon.Blend(temp, ICON_OVERLAY)

		if(!skeleton)
			if(husk)
				base_icon.ColorTone(husk_color_mod)
			else if(hulk)
				var/list/tone = ReadRGB(hulk_color_mod)
				base_icon.MapColors(rgb(tone[1],0,0),rgb(0,tone[2],0),rgb(0,0,tone[3]))

		//Handle husk overlay.
		if(husk && ("overlay_husk" in icon_states(species.icobase)))
			var/icon/mask = new(base_icon)
			var/icon/husk_over = new(species.icobase,"overlay_husk")
			mask.MapColors(0,0,0,1, 0,0,0,1, 0,0,0,1, 0,0,0,1, 0,0,0,0)
			husk_over.Blend(mask, ICON_ADD)
			base_icon.Blend(husk_over, ICON_OVERLAY)

		human_icon_cache[icon_key] = base_icon

	//END CACHED ICON GENERATION.
	stand_icon.Blend(base_icon,ICON_OVERLAY)
	icon = stand_icon

	//tail
	update_tail_showing()
	update_wing_showing() // VOREStation Edit

/mob/living/carbon/human/proc/update_skin()
	if(QDESTROYING(src))
		return

	remove_layer(SKIN_LAYER)

	var/image/skin = species.update_skin(src)
	if(skin)
		skin.layer = BODY_LAYER+SKIN_LAYER
		overlays_standing[SKIN_LAYER] = skin
		apply_layer(SKIN_LAYER)

/mob/living/carbon/human/proc/update_bloodied()
	if(QDESTROYING(src))
		return

	remove_layer(BLOOD_LAYER)
	if(!blood_DNA && !feet_blood_DNA)
		return

	var/image/both = image(icon = 'icons/effects/effects.dmi', icon_state = "nothing", layer = BODY_LAYER+BLOOD_LAYER)

	//Bloody hands
	if(blood_DNA)
		var/image/bloodsies	= image(icon = species.get_blood_mask(src), icon_state = "bloodyhands", layer = BODY_LAYER+BLOOD_LAYER)
		bloodsies.color = hand_blood_color
		both.add_overlay(bloodsies)

	//Bloody feet
	if(feet_blood_DNA)
		var/image/bloodsies = image(icon = species.get_blood_mask(src), icon_state = "shoeblood", layer = BODY_LAYER+BLOOD_LAYER)
		bloodsies.color = feet_blood_color
		both.add_overlay(bloodsies)

	overlays_standing[BLOOD_LAYER] = both

	apply_layer(BLOOD_LAYER)

//UNDERWEAR OVERLAY
/mob/living/carbon/human/proc/update_underwear()
	if(QDESTROYING(src))
		return

	remove_layer(UNDERWEAR_LAYER)

	if(species.appearance_flags & HAS_UNDERWEAR)
		overlays_standing[UNDERWEAR_LAYER] = list()
		for(var/category in all_underwear)
			if(hide_underwear[category])
				continue
			var/datum/category_item/underwear/UWI = all_underwear[category]
			var/image/wear = UWI.generate_image(all_underwear_metadata[category], layer = BODY_LAYER+UNDERWEAR_LAYER)
			overlays_standing[UNDERWEAR_LAYER] += wear

		apply_layer(UNDERWEAR_LAYER)

//HAIR OVERLAY
/mob/living/carbon/human/proc/update_hair()
	if(QDESTROYING(src))
		return

	//Reset our hair
	remove_layer(HAIR_LAYER)
	update_eyes() //Pirated out of here, for glowing eyes.

	var/obj/item/organ/external/head/head_organ = get_organ(BP_HEAD)
	if(!head_organ || head_organ.is_stump() )
		return

	//masks and helmets can obscure our hair.
	if( (head && (head.flags_inv & BLOCKHAIR)) || (wear_mask && (wear_mask.flags_inv & BLOCKHAIR)))
		return

	//base icons
	var/icon/face_standing = icon(icon = 'icons/mob/human_face.dmi', icon_state = "bald_s")

	if(f_style)
		var/datum/sprite_accessory/facial_hair_style = facial_hair_styles_list[f_style]
		if(facial_hair_style && facial_hair_style.species_allowed && (src.species.get_bodytype(src) in facial_hair_style.species_allowed))
			var/icon/facial_s = new/icon("icon" = facial_hair_style.icon, "icon_state" = "[facial_hair_style.icon_state]_s")
			if(facial_hair_style.do_colouration)
				facial_s.Blend(rgb(r_facial, g_facial, b_facial), ICON_MULTIPLY) //VOREStation edit

			face_standing.Blend(facial_s, ICON_OVERLAY)

	if(h_style)
		var/datum/sprite_accessory/hair/hair_style = hair_styles_list[h_style]
		if(head && (head.flags_inv & BLOCKHEADHAIR))
			if(!(hair_style.flags & HAIR_VERY_SHORT))
				hair_style = hair_styles_list["Short Hair"]

		if(hair_style && (src.species.get_bodytype(src) in hair_style.species_allowed))
			var/icon/hair_s = new/icon("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state]_s")
			var/icon/hair_s_add = new/icon("icon" = hair_style.icon_add, "icon_state" = "[hair_style.icon_state]_s")
			if(hair_style.do_colouration)
				hair_s.Blend(rgb(r_hair, g_hair, b_hair), ICON_MULTIPLY)
				hair_s.Blend(hair_s_add, ICON_ADD)

			face_standing.Blend(hair_s, ICON_OVERLAY)

	// VOREStation Edit - START
	var/icon/ears_s = get_ears_overlay()
	if (ears_s)
		face_standing.Blend(ears_s, ICON_OVERLAY)
	// VOREStation Edit - END

	if(head_organ.nonsolid)
		face_standing += rgb(,,,120)

	overlays_standing[HAIR_LAYER] = image(face_standing, layer = BODY_LAYER+HAIR_LAYER)
	apply_layer(HAIR_LAYER)

/mob/living/carbon/human/update_eyes()
	if(QDESTROYING(src))
		return

	//Reset our eyes
	remove_layer(EYES_LAYER)

	//TODO: Probably redo this. I know I wrote it, but...

	//This is ONLY for glowing eyes for now. Boring flat eyes are done by the head's own proc.
	if(!species.has_glowing_eyes)
		return

	//Our glowy eyes should be hidden if some equipment hides them.
	if(!should_have_organ(O_EYES) || (head && (head.flags_inv & BLOCKHAIR)) || (wear_mask && (wear_mask.flags_inv & BLOCKHAIR)))
		return

	//Get the head, we'll need it later.
	var/obj/item/organ/external/head/head_organ = get_organ(BP_HEAD)
	if(!head_organ || head_organ.is_stump() )
		return

	//The eyes store the color themselves, funny enough.
	var/obj/item/organ/internal/eyes/eyes = internal_organs_by_name[O_EYES]
	if(!head_organ.eye_icon)
		return

	var/icon/eyes_icon = new/icon(head_organ.eye_icon_location, head_organ.eye_icon)
	if(eyes)
		eyes_icon.Blend(rgb(eyes.eye_colour[1], eyes.eye_colour[2], eyes.eye_colour[3]), ICON_ADD)
	else
		eyes_icon.Blend(rgb(128,0,0), ICON_ADD)

	var/image/eyes_image = image(eyes_icon)
	eyes_image.plane = PLANE_LIGHTING_ABOVE

	overlays_standing[EYES_LAYER] = eyes_image
	apply_layer(EYES_LAYER)

/mob/living/carbon/human/update_mutations()
	if(QDESTROYING(src))
		return

	remove_layer(MUTATIONS_LAYER)

	if(!LAZYLEN(mutations))
		return //No mutations, no icons.

	//TODO: THIS PROC???
	var/fat
	if(FAT in mutations)
		fat = "fat"

	var/image/standing	= image(icon = 'icons/effects/genetics.dmi', layer = BODY_LAYER+MUTATIONS_LAYER)
	var/g = gender == FEMALE ? "f" : "m"

	for(var/datum/dna/gene/gene in dna_genes)
		if(!gene.block)
			continue
		if(gene.is_active(src))
			var/underlay = gene.OnDrawUnderlays(src,g,fat)
			if(underlay)
				standing.underlays += underlay

	for(var/mut in mutations)
		if(LASER)
			standing.overlays += "lasereyes_s" //TODO

	overlays_standing[MUTATIONS_LAYER]	= standing
	apply_layer(MUTATIONS_LAYER)

/* --------------------------------------- */
//Recomputes every icon on the mob. Expensive.
//Useful if the species changed, or there's some
//other drastic body-shape change, but otherwise avoid.
/mob/living/carbon/human/regenerate_icons()
	..()
	if(transforming || QDELETED(src))
		return

	update_icons_body()
	UpdateDamageIcon()
	update_mutations()
	update_skin()
	update_underwear()
	update_hair()
	update_inv_w_uniform()
	update_inv_wear_id()
	update_inv_gloves()
	update_inv_glasses()
	update_inv_ears()
	update_inv_shoes()
	update_inv_s_store()
	update_inv_wear_mask()
	update_inv_head()
	update_inv_belt()
	update_inv_back()
	update_inv_wear_suit()
	update_inv_r_hand()
	update_inv_l_hand()
	update_inv_handcuffed()
	update_inv_legcuffed()
	//update_inv_pockets() //Doesn't do anything
	update_fire()
	update_water()
	update_surgery()

/* --------------------------------------- */
//vvvvvv UPDATE_INV PROCS vvvvvv

/mob/living/carbon/human/update_inv_w_uniform()
	if(QDESTROYING(src))
		return

	remove_layer(UNIFORM_LAYER)

	//Shoes can be affected by uniform being drawn onto them
	update_inv_shoes()

	if(!w_uniform)
		return

	if(wear_suit && (wear_suit.flags_inv & HIDEJUMPSUIT) && !istype(wear_suit, /obj/item/clothing/suit/space/rig))
		return //Wearing a suit that prevents uniform rendering

	//Build a uniform sprite
	//VOREStation Edit start.
	var/icon/c_mask = null
	if(tail_style && tail_style.clip_mask_icon && tail_style.clip_mask_state)
		var/obj/item/clothing/suit/S = wear_suit
		if(!(wear_suit && ((wear_suit.flags_inv & HIDETAIL) || (istype(S) && S.taurized)))) //Clip the lower half of the suit off using the tail's clip mask.
			c_mask = new /icon(tail_style.clip_mask_icon, tail_style.clip_mask_state)
	overlays_standing[UNIFORM_LAYER] = w_uniform.make_worn_icon(body_type = species.get_bodytype(src), slot_name = slot_w_uniform_str, default_icon = INV_W_UNIFORM_DEF_ICON, default_layer = UNIFORM_LAYER, clip_mask = c_mask)
	//VOREStation Edit end.

	apply_layer(UNIFORM_LAYER)

/mob/living/carbon/human/update_inv_wear_id()
	if(QDESTROYING(src))
		return

	remove_layer(ID_LAYER)

	if(!wear_id)
		return //Not wearing an ID

	//Only draw the ID on the mob if the uniform allows for it
	if(w_uniform && istype(w_uniform, /obj/item/clothing/under))
		var/obj/item/clothing/under/U = w_uniform
		if(U.displays_id)
			overlays_standing[ID_LAYER] = wear_id.make_worn_icon(body_type = species.get_bodytype(src), slot_name = slot_wear_id_str, default_icon = INV_WEAR_ID_DEF_ICON, default_layer = ID_LAYER)

	apply_layer(ID_LAYER)

/mob/living/carbon/human/update_inv_gloves()
	if(QDESTROYING(src))
		return

	remove_layer(GLOVES_LAYER)

	if(!gloves)
		return //No gloves, no reason to be here.

	overlays_standing[GLOVES_LAYER]	= gloves.make_worn_icon(body_type = species.get_bodytype(src), slot_name = slot_gloves_str, default_icon = INV_GLOVES_DEF_ICON, default_layer = GLOVES_LAYER)

	apply_layer(GLOVES_LAYER)

/mob/living/carbon/human/update_inv_glasses()
	if(QDESTROYING(src))
		return

	remove_layer(GLASSES_LAYER)

	if(!glasses)
		return //Not wearing glasses, no need to update anything.

	overlays_standing[GLASSES_LAYER] = glasses.make_worn_icon(body_type = species.get_bodytype(src), slot_name = slot_gloves_str, default_icon = INV_EYES_DEF_ICON, default_layer = GLASSES_LAYER)

	apply_layer(GLASSES_LAYER)

/mob/living/carbon/human/update_inv_ears()
	if(QDESTROYING(src))
		return

	remove_layer(EARS_LAYER)

	if((head && head.flags_inv & (BLOCKHAIR | BLOCKHEADHAIR)) || (wear_mask && wear_mask.flags_inv & (BLOCKHAIR | BLOCKHEADHAIR)))
		return //Ears are blocked (by hair being blocked, overloaded)

	if(!l_ear && !r_ear)
		return //Why bother, if no ear sprites

	// Blank image upon which to layer left & right overlays.
	var/image/both = image(icon = 'icons/effects/effects.dmi', icon_state = "nothing", layer = BODY_LAYER+EARS_LAYER)

	if(l_ear)
		var/image/standing = l_ear.make_worn_icon(body_type = species.get_bodytype(src), slot_name = slot_l_ear_str, default_icon = INV_EARS_DEF_ICON, default_layer = EARS_LAYER)
		both.add_overlay(standing)

	if(r_ear)
		var/image/standing = r_ear.make_worn_icon(body_type = species.get_bodytype(src), slot_name = slot_r_ear_str, default_icon = INV_EARS_DEF_ICON, default_layer = EARS_LAYER)
		both.add_overlay(standing)

	overlays_standing[EARS_LAYER] = both
	apply_layer(EARS_LAYER)

/mob/living/carbon/human/update_inv_shoes()
	if(QDESTROYING(src))
		return

	remove_layer(SHOES_LAYER)
	remove_layer(SHOES_LAYER_ALT) //Dumb alternate layer for shoes being under the uniform.

	if(!shoes || (wear_suit && wear_suit.flags_inv & HIDESHOES) || (w_uniform && w_uniform.flags_inv & HIDESHOES))
		return //Either nothing to draw, or it'd be hidden.

	//VOREStation Edit
	for(var/f in list(BP_L_FOOT, BP_R_FOOT))
		var/obj/item/organ/external/foot/foot = get_organ(f)
		if(istype(foot) && foot.is_hidden_by_tail()) //If either foot is hidden by the tail, don't render footwear.
			return

	//Allow for shoe layer toggle nonsense
	var/shoe_layer = SHOES_LAYER
	if(istype(shoes, /obj/item/clothing/shoes))
		var/obj/item/clothing/shoes/ushoes = shoes
		if(ushoes.shoes_under_pants == 1)
			shoe_layer = SHOES_LAYER_ALT

	//NB: the use of a var for the layer on this one
	overlays_standing[shoe_layer] = shoes.make_worn_icon(body_type = species.get_bodytype(src), slot_name = slot_shoes_str, default_icon = INV_FEET_DEF_ICON, default_layer = shoe_layer)

	apply_layer(SHOES_LAYER)
	apply_layer(SHOES_LAYER_ALT)

/mob/living/carbon/human/update_inv_s_store()
	if(QDESTROYING(src))
		return

	remove_layer(SUIT_STORE_LAYER)

	if(!s_store)
		return //Why bother, nothing there.

	//TODO, this is unlike the rest of the things
	//Basically has no variety in slot icon choices at all. WHY SPECIES ONLY??
	var/t_state = s_store.item_state
	if(!t_state)
		t_state = s_store.icon_state
	overlays_standing[SUIT_STORE_LAYER]	= image(icon = species.suit_storage_icon, icon_state = t_state, layer = BODY_LAYER+SUIT_STORE_LAYER)

	apply_layer(SUIT_STORE_LAYER)

/mob/living/carbon/human/update_inv_head()
	if(QDESTROYING(src))
		return

	remove_layer(HEAD_LAYER)

	if(!head)
		return //No head item, why bother.

	overlays_standing[HEAD_LAYER] = head.make_worn_icon(body_type = species.get_bodytype(src), slot_name = slot_head_str, default_icon = INV_HEAD_DEF_ICON, default_layer = HEAD_LAYER)

	apply_layer(HEAD_LAYER)

/mob/living/carbon/human/update_inv_belt()
	if(QDESTROYING(src))
		return

	remove_layer(BELT_LAYER)
	remove_layer(BELT_LAYER_ALT) //Because you can toggle belt layer with a verb

	if(!belt)
		return //No belt, why bother.

	//Toggle for belt layering with uniform
	var/belt_layer = BELT_LAYER
	if(istype(belt, /obj/item/weapon/storage/belt))
		var/obj/item/weapon/storage/belt/ubelt = belt
		if(ubelt.show_above_suit)
			belt_layer = BELT_LAYER_ALT

	//NB: this uses a var from above
	overlays_standing[belt_layer] = belt.make_worn_icon(body_type = species.get_bodytype(src), slot_name = slot_belt_str, default_icon = INV_BELT_DEF_ICON, default_layer = belt_layer)

	apply_layer(belt_layer)

/mob/living/carbon/human/update_inv_wear_suit()
	if(QDESTROYING(src))
		return

	remove_layer(SUIT_LAYER)

	//Hide/show other layers if necessary
	update_inv_w_uniform()
	update_inv_shoes()
	update_tail_showing()
	update_wing_showing() // VOREStation Edit

	if(!wear_suit)
		return //No point, no suit.

	// Part of splitting the suit sprites up
	var/iconFile = INV_SUIT_DEF_ICON
	var/obj/item/clothing/suit/S //VOREStation edit - break this var out a level for use below.
	if(istype(wear_suit, /obj/item/clothing/suit))
		S = wear_suit
		if(S.update_icon_define)
			iconFile = S.update_icon_define

	//VOREStation Edit start.
	var/icon/c_mask = null
	if((tail_style && tail_style.clip_mask_icon && tail_style.clip_mask_state) && !(wear_suit.flags_inv & HIDETAIL) && !(S && S.taurized)) //Clip the lower half of the suit off using the tail's clip mask.
		c_mask = new /icon(tail_style.clip_mask_icon, tail_style.clip_mask_state)
	overlays_standing[SUIT_LAYER] = wear_suit.make_worn_icon(body_type = species.get_bodytype(src), slot_name = slot_wear_suit_str, default_icon = iconFile, default_layer = SUIT_LAYER, clip_mask = c_mask)
	//VOREStation Edit end.

	apply_layer(SUIT_LAYER)

/mob/living/carbon/human/update_inv_pockets()
	crash_with("Someone called update_inv_pockets even though it's dumb")

/mob/living/carbon/human/update_inv_wear_mask()
	if(QDESTROYING(src))
		return

	remove_layer(FACEMASK_LAYER)

	if(!wear_mask || (head && head.flags_inv & HIDEMASK))
		return //Why bother, nothing in mask slot.

	overlays_standing[FACEMASK_LAYER] = wear_mask.make_worn_icon(body_type = species.get_bodytype(src), slot_name = slot_wear_mask_str, default_icon = INV_MASK_DEF_ICON, default_layer = FACEMASK_LAYER)

	apply_layer(FACEMASK_LAYER)

/mob/living/carbon/human/update_inv_back()
	if(QDESTROYING(src))
		return

	remove_layer(BACK_LAYER)

	if(!back)
		return //Why do anything

	overlays_standing[BACK_LAYER] = back.make_worn_icon(body_type = species.get_bodytype(src), slot_name = slot_back_str, default_icon = INV_BACK_DEF_ICON, default_layer = BACK_LAYER)

	apply_layer(BACK_LAYER)

//TODO: Carbon procs in my human update_icons??
/mob/living/carbon/human/update_hud()	//TODO: do away with this if possible
	if(QDESTROYING(src))
		return

	if(client)
		client.screen |= contents
		if(hud_used)
			hud_used.hidden_inventory_update() 	//Updates the screenloc of the items on the 'other' inventory bar

//update whether handcuffs appears on our hud.
/mob/living/carbon/proc/update_hud_handcuffed()
	if(QDESTROYING(src))
		return

	if(hud_used && hud_used.l_hand_hud_object && hud_used.r_hand_hud_object)
		hud_used.l_hand_hud_object.update_icon()
		hud_used.r_hand_hud_object.update_icon()

/mob/living/carbon/human/update_inv_handcuffed()
	if(QDESTROYING(src))
		return

	remove_layer(HANDCUFF_LAYER)
	update_hud_handcuffed() //TODO

	if(!handcuffed)
		return //Not cuffed, why bother

	overlays_standing[HANDCUFF_LAYER] = handcuffed.make_worn_icon(body_type = species.get_bodytype(src), slot_name = slot_handcuffed_str, default_icon = INV_HCUFF_DEF_ICON, default_layer = HANDCUFF_LAYER)

	apply_layer(HANDCUFF_LAYER)

/mob/living/carbon/human/update_inv_legcuffed()
	if(QDESTROYING(src))
		return

	remove_layer(LEGCUFF_LAYER)

	if(!legcuffed)
		return //Not legcuffed, why bother.

	overlays_standing[LEGCUFF_LAYER] = legcuffed.make_worn_icon(body_type = species.get_bodytype(src), slot_name = slot_legcuffed_str, default_icon = INV_LCUFF_DEF_ICON, default_layer = LEGCUFF_LAYER)

	apply_layer(LEGCUFF_LAYER)

/mob/living/carbon/human/update_inv_r_hand()
	if(QDESTROYING(src))
		return

	remove_layer(R_HAND_LAYER)

	if(!r_hand)
		return //No hand, no bother.

	overlays_standing[R_HAND_LAYER] = r_hand.make_worn_icon(body_type = species.get_bodytype(src), inhands = TRUE, slot_name = slot_r_hand_str, default_icon = INV_R_HAND_DEF_ICON, default_layer = R_HAND_LAYER)

	apply_layer(R_HAND_LAYER)

/mob/living/carbon/human/update_inv_l_hand()
	if(QDESTROYING(src))
		return

	remove_layer(L_HAND_LAYER)

	if(!l_hand)
		return //No hand, no bother.

	overlays_standing[L_HAND_LAYER] = l_hand.make_worn_icon(body_type = species.get_bodytype(src), inhands = TRUE, slot_name = slot_l_hand_str, default_icon = INV_L_HAND_DEF_ICON, default_layer = L_HAND_LAYER)

	apply_layer(L_HAND_LAYER)

/mob/living/carbon/human/proc/update_tail_showing()
	if(QDESTROYING(src))
		return

	remove_layer(TAIL_LAYER)
	remove_layer(TAIL_LAYER_ALT) // VOREStation Edit - START - Alt Tail Layer

	var/used_tail_layer = tail_alt ? TAIL_LAYER_ALT : TAIL_LAYER

	var/image/vr_tail_image = get_tail_image()
	if(vr_tail_image)
		vr_tail_image.layer = BODY_LAYER+used_tail_layer
		overlays_standing[used_tail_layer] = vr_tail_image
		apply_layer(used_tail_layer)
		return
	// VOREStation Edit - END

	var/species_tail = species.get_tail(src) // Species tail icon_state prefix.

	//This one is actually not that bad I guess.
	if(species_tail && !(wear_suit && wear_suit.flags_inv & HIDETAIL))
		var/icon/tail_s = get_tail_icon()
		overlays_standing[used_tail_layer] = image(icon = tail_s, icon_state = "[species_tail]_s", layer = BODY_LAYER+used_tail_layer) // VOREStation Edit - Alt Tail Layer
		animate_tail_reset()

//TODO: Is this the appropriate place for this, and not on species...?
/mob/living/carbon/human/proc/get_tail_icon()
	var/icon_key = "[species.get_race_key(src)][r_skin][g_skin][b_skin][r_hair][g_hair][b_hair]"
	var/icon/tail_icon = tail_icon_cache[icon_key]
	if(!tail_icon)
		//generate a new one
		var/species_tail_anim = species.get_tail_animation(src)
		if(!species_tail_anim && species.icobase_tail) species_tail_anim = species.icobase //VOREStation Code - Allow override of file for non-animated tails
		if(!species_tail_anim) species_tail_anim = 'icons/effects/species.dmi'
		tail_icon = new/icon(species_tail_anim)
		tail_icon.Blend(rgb(r_skin, g_skin, b_skin), species.color_mult ? ICON_MULTIPLY : ICON_ADD) // VOREStation edit
		// The following will not work with animated tails.
		var/use_species_tail = species.get_tail_hair(src)
		if(use_species_tail)
			var/icon/hair_icon = icon('icons/effects/species.dmi', "[species.get_tail(src)]_[use_species_tail]_s")	//VOREStation edit -- Suffix icon state string with '_s' to compensate for diff in .dmi b/w us & Polaris.
			hair_icon.Blend(rgb(r_hair, g_hair, b_hair), species.color_mult ? ICON_MULTIPLY : ICON_ADD)				//VOREStation edit -- Check for species color_mult
			tail_icon.Blend(hair_icon, ICON_OVERLAY)
		tail_icon_cache[icon_key] = tail_icon

	return tail_icon

/mob/living/carbon/human/proc/set_tail_state(var/t_state)
	var/used_tail_layer = tail_alt ? TAIL_LAYER_ALT : TAIL_LAYER // VOREStation Edit - START - Alt Tail Layer
	var/image/tail_overlay = overlays_standing[used_tail_layer]

	remove_layer(TAIL_LAYER)
	remove_layer(TAIL_LAYER_ALT)

	if(tail_overlay)
		overlays_standing[used_tail_layer] = tail_overlay
		if(species.get_tail_animation(src))
			tail_overlay.icon_state = t_state
			. = tail_overlay

	apply_layer(used_tail_layer) // VOREStation Edit - END

//Not really once, since BYOND can't do that.
//Update this if the ability to flick() images or make looping animation start at the first frame is ever added.
//You can sort of flick images now with flick_overlay -Aro
/mob/living/carbon/human/proc/animate_tail_once()
	if(QDESTROYING(src))
		return

	var/t_state = "[species.get_tail(src)]_once"
	var/used_tail_layer = tail_alt ? TAIL_LAYER_ALT : TAIL_LAYER // VOREStation Edit - Alt Tail Layer

	var/image/tail_overlay = overlays_standing[used_tail_layer] // VOREStation Edit - Alt Tail Layer
	if(tail_overlay && tail_overlay.icon_state == t_state)
		return //let the existing animation finish

	tail_overlay = set_tail_state(t_state) // Calls remove_layer & apply_layer
	if(tail_overlay)
		spawn(20)
			//check that the animation hasn't changed in the meantime
			if(overlays_standing[used_tail_layer] == tail_overlay && tail_overlay.icon_state == t_state) // VOREStation Edit - Alt Tail Layer
				animate_tail_stop()

/mob/living/carbon/human/proc/animate_tail_start()
	if(QDESTROYING(src))
		return

	set_tail_state("[species.get_tail(src)]_slow[rand(0,9)]")

/mob/living/carbon/human/proc/animate_tail_fast()
	if(QDESTROYING(src))
		return

	set_tail_state("[species.get_tail(src)]_loop[rand(0,9)]")

/mob/living/carbon/human/proc/animate_tail_reset()
	if(QDESTROYING(src))
		return

	if(stat != DEAD)
		set_tail_state("[species.get_tail(src)]_idle[rand(0,9)]")
	else
		set_tail_state("[species.get_tail(src)]_static")
		toggle_tail_vr(FALSE) //VOREStation Add - So tails stop when someone dies. TODO - Fix this hack ~Leshana

/mob/living/carbon/human/proc/animate_tail_stop()
	if(QDESTROYING(src))
		return

	set_tail_state("[species.get_tail(src)]_static")

// VOREStation Edit - Wings! See update_icons_vr.dm for more wing procs
/mob/living/carbon/human/proc/update_wing_showing()
	if(QDESTROYING(src))
		return

	remove_layer(WING_LAYER)

	var/image/vr_wing_image = get_wing_image()
	if(vr_wing_image)
		vr_wing_image.layer = BODY_LAYER+WING_LAYER
		overlays_standing[WING_LAYER] = vr_wing_image

	apply_layer(WING_LAYER)
// VOREStation Edit end

/mob/living/carbon/human/update_modifier_visuals()
	if(QDESTROYING(src))
		return

	remove_layer(MODIFIER_EFFECTS_LAYER)

	if(!LAZYLEN(modifiers))
		return //No modifiers, no effects.

	var/image/effects = new()
	for(var/datum/modifier/M in modifiers)
		if(M.mob_overlay_state)
			var/image/I = image(icon = 'icons/mob/modifier_effects.dmi', icon_state = M.mob_overlay_state)
			effects.overlays += I //TODO, this compositing is annoying.

	overlays_standing[MODIFIER_EFFECTS_LAYER] = effects

	apply_layer(MODIFIER_EFFECTS_LAYER)

/mob/living/carbon/human/update_fire()
	if(QDESTROYING(src))
		return

	remove_layer(FIRE_LAYER)

	if(!on_fire)
		return

	overlays_standing[FIRE_LAYER] = image(icon = 'icons/mob/OnFire.dmi', icon_state = get_fire_icon_state(), layer = BODY_LAYER+FIRE_LAYER)

	apply_layer(FIRE_LAYER)

/mob/living/carbon/human/update_water()
	if(QDESTROYING(src))
		return

	remove_layer(WATER_LAYER)

	var/depth = check_submerged()
	if(!depth || lying)
		return

	overlays_standing[WATER_LAYER] = image(icon = 'icons/mob/submerged.dmi', icon_state = "human_swimming_[depth]", layer = BODY_LAYER+WATER_LAYER) //TODO: Improve

	apply_layer(WATER_LAYER)

/mob/living/carbon/human/proc/update_surgery()
	if(QDESTROYING(src))
		return

	remove_layer(SURGERY_LAYER)

	var/image/total = new
	for(var/obj/item/organ/external/E in organs)
		if(E.open)
			var/image/I = image(icon = 'icons/mob/surgery.dmi',  icon_state = "[E.icon_name][round(E.open)]", layer = BODY_LAYER+SURGERY_LAYER)
			total.overlays += I //TODO: This compositing is annoying

	if(total.overlays.len)
		overlays_standing[SURGERY_LAYER] = total
		apply_layer(SURGERY_LAYER)

//Human Overlays Indexes/////////
#undef MUTATIONS_LAYER
#undef SKIN_LAYER
#undef DAMAGE_LAYER
#undef SURGERY_LAYER
#undef UNDERWEAR_LAYER
#undef SHOES_LAYER_ALT
#undef UNIFORM_LAYER
#undef ID_LAYER
#undef SHOES_LAYER
#undef GLOVES_LAYER
#undef BELT_LAYER
#undef SUIT_LAYER
#undef TAIL_LAYER
#undef GLASSES_LAYER
#undef BELT_LAYER_ALT
#undef SUIT_STORE_LAYER
#undef BACK_LAYER
#undef HAIR_LAYER
#undef EARS_LAYER
#undef EYES_LAYER
#undef FACEMASK_LAYER
#undef HEAD_LAYER
#undef COLLAR_LAYER
#undef HANDCUFF_LAYER
#undef LEGCUFF_LAYER
#undef L_HAND_LAYER
#undef R_HAND_LAYER
#undef MODIFIER_EFFECTS_LAYER
#undef FIRE_LAYER
#undef WATER_LAYER
#undef TARGETED_LAYER
#undef TOTAL_LAYERS
