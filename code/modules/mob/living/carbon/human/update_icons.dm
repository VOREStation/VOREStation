/*
	Global associative list for caching humanoid icons.
	Index format m or f, followed by a string of 0 and 1 to represent bodyparts followed by husk fat hulk skeleton 1 or 0.
	TODO: Proper documentation
	icon_key is [species.race_key][g][husk][fat][hulk][skeleton][s_tone]
*/
var/global/list/human_icon_cache = list()
var/global/list/tail_icon_cache = list() //key is [species.race_key][r_skin][g_skin][b_skin]
var/global/list/light_overlay_cache = list()

/mob/living/carbon/human/proc/apply_overlay(cache_index)
	if((. = overlays_standing[cache_index]))
		add_overlay(.)

/mob/living/carbon/human/proc/remove_overlay(cache_index)
	var/I = overlays_standing[cache_index]
	if(I)
		cut_overlay(I)
		overlays_standing[cache_index] = null

	///////////////////////
	//UPDATE_ICONS SYSTEM//
	///////////////////////
/*
Calling this  a system is perhaps a bit trumped up. It is essentially update_clothing dismantled into its
core parts. The key difference is that when we generate overlays we do not generate either lying or standing
versions. Instead, we generate both and store them in two fixed-length lists, both using the same list-index
(The indexes are in update_icons.dm): Each list for humans is (at the time of writing) of length 19.
This will hopefully be reduced as the system is refined.
	var/overlays_lying[19]			//For the lying down stance
	var/overlays_standing[19]		//For the standing stance
When we call update_icons, the 'lying' variable is checked and then the appropriate list is assigned to our overlays!
That in itself uses a tiny bit more memory (no more than all the ridiculous lists the game has already mind you).
On the other-hand, it should be very CPU cheap in comparison to the old system.
In the old system, we updated all our overlays every life() call, even if we were standing still inside a crate!
or dead!. 25ish overlays, all generated from scratch every second for every xeno/human/monkey and then applied.
More often than not update_clothing was being called a few times in addition to that! CPU was not the only issue,
all those icons had to be sent to every client. So really the cost was extremely cumulative. To the point where
update_clothing would frequently appear in the top 10 most CPU intensive procs during profiling.
Another feature of this new system is that our lists are indexed. This means we can update specific overlays!
So we only regenerate icons when we need them to be updated! This is the main saving for this system.
In practice this means that:
	everytime you fall over, we just switch between precompiled lists. Which is fast and cheap.
	Everytime you do something minor like take a pen out of your pocket, we only update the in-hand overlay
	etc...
There are several things that need to be remembered:
>	Whenever we do something that should cause an overlay to update (which doesn't use standard procs
	( i.e. you do something like l_hand = /obj/item/something new(src) )
	You will need to call the relevant update_inv_* proc:
		update_inv_head()
		update_inv_wear_suit()
		update_inv_gloves()
		update_inv_shoes()
		update_inv_w_uniform()
		update_inv_glasse()
		update_inv_l_hand()
		update_inv_r_hand()
		update_inv_belt()
		update_inv_wear_id()
		update_inv_ears()
		update_inv_s_store()
		update_inv_pockets()
		update_inv_back()
		update_inv_handcuffed()
		update_inv_wear_mask()
	All of these are named after the variable they update from. They are defined at the mob/ level like
	update_clothing was, so you won't cause undefined proc runtimes with usr.update_inv_wear_id() if the usr is a
	slime etc. Instead, it'll just return without doing any work. So no harm in calling it for slimes and such.
>	There are also these special cases:
		update_mutations()	//handles updating your appearance for certain mutations.  e.g TK head-glows
		UpdateDamageIcon()	//handles damage overlays for brute/burn damage //(will rename this when I geta round to it)
		update_icons_body()	//Handles updating your mob's icon to reflect their gender/race/complexion etc
		update_hair()	//Handles updating your hair overlay (used to be update_face, but mouth and
																			...eyes were merged into update_body)
		update_targeted() // Updates the target overlay when someone points a gun at you
>	All of these procs update our overlays_lying and overlays_standing, and then call update_icons() by default.
	If you wish to update several overlays at once, you can set the argument to 0 to disable the update and call
	it manually:
		e.g.
		update_inv_head(0)
		update_inv_l_hand(0)
		update_inv_r_hand()		//<---calls update_icons()
	or equivillantly:
		update_inv_head(0)
		update_inv_l_hand(0)
		update_inv_r_hand(0)
		update_icons()
>	If you need to update all overlays you can use regenerate_icons(). it works exactly like update_clothing used to.
>	I reimplimented an old unused variable which was in the code called (coincidentally) var/update_icon
	It can be used as another method of triggering regenerate_icons(). It's basically a flag that when set to non-zero
	will call regenerate_icons() at the next life() call and then reset itself to 0.
	The idea behind it is icons are regenerated only once, even if multiple events requested it.
This system is confusing and is still a WIP. It's primary goal is speeding up the controls of the game whilst
reducing processing costs. So please bear with me while I iron out the kinks. It will be worth it, I promise.
If I can eventually free var/lying stuff from the life() process altogether, stuns/death/status stuff
will become less affected by lag-spikes and will be instantaneous! :3
If you have any questions/constructive-comments/bugs-to-report/or have a massivly devestated butt...
Please contact me on #coderbus IRC. ~Carn x
*/

