// These hivebots are intended for general damage causing, at range.

/mob/living/simple_mob/mechanical/hivebot/ranged_damage
	maxHealth = 2 LASERS_TO_KILL // 60 health
	health = 2 LASERS_TO_KILL
	projectiletype = /obj/item/projectile/bullet/hivebot

// The regular ranged hivebot, that fires somewhat weak projectiles.
/mob/living/simple_mob/mechanical/hivebot/ranged_damage/basic
	name = "ranged hivebot"
	desc = "A robot with a makeshift integrated ballistic weapon."
	projectile_dispersion = 10
	projectile_accuracy = -20

// This one shoots quickly, and is considerably more dangerous.
/mob/living/simple_mob/mechanical/hivebot/ranged_damage/rapid
	name = "rapid hivebot"
	desc = "A robot with a crude but deadly integrated rifle."
	base_attack_cooldown = 5 // Two attacks a second or so.
	player_msg = "You have a <b>rapid fire attack</b>."
	projectile_dispersion = 7
	projectile_accuracy = -10

// Shoots deadly lasers.
/mob/living/simple_mob/mechanical/hivebot/ranged_damage/laser
	name = "laser hivebot"
	desc = "A robot with a photonic weapon integrated into itself."
	projectiletype = /obj/item/projectile/beam/blue
	projectilesound = 'sound/weapons/Laser.ogg'
	player_msg = "You have a <b>laser attack</b>."
	projectile_dispersion = 7
	projectile_accuracy = -20

// Shoots EMPs, to screw over other robots.
/mob/living/simple_mob/mechanical/hivebot/ranged_damage/ion
	name = "ionic hivebot"
	desc = "A robot with an electromagnetic pulse projector."
	icon_state = "yellow"
	icon_living = "yellow"

	projectiletype = /obj/item/projectile/ion
	projectilesound = 'sound/weapons/Laser.ogg'
	player_msg = "You have a <b>ranged ion attack</b>, which is very strong against other synthetics.<br>\
	Be careful to not hit yourself or your team, as it will affect you as well."

// Beefy and ranged.
/mob/living/simple_mob/mechanical/hivebot/ranged_damage/strong
	name = "strong hivebot"
	desc = "A robot with a crude ballistic weapon and strong armor."
	maxHealth = 4 LASERS_TO_KILL // 120 health.
	health = 4 LASERS_TO_KILL
	melee_damage_lower = 15
	melee_damage_upper = 15
	projectile_dispersion = 5
	projectile_accuracy = -15

// Also beefy, but tries to stay at their 'home', ideal for base defense.
/mob/living/simple_mob/mechanical/hivebot/ranged_damage/strong/guard
	name = "guard hivebot"
	desc = "A robot that seems to be guarding something."
//	ai_holder_type = todo


// Inflicts a damage-over-time modifier on things it hits.
// It is able to stack with repeated attacks.
/mob/living/simple_mob/mechanical/hivebot/ranged_damage/dot
	name = "ember hivebot"
	desc = "A robot that appears to utilize fire to cook their enemies."
	icon_state = "red"
	icon_living = "red"

	projectiletype = /obj/item/projectile/fire
	heat_resist = 1
	player_msg = "Your attacks inflict a <b>damage over time</b> effect, that will \
	harm your target slowly. The effect stacks with further attacks.<br>\
	You are also immune to fire."

/obj/item/projectile/fire
	name = "ember"
	icon = 'icons/effects/effects.dmi'
	icon_state = "explosion_particle"
	modifier_type_to_apply = /datum/modifier/fire
	modifier_duration = 6 SECONDS // About 15 damage per stack, as Life() ticks every two seconds.
	damage = 0
	nodamage = TRUE

	impact_effect_type = /obj/effect/temp_visual/impact_effect
	hitsound_wall = 'sound/weapons/effects/searwall.ogg'


// Close to mid-ranged shooter that arcs over other things, ideal if allies are in front of it.
// Difference from siege hivebots is that siege hivebots have limited charges for their attacks, are very long range, and
// the projectiles have an AoE component, where as backline hivebots do not.
/mob/living/simple_mob/mechanical/hivebot/ranged_damage/backline
	name = "backline hivebot"
	desc = "A robot that can fire short-ranged projectiles over their allies."
	projectiletype = /obj/item/projectile/arc/blue_energy
	projectilesound = 'sound/weapons/Laser.ogg'
	player_msg = "Your attacks are short-ranged, but can <b>arc over obstructions</b> such as allies \
	or barriers."

/obj/item/projectile/arc/blue_energy
	name = "energy missile"
	icon_state = "force_missile"
	damage = 15 // A bit stronger since arcing projectiles are much easier to avoid than traditional ones.
	damage_type = BURN

// Very long ranged hivebot that rains down hell.
// Their projectiles arc, meaning they go over everything until it hits the ground.
// This means they're somewhat easier to avoid, but go over most defenses (like allies, or barriers),
// and tend to do more harm than a regular projectile, due to being AoE.
/mob/living/simple_mob/mechanical/hivebot/ranged_damage/siege
	name = "siege engine hivebot"
	desc = "A large robot capable of delivering long range bombardment."
<<<<<<< HEAD
	projectiletype = /obj/item/projectile/arc/test
=======
	projectiletype = /obj/item/projectile/arc/fragmentation/mortar
	projectilesound = 'sound/weapons/mech_mortar.ogg'
>>>>>>> 7b35dc7e9ea... Merge pull request #9039 from Mechoid/SiegeHivebot
	icon_scale_x = 2
	icon_scale_y = 2
	icon_state = "red"
	icon_living = "red"

	organ_names = /decl/mob_organ_names/hivebotsiege

	player_msg = "You are capable of firing <b>very long range bombardment attacks</b>.<br>\
	To use, click on a tile or enemy at a long range. Note that the projectile arcs in the air, \
	so it will fly over everything inbetween you and the target.<br>\
	The bombardment is most effective when attacking a static structure, as it cannot avoid your fire."

// Fires EMP blasts.
/mob/living/simple_mob/mechanical/hivebot/ranged_damage/siege/emp
	name = "ionic artillery hivebot"
	desc = "A large robot capable of annihilating electronics from a long distance."
	projectiletype = /obj/item/projectile/arc/emp_blast

/obj/item/projectile/arc/emp_blast
	name = "emp blast"
	icon_state = "bluespace"

/obj/item/projectile/arc/emp_blast/on_impact(turf/T)
	empulse(T, 2, 4, 7, 10) // Normal EMP grenade.
	return ..()

/obj/item/projectile/arc/emp_blast/weak/on_impact(turf/T)
	empulse(T, 1, 2, 3, 4) // Sec EMP grenade.
	return ..()


// Fires shots that irradiate the tile hit.
/mob/living/simple_mob/mechanical/hivebot/ranged_damage/siege/radiation
	name = "desolator hivebot"
	desc = "A large robot capable of irradiating a large area from afar."
	projectiletype = /obj/item/projectile/arc/radioactive


// Essentially a long ranged frag grenade.
/mob/living/simple_mob/mechanical/hivebot/ranged_damage/siege/fragmentation
	name = "anti-personnel artillery hivebot"
	desc = "A large robot capable of delivering fragmentation shells to rip apart their fleshy enemies."
	projectiletype = /obj/item/projectile/arc/fragmentation

/decl/mob_organ_names/hivebotsiege
	hit_zones = list("central chassis", "armor plating", "reinforced positioning servo", "head", "sensor suite", "manipulator arm", "heavy weapons mount", "advanced weapons array", "front right leg", "front left leg", "rear left leg", "rear right leg")
