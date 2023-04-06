#define span(class, text) ("<span class='[class]'>[text]</span>")

#define get_turf(A) get_step(A,0)

#define get_x(A) (get_step(A, 0)?.x || 0)

#define get_y(A) (get_step(A, 0)?.y || 0)

#define get_z(A) (get_step(A, 0)?.z || 0)

#define RANDOM_BLOOD_TYPE pick(4;"O-", 36;"O+", 3;"A-", 28;"A+", 1;"B-", 20;"B+", 1;"AB-", 5;"AB+")

// #define to_chat(target, message) target << message Not anymore!
//#define to_chat to_chat_filename=__FILE__;to_chat_line=__LINE__;to_chat_src=src;__to_chat
#define to_chat __to_chat
#define to_world(message) to_chat(world, message)
#define to_world_log(message) world.log << message
// TODO - Baystation has this log to crazy places. For now lets just world.log, but maybe look into it later.
#define log_world(message) to_world_log(message)
#define to_file(file_entry, source_var) file_entry << source_var
#define from_file(file_entry, target_var) file_entry >> target_var
#define show_browser(target, browser_content, browser_name) target << browse(parse_html(browser_content), browser_name)
#define send_rsc(target, rsc_content, rsc_name)	target << browse_rsc(rsc_content, rsc_name)
#define open_link(target, url) target << link(url)

// From TG, might be useful to have.
// Didn't port SEND_TEXT() since to_chat() appears to serve the same purpose.
#define DIRECT_OUTPUT(A, B) A << B
#define SEND_IMAGE(target, image) DIRECT_OUTPUT(target, image)
#define SEND_SOUND(target, sound) DIRECT_OUTPUT(target, sound)
//#define WRITE_LOG is in logging.dm

#define CanInteract(user, state) (CanUseTopic(user, state) == STATUS_INTERACTIVE)

#define qdel_null(x) if(x) { qdel(x) ; x = null }

#define sequential_id(key) uniqueness_repository.Generate(/datum/uniqueness_generator/id_sequential, key)

#define random_id(key,min_id,max_id) uniqueness_repository.Generate(/datum/uniqueness_generator/id_random, key, min_id, max_id)

#define ARGS_DEBUG log_debug("[__FILE__] - [__LINE__]") ; for(var/arg in args) { log_debug("\t[log_info_line(arg)]") }

#define WORLD_ICON_SIZE 32 //Needed for the R-UST port

#define PIXEL_MULTIPLIER WORLD_ICON_SIZE/32 //Needed for the R-UST port

#define JOINTEXT(X) jointext(X, null)



/proc/parse_html(var/browser_content)
	if(isfile(browser_content))
		return browser_content
	else if(findtext(browser_content, "<html>"))
		return replacetext(browser_content, "<html>", "<html><meta charset='UTF-8'>")
	else
		return "<HTML><meta charset='UTF-8'><BODY>[browser_content]</BODY></HTML>"
