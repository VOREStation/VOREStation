#define get_turf(A) get_step(A,0)

#define get_x(A) (get_step(A, 0)?.x || 0)

#define get_y(A) (get_step(A, 0)?.y || 0)

#define get_z(A) (get_step(A, 0)?.z || 0)

#define RANDOM_BLOOD_TYPE pick(4;"O-", 36;"O+", 3;"A-", 28;"A+", 1;"B-", 20;"B+", 1;"AB-", 5;"AB+")
#define DEFAULT_BLOOD_TYPE "A+"

#define to_file(file_entry, source_var) file_entry << source_var
#define from_file(file_entry, target_var) file_entry >> target_var
#define show_browser(target, browser_content, browser_name) target << browse(browser_content, browser_name)
#define send_rsc(target, rsc_content, rsc_name)	target << browse_rsc(rsc_content, rsc_name)
#define open_link(target, url) target << link(url)

#define CanInteract(user, state) (CanUseTopic(user, state) == STATUS_INTERACTIVE)

#define sequential_id(key) uniqueness_repository.Generate(/datum/uniqueness_generator/id_sequential, key)

#define random_id(key,min_id,max_id) uniqueness_repository.Generate(/datum/uniqueness_generator/id_random, key, min_id, max_id)

#define WORLD_ICON_SIZE 32 //Needed for the R-UST port

#define PIXEL_MULTIPLIER WORLD_ICON_SIZE/32 //Needed for the R-UST port

#define JOINTEXT(X) jointext(X, null)

#define isbelly(A)				istype(A, /obj/belly)
#define isgripperpocket(A)		istype(A, /obj/item/storage/internal/gripper)
#define iscapturecrystal(A)		istype(A, /obj/item/capture_crystal)
