#define span(class, text) ("<span class='[class]'>[text]</span>")

#define get_turf(A) get_step(A,0)

#define get_x(A) (get_step(A, 0)?.x || 0)

#define get_y(A) (get_step(A, 0)?.y || 0)

#define get_z(A) (get_step(A, 0)?.z || 0)

#define RANDOM_BLOOD_TYPE pick(4;"O-", 36;"O+", 3;"A-", 28;"A+", 1;"B-", 20;"B+", 1;"AB-", 5;"AB+")

// #define to_chat(target, message) target << message Not anymore!
//#define to_chat to_chat_filename=__FILE__;to_chat_line=__LINE__;to_chat_src=src;__to_chat


// General I/O semantics
#define to_target(target, payload)            target << (payload)
#define from_target(target, receiver)         target >> (receiver)


// Common use patterns
#define to_chat __to_vchat
#define to_world(message)                     to_chat(world, message)
#define to_world_log(message)                 to_target(world.log, message)
#define legacy_chat(target, message)          to_target(target, message)
#define sound_to(target, sound)               to_target(target, sound)
#define image_to(target, image)               to_target(target, image)
#define show_browser(target, content, title)  to_target(target, browse(content, title))
#define close_browser(target, title)          to_target(target, browse(null, title))
#define send_rsc(target, content, title)      to_target(target, browse_rsc(content, title))
#define send_link(target, url)                to_target(target, link(url))
#define send_output(target, msg, control)     to_target(target, output(msg, control))
#define to_save(handle, value)                to_target(handle, value)
#define from_save(handle, target_var)         from_target(handle, target_var)


#define CanInteract(user, state) (CanUseTopic(user, state) == STATUS_INTERACTIVE)

#define sequential_id(key) uniqueness_repository.Generate(/datum/uniqueness_generator/id_sequential, key)

#define random_id(key,min_id,max_id) uniqueness_repository.Generate(/datum/uniqueness_generator/id_random, key, min_id, max_id)

#define ARGS_DEBUG log_debug("[__FILE__] - [__LINE__]") ; for(var/arg in args) { log_debug("\t[log_info_line(arg)]") }

#define WORLD_ICON_SIZE 32 //Needed for the R-UST port

#define PIXEL_MULTIPLIER WORLD_ICON_SIZE/32 //Needed for the R-UST port

#define JOINTEXT(X) jointext(X, null)
