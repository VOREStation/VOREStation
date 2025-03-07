//Item type vorepanel egg release containers.

/obj/item/storage/vore_egg
	name = "egg"
	desc = "It's an egg; it's smooth to the touch." //This is the default egg.
	icon = 'icons/obj/egg_new_vr.dmi'
	icon_state = "egg"
	var/open_egg_icon = 'icons/obj/egg_open_vr.dmi'
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_storage.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_storage.dmi',
		)
	w_class = 2
	max_w_class = 0
	show_messages = 0
	allow_quick_empty = TRUE
	use_sound = 'sound/items/drop/flesh.ogg'

/obj/item/storage/vore_egg/Initialize()
	. = ..()
	randpixel_xy()

/obj/item/storage/vore_egg/open(mob/user as mob)
	if(isobserver(user))
		return
	icon = open_egg_icon
	..()

/obj/item/storage/vore_egg/proc/hatch(mob/living/user as mob)
	visible_message(span_danger("\The [src] begins to shake as something pushes out from within!"))
	animate_shake()
	if(do_after(user, 50))
		if(use_sound)
			playsound(src, src.use_sound, 50, 0, -5)
		animate_shake()
		drop_contents()
		icon = open_egg_icon
		if(user.transforming) //this is actually godawful and transforming should never be used as it skips life ticks
			user.transforming = FALSE //but if something does still use transforming (Bad, please do not.), we want it to be removed from them.

/obj/item/storage/vore_egg/unathi
	name = "unathi egg"
	desc = "Some species of Unathi apparently lay soft-shelled eggs!"
	icon_state = "egg_unathi"

/obj/item/storage/vore_egg/nevrean
	name = "nevrean egg"
	desc = "Most Nevreans lay hard-shelled eggs!"
	icon_state = "egg_nevrean"

/obj/item/storage/vore_egg/human
	name = "human egg"
	desc = "Some humans lay eggs that are--wait, what?"
	icon_state = "egg_human"

/obj/item/storage/vore_egg/tajaran
	name = "tajaran egg"
	desc = "Apparently that's what a Tajaran egg looks like. Weird."
	icon_state = "egg_tajaran"

/obj/item/storage/vore_egg/skrell
	name = "skrell egg"
	desc = "Its soft and squishy"
	icon_state = "egg_skrell"

/obj/item/storage/vore_egg/shark
	name = "akula egg"
	desc = "Its soft and slimy to the touch"
	icon_state  = "egg_akula"

/obj/item/storage/vore_egg/sergal
	name = "sergal egg"
	desc = "An egg with a slightly fuzzy exterior, and a hard layer beneath."
	icon_state = "egg_sergal"

/obj/item/storage/vore_egg/slime
	name = "slime egg"
	desc = "An egg with a soft and squishy interior, coated with slime."
	icon_state = "egg_slime"

/obj/item/storage/vore_egg/special //Not actually used, but the sprites are in, and it's there in case any admins need to spawn in the egg for any specific reasons.
	name = "special egg"
	desc = "This egg has a very unique look to it."
	icon_state = "egg_unique"

/obj/item/storage/vore_egg/scree
	name = "Chimera egg"
	desc = "...You don't know what type of creature laid this egg."
	icon_state = "egg_scree"

/obj/item/storage/vore_egg/xenomorph
	name = "Xenomorph egg"
	desc = "Some type of pitch black egg. It has a slimy exterior coating."
	icon_state = "egg_xenomorph"

/obj/item/storage/vore_egg/chocolate
	name = "chocolate egg"
	desc = "Delicious. May contain a choking hazard."
	icon_state = "egg_chocolate"

/obj/item/storage/vore_egg/owlpellet
	name = "boney egg"
	desc = "Can an egg shell be made of bones and hair?"
	icon_state = "egg_pellet"

/obj/item/storage/vore_egg/slimeglob
	name = "glob of slime"
	desc = "Very squishy."
	icon_state = "egg_slimeglob"

/obj/item/storage/vore_egg/chicken
	name = "chicken egg"
	desc = "Looks like chickens come in all sizes and shapes."
	icon_state = "egg_chicken"

/obj/item/storage/vore_egg/synthetic
	name = "synthetic egg"
	desc = "Smells like Easter morning."
	icon_state = "egg_synthetic"

/obj/item/storage/vore_egg/escapepod
	name = "small escape pod"
	desc = "Someone left in a hurry."
	icon_state = "egg_escapepod"

/obj/item/storage/vore_egg/floppy
	name = "blue space floppy disc"
	desc = "Probably shouldn't copy THIS floppy."
	icon_state = "egg_floppy"

/obj/item/storage/vore_egg/cd
	name = "blue space cd"
	desc = "What could even be on this?!"
	icon_state = "egg_cd"

/obj/item/storage/vore_egg/file
	name = "blue space file"
	desc = "Gotta wonder how much is compressed in there."
	icon_state = "egg_file"

/obj/item/storage/vore_egg/badrecipe
	name = "Burned mess"
	desc = "Someone didn't cook this egg quite right..."
	icon_state = "egg_badrecipe"

/obj/item/storage/vore_egg/cocoon
	name = "web cocoon"
	desc = "It straight up smells like spiders in here."
	icon_state = "egg_cocoon"

/obj/item/storage/vore_egg/honeycomb
	name = "honeycomb"
	desc = "Smells delicious!"
	icon_state = "egg_honeycomb"

/obj/item/storage/vore_egg/bugcocoon
	name = "bug cocoon"
	desc = "Metamorphosis!"
	icon_state = "egg_bugcocoon"

/obj/item/storage/vore_egg/rock
	name = "rock egg"
	desc = "It looks like a small boulder."
	icon_state = "egg_rock"

/obj/item/storage/vore_egg/yellow
	name = "yellow egg"
	desc = "It is a nice yellow egg."
	icon_state = "egg_yellow"

/obj/item/storage/vore_egg/blue
	name = "blue egg"
	desc = "It is a nice blue egg."
	icon_state = "egg_blue"

/obj/item/storage/vore_egg/green
	name = "green egg"
	desc = "It is a nice green egg."
	icon_state = "egg_green"

/obj/item/storage/vore_egg/orange
	name = "orange egg"
	desc = "It is a nice orange egg."
	icon_state = "egg_orange"

/obj/item/storage/vore_egg/purple
	name = "purple egg"
	desc = "It is a nice purple egg."
	icon_state = "egg_purple"

/obj/item/storage/vore_egg/red
	name = "red egg"
	desc = "It is a nice red egg."
	icon_state = "egg_red"

/obj/item/storage/vore_egg/rainbow
	name = "rainbow egg"
	desc = "It looks so colorful."
	icon_state = "egg_rainbow"

/obj/item/storage/vore_egg/pinkspots
	name = "spotted pink egg"
	desc = "It is a cute pink egg with white spots."
	icon_state = "egg_pinkspots"
