/obj/item/robot_module/drone/swarm
	name = "swarm drone module"
	var/id

<<<<<<< HEAD
/obj/item/weapon/robot_module/drone/swarm/New(var/mob/living/silicon/robot/robot)
	..()
=======
/obj/item/robot_module/drone/swarm/Initialize(var/ml)
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon

	id = robot.idcard
	src.modules += id
<<<<<<< HEAD

	src.modules += new /obj/item/weapon/rcd/electric/mounted/borg/swarm(src)
	src.modules += new /obj/item/device/flash/robot(src)
	src.modules += new /obj/item/weapon/handcuffs/cable/tape/cyborg(src)
	src.modules += new /obj/item/weapon/melee/baton/robot(src)
	src.modules += new /obj/item/weapon/gun/energy/taser/mounted/cyborg/swarm(src)
	src.modules += new /obj/item/weapon/matter_decompiler/swarm(src)
=======
	src.modules += new /obj/item/rcd/electric/mounted/borg/swarm(src)
	src.modules += new /obj/item/flash/robot(src)
	src.modules += new /obj/item/handcuffs/cable/tape/cyborg(src)
	src.modules += new /obj/item/melee/baton/robot(src)
	src.modules += new /obj/item/gun/energy/taser/mounted/cyborg/swarm(src)
	src.modules += new /obj/item/matter_decompiler/swarm(src)
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon

/obj/item/robot_module/drone/swarm/ranged
	name = "swarm gunner module"

<<<<<<< HEAD
/obj/item/weapon/robot_module/drone/swarm/ranged/New(var/mob/living/silicon/robot/robot)
	..()

	src.modules += new /obj/item/weapon/gun/energy/xray/swarm(src)

/obj/item/weapon/robot_module/drone/swarm/melee/New(var/mob/living/silicon/robot/robot)
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
=======
/obj/item/robot_module/drone/swarm/ranged/Initialize(var/ml)
	. = ..()
	if(. == INITIALIZE_HINT_NORMAL)
		modules += new /obj/item/gun/energy/xray/swarm(src)

/obj/item/robot_module/drone/swarm/melee/Initialize(var/ml)
	. = ..()
	if(. == INITIALIZE_HINT_NORMAL)
		modules += new /obj/item/melee/energy/sword/ionic_rapier/lance(src)
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
