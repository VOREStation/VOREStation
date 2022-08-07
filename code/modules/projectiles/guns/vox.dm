/*
 * Vox Spike Thrower
 *  Alien pinning weapon.
 */

/obj/item/weapon/gun/launcher/spikethrower
	name = "spike thrower"
	desc = "A vicious alien projectile weapon, adapted from a tool used for bolting hull sections together. Parts of it quiver gelatinously, as though the thing is insectile and alive."
	release_force = 30
	icon = 'icons/obj/gun.dmi'
	icon_state = "spikethrower3"
	item_state = "spikethrower"
	fire_sound = 'sound/weapons/bladeslice.ogg'
	fire_sound_text = "a meaty thunk"
	var/base_state = "spikethrower"
	var/last_regen = 0
	var/spike_gen_time = 150
	var/max_spikes = 5
	var/spikes = 5

/obj/item/gun/launcher/spikethrower/attackby(obj/item/A, mob/user)
	if(istype(A, /obj/item/spike))
		if(spikes >= max_spikes)
			to_chat(user, SPAN_WARNING("\The [src] is already loaded to capacity."))
			return TRUE
		to_chat(user, SPAN_NOTICE("You insert \the [A] into \the [src]."))
		user.drop_from_inventory(A)
		qdel(A)
		spikes++
		update_icon()
		return TRUE
	return ..()

/obj/item/gun/launcher/spikethrower/small
	name = "spike pistol"
	desc = "A cut-down version of the infamous spike thrower, adapted from a tool used for bolting hull sections together. Parts of it quiver gelatinously, as though the thing is insectile and alive."
	icon_state = "spikepistol3"
	base_state = "spikepistol"
	w_class = ITEMSIZE_COST_SMALL
	slot_flags = SLOT_BACK | SLOT_BELT
	spike_gen_time = 180
	release_force = 24
	max_spikes = 3
	spikes = 3

/obj/item/weapon/gun/launcher/spikethrower/New()
	..()
	START_PROCESSING(SSobj, src)
	last_regen = world.time

/obj/item/weapon/gun/launcher/spikethrower/Destroy()
	STOP_PROCESSING(SSobj, src)
	..()

/obj/item/weapon/gun/launcher/spikethrower/process()
	if(spikes < max_spikes && world.time > last_regen + spike_gen_time)
		spikes++
		last_regen = world.time
		update_icon()

/obj/item/weapon/gun/launcher/spikethrower/examine(mob/user)
	. = ..()
	. += "It has [spikes] spike\s remaining."

<<<<<<< HEAD
/obj/item/weapon/gun/launcher/spikethrower/update_icon()
	icon_state = "spikethrower[spikes]"
=======
/obj/item/gun/launcher/spikethrower/update_icon()
	icon_state = "[base_state][spikes]"
>>>>>>> 994f58e3c59... Playable vox oh no. [MDB IGNORE] (#8674)

/obj/item/weapon/gun/launcher/spikethrower/update_release_force()
	return

/obj/item/weapon/gun/launcher/spikethrower/consume_next_projectile()
	if(spikes < 1) return null
	spikes--
	return new /obj/item/weapon/spike(src)

/*
 * Vox Darkmatter Cannon
 */
/obj/item/weapon/gun/energy/darkmatter
	name = "dark matter gun"
	desc = "A vicious alien beam weapon. Parts of it quiver gelatinously, as though the thing is insectile and alive."
	icon_state = "darkcannon"
	item_state = "darkcannon"
	w_class = ITEMSIZE_HUGE
	charge_cost = 300
	projectile_type = /obj/item/projectile/beam/stun/darkmatter
	cell_type = /obj/item/weapon/cell/device/weapon/recharge
	battery_lock = 1
	accuracy = 30

	firemodes = list(
		list(mode_name="stunning", burst=1, fire_delay=null, move_delay=null, burst_accuracy=list(30), dispersion=null, projectile_type=/obj/item/projectile/beam/stun/darkmatter, charge_cost = 300),
		list(mode_name="focused", burst=1, fire_delay=null, move_delay=null, burst_accuracy=list(30), dispersion=null, projectile_type=/obj/item/projectile/beam/darkmatter, charge_cost = 400),
		list(mode_name="scatter burst", burst=8, fire_delay=null, move_delay=4, burst_accuracy=list(0, 0, 0, 0, 0, 0, 0, 0), dispersion=list(3, 3, 3, 3, 3, 3, 3, 3, 3), projectile_type=/obj/item/projectile/energy/darkmatter, charge_cost = 300),
	)

/obj/item/projectile/beam/stun/darkmatter
	name = "dark matter wave"
	icon_state = "darkt"
	fire_sound = 'sound/weapons/eLuger.ogg'
	nodamage = 1
	taser_effect = 1
	agony = 55
	damage_type = HALLOSS
	light_color = "#8837A3"

	muzzle_type = /obj/effect/projectile/muzzle/darkmatterstun
	tracer_type = /obj/effect/projectile/tracer/darkmatterstun
	impact_type = /obj/effect/projectile/impact/darkmatterstun

/obj/item/projectile/beam/darkmatter
	name = "dark matter bolt"
	icon_state = "darkb"
	fire_sound = 'sound/weapons/eLuger.ogg'
	damage = 35
	armor_penetration = 35
	damage_type = BRUTE
	check_armour = "energy"
	light_color = "#8837A3"

	embed_chance = 0

	muzzle_type = /obj/effect/projectile/muzzle/darkmatter
	tracer_type = /obj/effect/projectile/tracer/darkmatter
	impact_type = /obj/effect/projectile/impact/darkmatter

/obj/item/projectile/energy/darkmatter
	name = "dark matter pellet"
	icon_state = "dark_pellet"
	fire_sound = 'sound/weapons/eLuger.ogg'
	damage = 20
	armor_penetration = 35
	damage_type = BRUTE
	check_armour = "energy"
	light_color = "#8837A3"

	embed_chance = 0

/*
 * Vox Sonic Cannon
 */
/obj/item/weapon/gun/energy/sonic
	name = "soundcannon"
	desc = "A vicious alien sound weapon. Parts of it quiver gelatinously, as though the thing is insectile and alive."
	icon_state = "noise"
	item_state = "noise"
	w_class = ITEMSIZE_HUGE
	cell_type = /obj/item/weapon/cell/device/weapon/recharge
	battery_lock = 1
	charge_cost = 400

	projectile_type=/obj/item/projectile/sonic/weak

	firemodes = list(
		list(mode_name="suppressive", projectile_type=/obj/item/projectile/sonic/weak, charge_cost = 200),
		list(mode_name="normal", projectile_type=/obj/item/projectile/sonic/strong, charge_cost = 600),
		)

/obj/item/projectile/sonic
	name = "sonic pulse"
	icon_state = "sound"
	fire_sound = 'sound/effects/basscannon.ogg'
	damage = 5
	armor_penetration = 30
	damage_type = BRUTE
	check_armour = "melee"
	embed_chance = 0
	vacuum_traversal = 0

/obj/item/projectile/sonic/weak
	agony = 50

/obj/item/projectile/sonic/strong
	damage = 45

/obj/item/projectile/sonic/strong/on_hit(var/atom/movable/target, var/blocked = 0)
	if(ismob(target))
		var/throwdir = get_dir(firer,target)
		target.throw_at(get_edge_target_turf(target, throwdir), rand(1,6), 10)
		return 1