//Human Overlays Indexes/////////
#define MUTATIONS_LAYER			1		//Mutations like fat, and lasereyes
#define SKIN_LAYER				2		//Skin things added by a call on species
#define DAMAGE_LAYER			3		//Injury overlay sprites like open wounds
#define SURGERY_LEVEL			4		//Overlays for open surgical sites
#define UNDERWEAR_LAYER  		5		//Underwear/bras/etc
#define SHOES_LAYER_ALT			6		//Shoe-slot item (when set to be under uniform via verb)
#define UNIFORM_LAYER			7		//Uniform-slot item
#define ID_LAYER				8		//ID-slot item
#define SHOES_LAYER				9		//Shoe-slot item
#define GLOVES_LAYER			10		//Glove-slot item
#define BELT_LAYER				11		//Belt-slot item
#define SUIT_LAYER				12		//Suit-slot item
#define TAIL_LAYER				13		//Some species have tails to render
#define GLASSES_LAYER			14		//Eye-slot item
#define BELT_LAYER_ALT			15		//Belt-slot item (when set to be above suit via verb)
#define SUIT_STORE_LAYER		16		//Suit storage-slot item
#define BACK_LAYER				17		//Back-slot item
#define HAIR_LAYER				18		//The human's hair
#define EARS_LAYER				19		//Both ear-slot items (combined image)
#define EYES_LAYER				20		//Mob's eyes (used for glowing eyes)
#define FACEMASK_LAYER			21		//Mask-slot item
#define HEAD_LAYER				22		//Head-slot item
#define HANDCUFF_LAYER			23		//Handcuffs, if the human is handcuffed, in a secret inv slot
#define LEGCUFF_LAYER			24		//Same as handcuffs, for legcuffs
#define L_HAND_LAYER			25		//Left-hand item
#define R_HAND_LAYER			26		//Right-hand item
#define MODIFIER_EFFECTS_LAYER	27		//Effects drawn by modifiers
#define FIRE_LAYER				28		//'Mob on fire' overlay layer
#define WATER_LAYER				29		//'Mob submerged' overlay layer
#define TARGETED_LAYER			30		//'Aimed at' overlay layer
#define TOTAL_LAYERS			30//<---- KEEP THIS UPDATED, should always equal the highest number here, used to initialize a list.
//////////////////////////////////

/mob/living/carbon/human
	var/list/list_huds = list()
	var/list/list_body = list()
	var/list/list_layers = list()

	var/list/overlays_standing[TOTAL_LAYERS]
	var/previous_damage_appearance // store what the body last looked like, so we only have to update it if something changed

//UPDATES OVERLAYS FROM OVERLAYS_LYING/OVERLAYS_STANDING
//I'll work on removing that stuff by rewriting some of the cloaking stuff at a later date.
/mob/living/carbon/human/update_icons()
	if(QDESTROYING(src))
		return

	lying_prev = lying	//so we don't update overlays for lying/standing unless our stance changes again
	update_hud()		//TODO: remove the need for this

	//0: We start with their existing appearance (this contains their verbs, important to keep those!)
	var/mutable_appearance/ma_compiled = new(src)

	//1: HUDs because these are hidden behind a backplane. See update_icons_huds()
	ma_compiled.underlays = list_huds //The first one can set instead of add

	//2: The body itself, all the organs and whatnot
	//ma_compiled.overlays += list_body //Trying flat icon setting for now

	//3: The 'layers' list (overlays_standing), from the defines above
	ma_compiled.overlays = list_layers

	//4: Apply transforms based on situation
	update_transform(ma_compiled)

	//5: Do any species specific layering updates, such as when hiding.
	update_icon_special(ma_compiled, FALSE)

	//6: Set appearance once
	appearance = ma_compiled

/mob/living/carbon/human/update_transform(var/mutable_appearance/passed_ma)
	if(QDESTROYING(src))
		return

	var/mutable_appearance/ma
	if(passed_ma)
		ma = passed_ma
	else
		ma = new(src)

	// First, get the correct size.
	var/desired_scale = icon_scale

	desired_scale *= species.icon_scale

	for(var/datum/modifier/M in modifiers)
		if(!isnull(M.icon_scale_percent))
			desired_scale *= M.icon_scale_percent

	// Regular stuff again.
	if(lying && !species.prone_icon) //Only rotate them if we're not drawing a specific icon for being prone.
		var/matrix/M = matrix()
		M.Turn(90)
		M.Scale(desired_scale)
		M.Translate(1,-6)
		ma.transform = M
		ma.layer = MOB_LAYER -0.01 // Fix for a byond bug where turf entry order no longer matters
	else
		var/matrix/M = matrix()
		M.Scale(desired_scale)
		M.Translate(0, 16*(desired_scale-1))
		ma.transform = M
		ma.layer = MOB_LAYER // Fix for a byond bug where turf entry order no longer matters

	if(!passed_ma)
		update_icon_special(ma)
		appearance = ma

//Update the layers from the defines above
/mob/living/carbon/human/update_icons_layers(var/update_icons = 1)
	if(QDESTROYING(src))
		return

	list_layers.Cut()

	for(var/entry in overlays_standing)
		if(istype(entry, /image))
			list_layers += entry
		else if(istype(entry, /list)) //Is this necessary? What adds a list to this?
			for(var/inner_entry in entry)
				list_layers += inner_entry

	if(species && species.has_floating_eyes)
		list_layers += species.get_eyes(src)

	if(update_icons)
		update_icons()

