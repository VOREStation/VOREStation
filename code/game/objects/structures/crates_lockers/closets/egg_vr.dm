/obj/structure/closet/secure_closet/egg
	name = "egg"
	desc = "It's an egg; it's smooth to the touch." //This is the default egg.
	icon = 'icons/obj/egg.dmi'
	icon_state = "egg"
	density = FALSE //Just in case there's a lot of eggs, so it doesn't block hallways/areas.
	var/icon_closed = "egg"
	var/icon_opened = "egg_open"
	var/icon_locked = "egg"
	closet_appearance = null
	open_sound = 'sound/vore/schlorp.ogg'
	close_sound = 'sound/vore/schlorp.ogg'
	opened = 0
	sealed = 0 //Don't touch this.
	health = 100

/obj/structure/closet/secure_closet/egg/update_icon()
	if(opened)
		icon_state = icon_opened
	else
		if(sealed)
			icon_state = icon_locked
		else
			icon_state = icon_closed

/obj/structure/closet/secure_closet/egg/attackby(obj/item/W, mob/user as mob) //This also prevents crew from welding the eggs and making them unable to be opened.
	if(W.has_tool_quality(TOOL_WELDER))
		src.dump_contents()
		qdel(src)

/obj/structure/closet/secure_closet/egg/unathi
	name = "unathi egg"
	desc = "Some species of Unathi apparently lay soft-shelled eggs!"
	icon_state = "egg_unathi"
	icon_closed = "egg_unathi"
	icon_opened = "egg_unathi_open"

/obj/structure/closet/secure_closet/egg/nevrean
	name = "nevrean egg"
	desc = "Most Nevreans lay hard-shelled eggs!"
	icon_state = "egg_nevrean"
	icon_closed = "egg_nevrean"
	icon_opened = "egg_nevrean_open"

/obj/structure/closet/secure_closet/egg/human
	name = "human egg"
	desc = "Some humans lay eggs that are--wait, what?"
	icon_state = "egg_human"
	icon_closed = "egg_human"
	icon_opened = "egg_human_open"

/obj/structure/closet/secure_closet/egg/tajaran
	name = "tajaran egg"
	desc = "Apparently that's what a Tajaran egg looks like. Weird."
	icon_state = "egg_tajaran"
	icon_closed = "egg_tajaran"
	icon_opened = "egg_tajaran_open"

/obj/structure/closet/secure_closet/egg/skrell
	name = "skrell egg"
	desc = "Its soft and squishy"
	icon_state = "egg_skrell"
	icon_closed = "egg_skrell"
	icon_opened = "egg_skrell_open"

/obj/structure/closet/secure_closet/egg/shark
	name = "akula egg"
	desc = "Its soft and slimy to the touch"
	icon_state  = "egg_akula"
	icon_closed = "egg_akula"
	icon_opened = "egg_akula_open"

/obj/structure/closet/secure_closet/egg/sergal
	name = "sergal egg"
	desc = "An egg with a slightly fuzzy exterior, and a hard layer beneath."
	icon_state = "egg_sergal"
	icon_closed = "egg_sergal"
	icon_opened = "egg_sergal_open"

/obj/structure/closet/secure_closet/egg/slime
	name = "slime egg"
	desc = "An egg with a soft and squishy interior, coated with slime."
	icon_state = "egg_slime"
	icon_closed = "egg_slime"
	icon_opened = "egg_slime_open"

/obj/structure/closet/secure_closet/egg/special //Not actually used, but the sprites are in, and it's there in case any admins need to spawn in the egg for any specific reasons.
	name = "special egg"
	desc = "This egg has a very unique look to it."
	icon_state = "egg_unique"
	icon_closed = "egg_unique"
	icon_opened = "egg_unique_open"

/obj/structure/closet/secure_closet/egg/scree
	name = "Chimera egg"
	desc = "...You don't know what type of creature layed this egg."
	icon_state = "egg_scree"
	icon_closed = "egg_scree"
	icon_opened = "egg_scree_open"

/obj/structure/closet/secure_closet/egg/xenomorph
	name = "Xenomorph egg"
	desc = "Some type of pitch black egg. It has a slimy exterior coating."
	icon_state = "egg_xenomorph"
	icon_closed = "egg_xenomorph"
	icon_opened = "egg_xenomorph_open"

// various discarded clothing sprites, thanks Arpi
/obj/item/storage/vore_egg/clothing_pile_red
	name = "red pile of clothes"
	desc = "It is a pile of someone's laundry."
	icon_state = "egg_pile_red"
	icon_closed = "egg_pile_red"
	icon_open = "egg_clothes_open"

/obj/item/storage/vore_egg/clothing_pile_blue
	name = "blue pile of clothes"
	desc = "It is a pile of someone's laundry."
	icon_state = "egg_pile_blue"
	icon_closed = "egg_pile_blue"
	icon_open = "egg_clothes_open"

