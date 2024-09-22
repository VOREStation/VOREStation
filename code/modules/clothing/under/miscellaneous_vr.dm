/obj/item/clothing/under/customs
	desc = "A standard SolCom customs uniform. Complete with epaulettes."

/obj/item/clothing/var/hides_bulges = FALSE // OwO wats this?

/obj/item/clothing/under/permit
	name = "public nudity permit"
	desc = "This permit entitles the bearer to conduct their duties without a uniform. Normally issued to furred crewmembers or those with nothing to hide."
	icon = 'icons/obj/card_new.dmi'
	icon_state = "permit-nude"
	body_parts_covered = 0
	equip_sound = null

	sprite_sheets = null

	item_state = "golem"  //This is dumb and hacky but was here when I got here.
	worn_state = "golem"  //It's basically just a coincidentally black iconstate in the file.

/obj/item/clothing/under/hyperfiber
	name = "HYPER jumpsuit"
	icon = 'icons/inventory/uniform/item_vr.dmi'
	icon_override = 'icons/inventory/uniform/mob_vr.dmi'
	icon_state = "hyper"
	item_icons = list(
			slot_l_hand_str = 'icons/mob/items/lefthand_uniforms.dmi',
			slot_r_hand_str = 'icons/mob/items/righthand_uniforms.dmi',
			)
	item_state = "hyper"
	worn_state = "hyper"
	desc = "Got a lot to hide on your body? Well, this Heavy Yield Protrusion Erasing and Retracting suit seems perfect for you. \
			Hides any bulges on your body, as well as conceals your true weight."
	hides_bulges = TRUE

/obj/item/clothing/under/hyperfiber/verb/toggle_fibers()
		set category = "Object"
		set name = "Adjust Bluespace Fibers"
		set desc = "Adjust your suit's HYPER fibers. Activating it hides your stomach(s) and your general body-build. Good if you have a lot to hide."
		set src in usr

		adjust_fibers(usr)

/obj/item/clothing/under/hyperfiber/proc/adjust_fibers(mob/user)
	if(hides_bulges == FALSE)
		hides_bulges = TRUE
		to_chat(user, "You tense the suit fibers, hiding your stomach(s) and weight.")
	else
		hides_bulges = FALSE
		to_chat(user, "You relax the suit fibers, revealing your stomach(s) and weight.")

/obj/item/clothing/under/hyperfiber/bluespace
	name = "bluespace jumpsuit"
	icon_state = "bluespace"
	item_state = "bluespace"
	worn_state = "bluespace"
	desc = "Do you feel like warping spacetime today? Because it seems like that's on the agenda, now. \
			Allows one to resize themselves at will, and conceals their true weight as well as any bulges or protrusions on their body."
	var/original_size

/obj/item/clothing/under/hyperfiber/bluespace/verb/resize()
	set name = "Adjust Bluespace Fibers"
	set desc = "Adjust your suit's bluespace fibers. Activating it allows you to expand your own body or reduce it in size! Effect is limited to when you have the suit on."
	set category = "Object"
	set src in usr
	bluespace_size(usr)

/obj/item/clothing/under/hyperfiber/bluespace/proc/bluespace_size(mob/usr as mob)
	if (!ishuman(usr))
		return

	var/mob/living/carbon/human/H = usr

	if (H.stat || H.restrained())
		return

	if (src != H.w_uniform)
		to_chat(H,"<span class='warning'>You must be WEARING the uniform to change your size.</span>")
		return

	var/new_size = tgui_input_number(usr, "Put the desired size (25-200%), or (1-600%) in dormitory areas.", "Set Size", 200, 600, 1)
	if(!new_size)
		return //cancelled

	//Check AGAIN because we accepted user input which is blocking.
	if (src != H.w_uniform)
		to_chat(H,"<span class='warning'>You must be WEARING the uniform to change your size.</span>")
		return

	if (H.stat || H.restrained())
		return

	if (isnull(H.size_multiplier)) // Why would this ever be the case?
		to_chat(H,"<span class='warning'>The uniform panics and corrects your apparently microscopic size.</span>")
		H.resize(RESIZE_NORMAL, ignore_prefs = TRUE)
		H.update_icons() //Just want the matrix transform
		return

	if (!H.size_range_check(new_size))
		to_chat(H,"<span class='notice'>The safety features of the uniform prevent you from choosing this size.</span>")
		return

	else if(new_size)
		if(new_size != H.size_multiplier)
			if(!original_size)
				original_size = H.size_multiplier
			H.resize(new_size/100, uncapped = H.has_large_resize_bounds(), ignore_prefs = TRUE) // Ignores prefs because you can only resize yourself
			H.visible_message("<span class='warning'>The space around [H] distorts as they change size!</span>","<span class='notice'>The space around you distorts as you change size!</span>")
		else //They chose their current size.
			return