//HUD Icons (ingame huds, not the user interface)
//Update things like med/sec hud icons
/mob/living/carbon/human/update_icons_huds(var/update_icons = 1)
	if(QDESTROYING(src))
		return

	list_huds.Cut()

	if(has_huds)
		list_huds = hud_list.Copy()
		list_huds += backplane // Required to mask HUDs in context menus: http://www.byond.com/forum/?post=2336679

	//Typing indicator code
	if(client && !stat) //They have a client & aren't dead/KO'd? Continue on!
		if(typing_indicator && hud_typing) //They already have the indicator and are still typing
			list_huds += typing_indicator
			typing_indicator.invisibility = invisibility

		else if(!typing_indicator && hud_typing) //Are they in their body, NOT dead, have hud_typing, do NOT have a typing indicator. and have it enabled?
			typing_indicator = new
			typing_indicator.icon = 'icons/mob/talk.dmi'
			typing_indicator.icon_state = "[speech_bubble_appearance()]_typing"
			list_huds += typing_indicator

		else if(typing_indicator && !hud_typing) //Did they stop typing?
			typing = FALSE
			hud_typing = FALSE

	if(update_icons)
		update_icons()

//A full, crunchy reprocess of all three cached lists
/mob/living/carbon/human/update_icons_all(var/update_icons = 1)
	if(QDESTROYING(src))
		return

	update_icons_huds(FALSE)
	update_icons_body(FALSE)
	update_icons_layers(FALSE)

	if(update_icons)
		update_icons()

var/global/list/damage_icon_parts = list()
//DAMAGE OVERLAYS
//constructs damage icon for each organ from mask * damage field and saves it in our overlays_ lists
/mob/living/carbon/human/UpdateDamageIcon(var/update_icons=1)
	if(QDESTROYING(src))
		return

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

	var/icon/standing = new /icon(species.damage_overlays, "00")

	var/image/standing_image = new /image("icon" = standing,layer = BODY_LAYER+DAMAGE_LAYER)

	// blend the individual damage states with our icons
	for(var/obj/item/organ/external/O in organs)
		if(isnull(O) || O.is_stump())
			continue

		O.update_icon()
		if(O.damage_state == "00") continue
		var/icon/DI
		var/cache_index = "[O.damage_state]/[O.icon_name]/[species.get_blood_colour(src)]/[species.get_bodytype(src)]"
		if(damage_icon_parts[cache_index] == null)
			DI = new /icon(species.get_damage_overlays(src), O.damage_state)			// the damage icon for whole human
			DI.Blend(new /icon(species.get_damage_mask(src), O.icon_name), ICON_MULTIPLY)	// mask with this organ's pixels
			DI.Blend(species.get_blood_colour(src), ICON_MULTIPLY)
			damage_icon_parts[cache_index] = DI
		else
			DI = damage_icon_parts[cache_index]

		standing_image.overlays += DI

	overlays_standing[DAMAGE_LAYER]	= standing_image

	if(update_icons)
		update_icons_layers()

//BASE MOB SPRITE
/mob/living/carbon/human/update_icons_body(var/update_icons=1)
	if(QDESTROYING(src))
		return

	var/husk_color_mod = rgb(96,88,80)
	var/hulk_color_mod = rgb(48,224,40)

	var/husk = (HUSK in src.mutations)
	var/fat = (FAT in src.mutations)
	var/hulk = (HULK in src.mutations)
	var/skeleton = (SKELETON in src.mutations)

	robolimb_count = 0
	robobody_count = 0

	//CACHING: Generate an index key from visible bodyparts.
	//0 = destroyed, 1 = normal, 2 = robotic, 3 = necrotic.

	//Create a new, blank icon for our mob to use.
	var/icon/stand_icon = new(species.icon_template ? species.icon_template : 'icons/mob/human.dmi',"blank")

	//Clean old list_body
	list_body.Cut()

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
		icon_key += "#000000"

	for(var/organ_tag in species.has_limbs)
		var/obj/item/organ/external/part = organs_by_name[organ_tag]
		if(isnull(part) || part.is_stump())
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
				icon_key += "[part.s_col_blend]"
			else
				icon_key += "#000000"
			for(var/M in part.markings)
				icon_key += "[M][part.markings[M]["color"]]"

			if(part.robotic >= ORGAN_ROBOT)
				icon_key += "2[part.model ? "-[part.model]": ""]"
				robolimb_count++
				if(part.organ_tag == BP_HEAD || part.organ_tag == BP_TORSO || part.organ_tag == BP_GROIN)
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
			if(isnull(part) || part.is_stump())
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
	//var/image/standing = image(stand_icon)
	//standing.layer = BODY_LAYER
	//list_body += standing //A little silly, almost pointless to use a list for this, but can come back later and make this proc itself better
	icon = stand_icon

	if(update_icons)
		update_icons()

	//tail
	update_tail_showing(0)

/mob/living/carbon/human/proc/update_skin(var/update_icons=1)
	if(QDESTROYING(src))
		return
	
	var/image/skin = species.update_skin(src)
	if(skin)
		skin.layer = BODY_LAYER+SKIN_LAYER
		overlays_standing[SKIN_LAYER] = skin
	
	if(update_icons)   update_icons_layers()

//UNDERWEAR OVERLAY
/mob/living/carbon/human/proc/update_underwear(var/update_icons=1)
	if(QDESTROYING(src))
		return

	overlays_standing[UNDERWEAR_LAYER] = null

	if(species.appearance_flags & HAS_UNDERWEAR)
		overlays_standing[UNDERWEAR_LAYER] = list()
		for(var/category in all_underwear)
			if(hide_underwear[category])
				continue
			var/datum/category_item/underwear/UWI = all_underwear[category]
			var/image/wear = UWI.generate_image(all_underwear_metadata[category], layer = BODY_LAYER+UNDERWEAR_LAYER)
			overlays_standing[UNDERWEAR_LAYER] += wear

	if(update_icons)   update_icons_layers()

