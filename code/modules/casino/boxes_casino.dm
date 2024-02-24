/obj/item/weapon/storage/box/casino
	name = "prize box"
	desc = "It's a lovely golden tinted cardboard box, maybe there's something valuable inside?"
	icon = 'icons/obj/casino.dmi'
	icon_state = "casino_box"

/obj/item/weapon/storage/box/casino/costume_marine
	name = "ruin marine costume"
	starts_with = list(
	/obj/item/clothing/head/marine,
	/obj/item/clothing/suit/marine
	)

/obj/item/weapon/storage/box/casino/costume_pirate
	name = "pirate costume"
	starts_with = list(
	/obj/item/clothing/under/pirate,
	/obj/item/clothing/suit/pirate,
	/obj/item/clothing/head/pirate,
	/obj/item/clothing/glasses/eyepatch
	)

/obj/item/weapon/storage/box/casino/costume_commie
	name = "communist costume"
	starts_with = list(
	/obj/item/clothing/under/soviet,
	/obj/item/clothing/head/ushanka
	)

/obj/item/weapon/storage/box/casino/costume_wizard
	name = "wizard costume"
	starts_with = list(
	/obj/item/clothing/suit/wizrobe/fake,
	/obj/item/clothing/head/wizard/fake,
	/obj/item/weapon/staff
	)

/obj/item/weapon/storage/box/casino/costume_plaguedoctor
	name = "plague doctor costume"
	starts_with = list(
	/obj/item/clothing/suit/bio_suit/plaguedoctorsuit,
	/obj/item/clothing/head/plaguedoctorhat
	)

/obj/item/weapon/storage/box/casino/costume_cowboy
	name = "cowboy costume"
	starts_with = list(
	/obj/item/clothing/under/cowboy,
	/obj/item/clothing/accessory/holster/hip,
	/obj/item/clothing/head/cowboy/ranger,
	/obj/item/clothing/shoes/boots/cowboy/brown
	)

/obj/item/weapon/storage/box/roulette_balls_normal
	name = "roulette ball box"
	desc = "A box of spare roulette balls."
	icon_state = "balls"
	can_hold = list(/obj/item/roulette_ball)
	starts_with = list(
		/obj/item/roulette_ball = 7,
		/obj/item/roulette_ball/hollow = 2)

/obj/item/weapon/storage/box/roulette_balls_fancy
	name = "fancy roulette ball box"
	desc = "A box of extra-pretty roulette balls."
	icon_state = "balls"
	can_hold = list(/obj/item/roulette_ball)
	starts_with = list(
		/obj/item/roulette_ball,
		/obj/item/roulette_ball/hollow,
		/obj/item/roulette_ball/red,
		/obj/item/roulette_ball/orange,
		/obj/item/roulette_ball/yellow,
		/obj/item/roulette_ball/green,
		/obj/item/roulette_ball/blue,
		/obj/item/roulette_ball/purple,
		/obj/item/roulette_ball/moon,
		/obj/item/roulette_ball/planet,
		/obj/item/roulette_ball/gold)

/obj/item/weapon/storage/box/roulette_balls_cheat
	name = "special roulette ball box"
	desc = "A box of 'special' roulette balls."
	icon_state = "balls"
	can_hold = list(/obj/item/roulette_ball)
	starts_with = list(
		/obj/item/roulette_ball/cheat/first_twelve,
		/obj/item/roulette_ball/cheat/second_twelve,
		/obj/item/roulette_ball/cheat/third_twelve,
		/obj/item/roulette_ball/cheat/red,
		/obj/item/roulette_ball/cheat/black,
		/obj/item/roulette_ball/cheat/zeros,
		/obj/item/roulette_ball/cheat/odd,
		/obj/item/roulette_ball/cheat/even)