/obj/item/clothing/under/hyperfiber/bluespace/mob_can_unequip(mob/M, slot, disable_warning = 0)
	. = ..()
	if(. && ishuman(M) && original_size && !disable_warning)
		var/mob/living/carbon/human/H = M
		H.resize(original_size, ignore_prefs = TRUE)
		original_size = null
		H.visible_message("<span class='warning'>The space around [H] distorts as they return to their original size!</span>","<span class='notice'>The space around you distorts as you return to your original size!</span>")

/obj/item/clothing/gloves/bluespace
	name = "size standardization bracelet"
	desc = "A somewhat bulky metal bracelet featuring a crystal, glowing blue. The outer side of the bracelet has an elongated case that one might imagine contains electronic components. This bracelet is used to standardize the size of crewmembers who may need a non-permanent size assist."
	icon = 'icons/inventory/accessory/item_vr.dmi'
	icon_state = "bs_bracelet"
	w_class = ITEMSIZE_TINY
	glove_level = 1
	var/original_size
	var/last_activated
	var/emagged = FALSE
	var/target_size = 1

/obj/item/proc/equip_special()
	return

/obj/item/clothing/gloves/bluespace/equip_special()
	var/mob/M = src.loc
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.resizable)
			return
		if(H.size_multiplier != target_size)
			if(!(world.time - last_activated > 10 SECONDS))
				to_chat(M, "<span class ='warning'>\The [src] flickers. It seems to be recharging.</span>")
				return
			last_activated = world.time
			original_size = H.size_multiplier
			H.resize(target_size, uncapped = emagged, ignore_prefs = FALSE)		//In case someone else tries to put it on you.
			H.visible_message("<span class='warning'>The space around [H] distorts as they change size!</span>","<span class='notice'>The space around you distorts as you change size!</span>")
			log_admin("Admin [key_name(M)]'s size was altered by a bluespace bracelet.")

/obj/item/clothing/gloves/bluespace/mob_can_unequip(mob/M, gloves, disable_warning = 0)
	. = ..()
	if(. && ishuman(M) && original_size && !disable_warning)
		var/mob/living/carbon/human/H = M
		if(!H.resizable)
			return
		last_activated = world.time
		H.resize(original_size, uncapped = emagged, ignore_prefs = FALSE)
		original_size = null
		H.visible_message("<span class='warning'>The space around [H] distorts as they return to their original size!</span>","<span class='notice'>The space around you distorts as you return to your original size!</span>")
		log_admin("Admin [key_name(M)]'s size was altered by a bluespace bracelet.")
		to_chat(M, "<span class ='warning'>\The [src] flickers. It is now recharging and will be ready again in thirty seconds.</span>")

/obj/item/clothing/gloves/bluespace/examine(var/mob/user)
	. = ..()
	var/cooldowntime = round((10 SECONDS - (world.time - last_activated)) * 0.1)
	if(Adjacent(user))
		if(cooldowntime >= 0)
			. += "<span class='notice'>It appears to be recharging.</span>"
		if(emagged)
			. += "<span class='warning'>The crystal is flickering.</span>"