//HAIR OVERLAY
/mob/living/carbon/human/proc/update_hair(var/update_icons=1)
	if(QDESTROYING(src))
		return

	//Reset our hair
	overlays_standing[HAIR_LAYER]	= null
	update_eyes(0) //Pirated out of here, for glowing eyes.

	var/obj/item/organ/external/head/head_organ = get_organ(BP_HEAD)
	if(!head_organ || head_organ.is_stump() )
		if(update_icons)   update_icons_layers()
		return

	//masks and helmets can obscure our hair.
	if( (head && (head.flags_inv & BLOCKHAIR)) || (wear_mask && (wear_mask.flags_inv & BLOCKHAIR)))
		if(update_icons)   update_icons_layers()
		return

	//base icons
	var/icon/face_standing	= new /icon('icons/mob/human_face.dmi',"bald_s")

	if(f_style)
		var/datum/sprite_accessory/facial_hair_style = facial_hair_styles_list[f_style]
		if(facial_hair_style && facial_hair_style.species_allowed && (src.species.get_bodytype(src) in facial_hair_style.species_allowed))
			var/icon/facial_s = new/icon("icon" = facial_hair_style.icon, "icon_state" = "[facial_hair_style.icon_state]_s")
			if(facial_hair_style.do_colouration)
				facial_s.Blend(rgb(r_facial, g_facial, b_facial), ICON_ADD)

			face_standing.Blend(facial_s, ICON_OVERLAY)

	if(h_style && !(head && (head.flags_inv & BLOCKHEADHAIR)))
		var/datum/sprite_accessory/hair/hair_style = hair_styles_list[h_style]
		if(hair_style && (src.species.get_bodytype(src) in hair_style.species_allowed))
			var/icon/hair_s = new/icon("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state]_s")
			var/icon/hair_s_add = new/icon("icon" = hair_style.icon_add, "icon_state" = "[hair_style.icon_state]_s")
			if(hair_style.do_colouration)
				hair_s.Blend(rgb(r_hair, g_hair, b_hair), ICON_MULTIPLY)
				hair_s.Blend(hair_s_add, ICON_ADD)

			face_standing.Blend(hair_s, ICON_OVERLAY)

	if(head_organ.nonsolid)
		face_standing += rgb(,,,120)

	overlays_standing[HAIR_LAYER]	= image(face_standing, layer = BODY_LAYER+HAIR_LAYER)
	if(update_icons)   update_icons_layers()

/mob/living/carbon/human/update_eyes(var/update_icons=1)
	if(QDESTROYING(src))
		return

	//Reset our eyes
	overlays_standing[EYES_LAYER]	= null

	//TODO: Probably redo this. I know I wrote it, but...

	//This is ONLY for glowing eyes for now. Boring flat eyes are done by the head's own proc.
	if(!species.has_glowing_eyes)
		if(update_icons) update_icons_layers()
		return

	//Our glowy eyes should be hidden if some equipment hides them.
	if(!should_have_organ(O_EYES) || (head && (head.flags_inv & BLOCKHAIR)) || (wear_mask && (wear_mask.flags_inv & BLOCKHAIR)))
		if(update_icons) update_icons_layers()
		return

	//Get the head, we'll need it later.
	var/obj/item/organ/external/head/head_organ = get_organ(BP_HEAD)
	if(!head_organ || head_organ.is_stump() )
		if(update_icons)   update_icons_layers()
		return

	//The eyes store the color themselves, funny enough.
	var/obj/item/organ/internal/eyes/eyes = internal_organs_by_name[O_EYES]
	if(!head_organ.eye_icon)
		if(update_icons) update_icons_layers()
		return

	var/icon/eyes_icon = new/icon(head_organ.eye_icon_location, head_organ.eye_icon)
	if(eyes)
		eyes_icon.Blend(rgb(eyes.eye_colour[1], eyes.eye_colour[2], eyes.eye_colour[3]), ICON_ADD)
	else
		eyes_icon.Blend(rgb(128,0,0), ICON_ADD)

	var/image/eyes_image = image(eyes_icon)
	eyes_image.plane = PLANE_LIGHTING_ABOVE

	overlays_standing[EYES_LAYER] = eyes_image

	if(update_icons) update_icons_layers()

/mob/living/carbon/human/update_mutations(var/update_icons=1)
	if(QDESTROYING(src))
		return

	overlays_standing[MUTATIONS_LAYER]	= null
	
	if(!LAZYLEN(mutations))
		if(update_icons) update_icons_layers()
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
		
	if(update_icons) update_icons_layers()

/* --------------------------------------- */
//For legacy support.
/mob/living/carbon/human/regenerate_icons()
	..()
	if(transforming || QDELETED(src))		return

	update_mutations(0)
	update_skin(0)
	update_icons_body(0)
	update_underwear(0)
	update_hair(0)
	update_inv_w_uniform(0)
	update_inv_wear_id(0)
	update_inv_gloves(0)
	update_inv_glasses(0)
	update_inv_ears(0)
	update_inv_shoes(0)
	update_inv_s_store(0)
	update_inv_wear_mask(0)
	update_inv_head(0)
	update_inv_belt(0)
	update_inv_back(0)
	update_inv_wear_suit(0)
	update_inv_r_hand(0)
	update_inv_l_hand(0)
	update_inv_handcuffed(0)
	update_inv_legcuffed(0)
	update_inv_pockets(0)
	update_fire(0)
	update_water(0)
	update_surgery(0)
	UpdateDamageIcon(0)
	update_icons_layers(0)
	update_icons_huds(0)
	update_icons()
	//Hud Stuff
	update_hud()