/obj/item/storage/vore_egg/clothing_pile_purple
	name = "purple pile of clothes"
	desc = "It is a pile of someone's laundry."
	icon_state = "egg_pile_purple"
	icon_closed = "egg_pile_purple"
	icon_open = "egg_clothes_open"

/obj/item/storage/vore_egg/clothing_pile_green
	name = "green pile of clothes"
	desc = "It is a pile of someone's laundry."
	icon_state = "egg_pile_green"
	icon_closed = "egg_pile_green"
	icon_open = "egg_clothes_open"

/obj/item/storage/vore_egg/clothing_pile_white
	name = "white pile of clothes"
	desc = "It is a pile of someone's laundry."
	icon_state = "egg_pile_white"
	icon_closed = "egg_pile_white"
	icon_open = "egg_clothes_open"

/obj/item/storage/vore_egg/clothing_pile_black
	name = "black pile of clothes"
	desc = "It is a pile of someone's laundry."
	icon_state = "egg_pile_black"
	icon_closed = "egg_pile_black"
	icon_open = "egg_clothes_open"

/obj/item/storage/vore_egg/clothing_bra_red
	name = "red discarded bra"
	desc = "A supportive piece of underwear for the chest laying about."
	icon_state = "egg_bra_red"
	icon_closed = "egg_bra_red"
	icon_open = "egg_clothes_open"

/obj/item/storage/vore_egg/clothing_bra_blue
	name = "blue discarded bra"
	desc = "A supportive piece of underwear for the chest laying about."
	icon_state = "egg_bra_blue"
	icon_closed = "egg_bra_blue"
	icon_open = "egg_clothes_open"

/obj/item/storage/vore_egg/clothing_bra_purple
	name = "purple discarded bra"
	desc = "A supportive piece of underwear for the chest laying about."
	icon_state = "egg_bra_purple"
	icon_closed = "egg_bra_purple"
	icon_open = "egg_clothes_open"

/obj/item/storage/vore_egg/clothing_bra_green
	name = "green discarded bra"
	desc = "A supportive piece of underwear for the chest laying about."
	icon_state = "egg_bra_green"
	icon_closed = "egg_bra_green"
	icon_open = "egg_clothes_open"

/obj/item/storage/vore_egg/clothing_bra_white
	name = "white discarded bra"
	desc = "A supportive piece of underwear for the chest laying about."
	icon_state = "egg_bra_white"
	icon_closed = "egg_bra_white"
	icon_open = "egg_clothes_open"

/obj/item/storage/vore_egg/clothing_bra_black
	name = "black discarded bra"
	desc = "A supportive piece of underwear for the chest laying about."
	icon_state = "egg_bra_black"
	icon_closed = "egg_bra_black"
	icon_open = "egg_clothes_open"

/obj/item/storage/vore_egg/clothing_bottom_red
	name = "red discarded bottom"
	desc = "A cloth undergarment for the hips laying about."
	icon_state = "egg_bottom_red"
	icon_closed = "egg_bottom_red"
	icon_open = "egg_clothes_open"

/obj/item/storage/vore_egg/clothing_bottom_blue
	name = "blue discarded bottom"
	desc = "A cloth undergarment for the hips laying about."
	icon_state = "egg_bottom_blue"
	icon_closed = "egg_bottom_blue"
	icon_open = "egg_clothes_open"

/obj/item/storage/vore_egg/clothing_bottom_purple
	name = "purple discarded bottom"
	desc = "A cloth undergarment for the hips laying about."
	icon_state = "egg_bottom_purple"
	icon_closed = "egg_bottom_purple"
	icon_open = "egg_clothes_open"

/obj/item/storage/vore_egg/clothing_bottom_green
	name = "green discarded bottom"
	desc = "A cloth undergarment for the hips laying about."
	icon_state = "egg_bottom_green"
	icon_closed = "egg_bottom_green"
	icon_open = "egg_clothes_open"

/obj/item/storage/vore_egg/clothing_bottom_white
	name = "white discarded bottom"
	desc = "A cloth undergarment for the hips laying about."
	icon_state = "egg_bottom_white"
	icon_closed = "egg_bottom_white"
	icon_open = "egg_clothes_open"

/obj/item/storage/vore_egg/clothing_bottom_black
	name = "black discarded bottom"
	desc = "A cloth undergarment for the hips laying about."
	icon_state = "egg_bottom_black"
	icon_closed = "egg_bottom_black"
	icon_open = "egg_clothes_open"

//In case anyone stumbles upon this, MAJOR thanks to Vorrakul and Nightwing. Without them, this wouldn't be a reality.
//Also, huge thanks for Ace for helping me through with this and getting me to work at my full potential instead of tapping out early, along with coding advice.
//Additionally, huge thanks to the entire Virgo community for giving suggestions about egg TF, the sprites, descriptions, etc etc. Cheers to everyone. Also, you should totally eat Cadence. ~CK
