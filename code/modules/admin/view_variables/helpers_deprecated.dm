//This entire file needs to be removed eventually
/datum/proc/get_view_variables_options()
	return ""

/mob/get_view_variables_options()
	return ..() + {"
		<option value='?_src_=vars;mob_player_panel=\ref[src]'>Show player panel</option>
		<option>---</option>
		<option value='?_src_=vars;give_modifier=\ref[src]'>Give Modifier</option>
		<option value='?_src_=vars;give_spell=\ref[src]'>Give Spell</option>
		<option value='?_src_=vars;give_disease2=\ref[src]'>Give Disease</option>
		<option value='?_src_=vars;give_disease=\ref[src]'>Give TG-style Disease</option>
		<option value='?_src_=vars;godmode=\ref[src]'>Toggle Godmode</option>
		<option value='?_src_=vars;build_mode=\ref[src]'>Toggle Build Mode</option>

		<option value='?_src_=vars;ninja=\ref[src]'>Make Space Ninja</option>
		<option value='?_src_=vars;make_skeleton=\ref[src]'>Make 2spooky</option>

		<option value='?_src_=vars;direct_control=\ref[src]'>Assume Direct Control</option>
		<option value='?_src_=vars;drop_everything=\ref[src]'>Drop Everything</option>

		<option value='?_src_=vars;regenerateicons=\ref[src]'>Regenerate Icons</option>
		<option value='?_src_=vars;addlanguage=\ref[src]'>Add Language</option>
		<option value='?_src_=vars;remlanguage=\ref[src]'>Remove Language</option>
		<option value='?_src_=vars;addorgan=\ref[src]'>Add Organ</option>
		<option value='?_src_=vars;remorgan=\ref[src]'>Remove Organ</option>

		<option value='?_src_=vars;fix_nano=\ref[src]'>Fix NanoUI</option>

		<option value='?_src_=vars;addverb=\ref[src]'>Add Verb</option>
		<option value='?_src_=vars;remverb=\ref[src]'>Remove Verb</option>
		<option>---</option>
		<option value='?_src_=vars;gib=\ref[src]'>Gib</option>
		"}

/mob/living/carbon/human/get_view_variables_options()
	return ..() + {"
		<option value='?_src_=vars;setspecies=\ref[src]'>Set Species</option>
		<option value='?_src_=vars;makeai=\ref[src]'>Make AI</option>
		<option value='?_src_=vars;makerobot=\ref[src]'>Make cyborg</option>
		<option value='?_src_=vars;makemonkey=\ref[src]'>Make monkey</option>
		<option value='?_src_=vars;makealien=\ref[src]'>Make alien</option>
		"}

/obj/get_view_variables_options()
	return ..() + {"
		<option value='?_src_=vars;delall=\ref[src]'>Delete all of type</option>
		"}