/* --------------------------------------- */
//vvvvvv UPDATE_INV PROCS vvvvvv

/mob/living/carbon/human/update_inv_w_uniform(var/update_icons=1)
	if(QDESTROYING(src))
		return

	overlays_standing[UNIFORM_LAYER] = null

	if(!(w_uniform && istype(w_uniform, /obj/item/clothing/under)))
		if(update_icons) update_icons_layers()
		return //Not wearing a uniform (dumb check)
	 
	if(wear_suit && istype(wear_suit, /obj/item/clothing/suit/space) && (wear_suit.flags_inv & HIDEJUMPSUIT) && !istype(wear_suit, /obj/item/clothing/suit/space/rig))
		if(update_icons) update_icons_layers()
		return //Wearing a suit that prevents uniform rendering

	//Align this item on the inventory screen TODO: Move this elsewhere
	w_uniform.screen_loc = ui_iclothing

	//Build a uniform sprite
	overlays_standing[UNIFORM_LAYER] = w_uniform.make_worn_icon(body_type = species.get_bodytype(), slot_name = slot_w_uniform_str, default_icon = INV_W_UNIFORM_DEF_ICON, default_layer = UNIFORM_LAYER)

	//Shoes can be affected by uniform being drawn onto them
	update_inv_shoes(FALSE)

	//TODO: Remove this
	if(update_icons) update_icons_layers()

/mob/living/carbon/human/update_inv_wear_id(var/update_icons=1)
	if(QDESTROYING(src))
		return

	overlays_standing[ID_LAYER]	= null

	if(!wear_id)
		if(update_icons) update_icons_layers()
		return //Not wearing an ID
	
	//Align this item on the inventory screen TODO: Move this elsewhere
	wear_id.screen_loc = ui_id

	//Only draw the ID on the mob if the uniform allows for it
	if(w_uniform && istype(w_uniform, /obj/item/clothing/under))
		var/obj/item/clothing/under/U = w_uniform
		if(U.displays_id)
			overlays_standing[ID_LAYER] = wear_id.make_worn_icon(body_type = species.get_bodytype(), slot_name = slot_wear_id_str, default_icon = INV_WEAR_ID_DEF_ICON, default_layer = ID_LAYER)

	//Set the bits to update the ID hud since they put something in this slot (or removed it)
	//TODO: Move elsewhere, update icons is not the place.
	BITSET(hud_updateflag, ID_HUD)
	BITSET(hud_updateflag, WANTED_HUD)

	//TODO: Remove this
	if(update_icons) update_icons_layers()

/mob/living/carbon/human/update_inv_gloves(var/update_icons=1)
	if(QDESTROYING(src))
		return

	overlays_standing[GLOVES_LAYER]	= null

	if(!gloves && !blood_DNA)
		if(update_icons) update_icons_layers()
		return //No gloves, no bloody hands, no reason to be here.

	//Draw gloves if they have gloves
	if(gloves)
		gloves.screen_loc = ui_gloves //TODO

		overlays_standing[GLOVES_LAYER]	= gloves.make_worn_icon(body_type = species.get_bodytype(), slot_name = slot_gloves_str, default_icon = INV_GLOVES_DEF_ICON, default_layer = GLOVES_LAYER)
	
	else if(blood_DNA) //TODO: Make this proc generic
		var/image/bloodsies	= image("icon" = species.get_blood_mask(src), "icon_state" = "bloodyhands")
		bloodsies.color = hand_blood_color
		overlays_standing[GLOVES_LAYER]	= bloodsies
	
	if(update_icons)
		update_icons_layers()

/mob/living/carbon/human/update_inv_glasses(var/update_icons=1)
	if(QDESTROYING(src))
		return

	overlays_standing[GLASSES_LAYER] = null

	if(!glasses)
		if(update_icons) update_icons_layers()
		return //Not wearing glasses, no need to update anything.

	overlays_standing[GLASSES_LAYER] = glasses.make_worn_icon(body_type = species.get_bodytype(), slot_name = slot_gloves_str, default_icon = INV_EYES_DEF_ICON, default_layer = GLASSES_LAYER)
		
	if(update_icons) update_icons_layers()

/mob/living/carbon/human/update_inv_ears(var/update_icons=1)
	if(QDESTROYING(src))
		return

	overlays_standing[EARS_LAYER] = null

	if((head && head.flags_inv & (BLOCKHAIR | BLOCKHEADHAIR)) || (wear_mask && wear_mask.flags_inv & (BLOCKHAIR | BLOCKHEADHAIR)))
		if(update_icons) update_icons_layers()
		return //Ears are blocked (by hair being blocked, overloaded)

	if(!l_ear && !r_ear)
		if(update_icons) update_icons_layers()
		return //Why bother, if no ear sprites
		
	// Blank image upon which to layer left & right overlays.
	var/image/both = image(icon = 'icons/effects/effects.dmi', icon_state = "nothing", layer = BODY_LAYER+EARS_LAYER)

	if(l_ear)
		var/image/standing = l_ear.make_worn_icon(body_type = species.get_bodytype(), slot_name = slot_l_ear_str, default_icon = INV_EARS_DEF_ICON, default_layer = EARS_LAYER)
		both.add_overlay(standing)

	if(r_ear)
		var/image/standing = r_ear.make_worn_icon(body_type = species.get_bodytype(), slot_name = slot_r_ear_str, default_icon = INV_EARS_DEF_ICON, default_layer = EARS_LAYER)
		both.add_overlay(standing)

	overlays_standing[EARS_LAYER] = both

	if(update_icons) update_icons_layers()

