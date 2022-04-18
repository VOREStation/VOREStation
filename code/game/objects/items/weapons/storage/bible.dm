<<<<<<< HEAD
GLOBAL_LIST_INIT(biblenames, list(
	"Bible", "Koran", "Scrapbook",
	"Pagan", "White Bible", "Holy Light",
	"Athiest", "Tome", "The King in Yellow",
	"Ithaqua", "Scientology", "the bible melts",
	"Necronomicon", "Orthodox", "Torah"))
//If you get these two lists not matching in size, there will be runtimes and I will hurt you in ways you couldn't even begin to imagine
// if your bible has no custom itemstate, use one of the existing ones
GLOBAL_LIST_INIT(biblestates, list(
	"bible", "koran", "scrapbook",
	"shadows", "white", "holylight",
	"athiest", "tome", "kingyellow",
	"ithaqua", "scientology", "melted",
	"necronomicon", "orthodoxy", "torah"))
GLOBAL_LIST_INIT(bibleitemstates, list(
	"bible", "koran", "scrapbook",
	"syringe_kit", "syringe_kit", "syringe_kit",
	"syringe_kit", "syringe_kit", "kingyellow",
	"ithaqua", "scientology", "melted",
	"necronomicon", "bible", "clipboard"))

/obj/item/weapon/storage/bible
=======
/obj/item/storage/bible
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	name = "bible"
	desc = "Apply to head repeatedly."
	icon_state ="bible"
	item_state = "bible"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_books.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_books.dmi'
		)
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_NORMAL
	var/mob/affecting = null
	var/deity_name = "Christ"
	use_sound = 'sound/bureaucracy/bookopen.ogg'
	drop_sound = 'sound/bureaucracy/bookclose.ogg'

<<<<<<< HEAD
/obj/item/weapon/storage/bible/attack_self(mob/living/carbon/human/user)
	if(GLOB.bible_icon_state)
		icon_state = GLOB.bible_icon_state
		item_state = GLOB.bible_item_state
		return FALSE
	if(user?.mind?.assigned_role != "Chaplain")
		return FALSE

	var/list/skins = list()
	for(var/i in 1 to GLOB.biblestates.len)
		var/image/bible_image = image(icon = 'icons/obj/storage.dmi', icon_state = GLOB.biblestates[i])
		skins += list("[GLOB.biblenames[i]]" = bible_image)

	var/choice = show_radial_menu(user, src, skins, custom_check = CALLBACK(src, .proc/check_menu, user), radius = 40, require_near = TRUE)
	if(!choice)
		return FALSE
	var/bible_index = GLOB.biblenames.Find(choice)
	if(!bible_index)
		return FALSE
	icon_state = GLOB.biblestates[bible_index]
	item_state = GLOB.bibleitemstates[bible_index]

	GLOB.bible_icon_state = icon_state
	GLOB.bible_item_state = item_state
	feedback_set_details("religion_book", "[choice]")

/**
  * Checks if we are allowed to interact with a radial menu
  *
  * Arguments:
  * * user The mob interacting with the menu
  */
/obj/item/weapon/storage/bible/proc/check_menu(mob/living/carbon/human/user)
	if(GLOB.bible_icon_state)
		return FALSE
	if(!istype(user))
		return FALSE
	if(user.get_active_hand() != src)
		return FALSE
	if(user.incapacitated())
		return FALSE
	if(user.mind.assigned_role != "Chaplain")
		return FALSE
	return TRUE

/obj/item/weapon/storage/bible/booze
=======
/obj/item/storage/bible/booze
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	name = "bible"
	desc = "To be applied to the head repeatedly."
	icon_state ="bible"

/obj/item/weapon/storage/bible/booze/New()
	starts_with = list(
		/obj/item/reagent_containers/food/drinks/bottle/small/beer,
		/obj/item/reagent_containers/food/drinks/bottle/small/beer,
		/obj/item/spacecash/c100,
		/obj/item/spacecash/c100,
		/obj/item/spacecash/c100
	)

/obj/item/storage/bible/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity) return
	if(user.mind && (user.mind.assigned_role == "Chaplain"))
		if(A.reagents && A.reagents.has_reagent("water")) //blesses all the water in the holder
			to_chat(user, "<span class='notice'>You bless [A].</span>")
			var/water2holy = A.reagents.get_reagent_amount("water")
			A.reagents.del_reagent("water")
			A.reagents.add_reagent("holywater",water2holy)

/obj/item/storage/bible/attackby(obj/item/W as obj, mob/user as mob)
	if (src.use_sound)
		playsound(src, src.use_sound, 50, 1, -5)
	..()
