/obj/item/weapon/gun/projectile/shotgun/pump/rifle
	desc = "The Weissen Company Type-19 is a modern interpretation of an almost ancient weapon design. The model is popular among hunters and collectors due to its reliability. Uses 7.62mm rounds."
	description_fluff = "The frontier’s largest home-grown firearms manufacturer, the APEX Arms Company offers a range of high-quality, high-cost hunting rifles and shotguns designed with the wild frontier wilderness - and its wildlife - in mind. \
	The company operates just one production plant in the Mytis system, but their weapons have found popularity on garden worlds as far afield as the Tajaran homeworld due to their excellent build quality, precision, and stopping power."
	icon = 'icons/obj/gun_vr.dmi'

/obj/item/weapon/gun/projectile/shotgun/pump/rifle/practice //For target practice
	name = "practice rifle"
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "boltaction_p"
	item_state = "boltaction_p"
	item_icons = list(slot_l_hand_str = 'icons/mob/items/lefthand_guns_vr.dmi', slot_r_hand_str = 'icons/mob/items/righthand_guns_vr.dmi')
	max_shells = 4

/obj/item/weapon/gun/projectile/shotgun/pump/rifle/ceremonial
	max_shells = 5

/obj/item/weapon/gun/projectile/shotgun/pump/rifle/lever
	desc = "The Weissen Company Thunderking is the latest version of an almost ancient weapon design from the 19th century, popular with some due to its simplistic design. This one uses a lever-action to move new rounds into the chamber. Uses 7.62mm rounds."
	description_fluff = "The frontier’s largest home-grown firearms manufacturer, the Weissen Company offers a range of high-quality, high-cost hunting rifles and shotguns designed with the wild frontier wilderness - and its wildlife - in mind. \
	The company operates just one production plant in the Mytis system, but their weapons have found popularity on garden worlds as far afield as the Tajaran homeworld due to their excellent build quality, precision, and stopping power."
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "levergun"
	max_shells = 6

/obj/item/weapon/gun/projectile/shotgun/pump/rifle/lever/vintage
	desc = "The Weissen Company's version of an iconic manually operated lever action rifle, the Bushhog, offering adequate stopping power due to it's still powerful cartridge while at the same time having a rather respectable firing rate due to it's mechanism. It is very probable this is a replica instead of a museum piece, but rifles of this pattern still see usage as colonist guns in some far off regions. Uses 7.62mm rounds."
	description_fluff = "The frontier’s largest home-grown firearms manufacturer, the Weissen Company offers a range of high-quality, high-cost hunting rifles and shotguns designed with the wild frontier wilderness - and its wildlife - in mind. \
	The company operates just one production plant in the Mytis system, but their weapons have found popularity on garden worlds as far afield as the Tajaran homeworld due to their excellent build quality, precision, and stopping power."
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "levergunv"
	item_state = "leveraction"
	max_shells = 5
	caliber = "7.62mm"
	load_method = SINGLE_CASING
	pump_animation = null

////////////////////////surplus gun - for derelicts (04/26/2021)////////////////////////

/obj/item/weapon/gun/projectile/shotgun/pump/surplus
	name = "surplus rifle"
	desc = "An ancient weapon from an era long pas, crude in design, but still just as effective as any modern interpretation. Uses 7.62mm rounds."
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "boltaction_s"
	item_state = "boltaction_p"
	item_icons = list(slot_l_hand_str = 'icons/mob/items/lefthand_guns_vr.dmi', slot_r_hand_str = 'icons/mob/items/righthand_guns_vr.dmi')
	fire_sound = 'sound/weapons/Gunshot_generic_rifle.ogg'
	max_shells = 4
	slot_flags = null
	caliber = "7.62mm"
	origin_tech = list(TECH_COMBAT = 1) // Old(er) as shit rifle doesn't have very good tech.
	ammo_type = /obj/item/ammo_casing/a762
	load_method = SINGLE_CASING|SPEEDLOADER
	action_sound = 'sound/weapons/riflebolt.ogg'
	pump_animation = null
