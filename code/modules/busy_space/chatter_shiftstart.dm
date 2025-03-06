/datum/atc_chatter/shift_start/squak()
	SSatc.msg("New shift beginning, resuming traffic control. This shift's Colony Frequencies are as follows: Emergency Responders: [SSatc.ertchannel]. Medical: [SSatc.medchannel]. Engineering: [SSatc.engchannel]. Security: [SSatc.secchannel]. System Defense: [SSatc.sdfchannel].")
	finish()
