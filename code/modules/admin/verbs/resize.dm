/client/proc/resize(var/mob/living/L in mob_list)
    set name = "Resize"
    set desc = "Resizes any living mob without any restrictions on size."
    set category = "Fun"
    if(!check_rights(R_ADMIN, R_FUN))
        return
    
    var/size_multiplier = input(usr, "Input size multiplier.", "Resize", 1)
    L.resize(size_multiplier, TRUE, TRUE)
    if(size_multiplier >= RESIZE_TINY && size_multiplier <= RESIZE_HUGE)
        L.size_uncapped = FALSE
    else
        L.size_uncapped = TRUE

    log_and_message_admins("has changed [key_name(L)]'s size multiplier to [size_multiplier].")
    feedback_add_details("admin_verb","RESIZE")