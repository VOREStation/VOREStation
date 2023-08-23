/obj/item/weapon/robot_module/drone/swarm
	name = "swarm drone module"
	var/id

/obj/item/weapon/robot_module/drone/swarm/create_equipment(var/mob/living/silicon/robot/robot)
	..()

	id = robot.idcard
	src.modules += id

	src.modules += new /obj/item/weapon/rcd/electric/mounted/borg/swarm(src)
	src.modules += new /obj/item/device/flash/robot(src)
	src.modules += new /obj/item/weapon/handcuffs/cable/tape/cyborg(src)
	src.modules += new /obj/item/weapon/melee/baton/robot(src)
	src.modules += new /obj/item/weapon/gun/energy/taser/mounted/cyborg/swarm(src)
	src.modules += new /obj/item/weapon/matter_decompiler/swarm(src)

/obj/item/weapon/robot_module/drone/swarm/ranged
	name = "swarm gunner module"

/obj/item/weapon/robot_module/drone/swarm/ranged/create_equipment(var/mob/living/silicon/robot/robot)
	..()

	src.modules += new /obj/item/weapon/gun/energy/xray/swarm(src)

/obj/item/weapon/robot_module/drone/swarm/melee/create_equipment(var/mob/living/silicon/robot/robot)
	..()

	src.modules += new /obj/item/weapon/melee/energy/sword/ionic_rapier/lance(src)

//Swarm Disabler Module
/obj/item/weapon/gun/energy/taser/mounted/cyborg/swarm
	name = "disabler"
	desc = "An archaic device which attacks the target's nervous-system or control circuits."
	icon_state = "disabler"
	projectile_type = /obj/item/projectile/beam/stun/disabler
	charge_cost = 800
	recharge_time = 0.5 SECONDS