/mob/living/carbon/human/update_inv_shoes(var/update_icons=1)
	if(QDESTROYING(src))
		return

	overlays_standing[SHOES_LAYER] = null
	overlays_standing[SHOES_LAYER_ALT] = null //Dumb alternate layer for shoes being under the uniform.

	if((!shoes && !feet_blood_DNA) || (wear_suit && wear_suit.flags_inv & HIDESHOES) || (w_uniform && w_uniform.flags_inv & HIDESHOES))
		if(update_icons) update_icons_layers()
		return //Either nothing to draw, or it'd be hidden.

	if(shoes)
		//Allow for shoe layer toggle nonsense
		var/shoe_layer = SHOES_LAYER
		if(istype(shoes, /obj/item/clothing/shoes))
			var/obj/item/clothing/shoes/ushoes = shoes
			if(ushoes.shoes_under_pants == 1)
				shoe_layer = SHOES_LAYER_ALT

		//NB: the use of a var for the layer on this one
		overlays_standing[shoe_layer] = shoes.make_worn_icon(body_type = species.get_bodytype(), slot_name = slot_shoes_str, default_icon = INV_FEET_DEF_ICON, default_layer = shoe_layer)

	//Bloody feet, but not wearing shoes TODO
	else if(feet_blood_DNA)
		var/image/bloodsies = image("icon" = species.get_blood_mask(src), "icon_state" = "shoeblood")
		bloodsies.color = feet_blood_color
		overlays_standing[SHOES_LAYER] = bloodsies
			
	if(update_icons) update_icons_layers()

/mob/living/carbon/human/update_inv_s_store(var/update_icons=1)
	if(QDESTROYING(src))
		return

	overlays_standing[SUIT_STORE_LAYER]	= null

	if(!s_store)
		if(update_icons) update_icons_layers()
		return //Why bother, nothing there.

	s_store.screen_loc = ui_sstore1		//TODO
	
	//TODO, this is unlike the rest of the things
	//Basically has no variety in slot icon choices at all. WHY SPECIES ONLY??
	var/t_state = s_store.item_state
	if(!t_state)
		t_state = s_store.icon_state
	overlays_standing[SUIT_STORE_LAYER]	= image(icon = species.suit_storage_icon, icon_state = t_state, layer = BODY_LAYER+SUIT_STORE_LAYER)
		
	if(update_icons) update_icons_layers()

/mob/living/carbon/human/update_inv_head(var/update_icons=1)
	if(QDESTROYING(src))
		return

	overlays_standing[HEAD_LAYER] = null
	
	if(!head)
		if(update_icons) update_icons_layers()
		return //No head item, why bother.
		
	head.screen_loc = ui_head //TODO

	overlays_standing[HEAD_LAYER] = head.make_worn_icon(body_type = species.get_bodytype(), slot_name = slot_head_str, default_icon = INV_HEAD_DEF_ICON, default_layer = HEAD_LAYER)

	if(update_icons) update_icons_layers()

/mob/living/carbon/human/update_inv_belt(var/update_icons=1)
	if(QDESTROYING(src))
		return

	overlays_standing[BELT_LAYER] = null
	overlays_standing[BELT_LAYER_ALT] = null //Because you can toggle belt layer with a verb

	if(!belt)
		if(update_icons) update_icons_layers()
		return //No belt, why bother.

	belt.screen_loc = ui_belt	//TODO - Distant screaming.
	
	//Toggle for belt layering with uniform
	var/belt_layer = BELT_LAYER
	if(istype(belt, /obj/item/weapon/storage/belt))
		var/obj/item/weapon/storage/belt/ubelt = belt
		if(ubelt.show_above_suit)
			belt_layer = BELT_LAYER_ALT

	//NB: this uses a var from above
	overlays_standing[belt_layer] = belt.make_worn_icon(body_type = species.get_bodytype(), slot_name = slot_belt_str, default_icon = INV_BELT_DEF_ICON, default_layer = belt_layer)

	if(update_icons) update_icons_layers()

/mob/living/carbon/human/update_inv_wear_suit(var/update_icons=1)
	if(QDESTROYING(src))
		return

	overlays_standing[SUIT_LAYER] = null

	if(!wear_suit)
		if(update_icons) update_icons_layers()
		return //No point, no suit.

		wear_suit.screen_loc = ui_oclothing //TODO

	overlays_standing[SUIT_LAYER] = wear_suit.make_worn_icon(body_type = species.get_bodytype(), slot_name = slot_wear_suit_str, default_icon = INV_SUIT_DEF_ICON, default_layer = SUIT_LAYER)

	//REALLY? REAAAAAAALLY???? UPDATE ICONS??? TODO
	if( istype(wear_suit, /obj/item/clothing/suit/straight_jacket) )
		drop_from_inventory(handcuffed)
		drop_l_hand()
		drop_r_hand()

	//Hide/show other layers if necessary (AAAAA) TODO
	update_inv_w_uniform(0)
	update_inv_shoes(0)
	update_tail_showing(0)

	if(update_icons) update_icons_layers()

