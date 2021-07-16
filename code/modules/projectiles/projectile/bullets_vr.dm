/obj/item/projectile/bullet/pistol/rubber/strong //"rubber" bullets for revolvers and matebas
	damage = 10
	agony = 60
	embed_chance = 0
	sharp = FALSE
	check_armour = "melee"

/obj/item/projectile/energy/flash/strong
	name = "chemical shell"
	icon_state = "bullet"
	damage = 10
	range = 15 //if the shell hasn't hit anything after travelling this far it just explodes.
	flash_strength = 15
	brightness = 15

/obj/item/projectile/energy/electrode/stunshot/strong
	name = "stunshot"
	icon_state = "bullet"
	damage = 10
	taser_effect = 1
	agony = 100

/obj/item/projectile/bullet/magnetic/flechette/small/khi
	name = "small carbyne flechette"
	icon_state = "flechette"
	fire_sound = 'sound/weapons/rapidslice.ogg'
	damage = 18
	armor_penetration = 100
	penetrating = 10
