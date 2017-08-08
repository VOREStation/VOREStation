/obj/structure/closet/secure_closet/guncabinet/sidearm
	name = "emergency weapon cabinet"
	req_access = list()
	req_one_access = list(access_armory,access_captain)

	will_contain = list(
		/obj/item/weapon/gun/energy/gun = 4
	)

/obj/structure/closet/secure_closet/guncabinet/rifle
	name = "rifle cabinet"
	will_contain = list(
		/obj/item/weapon/gun/projectile/shotgun/pump/rifle/mosin = 3
	)