/obj/item/clothing/gloves/bluespace/emag_act(R_charges, var/mob/user, emag_source)
	. = ..()
	if(!emagged)
		emagged = TRUE
		target_size = (rand(1,300)) /100
		if(target_size < 0.1)
			target_size = 0.1
		user.visible_message("<span class='notice'>\The [user] swipes the [emag_source] over the \the [src].</span>","<span class='notice'>You swipes the [emag_source] over the \the [src].</span>")
		return 1

/obj/item/clothing/gloves/bluespace/emagged
	emagged = TRUE

/obj/item/clothing/gloves/bluespace/emagged/Initialize()
	. = ..()
	target_size = (rand(1,300)) /100
	if(target_size < 0.1)
		target_size = 0.1

//Same as Nanotrasen Security Uniforms
/obj/item/clothing/under/ert
	armor = list(melee = 5, bullet = 10, laser = 10, energy = 5, bomb = 5, bio = 0, rad = 0)

/obj/item/clothing/under/qipao
	name = "black qipao"
	desc = "A type of feminine body-hugging dress with distinctive Chinese features of Manchu origin."
	icon = 'icons/inventory/uniform/item_vr.dmi'
	icon_override = 'icons/inventory/uniform/mob_vr.dmi'
	icon_state = "qipao"
	item_state = "qipao"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/qipao/white
	name = "white qipao"
	icon_state = "qipao_white"
	item_state = "qipao_white"

/obj/item/clothing/under/qipao/white/colorable
	name = "qipao"
	starting_accessories = list(/obj/item/clothing/accessory/qipaogold)

/obj/item/clothing/under/qipao/red
	name = "red qipao"
	icon_state = "qipao_red"
	item_state = "qipao_red"

/obj/item/clothing/under/pizzaguy
	name = "pizza delivery uniform"
	desc = "A dedicated outfit for pizza delivery people, one of most dangerous occupations around these parts. Can be rolled up for extra show of skin."
	icon = 'icons/inventory/uniform/item_vr.dmi'
	icon_override = 'icons/inventory/uniform/mob_vr.dmi'
	rolled_down_icon = 'icons/inventory/uniform/mob_vr_rolled_down.dmi'
	rolled_down_icon_override = FALSE
	icon_state = "pizzadelivery"
	item_state = "pizzadelivery"
	rolled_down = 0

//////////////////////TALON JUMPSUITS//////////////////////

/obj/item/clothing/under/rank/talon/basic
	name = "Talon jumpsuit"
	desc = "A basic jumpsuit that bares the ITV Talon logo on the breast."
	icon = 'icons/inventory/uniform/item_vr.dmi'
	rolled_down_icon = 'icons/inventory/uniform/mob_vr_rolled_down.dmi'
	icon_override = 'icons/inventory/uniform/mob_vr.dmi'
	icon_state = "talon_basic"
	item_state = "talon_basic"
	rolled_sleeves = 0
	rolled_down_icon_override = FALSE
	rolled_sleeves_icon_override = FALSE

/obj/item/clothing/under/rank/talon/proper
	name = "Talon proper jumpsuit"
	desc = "A neat and proper uniform for a proper private ship."
	icon = 'icons/inventory/uniform/item_vr.dmi'
	rolled_down_icon = 'icons/inventory/uniform/mob_vr_rolled_down.dmi'
	icon_override = 'icons/inventory/uniform/mob_vr.dmi'
	icon_state = "talon_jumpsuit"
	item_state = "talon_jumpsuit"
	rolled_sleeves = 0
	rolled_down_icon_override = FALSE
	rolled_sleeves_icon_override = FALSE

/obj/item/clothing/under/rank/talon/security
	name = "Talon security jumpsuit"
	desc = "A sleek, streamlined version of ITV Talon's standard jumpsuit that bares security markings."
	icon = 'icons/inventory/uniform/item_vr.dmi'
	rolled_down_icon = 'icons/inventory/uniform/mob_vr_rolled_down.dmi'
	icon_override = 'icons/inventory/uniform/mob_vr.dmi'
	icon_state = "talon_security"
	item_state = "talon_security"
	rolled_sleeves = 0
	rolled_down_icon_override = FALSE
	rolled_sleeves_icon_override = FALSE