/mob/living/carbon/human/update_inv_pockets(var/update_icons=1)
	if(QDESTROYING(src))
		return

	//Wow, this can probably go away, huh.
	if(l_store)			l_store.screen_loc = ui_storage1	//TODO
	if(r_store)			r_store.screen_loc = ui_storage2	//TODO
	if(update_icons)	update_icons_layers()

/mob/living/carbon/human/update_inv_wear_mask(var/update_icons=1)
	if(QDESTROYING(src))
		return

	overlays_standing[FACEMASK_LAYER]	= null

	if(!wear_mask || (head && head.flags_inv & HIDEMASK))
		if(update_icons) update_icons_layers()
		return //Why bother, nothing in mask slot.

	wear_mask.screen_loc = ui_mask	//TODO
	
	overlays_standing[FACEMASK_LAYER] = wear_mask.make_worn_icon(body_type = species.get_bodytype(), slot_name = slot_wear_mask_str, default_icon = INV_MASK_DEF_ICON, default_layer = FACEMASK_LAYER)
	
	if(update_icons) update_icons_layers()

/mob/living/carbon/human/update_inv_back(var/update_icons=1)
	if(QDESTROYING(src))
		return

	overlays_standing[BACK_LAYER] = null

	if(!back)
		if(update_icons) update_icons_layers()
		return

	back.screen_loc = ui_back	//TODO

	overlays_standing[BACK_LAYER] = back.make_worn_icon(body_type = species.get_bodytype(), slot_name = slot_back_str, default_icon = INV_BACK_DEF_ICON, default_layer = BACK_LAYER)

	if(update_icons) update_icons_layers()

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
	if(hud_used && hud_used.l_hand_hud_object && hud_used.r_hand_hud_object)
		hud_used.l_hand_hud_object.update_icon()
		hud_used.r_hand_hud_object.update_icon()

/mob/living/carbon/human/update_inv_handcuffed(var/update_icons=1)
	if(QDESTROYING(src))
		return

	overlays_standing[HANDCUFF_LAYER] = null
	update_hud_handcuffed()

	if(!handcuffed)
		if(update_icons) update_icons_layers()
		return //Not cuffed, why bother

	drop_r_hand()
	drop_l_hand()
	stop_pulling()	//TODO: should be handled elsewhere

	overlays_standing[HANDCUFF_LAYER] = handcuffed.make_worn_icon(body_type = species.get_bodytype(), slot_name = slot_handcuffed_str, default_icon = INV_HCUFF_DEF_ICON, default_layer = HANDCUFF_LAYER)

	if(update_icons) update_icons_layers()

/mob/living/carbon/human/update_inv_legcuffed(var/update_icons=1)
	if(QDESTROYING(src))
		return

	overlays_standing[LEGCUFF_LAYER] = null

	if(!legcuffed)
		if(update_icons) update_icons_layers()
		return //Not legcuffed, why bother.

	overlays_standing[LEGCUFF_LAYER] = handcuffed.make_worn_icon(body_type = species.get_bodytype(), slot_name = slot_legcuffed_str, default_icon = INV_LCUFF_DEF_ICON, default_layer = LEGCUFF_LAYER)

	//TODO: Not in my update_icons
	if(m_intent != "walk")
		m_intent = "walk"
		if(hud_used && src.hud_used.move_intent)
			hud_used.move_intent.icon_state = "walking"

	if(update_icons) update_icons_layers()

/mob/living/carbon/human/update_inv_r_hand(var/update_icons=1)
	if(QDESTROYING(src))
		return

	overlays_standing[R_HAND_LAYER] = null

	if(!r_hand)
		if(update_icons) update_icons_layers()
		return //No hand, no bother.

	r_hand.screen_loc = ui_rhand	//TODO

	overlays_standing[R_HAND_LAYER] = r_hand.make_worn_icon(body_type = species.get_bodytype(), inhands = TRUE, slot_name = slot_r_hand_str, default_icon = INV_R_HAND_DEF_ICON, default_layer = R_HAND_LAYER)

	if(handcuffed)
		drop_r_hand() //TODO: EXCUSE ME

	if(update_icons) update_icons_layers()

/mob/living/carbon/human/update_inv_l_hand(var/update_icons=1)
	if(QDESTROYING(src))
		return

	overlays_standing[L_HAND_LAYER] = null

	if(!l_hand)
		if(update_icons) update_icons_layers()
		return //No hand, no bother.

	l_hand.screen_loc = ui_lhand	//TODO

	overlays_standing[L_HAND_LAYER] = l_hand.make_worn_icon(body_type = species.get_bodytype(), inhands = TRUE, slot_name = slot_l_hand_str, default_icon = INV_L_HAND_DEF_ICON, default_layer = L_HAND_LAYER)

	if(handcuffed)
		drop_l_hand() //TODO: AAAAAAAAAAa

	if(update_icons) update_icons_layers()

/mob/living/carbon/human/proc/update_tail_showing(var/update_icons=1)
	if(QDESTROYING(src))
		return

	overlays_standing[TAIL_LAYER] = null

	var/species_tail = species.get_tail(src)

	//This one is actually not that bad I guess.
	if(species_tail && !(wear_suit && wear_suit.flags_inv & HIDETAIL))
		var/icon/tail_s = get_tail_icon()
		overlays_standing[TAIL_LAYER] = image(tail_s, icon_state = "[species_tail]_s")
		animate_tail_reset(0)

	if(update_icons) update_icons_layers()

