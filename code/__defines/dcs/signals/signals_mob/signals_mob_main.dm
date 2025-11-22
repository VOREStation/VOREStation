///from base of /mob/verb/pointed: (atom/A)
#define COMSIG_MOB_POINTED "mob_pointed"

/// from /mob/living/proc/apply_damage(): (damage, damagetype, def_zone, blocked, sharp, edge, used_weapon, projectile)
/// allows you to add multiplicative damage modifiers to the damage mods argument to adjust incoming damage... UNUSED ATM
/// not sent if the apply damage call was forced
#define COMSIG_MOB_APPLY_DAMAGE_MODIFIERS "mob_apply_damage_modifiers"
/// from base of /mob/living/proc/apply_damage(): (damage, damagetype, def_zone, blocked, sharp, edge, used_weapon, projectile)
#define COMSIG_MOB_APPLY_DAMAGE "mob_apply_damage"
/// from /mob/living/proc/apply_damage(): (damage, damagetype, def_zone, blocked, sharp, edge, /obj/used_weapon, projectile)
/// works like above but after the damage is actually inflicted
#define COMSIG_MOB_AFTER_APPLY_DAMAGE "mob_after_apply_damage"
///from end of revival_healing_action(): ()
#define COMSIG_LIVING_AHEAL "living_post_aheal"

/// From /datum/status_effect/proc/on_creation() : (datum/status_effect/effect)
#define COMSIG_LIVING_STATUS_APPLIED "living_status_applied"

/// From /datum/status_effect/proc/Destroy() : (datum/status_effect/effect)
#define COMSIG_LIVING_STATUS_REMOVED "living_status_removed"

///from /datum/species/handle_fire. Called when the human is set on fire and burning clothes and stuff
#define COMSIG_HUMAN_BURNING "human_burning"

///from base of mob/clickon(): (atom/A, list/modifiers)
#define COMSIG_MOB_CLICKON "mob_clickon"
///from base of mob/MiddleClickOn(): (atom/A)
#define COMSIG_MOB_MIDDLECLICKON "mob_middleclickon"
///from base of mob/AltClickOn(): (atom/A)
#define COMSIG_MOB_ALTCLICKON "mob_altclickon"
	#define COMSIG_MOB_CANCEL_CLICKON (1<<0)
///From base of /mob/base_click_ctrl: (atom/A)
#define COMSIG_MOB_CTRL_CLICKED "mob_ctrl_clicked"
///From base of /mob/base_click_ctrl_shift: (atom/A)
#define COMSIG_MOB_CTRL_SHIFT_CLICKED "mob_ctrl_shift_clicked"
///from base of mob/alt_click_on_secodary(): (atom/A)
#define COMSIG_MOB_ALTCLICKON_SECONDARY "mob_altclickon_secondary"
