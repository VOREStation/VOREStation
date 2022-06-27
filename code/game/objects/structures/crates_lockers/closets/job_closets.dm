/*
 * Closets for specific jobs
 * Contains:
 *		Bartender
 *		Janitor
 *		Lawyer
 *		Janitorial Equipment
 *
 *
 * These have been removed from the map for the most part, however
 * do not remove these in case people want to make maps or POIs
 * with these closets.
 *
 */

/*
 * Bartender
 */
/obj/structure/closet/gmcloset
	name = "formal closet"
	desc = "It's a storage unit for formal clothing."
	closet_appearance = /decl/closet_appearance/wardrobe/suit

	starts_with = list(
		/obj/item/clothing/head/that = 2,
		/obj/item/device/radio/headset/headset_service = 2,
		/obj/item/clothing/head/pin/flower,
		/obj/item/clothing/head/pin/flower/pink,
		/obj/item/clothing/head/pin/flower/yellow,
		/obj/item/clothing/head/pin/flower/blue,
		/obj/item/clothing/head/pin/pink,
		/obj/item/clothing/head/pin/magnetic,
		/obj/item/clothing/under/sl_suit = 2,
		/obj/item/clothing/under/rank/bartender = 2,
		/obj/item/clothing/under/rank/bartender/skirt,
		/obj/item/clothing/under/dress/dress_saloon,
		/obj/item/clothing/accessory/wcoat = 2,
		/obj/item/clothing/shoes/black = 2,
		/obj/item/clothing/shoes/laceup
		)

/*
 * Chef
 */
/obj/structure/closet/chefcloset
	name = "chef's closet"
	desc = "It's a storage unit for foodservice garments."
	closet_appearance = /decl/closet_appearance/wardrobe/white

	starts_with = list(
		/obj/item/clothing/under/sundress,
		/obj/item/clothing/under/waiter = 2,
		/obj/item/device/radio/headset/headset_service = 2,
		/obj/item/weapon/storage/box/mousetraps = 2,
		/obj/item/clothing/under/rank/chef,
		/obj/item/clothing/head/chefhat,
		/obj/item/weapon/storage/bag/food = 2
		)

/*
 * Janitor
 */
/obj/structure/closet/jcloset
	name = "custodial closet"
	desc = "It's a storage unit for janitorial clothes and gear."
	closet_appearance = /decl/closet_appearance/wardrobe/janitor

	starts_with = list(
		/obj/item/clothing/under/rank/janitor,
		/obj/item/clothing/under/dress/maid/janitor,
		/obj/item/device/radio/headset/headset_service,
		/obj/item/clothing/mask/surgical/dust,
		/obj/item/weapon/cartridge/janitor,
		/obj/item/clothing/gloves/black,
		/obj/item/clothing/head/soft/purple,
		/obj/item/clothing/head/beret/purple,
		/obj/item/device/flashlight,
		/obj/item/clothing/suit/caution = 4,
		/obj/item/device/lightreplacer,
		/obj/item/weapon/storage/bag/trash,
		/obj/item/weapon/storage/belt/janitor,
		/obj/item/clothing/shoes/galoshes
		)

/*
 * Lawyer
 */
/obj/structure/closet/lawcloset
	name = "legal closet"
	desc = "It's a storage unit for courtroom apparel and items."
	closet_appearance = /decl/closet_appearance/wardrobe/suit

	starts_with = list(
		/obj/item/clothing/under/lawyer/female = 2,
		/obj/item/clothing/under/lawyer/black = 2,
		/obj/item/clothing/under/lawyer/black/skirt = 2,
		/obj/item/clothing/under/lawyer/red = 2,
		/obj/item/clothing/under/lawyer/red/skirt = 2,
		/obj/item/clothing/suit/storage/toggle/internalaffairs = 2,
		/obj/item/clothing/under/lawyer/bluesuit = 2,
		/obj/item/clothing/under/lawyer/bluesuit/skirt = 2,
		/obj/item/clothing/suit/storage/toggle/lawyer/bluejacket = 2,
		/obj/item/clothing/under/lawyer/purpsuit = 2,
		/obj/item/clothing/under/lawyer/purpsuit/skirt = 2,
		/obj/item/clothing/suit/storage/toggle/lawyer/purpjacket = 2,
		/obj/item/clothing/shoes/brown = 2,
		/obj/item/clothing/shoes/black = 2,
		/obj/item/clothing/shoes/laceup = 2,
		/obj/item/clothing/glasses/sunglasses/big = 2,
		/obj/item/clothing/under/lawyer/blue = 2,
		/obj/item/clothing/under/lawyer/blue/skirt = 2,
		/obj/item/device/tape/random = 2
		)

/*
 * Janitorial Equipment
 */
/obj/structure/closet/jequipcloset
	name = "custodial equipment closet"
	desc = "It's a storage unit for janitorial clothes and gear."
	closet_appearance = /decl/closet_appearance/wardrobe/janitor

	starts_with = list(
		/obj/item/device/flashlight = 5,
		/obj/item/clothing/suit/caution = 12,
		/obj/item/device/lightreplacer = 3,
		/obj/item/weapon/storage/bag/trash = 3,
		/obj/item/weapon/storage/box/lights/mixed = 3,
		/obj/item/weapon/storage/box/mousetraps = 1,
		/obj/item/weapon/grenade/chem_grenade/cleaner = 4
		)
