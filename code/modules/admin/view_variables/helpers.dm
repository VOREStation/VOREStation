
// Keep these two together, they *must* be defined on both
// If /client ever becomes /datum/client or similar, they can be merged
/datum/proc/get_view_variables_header()
	return span_bold("[src]")

/atom/get_view_variables_header()
	return {"
		<a href='?_src_=vars;[HrefToken()];datumedit=\ref[src];varnameedit=name'><b>[src]</b></a>
		<br><font size='1'>
		<a href='?_src_=vars;[HrefToken()];rotatedatum=\ref[src];rotatedir=left'><<</a>
		<a href='?_src_=vars;[HrefToken()];datumedit=\ref[src];varnameedit=dir'>[dir2text(dir)]</a>
		<a href='?_src_=vars;[HrefToken()];rotatedatum=\ref[src];rotatedir=right'>>></a>
		</font>
		"}

/mob/living/get_view_variables_header()
	return {"
		<a href='?_src_=vars;[HrefToken()];rename=\ref[src]'><b>[src]</b></a><font size='1'>
		<br><a href='?_src_=vars;[HrefToken()];rotatedatum=\ref[src];rotatedir=left'><<</a> <a href='?_src_=vars;[HrefToken()];datumedit=\ref[src];varnameedit=dir'>[dir2text(dir)]</a> <a href='?_src_=vars;[HrefToken()];rotatedatum=\ref[src];rotatedir=right'>>></a>
		<br><a href='?_src_=vars;[HrefToken()];datumedit=\ref[src];varnameedit=ckey'>[ckey ? ckey : "No ckey"]</a> / <a href='?_src_=vars;[HrefToken()];datumedit=\ref[src];varnameedit=real_name'>[real_name ? real_name : "No real name"]</a>
		<br>
		BRUTE:<a href='?_src_=vars;[HrefToken()];mobToDamage=\ref[src];adjustDamage=brute'>[getBruteLoss()]</a>
		FIRE:<a href='?_src_=vars;[HrefToken()];mobToDamage=\ref[src];adjustDamage=fire'>[getFireLoss()]</a>
		TOXIN:<a href='?_src_=vars;[HrefToken()];mobToDamage=\ref[src];adjustDamage=toxin'>[getToxLoss()]</a>
		OXY:<a href='?_src_=vars;[HrefToken()];mobToDamage=\ref[src];adjustDamage=oxygen'>[getOxyLoss()]</a>
		CLONE:<a href='?_src_=vars;[HrefToken()];mobToDamage=\ref[src];adjustDamage=clone'>[getCloneLoss()]</a>
		BRAIN:<a href='?_src_=vars;[HrefToken()];mobToDamage=\ref[src];adjustDamage=brain'>[getBrainLoss()]</a>
		</font>
		"}

//This entire file needs to be removed eventually
/datum/proc/get_view_variables_options()
	return ""

/mob/get_view_variables_options()
	return ..() + {"
		<option value='?_src_=vars;[HrefToken()];mob_player_panel=\ref[src]'>Show player panel</option>
		<option>---</option>
		<option value='?_src_=vars;[HrefToken()];give_modifier=\ref[src]'>Give Modifier</option>
		<option value='?_src_=vars;[HrefToken()];give_wound_internal=\ref[src]'>Give Internal Bleeding</option>
		<option value='?_src_=vars;[HrefToken()];give_spell=\ref[src]'>Give Spell</option>
		<option value='?_src_=vars;[HrefToken()];give_disease2=\ref[src]'>Give Disease</option>
		<option value='?_src_=vars;[HrefToken()];give_disease=\ref[src]'>Give TG-style Disease</option>
		<option value='?_src_=vars;[HrefToken()];godmode=\ref[src]'>Toggle Godmode</option>
		<option value='?_src_=vars;[HrefToken()];build_mode=\ref[src]'>Toggle Build Mode</option>

		<option value='?_src_=vars;[HrefToken()];ninja=\ref[src]'>Make Space Ninja</option>
		<option value='?_src_=vars;[HrefToken()];make_skeleton=\ref[src]'>Make 2spooky</option>

		<option value='?_src_=vars;[HrefToken()];direct_control=\ref[src]'>Assume Direct Control</option>
		<option value='?_src_=vars;[HrefToken()];give_ai=\ref[src]'>Enable/Modify A.I</option>
		<option value='?_src_=vars;[HrefToken()];drop_everything=\ref[src]'>Drop Everything</option>

		<option value='?_src_=vars;[HrefToken()];regenerateicons=\ref[src]'>Regenerate Icons</option>
		<option value='?_src_=vars;[HrefToken()];addlanguage=\ref[src]'>Add Language</option>
		<option value='?_src_=vars;[HrefToken()];remlanguage=\ref[src]'>Remove Language</option>
		<option value='?_src_=vars;[HrefToken()];addorgan=\ref[src]'>Add Organ</option>
		<option value='?_src_=vars;[HrefToken()];remorgan=\ref[src]'>Remove Organ</option>

		<option value='?_src_=vars;[HrefToken()];fix_nano=\ref[src]'>Fix NanoUI</option>

		<option value='?_src_=vars;[HrefToken()];addverb=\ref[src]'>Add Verb</option>
		<option value='?_src_=vars;[HrefToken()];remverb=\ref[src]'>Remove Verb</option>
		<option>---</option>
		<option value='?_src_=vars;[HrefToken()];gib=\ref[src]'>Gib</option>
		"}

/mob/living/carbon/human/get_view_variables_options()
	return ..() + {"
		<option value='?_src_=vars;[HrefToken()];setspecies=\ref[src]'>Set Species</option>
		<option value='?_src_=vars;[HrefToken()];makeai=\ref[src]'>Make AI</option>
		<option value='?_src_=vars;[HrefToken()];makerobot=\ref[src]'>Make cyborg</option>
		<option value='?_src_=vars;[HrefToken()];makemonkey=\ref[src]'>Make monkey</option>
		<option value='?_src_=vars;[HrefToken()];makealien=\ref[src]'>Make alien</option>
		"}

/obj/get_view_variables_options()
	return ..() + {"
		<option value='?_src_=vars;[HrefToken()];delall=\ref[src]'>Delete all of type</option>
		"}

/turf/get_view_variables_options()
	return ..() + {"
		<option value='?_src_=vars;[HrefToken()];explode=\ref[src]'>Trigger explosion</option>
		<option value='?_src_=vars;[HrefToken()];emp=\ref[src]'>Trigger EM pulse</option>
		"}

/obj/item/pda/get_view_variables_options()
	return ..() + {"
		<option value='?_src_=vars;[HrefToken()];fakepdapropconvo=\ref[src]'>Add Fake Prop Conversation</option>
		"}

/datum/proc/get_variables()
	. = vars - VV_hidden()
	if(!usr || !check_rights(R_ADMIN|R_DEBUG, FALSE))
		. -= VV_secluded()

/datum/proc/get_variable_value(varname)
	return vars[varname]

/datum/proc/set_variable_value(varname, value)
	vars[varname] = value

/datum/proc/get_initial_variable_value(varname)
	return initial(vars[varname])

/datum/proc/make_view_variables_variable_entry(var/varname, var/value, var/hide_watch = 0)
	return {"
			(<a href='?_src_=vars;[HrefToken()];datumedit=\ref[src];varnameedit=[varname]'>E</a>)
			(<a href='?_src_=vars;[HrefToken()];datumchange=\ref[src];varnamechange=[varname]'>C</a>)
			(<a href='?_src_=vars;[HrefToken()];datummass=\ref[src];varnamemass=[varname]'>M</a>)
			[hide_watch ? "" : "(<a href='?_src_=vars;[HrefToken()];datumwatch=\ref[src];varnamewatch=[varname]'>W</a>)"]
			"}

// No mass editing of clients
/client/make_view_variables_variable_entry(var/varname, var/value, var/hide_watch = 0)
	return {"
			(<a href='?_src_=vars;[HrefToken()];datumedit=\ref[src];varnameedit=[varname]'>E</a>)
			(<a href='?_src_=vars;[HrefToken()];datumchange=\ref[src];varnamechange=[varname]'>C</a>)
			[hide_watch ? "" : "(<a href='?_src_=vars;[HrefToken()];datumwatch=\ref[src];varnamewatch=[varname]'>W</a>)"]
			"}

// These methods are all procs and don't use stored lists to avoid VV exploits

// The following vars cannot be viewed by anyone
/datum/proc/VV_hidden()
	return list()

// The following vars can only be viewed by R_ADMIN|R_DEBUG
/datum/proc/VV_secluded()
	return list()

/datum/configuration/VV_secluded()
	return vars

// The following vars cannot be edited by anyone
/datum/proc/VV_static()
	return list("parent_type")

/atom/VV_static()
	return ..() + list("bound_x", "bound_y", "bound_height", "bound_width", "bounds", "step_x", "step_y", "step_size")

/client/VV_static()
	return ..() + list("holder", "prefs")

/datum/admins/VV_static()
	return vars

// The following vars require R_DEBUG to edit
/datum/proc/VV_locked()
	return list("vars", "cuffed")

/client/VV_locked()
	return list("vars", "mob")

/mob/VV_locked()
	return ..() + list("client")

// The following vars require R_FUN|R_DEBUG to edit
/datum/proc/VV_icon_edit_lock()
	return list()

/atom/VV_icon_edit_lock()
	return ..() + list("icon", "icon_state", "overlays", "underlays")

// The following vars require R_SPAWN|R_DEBUG to edit
/datum/proc/VV_ckey_edit()
	return list()

/mob/VV_ckey_edit()
	return list("key", "ckey")

/client/VV_ckey_edit()
	return list("key", "ckey")

/datum/proc/may_edit_var(var/user, var/var_to_edit)
	if(!user)
		return FALSE
	if(!(var_to_edit in vars))
		to_chat(user, span_warning("\The [src] does not have a var '[var_to_edit]'"))
		return FALSE
	if(var_to_edit in VV_static())
		return FALSE
	if((var_to_edit in VV_secluded()) && !check_rights(R_ADMIN|R_DEBUG, FALSE, C = user))
		return FALSE
	if((var_to_edit in VV_locked()) && !check_rights(R_DEBUG, C = user))
		return FALSE
	if((var_to_edit in VV_ckey_edit()) && !check_rights(R_SPAWN|R_DEBUG, C = user))
		return FALSE
	if((var_to_edit in VV_icon_edit_lock()) && !check_rights(R_FUN|R_DEBUG, C = user))
		return FALSE
	return TRUE

/proc/forbidden_varedit_object_types()
 	return list(
		/datum/admins						//Admins editing their own admin-power object? Yup, sounds like a good idea.
	)