/obj/item/clothing/under/rank/talon/pilot
	name = "Talon pilot jumpsuit"
	desc = "A sleek, streamlined version of ITV Talon's standard jumpsuit. Made from cushioned fabric to handle intense flight."
	icon = 'icons/inventory/uniform/item_vr.dmi'
	rolled_down_icon = 'icons/inventory/uniform/mob_vr_rolled_down.dmi'
	icon_override = 'icons/inventory/uniform/mob_vr.dmi'
	icon_state = "talon_pilot"
	item_state = "talon_pilot"
	rolled_sleeves = 0
	rolled_down_icon_override = FALSE
	rolled_sleeves_icon_override = FALSE

/obj/item/clothing/under/rank/talon/command
	name = "Talon command jumpsuit"
	desc = "A commanding jumpsuit fit for a commanding officer."
	icon = 'icons/inventory/uniform/item_vr.dmi'
	rolled_down_icon = 'icons/inventory/uniform/mob_vr_rolled_down.dmi'
	icon_override = 'icons/inventory/uniform/mob_vr.dmi'
	icon_state = "talon_captain"
	item_state = "talon_captain"
	rolled_sleeves = 0
	rolled_down_icon_override = FALSE
	rolled_sleeves_icon_override = FALSE

// Excelsior uniforms
/obj/item/clothing/under/excelsior
	name = "\improper Excelsior uniform"
	desc = "A uniform from a particular spaceship: Excelsior."

	icon = 'icons/inventory/uniform/item_vr.dmi'
	default_worn_icon = 'icons/inventory/uniform/mob_vr.dmi'
	icon_state = "excelsior_white"

/obj/item/clothing/under/excelsior/mixed
	icon_state = "excelsior_mixed"
/obj/item/clothing/under/excelsior/orange
	icon_state = "excelsior_orange"

// Summer dresses
/obj/item/clothing/under/summerdress
	name = "summer dress"
	desc = "A nice summer dress."

	icon = 'icons/inventory/uniform/item_vr.dmi'
	default_worn_icon = 'icons/inventory/uniform/mob_vr.dmi'
	icon_state = "summerdress"

/obj/item/clothing/under/summerdress/red
	icon_state = "summerdress3"
/obj/item/clothing/under/summerdress/blue
	icon_state = "summerdress2"

/obj/item/clothing/under/dress/dress_cap/femformal // formal in the loosest sense. because it's going to be taken off. or something. funnier in my head i swear
	name = "site manager's feminine formalwear"
	desc = "Essentially a skimpy...dress? Leotard? Whatever it is, it has the coloration and markings suitable for a site manager or rough equivalent."
	icon = 'icons/inventory/uniform/item_vr.dmi'
	default_worn_icon = 'icons/inventory/uniform/mob_vr.dmi'
	icon_state = "lewdcap"
	item_state = "lewdcap"
	rolled_sleeves = -1
	rolled_down = -1
	body_parts_covered = UPPER_TORSO // frankly this thing's a fucking embarassment

//FEMININE JUMPSUITS.
/obj/item/clothing/under/color/fjumpsuit //They won't see this so we can make it whatever we want.
	name = "blue feminine jumpsuit"
	desc = "It's very smart and in a ladies size!"
	icon = 'icons/inventory/uniform/item.dmi'
	default_worn_icon = 'icons/inventory/uniform/mob_vr.dmi'
	icon_state = "blue"	// In hand
	worn_state = "bluef"	// On mob

/obj/item/clothing/under/color/fjumpsuit/bluef
	name = "blue feminine jumpsuit"
	icon_state = "blue"
	worn_state = "bluef"
/obj/item/clothing/under/color/fjumpsuit/aquaf
	name = "aqua feminine jumpsuit"
	icon_state = "aqua"
	worn_state = "aquaf"
/obj/item/clothing/under/color/fjumpsuit/brownf
	name = "brown feminine jumpsuit"
	icon_state = "brown"
	worn_state = "brownf"
