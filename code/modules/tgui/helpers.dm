/datum/tgui_say/proc/handle_packets(id, total_packets, packet)
	id = text2num(id)

	var/total = text2num(total_packets)
	if(id == 1)
		if(total > MAX_MESSAGE_CHUNKS)
			return null

		partial_packets = list("chunks" = new /list(total),
								"timeout" = addtimer(CALLBACK(src, PROC_REF(clear_oversized_payload)), 10 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_STOPPABLE)
								)

	var/list/chunks = partial_packets["chunks"]
	chunks[id] = packet

	if(id != total)
		if(id > 1)
			partial_packets["timeout"] = addtimer(CALLBACK(src, PROC_REF(clear_oversized_payload)), 10 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_STOPPABLE)
		return null

	var/assembled_payload = ""
	for(var/received_packet in partial_packets["chunks"])
		assembled_payload += received_packet

	deltimer(partial_packets["timeout"])
	partial_packets = null
	return json_decode(assembled_payload)

/datum/tgui_say/proc/clear_oversized_payload()
	partial_packets = null

/datum/tgui/proc/handle_packets(id, total_packets, packet)
	id = text2num(id)

	var/total = text2num(total_packets)
	if(id == 1)
		if(total > MAX_MESSAGE_CHUNKS)
			return null

		partial_packets = list("chunks" = new /list(total),
								"timeout" = addtimer(CALLBACK(src, PROC_REF(clear_oversized_payload)), 10 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_STOPPABLE)
								)

	var/list/chunks = partial_packets["chunks"]
	chunks[id] = packet

	if(id != total)
		if(id > 1)
			partial_packets["timeout"] = addtimer(CALLBACK(src, PROC_REF(clear_oversized_payload)), 10 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_STOPPABLE)
		return null

	var/assembled_payload = ""
	for(var/received_packet in partial_packets["chunks"])
		assembled_payload += received_packet

	deltimer(partial_packets["timeout"])
	partial_packets = null
	return json_decode(assembled_payload)

/datum/tgui/proc/clear_oversized_payload()
	partial_packets = null