//TODO: Is this the appropriate place for this, and not on species...?
/mob/living/carbon/human/proc/get_tail_icon()
	var/icon_key = "[species.get_race_key(src)][r_skin][g_skin][b_skin][r_hair][g_hair][b_hair]"
	var/icon/tail_icon = tail_icon_cache[icon_key]
	if(!tail_icon)
		//generate a new one
		var/species_tail_anim = species.get_tail_animation(src)
		if(!species_tail_anim) species_tail_anim = 'icons/effects/species.dmi'
		tail_icon = new/icon(species_tail_anim)
		tail_icon.Blend(rgb(r_skin, g_skin, b_skin), ICON_ADD)
		// The following will not work with animated tails.
		var/use_species_tail = species.get_tail_hair(src)
		if(use_species_tail)
			var/icon/hair_icon = icon('icons/effects/species.dmi', "[species.get_tail(src)]_[use_species_tail]")
			hair_icon.Blend(rgb(r_hair, g_hair, b_hair), ICON_ADD)
			tail_icon.Blend(hair_icon, ICON_OVERLAY)
		tail_icon_cache[icon_key] = tail_icon

	return tail_icon

/mob/living/carbon/human/proc/set_tail_state(var/t_state)
	var/image/tail_overlay = overlays_standing[TAIL_LAYER]

	if(tail_overlay && species.get_tail_animation(src))
		tail_overlay.icon_state = t_state
		return tail_overlay
	return null

//Not really once, since BYOND can't do that.
//Update this if the ability to flick() images or make looping animation start at the first frame is ever added.
//You can sort of flick images now with flick_overlay -Aro
/mob/living/carbon/human/proc/animate_tail_once(var/update_icons=1)
	if(QDESTROYING(src))
		return

	var/t_state = "[species.get_tail(src)]_once"

	var/image/tail_overlay = overlays_standing[TAIL_LAYER]
	if(tail_overlay && tail_overlay.icon_state == t_state)
		return //let the existing animation finish

	tail_overlay = set_tail_state(t_state)
	if(tail_overlay)
		spawn(20)
			//check that the animation hasn't changed in the meantime
			if(overlays_standing[TAIL_LAYER] == tail_overlay && tail_overlay.icon_state == t_state)
				animate_tail_stop()

	if(update_icons) update_icons_layers()

/mob/living/carbon/human/proc/animate_tail_start(var/update_icons=1)
	if(QDESTROYING(src))
		return

	set_tail_state("[species.get_tail(src)]_slow[rand(0,9)]")

	if(update_icons) update_icons_layers()

/mob/living/carbon/human/proc/animate_tail_fast(var/update_icons=1)
	if(QDESTROYING(src))
		return

	set_tail_state("[species.get_tail(src)]_loop[rand(0,9)]")

	if(update_icons) update_icons_layers()

/mob/living/carbon/human/proc/animate_tail_reset(var/update_icons=1)
	if(QDESTROYING(src))
		return

	if(stat != DEAD)
		set_tail_state("[species.get_tail(src)]_idle[rand(0,9)]")
	else
		set_tail_state("[species.get_tail(src)]_static")

	if(update_icons) update_icons_layers()

/mob/living/carbon/human/proc/animate_tail_stop(var/update_icons=1)
	if(QDESTROYING(src))
		return

	set_tail_state("[species.get_tail(src)]_static")

	if(update_icons) update_icons_layers()

/mob/living/carbon/human/update_modifier_visuals(var/update_icons=1)
	if(QDESTROYING(src))
		return

	overlays_standing[MODIFIER_EFFECTS_LAYER] = null

	if(!LAZYLEN(modifiers))
		if(update_icons) update_icons_layers()
		return //No modifiers, no effects.

	var/image/effects = new()
	for(var/datum/modifier/M in modifiers)
		if(M.mob_overlay_state)
			var/image/I = image(icon = 'icons/mob/modifier_effects.dmi', icon_state = M.mob_overlay_state)
			effects.overlays += I //TODO, this compositing is annoying.

	overlays_standing[MODIFIER_EFFECTS_LAYER] = effects

	if(update_icons) update_icons_layers()

/mob/living/carbon/human/update_fire(var/update_icons=1)
	if(QDESTROYING(src))
		return

	overlays_standing[FIRE_LAYER] = null
	
	if(on_fire)
		overlays_standing[FIRE_LAYER] = image(icon = 'icons/mob/OnFire.dmi', icon_state = get_fire_icon_state())

	if(update_icons) update_icons_layers()

/mob/living/carbon/human/update_water(var/update_icons=1)
	if(QDESTROYING(src))
		return

	overlays_standing[WATER_LAYER] = null

	var/depth = check_submerged()
	if(depth && !lying)
		overlays_standing[WATER_LAYER] = image(icon = 'icons/mob/submerged.dmi', icon_state = "human_swimming_[depth]") //TODO: Improve

	if(update_icons) update_icons_layers()

/mob/living/carbon/human/proc/update_surgery(var/update_icons=1)
	if(QDESTROYING(src))
		return

	overlays_standing[SURGERY_LEVEL] = null

	var/image/total = new
	for(var/obj/item/organ/external/E in organs)
		if(E.open)
			var/image/I = image(icon = 'icons/mob/surgery.dmi',  icon_state = "[E.icon_name][round(E.open)]", layer = -SURGERY_LEVEL)
			total.overlays += I //TODO: This compositing is annoying

	overlays_standing[SURGERY_LEVEL] = total
	
	if(update_icons) update_icons_layers()

//Human Overlays Indexes/////////
#undef MUTATIONS_LAYER
#undef SKIN_LAYER
#undef DAMAGE_LAYER
#undef SURGERY_LEVEL
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