/obj/item/clothing/under/color/fjumpsuit/darkbluef
	name = "dark blue feminine jumpsuit"
	icon_state = "darkblue"
	worn_state = "darkbluef"
/obj/item/clothing/under/color/fjumpsuit/darkredf
	name = "dark red feminine jumpsuit"
	icon_state = "darkred"
	worn_state = "darkredf"
/obj/item/clothing/under/color/fjumpsuit/greenf
	name = "green feminine jumpsuit"
	icon_state = "green"
	worn_state = "greenf"
/obj/item/clothing/under/color/fjumpsuit/lightbluef
	name = "light blue feminine jumpsuit"
	icon_state = "lightblue"
	worn_state = "lightbluef"
/obj/item/clothing/under/color/fjumpsuit/lightbrownf
	name = "light brown feminine jumpsuit"
	icon_state = "lightbrown"
	worn_state = "lightbrownf"
/obj/item/clothing/under/color/fjumpsuit/lightgreenf
	name = "light green feminine jumpsuit"
	icon_state = "lightgreen"
	worn_state = "lightgreenf"
/obj/item/clothing/under/color/fjumpsuit/lightpurplef
	name = "light purple feminine jumpsuit"
	icon_state = "lightpurple"
	worn_state = "lightpurplef"
/obj/item/clothing/under/color/fjumpsuit/lightredf
	name = "light red feminine jumpsuit"
	icon_state = "lightred"
	worn_state = "lightredf"
/obj/item/clothing/under/color/fjumpsuit/maroonf
	name = "maroon feminine jumpsuit"
	icon_state = "maroon"
	worn_state = "maroonf"
/obj/item/clothing/under/color/fjumpsuit/pinkf
	name = "pink feminine jumpsuit"
	icon_state = "pink"
	worn_state = "pinkf"
/obj/item/clothing/under/color/fjumpsuit/purplef
	name = "purple feminine jumpsuit"
	icon_state = "purple"
	worn_state = "purplef"
/obj/item/clothing/under/color/fjumpsuit/redf
	name = "red feminine jumpsuit"
	icon_state = "red"
	worn_state = "redf"
/obj/item/clothing/under/color/fjumpsuit/yellowf
	name = "yellow feminine jumpsuit"
	icon_state = "yellow"
	worn_state = "yellowf"
/obj/item/clothing/under/color/fjumpsuit/yellowgreenf
	name = "yellow-green feminine jumpsuit"
	icon_state = "yellowgreen"
	worn_state = "yellowgreenf"

/obj/item/clothing/under/qipao_colorable
	name = "qipao"
	desc = "A traditional Chinese women's garment, typically made from silk."
	icon = 'icons/inventory/uniform/item.dmi'
	default_worn_icon = 'icons/inventory/uniform/mob_vr.dmi'
	icon_state = "qipao3"
	item_state = "qipao3"
	worn_state = "qipao3"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/qipao2_colorable
	name = "slim qipao"
	desc = "A traditional Chinese women's garment, typically made from silk. This one is fairly slim."
	icon = 'icons/inventory/uniform/item.dmi'
	default_worn_icon = 'icons/inventory/uniform/mob_vr.dmi'
	icon_state = "qipao2"
	item_state = "qipao2"
	worn_state = "qipao2"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/dress/antediluvian
	name = "antediluvian corset"
	desc = "A regal black and gold tight corset with silky sleeves. A sheer bodystocking accompanies it."
	icon = 'icons/inventory/uniform/item_vr.dmi'
	default_worn_icon = 'icons/inventory/uniform/mob_vr.dmi'
	icon_state = "antediluvian"
	item_state = "antediluvian"
	worn_state = "antediluvian"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/under/dress/antediluvian/sheerless
	desc = "A regal black and gold tight corset with silky sleeves. This one is just the corset and sleeves, sans lace stockings and gloves."
	worn_state = "antediluvian_c"

