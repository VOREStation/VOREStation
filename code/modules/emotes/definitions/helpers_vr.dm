// Not specifically /human type because those won't allow FBPs to use them
/decl/emote/helper/vwag
    key = "vwag"
    emote_message_3p = ""

/decl/emote/helper/vwag/mob_can_use(mob/living/carbon/human/user)
    if(!istype(user) || (!user.tail_style || !user.tail_style.ani_state))
        return FALSE
    return ..()

/decl/emote/helper/vwag/do_emote(var/mob/living/carbon/human/user, var/extra_params)
    if(user.toggle_tail(message = 1))
        return ..()

/decl/emote/helper/vwag/get_emote_message_3p(var/mob/living/carbon/human/user, var/atom/target, var/extra_params)
    return "[user.wagging ? "starts" : "stops"] wagging USER_THEIR tail."


/decl/emote/helper/vflap
    key = "vflap"
    emote_message_3p = ""

/decl/emote/helper/vflap/mob_can_use(mob/living/carbon/human/user)
    if(!istype(user) || (!user.wing_style || !user.wing_style.ani_state))
        return FALSE
    return ..()

/decl/emote/helper/vflap/do_emote(var/mob/living/carbon/human/user, var/extra_params)
    if(user.toggle_wing(message = 1))
        return ..()

/decl/emote/helper/vflap/get_emote_message_3p(var/mob/living/carbon/human/user, var/atom/target, var/extra_params)
    return "[user.flapping ? "starts" : "stops"] flapping USER_THEIR wings."
