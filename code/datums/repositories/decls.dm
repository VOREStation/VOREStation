// /datum/decl is a subtype used for singletons that should never have more than one instance
// in existence at a time. If you want to use a /datum/decl you should use a pattern like:
//     var/datum/decl/somedecl/mydecl = GET_DECL(/datum/decl/somedecl)

// /datum/decls are created the first time they are fetched from decls_repository and will
// automatically call Initialize() and such when created in this way.

// decls_repository.get_decls_of_type() and decls_repository.get_decls_of_subtype()
// can be used similarly to typesof() and subtypesof(), returning assoc instance lists.

// The /datum/decl commandments:
//     I.   Thou shalt not create a /datum/decl with new().
//     II.  Thou shalt not del() or qdel() a /datum/decl.
//     III. Thou shalt not write a decl that relies on arguments supplied to New().
//     IV.  Thou shalt not call Initialize() on a /datum/decl.

GLOBAL_DATUM_INIT(decls_repository, /datum/repository/decls, new) // Initialiozed in /datum/global_init/New()

/datum/repository/decls
	var/list/fetched_decls
	var/list/fetched_decl_types
	var/list/fetched_decl_subtypes

/datum/repository/decls/New()
	..()
	fetched_decls = list()
	fetched_decl_types = list()
	fetched_decl_subtypes = list()

/datum/repository/decls/proc/get_decl(var/decl_type)
	ASSERT(ispath(decl_type))
	. = fetched_decls[decl_type]
	if(!.)
		. = new decl_type()
		fetched_decls[decl_type] = .

		var/datum/decl/decl = .
		if(istype(decl))
			decl.Initialize()

/datum/repository/decls/proc/get_decls(var/list/decl_types)
	. = list()
	for(var/datum/decl_type in decl_types)
		.[decl_type] = get_decl(decl_type)

/datum/repository/decls/proc/get_decls_unassociated(var/list/decl_types)
	. = list()
	for(var/datum/decl_type in decl_types)
		. += get_decl(decl_type)

/datum/repository/decls/proc/get_decls_of_type(var/decl_prototype)
	. = fetched_decl_types[decl_prototype]
	if(!.)
		. = get_decls(typesof(decl_prototype))
		fetched_decl_types[decl_prototype] = .

/datum/repository/decls/proc/get_decls_of_subtype(var/decl_prototype)
	. = fetched_decl_subtypes[decl_prototype]
	if(!.)
		. = get_decls(subtypesof(decl_prototype))
		fetched_decl_subtypes[decl_prototype] = .

/datum/decl/proc/Initialize()
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	return

/datum/decl/Destroy()
	SHOULD_CALL_PARENT(FALSE)
	stack_trace("Prevented attempt to delete a decl instance: [log_info_line(src)]")
	return QDEL_HINT_LETMELIVE // Prevents decl destruction