//Colorable skirts
/obj/item/clothing/under/skirt/colorable
	name = "skirt"
	desc = "A rather plain looking skirt."
	icon = 'icons/inventory/uniform/item_vr.dmi'
	default_worn_icon = 'icons/inventory/uniform/mob_vr.dmi'
	icon_state = "skirt_casual"
	item_state = "skirt_casual"
	worn_state = "skirt_casual"

/obj/item/clothing/under/skirt/colorable/puffy
	icon_state = "skirt_puffy"
	item_state = "skirt_puffy"
	worn_state = "skirt_puffy"

/obj/item/clothing/under/skirt/colorable/skater
	desc = "A skirt with loose frills."
	icon_state = "skirt_skater"
	item_state = "skirt_skater"
	worn_state = "skirt_skater"

/obj/item/clothing/under/skirt/colorable/pleated
	desc = "A short skirt featuring pleat trailing up from the hem."
	icon_state = "skirt_pleated"
	item_state = "skirt_pleated"
	worn_state = "skirt_pleated"

/obj/item/clothing/under/skirt/colorable/pleated/alt
	icon_state = "skirt_pleated_alt"
	item_state = "skirt_pleated_alt"
	worn_state = "skirt_pleated_alt"

/obj/item/clothing/under/skirt/colorable/pencil
	name = "pencil skirt"
	desc = "A short skirt that's almost as thin as a pencil. Almost."
	icon_state = "skirt_pencil"
	item_state = "skirt_pencil"
	worn_state = "skirt_pencil"

/obj/item/clothing/under/skirt/colorable/plaid
	name = "plaid skirt"
	desc = "A skirt featuring a plaid pattern."
	icon_state = "skirt_plaid"
	item_state = "skirt_plaid"
	worn_state = "skirt_plaid"

/obj/item/clothing/under/skirt/colorable/tube
	desc = "A long thin skirt that trails beyond the knees."
	icon_state = "skirt_tube"
	item_state = "skirt_tube"
	worn_state = "skirt_tube"

/obj/item/clothing/under/skirt/colorable/long
	name = "long skirt"
	icon_state = "skirt_long"
	item_state = "skirt_long"
	worn_state = "skirt_long"

/obj/item/clothing/under/skirt/colorable/high
	name = "high skirt"
	desc = "A skirt that rests at the waist instead of the hips."
	icon_state = "skirt_high"
	item_state = "skirt_high"
	worn_state = "skirt_high"

/obj/item/clothing/under/skirt/colorable/swept
	name = "swept skirt"
	desc = "A skirt with an angled hem; shorter on one side, longer on the other, like a sweep."
	icon_state = "skirt_swept"
	item_state = "skirt_swept"
	worn_state = "skirt_swept"

/obj/item/clothing/under/skirt/colorable/jumper
	name = "jumper skirt"
	desc = "A skirt that's held up by suspenders."
	icon_state = "skirt_jumper"
	item_state = "skirt_jumper"
	worn_state = "skirt_jumper"

/obj/item/clothing/under/skirt/colorable/jumperdress
	name = "jumper dress"
	desc = "A dress held up by suspenders. Not quite a skirt anymore."
	icon_state = "skirt_jumperdress"
	item_state = "skirt_jumperdress"
	worn_state = "skirt_jumperdress"

/obj/item/clothing/under/skirt/colorable/short
	name = "short skirt"
	desc = "A far too short pleated skirt."
	icon_state = "skirt_short"
	item_state = "skirt_short"
	worn_state = "skirt_short"

/obj/item/clothing/under/skirt/colorable/short_split
	name = "short skirt (split)"
	desc = "A far too short pleated skirt with an open split down one side."
	icon_state = "skirt_short_split"
	item_state = "skirt_short_split"
	worn_state = "skirt_short_split"

// Gwen Beedell's clown outfit

/obj/item/clothing/under/stripeddungarees
	name = "striped dungarees"
	desc = "A colourful set of striped dungarees, pretty funny lookin'."
	icon = 'icons/inventory/uniform/item_vr.dmi'
	default_worn_icon = 'icons/inventory/uniform/mob_vr.dmi'
	icon_state = "striped_clown_uniform"

