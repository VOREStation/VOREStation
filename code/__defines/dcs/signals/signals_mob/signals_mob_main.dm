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

///from /mob/living/carbon/human/GetVoice(): (list/voice_data) - voice_data[1] contains the voice name
#define COMSIG_HUMAN_GET_VOICE "human_get_voice"
	#define COMPONENT_VOICE_CHANGED (1<<0)
///from /mob/living/carbon/human/GetAltName(): (list/name_data) - name_data[1] contains the alt name
#define COMSIG_HUMAN_GET_ALT_NAME "human_get_alt_name"
	#define COMPONENT_ALT_NAME_CHANGED (1<<0)
///from /mob/living/carbon/human/get_visible_name(): (list/name_data) - name_data[1] contains the visible name
#define COMSIG_HUMAN_GET_VISIBLE_NAME "human_get_visible_name"
	#define COMPONENT_VISIBLE_NAME_CHANGED (1<<0)
