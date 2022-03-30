// **For augment items that aren't subtypes of other things.**

/obj/item/weapon/melee/augment
	name = "integrated item"
	desc = "A surprisingly non-descript item, integrated into its user. You probably shouldn't be seeing this."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "augment_box"


/obj/item/weapon/melee/augment/blade
	name = "handblade"
	desc = "A sleek-looking telescopic blade that fits inside the hand. Favored by infiltration specialists and assassins."
	icon_state = "augment_handblade"
	item_icons = list(
			slot_l_hand_str = 'icons/mob/items/lefthand_melee.dmi',
			slot_r_hand_str = 'icons/mob/items/righthand_melee.dmi',
			)
	w_class = ITEMSIZE_SMALL
	force = 15
	armor_penetration = 25
	sharp = TRUE
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	defend_chance = 10
	projectile_parry_chance = 5
	hitsound = 'sound/weapons/bladeslice.ogg'

/obj/item/weapon/melee/augment/blade/arm
	name = "armblade"
	desc = "A sleek-looking cybernetic blade that cleaves through people like butter. Favored by psychopaths and assassins."
	icon_state = "augment_armblade"
	w_class = ITEMSIZE_HUGE
	force = 30
	armor_penetration = 15
<<<<<<< HEAD
	edge = TRUE
=======
	edge = 1
>>>>>>> 50c97504321... Merge pull request #8491 from Atermonera/revert_tool_qualities
	pry = 1
	defend_chance = 40
	projectile_parry_chance = 20