/obj/item/clothing/under/dress/cdress_fire
	name = "flame dress"
	desc = "A small black dress with a flames print on it. Perfect for recoloring!"
	icon = 'icons/inventory/uniform/item_vr.dmi'
	default_worn_icon = 'icons/inventory/uniform/mob_vr.dmi'
	icon_state = "cdress_fire"

/obj/item/clothing/under/dress/cbridesmaid
	name = "fancy dress"
	desc = "A cute, flirty dress. Good for weddings and fancy parties, or if you just want to look fashionable. Perfect for recoloring!"
	icon = 'icons/inventory/uniform/item_vr.dmi'
	default_worn_icon = 'icons/inventory/uniform/mob_vr.dmi'
	icon_state = "cbridesmaid"

/obj/item/clothing/under/dress/cswoopdress
	name = "swoop dress"
	desc = "A fancy gown for those who like to show leg. Perfect for recoloring!"
	default_worn_icon = 'icons/inventory/uniform/mob_vr.dmi'
	icon_state = "cswoopdress"

//Replikant uniforms

/obj/item/clothing/under/replika
	name = "generic"
	desc = "generic"
	description_fluff = "These purpose-made interfacing bodysuits are designed and produced by the Singheim Bureau of Biosynthetic Development for their long-running second generation of Biosynthetics, commonly known by the term Replikant. Although anyone could wear these, their overall cut and metallic ports along the spine make it rather uncomfortable to most."
	icon = 'icons/inventory/uniform/item_vr.dmi'
	default_worn_icon = 'icons/inventory/uniform/mob_vr.dmi'
	icon_state = "arar"
	item_state = "arar"
	rolled_sleeves = -1
	rolled_down = -1
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS

/obj/item/clothing/under/replika/arar
	name = "repair-worker replikant bodysuit"
	desc = "A skin-tight bodysuit designed for 2nd generation biosynthetics of the engineering variety. Comes with multiple interfacing ports, arm protectors, and a conspicuous lack of leg coverage."
	description_fluff = "These purpose-made interfacing bodysuits are designed and produced by the Singheim Bureau of Biosynthetic Development for their long-running second generation of Biosynthetics, commonly known by the term Replikant. Although anyone could wear these, their overall cut and metallic ports along the spine make it rather uncomfortable to most."
	icon_state = "arar"
	item_state = "arar"


/obj/item/clothing/under/replika/lstr
	name = "land-survey replikant bodysuit"
	desc = "A skin-tight bodysuit designed for 2nd generation biosynthetics of the exploration variety. Comes with several interfacing ports and a conspicuous lack of leg coverage."
	description_fluff = "These purpose-made interfacing bodysuits are designed and produced by the Singheim Bureau of Biosynthetic Development for their long-running second generation of Biosynthetics, commonly known by the term Replikant. Although anyone could wear these, their overall cut and metallic ports along the spine make it rather uncomfortable to most."
	icon_state = "lstr"
	item_state = "lstr"

/obj/item/clothing/under/replika/fklr
	name = "command replikant bodysuit"
	desc = "A skin-tight bodysuit designed for 2nd generation biosynthetics of the command variety. Comes with interfacing ports, an air of formality, and a conspicuous lack of leg coverage."
	description_fluff = "These purpose-made interfacing bodysuits are designed and produced by the Singheim Bureau of Biosynthetic Development for their long-running second generation of Biosynthetics, commonly known by the term Replikant. Although anyone could wear these, their overall cut and metallic ports along the spine make it rather uncomfortable to most."
	icon_state = "fklr"
	item_state = "fklr"

/obj/item/clothing/under/replika/eulr
	name = "general-purpose replikant bodysuit"
	desc = "A skin-tight bodysuit designed for 2nd generation biosynthetics of multipurpose variety. Comes with default interfacing ports and a conspicuous lack of leg coverage."
	description_fluff = "These purpose-made interfacing bodysuits are designed and produced by the Singheim Bureau of Biosynthetic Development for their long-running second generation of Biosynthetics, commonly known by the term Replikant. Although anyone could wear these, their overall cut and metallic ports along the spine make it rather uncomfortable to most."
	icon_state = "eulr"
	item_state = "eulr"

