///////////
// Commlink - Has a bunch of extra stuff due to communicator defines.
/datum/nifsoft/commlink
	name = "Commlink"
	desc = "An internal communicator for keeping in touch with people."
	list_pos = NIF_COMMLINK
	cost = 250
	wear = 0
	p_drain = 0.01
	other_flags = (NIF_O_COMMLINK)

/datum/nifsoft/commlink/install()
	if((. = ..()))
		nif.comm = new(nif,src)

/datum/nifsoft/commlink/uninstall()
	var/obj/item/nif/lnif = nif //Awkward. Parent clears it in an attempt to clean up.
	if((. = ..()) && lnif)
		QDEL_NULL(lnif.comm)

/datum/nifsoft/commlink/activate()
	if((. = ..()))
		nif.comm.initialize_exonet(nif.human)
		nif.comm.tgui_interact(nif.human, custom_state = GLOB.tgui_commlink_state)
		spawn(0)
			deactivate()

/datum/nifsoft/commlink/stat_text()
	return "Show Commlink"

/datum/nifsoft/commlink/Topic(href, href_list)
	if(href_list["open"])
		activate()

/obj/item/communicator/commlink
	name = "commlink"
	desc = "An internal communicator, basically."
	occupation = "\[Commlink\]"
	var/obj/item/nif/nif
	var/datum/nifsoft/commlink/nifsoft

/obj/item/communicator/commlink/New(var/newloc,var/soft)
	..()
	nif = newloc
	nifsoft = soft

/obj/item/communicator/commlink/Destroy()
	if(nif)
		nif.comm = null
		nif = null
	nifsoft = null
	return ..()

/obj/item/communicator/commlink/register_device(var/new_name)
	owner = new_name
	name = "[owner]'s [initial(name)]"
	nif.save_data["commlink_name"] = owner

//So that only the owner's chat is relayed to others.
/obj/item/communicator/commlink/hear_talk(mob/living/M, list/message_pieces, verb)
	if(M != nif.human)
		return

	for(var/obj/item/communicator/comm in communicating)
		var/turf/T = get_turf(comm)
		if(!T) return

		var/icon_object = src

		var/list/mobs_to_relay
		if(istype(comm, /obj/item/communicator/commlink))
			var/obj/item/communicator/commlink/CL = comm
			mobs_to_relay = list(CL.nif.human)
			icon_object = CL.nif.big_icon
		else
			var/list/in_range = get_mobs_and_objs_in_view_fast(T,world.view,0)
			mobs_to_relay = in_range["mobs"]

		for(var/mob/mob in mobs_to_relay)
			var/list/combined = mob.combine_message(message_pieces, verb, M)
			var/message = combined["formatted"]
			var/name_used = M.GetVoice()
			var/rendered = null
			rendered = span_game(span_say("[icon2html(icon_object,mob.client)] [span_name(name_used)] [message]"))
			mob.show_message(rendered, 2)

//Not supported by the internal one
/obj/item/communicator/commlink/show_message(msg, type, alt, alt_type)
	return

//The silent treatment
/obj/item/communicator/commlink/request(var/atom/candidate)
	if(candidate in voice_requests)
		return
	var/who = null
	if(isobserver(candidate))
		who = candidate.name
	else if(istype(candidate, /obj/item/communicator))
		var/obj/item/communicator/comm = candidate
		who = comm.owner
		comm.voice_invites |= src

	if(!who)
		return

	voice_requests |= candidate

	if(ringer && nif.human)
		nif.notify("New commlink call from [who]. (<a href='?src=\ref[nifsoft];open=1'>Open</a>)")

//Similar reason
/obj/item/communicator/commlink/request_im(var/atom/candidate, var/origin_address, var/text)
	var/who = null
	if(isobserver(candidate))
		var/mob/observer/dead/ghost = candidate
		who = ghost
		im_list += list(list("address" = origin_address, "to_address" = exonet.address, "im" = text))
	else if(istype(candidate, /obj/item/communicator))
		var/obj/item/communicator/comm = candidate
		who = comm.owner
		comm.im_contacts |= src
		im_list += list(list("address" = origin_address, "to_address" = exonet.address, "im" = text))
	else return

	im_contacts |= candidate

	if(!who)
		return

	if(ringer && nif.human)
		nif.notify("Commlink message from [who]: \"[text]\" (<a href='?src=\ref[nifsoft];open=1'>Open</a>) (<a href='?src=\ref[src];action=Reply;target=\ref[candidate]'>Reply</a>)")
