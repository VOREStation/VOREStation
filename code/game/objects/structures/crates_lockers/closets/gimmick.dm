/obj/structure/closet/cabinet
	name = "cabinet"
	desc = "Old will forever be in fashion."
	icon = 'icons/obj/closets/bases/cabinet.dmi'
	closet_appearance = /decl/closet_appearance/cabinet

	open_sound = 'sound/effects/wooden_closet_open.ogg'
	close_sound = 'sound/effects/wooden_closet_close.ogg'
	vore_sound = 'sound/effects/woodhit.ogg'

/obj/structure/closet/acloset
	name = "strange closet"
	desc = "It looks alien!"
	closet_appearance = /decl/closet_appearance/alien

	open_sound = 'sound/machines/click.ogg'
	close_sound = 'sound/machines/click.ogg'

/obj/structure/closet/gimmick
	name = "administrative supply closet"
	desc = "It's a storage unit for things that have no right being here."
	closet_appearance = /decl/closet_appearance/tactical
	anchored = FALSE

/obj/structure/closet/gimmick/russian
	name = "russian surplus closet"
	desc = "It's a storage unit for Russian standard-issue surplus."
	closet_appearance = /decl/closet_appearance/tactical

	starts_with = list(
		/obj/item/clothing/head/ushanka = 5,
		/obj/item/clothing/under/soviet = 5)


/obj/structure/closet/gimmick/tacticool
	name = "tacticool gear closet"
	desc = "It's a storage unit for Tacticool gear."
	closet_appearance = /decl/closet_appearance/tactical

	starts_with = list(
		/obj/item/clothing/glasses/eyepatch,
		/obj/item/clothing/glasses/sunglasses,
		/obj/item/clothing/gloves/swat = 2,
		/obj/item/clothing/head/helmet/swat = 2,
		/obj/item/clothing/mask/gas = 2,
		/obj/item/clothing/shoes/boots/swat = 2,
		/obj/item/clothing/suit/armor/swat = 2,
		/obj/item/clothing/under/syndicate/tacticool = 2)


/obj/structure/closet/thunderdome
	name = "\improper Thunderdome closet"
	desc = "Everything you need!"
	closet_appearance = /decl/closet_appearance/thunderdomered
	anchored = TRUE

/obj/structure/closet/thunderdome/tdred
	name = "red-team Thunderdome closet"

	starts_with = list(
		/obj/item/clothing/suit/armor/tdome/red = 3,
		/obj/item/melee/energy/sword = 3,
		/obj/item/gun/energy/laser = 3,
		/obj/item/melee/baton = 3,
		/obj/item/storage/box/flashbangs = 3,
		/obj/item/clothing/head/helmet/thunderdome = 3)

/obj/structure/closet/thunderdome/tdgreen
	name = "green-team Thunderdome closet"
	closet_appearance = /decl/closet_appearance/thunderdomegreen

	starts_with = list(
		/obj/item/clothing/suit/armor/tdome/green = 3,
		/obj/item/melee/energy/sword = 3,
		/obj/item/gun/energy/laser = 3,
		/obj/item/melee/baton = 3,
		/obj/item/storage/box/flashbangs = 3,
		/obj/item/clothing/head/helmet/thunderdome = 3)

/obj/structure/closet/alien
	name = "alien container"
	desc = "Contains secrets of the universe."
	icon = 'icons/obj/closets/abductor.dmi'
	anchored = TRUE
	closet_appearance = null // special icons

/obj/structure/closet/tent
	name = "tent"
	desc = "An old fashioned tent that can easily fit a couple of people."
	icon = 'icons/obj/closets/tent.dmi'
	closet_appearance = null
	anchored = 1
	open_sound = 'sound/effects/rustle3.ogg'
	close_sound = 'sound/effects/rustle4.ogg'
	vore_sound = 'sound/effects/rustle1.ogg'

/obj/structure/closet/tent/B
	icon = 'icons/obj/closets/tentB.dmi'

/datum/crafting_recipe/tent
	name = "tent (green)"
	result = /obj/structure/closet/tent
	reqs = list(
		list(/obj/item/stack/material/cloth = 10)
	)
	time = 60
	category = CAT_MISC

/datum/crafting_recipe/tentb
	name = "tent (tan)"
	result = /obj/structure/closet/tent/B
	reqs = list(
		list(/obj/item/stack/material/cloth = 10)
	)
	time = 60
	category = CAT_MISC
