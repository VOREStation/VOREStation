/obj/item/weapon/robot_module/drone/swarm
	name = "swarm drone module"
	var/id

/obj/item/weapon/robot_module/drone/swarm/New(var/mob/living/silicon/robot/robot)
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

/obj/item/weapon/robot_module/drone/swarm/ranged/New(var/mob/living/silicon/robot/robot)
	..()

	src.modules += new /obj/item/weapon/gun/energy/xray/swarm(src)

/obj/item/weapon/robot_module/drone/swarm/melee/New(var/mob/living/silicon/robot/robot)
	..()

	src.modules += new /obj/item/weapon/melee/energy/sword/ionic_rapier/lance(src)
