/obj/item/robot_module/drone/swarm
	name = "swarm drone module"
	var/obj/item/card/id/drone_id
	idcard_type = /obj/item/card/id/syndicate

/obj/item/robot_module/drone/swarm/create_equipment(mob/living/silicon/robot/robot)
	..()

	var/obj/item/card/id/robot_id = robot.idcard
	robot_id.forceMove(src)
	src.modules += robot_id

	src.modules += new /obj/item/rcd/electric/mounted/borg/swarm(src)
	src.modules += new /obj/item/flash/robot(src)
	src.modules += new /obj/item/handcuffs/cable/tape/cyborg(src)
	src.modules += new /obj/item/melee/robotic/baton(src)
	src.modules += new /obj/item/gun/energy/robotic/taser/swarm(src)
	src.modules += new /obj/item/matter_decompiler/swarm(src)

/obj/item/robot_module/drone/swarm/ranged
	name = "swarm gunner module"

/obj/item/robot_module/drone/swarm/ranged/create_equipment(mob/living/silicon/robot/robot)
	..()

	src.modules += new /obj/item/gun/energy/xray/swarm(src)

/obj/item/robot_module/drone/swarm/melee/create_equipment(mob/living/silicon/robot/robot)
	..()

	src.modules += new /obj/item/melee/robotic/blade/ionic/lance(src)

//Swarm Disabler Module
/obj/item/gun/energy/taser/mounted/cyborg/swarm
	name = "disabler"
	desc = "An archaic device which attacks the target's nervous-system or control circuits."
	icon_state = "disabler"
	projectile_type = /obj/item/projectile/beam/stun/disabler
	charge_cost = 800
	recharge_time = 0.5 SECONDS