/obj/item/clothing/under/replika/klbr
	name = "controller replikant bodysuit"
	desc = "A skin-tight bodysuit designed for 2nd generation biosynthetics of the controller variety. Comes with several interfacing ports and a conspicuous lack of leg coverage."
	description_fluff = "These purpose-made interfacing bodysuits are designed and produced by the Singheim Bureau of Biosynthetic Development for their long-running second generation of Biosynthetics, commonly known by the term Replikant. Although anyone could wear these, their overall cut and metallic ports along the spine make it rather uncomfortable to most."
	icon_state = "klbr"
	item_state = "klbr"

/obj/item/clothing/under/replika/stcr
	name = "security-technician replikant bodysuit"
	desc = "A skin-tight bodysuit designed for 2nd generation biosynthetics of the security variety. Comes with multiple interfacing ports and a conspicuous lack of leg coverage."
	description_fluff = "These purpose-made interfacing bodysuits are designed and produced by the Singheim Bureau of Biosynthetic Development for their long-running second generation of Biosynthetics, commonly known by the term Replikant. Although anyone could wear these, their overall cut and metallic ports along the spine make it rather uncomfortable to most."
	icon_state = "stcr"
	item_state = "stcr"

/obj/item/clothing/under/replika/adlr
	name = "administration replikant bodysuit"
	desc = "A skin-tight bodysuit designed for 2nd generation biosynthetics of the administrative variety. Comes with several interfacing ports and a conspicuous lack of leg coverage."
	description_fluff = "These purpose-made interfacing bodysuits are designed and produced by the Singheim Bureau of Biosynthetic Development for their long-running second generation of Biosynthetics, commonly known by the term Replikant. Although anyone could wear these, their overall cut and metallic ports along the spine make it rather uncomfortable to most."
	icon_state = "adlr"
	item_state = "adlr"

/obj/item/clothing/under/replika/lstr_alt
	name = "combat-engineer replikant bodysuit"
	desc = "A skin-tight bodysuit designed for 2nd generation biosynthetics of the exploration variety. Comes with extra interfacing ports, white armpads, and a familiar lack of leg coverage."
	description_fluff = "These purpose-made interfacing bodysuits are designed and produced by the Singheim Bureau of Biosynthetic Development for their long-running second generation of Biosynthetics, commonly known by the term Replikant. Although anyone could wear these, their overall cut and metallic ports along the spine make it rather uncomfortable to most."
	icon_state = "lstr_alt"
	item_state = "lstr_alt"

//Signalis-themed human-wear

/obj/item/clothing/under/gestalt
	name = "generic"
	desc = "generic"
	icon = 'icons/inventory/uniform/item_vr.dmi'
	default_worn_icon = 'icons/inventory/uniform/mob_vr.dmi'
	icon_state = "gestalt_skirt"
	item_state = "gestalt_skirt"
	rolled_sleeves = -1
	rolled_down = -1
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS

/obj/item/clothing/under/gestalt/sleek_skirt
	name = "sleek crew skirt"
	desc = "A tight-fitting black uniform with a narrow skirt and striking crimson trim."
	icon_state = "gestalt_skirt"
	item_state = "gestalt_skirt"


/obj/item/clothing/under/gestalt/sleek
	name = "sleek crew uniform"
	desc = "A tight-fitting black uniform with striking crimson trim."
	icon_state = "gestalt"
	item_state = "gestalt"


/obj/item/clothing/under/gestalt/sleek_fem
	name = "sleek female crew uniform"
	desc = "A tight-fitting black uniform with striking crimson trim."
	icon_state = "gestalt_fem"
	item_state = "gestalt_fem"


/obj/item/clothing/under/gestalt/sleeveless
	name = "sleeveless sleek crew uniform"
	desc = "A tight-fitting, sleeveless single-piece black uniform with striking crimson trim."
	icon_state = "gestalt_sleeveless"
	item_state = "gestalt_sleeveless"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS
