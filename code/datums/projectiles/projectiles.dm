/*********************************************************************************************
 * The Gattening: Core principles.
 *
 * Guncode has always been a mess on this branch of ss13. With many major reworks and different
 * schools of thought on how guns should be done from arcade to hyper realistic. The goal of
 * this rework is to minimize duplicated code, vars, and remove copypasted code where bullets
 * need to do unique behaviors such as flamethrowers.
 *
 * The tool used to achieve this goal is the bulletdata datum.
 *
 * Projectiles, bullet casing items, and even guns themselves lack most unique logic. Guns exist
 * to check what bullet item is inside them, and that bullet item says what bulletdata datum
 * should be used when firing. This is done to minimize vars on items. In most cases the bullet
 * item itself shouldn't exist. Such as inside a magazine, where the bullet item is destroyed when
 * placed into the magazine, and simply becomes the typepath to the bulletdata datum, and is added
 * to a list of bulletdata datums in that magazine. This also applies to ammo boxes, and the currently
 * chambered round of the gun.
 *
 * When a gun shoots a bullet, it will get the bulletdata datum of the bullet currently in its chamber.
 * This is when the bulletdatum is actually be instantiated. All other times, only the PATH to the datum
 * is stored. This minimizes memory footprint. The projectile effect fired from the gun stores the
 * instantiated datum. The gun modifies the datum however it wants based on the gun's special snowflake
 * design, such as increasing damage. Though most gun modifiers should be BASE vars to the gun item.
 *
 * When the fired bullet hits a target, it will pass the projectile, and atom hit, into a proc on the
 * bulletdata datum. This proc will allow unique behavior on bullet impact, bullet end-of-range, etc.
 *
 * Guns restrict their ammo types based on using subtypes of a datum. For example a gun that uses 10mm
 * will restrict it's bullets by setting it's bullet datum path to /datum/bulletdata/10mm, all subtypes
 * of 10mm including the base type can fit in that gun. This allows multiple ammos to work automatically
 * on every gun capable of shooting that bullet subtype without manually having to list them on the gun
 * itself. Which is an issue present on older gun reworks.
 *
 **********************************************************************************************/

/datum/bulletdata
	var/casing_name = "bullet"
	var/casing_desc = "a singular bullet, ready to go pew."
	var/damage = 1

/datum/bulletdata/proc/on_hit(obj/item/projectile, atom/hit_atom)
	// TODO - Bullet hit an atom

/datum/bulletdata/proc/on_range(obj/item/projectile)
	// TODO - Bullet reached maximum range



/datum/bulletdata/10mm
	casing_name = "10mm bullet"
