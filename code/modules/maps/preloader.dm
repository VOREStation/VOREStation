GLOBAL_VAR_INIT(use_preloader, FALSE)
GLOBAL_VAR_INIT(_preloader_path, null)
GLOBAL_LIST_EMPTY(_preloader_attributes)

/world/proc/preloader_setup(list/the_attributes, path)
	if(LAZYLEN(the_attributes))
		GLOB.use_preloader = TRUE
		GLOB._preloader_attributes = the_attributes
		GLOB._preloader_path = path

/world/proc/preloader_load(atom/what)
	GLOB.use_preloader = FALSE
	var/list/attributes = GLOB._preloader_attributes
	for(var/attribute in attributes)
		var/value = attributes[attribute]
		if(islist(value))
			value = deepCopyList(value)
		#ifdef TESTING
		if(what.vars[attribute] == value)
			var/message = span_green("[what.type]") + " at [AREACOORD(what)] - " + span_bold("VAR:") + " " + span_red("[attribute] = [isnull(value) ? "null" : (isnum(value) ? value : "\"[value]\"")]")
			world.log << "DIRTY VAR: [message]"
			// dirty_vars += message
		#endif
		what.vars[attribute] = value

/area/template_noop
	name = "Area Passthrough"

/turf/template_noop
	name = "Turf Passthrough"
	icon_state = "template_void"
