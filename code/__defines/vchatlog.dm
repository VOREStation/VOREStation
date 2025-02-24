/* This comment bypasses grep checks */ /var/__vchatlog

/proc/__detect_vchatlog()
	if (world.system_type == UNIX)
		return __vchatlog = (fexists("./libvchatlog.so") ? "./libvchatlog.so" : "libvchatlog")
	else
		return __vchatlog = "vchatlog"

#define VCHATLOG (__vchatlog || __detect_vchatlog())
#define VCHATLOG_CALL(name, args...) call_ext(VCHATLOG, "byond:" + name)(args)

/**
 * Writes a new chatlog entry to the database. This function does not return anything.
 *
 * Arguments:
 * * ckey - Ckey of the message receiver
 * * html - HTML of the received message
 * * round_id - Current ID of the round (library will resolve this to -1 if invalid or non-existant)
 */
#define vchatlog_write(ckey, html, round_id) VCHATLOG_CALL("write_chatlog", ckey, html, round_id)

/**
 * Requests the chatlog of an entire round. Upon completion the exported chatlog will be stored at tmp/chatlogs/ckey-roundid(.html).
 * The file will have the html ending, if rendered is set to TRUE.
 *
 * Arguments:
 * * ckey - Ckey of the message receiver
 * * round_id - Round ID of the chatlogs to fetch
 * * rendered - Tells the library if it should contain the rendered chatlog (css styling, etc.)
 */
#define vchatlog_read_round(ckey, round_id, rendered) VCHATLOG_CALL("read_chatlog_round", ckey, round_id, rendered)

/**
 * Requests the chatlog of multiple rounds. Upon completion the exported chatlog will be stored at tmp/chatlogs/ckey-roundid(.html).
 * The file will have the html ending, if rendered is set to TRUE.
 *
 * Arguments:
 * * ckey - Ckey of the message receiver
 * * start_round - Round ID of the start to fetch
 * * end_round - Round ID of the end to fetch
 * * rendered - Tells the library if it should contain the rendered chatlog (css styling, etc.)
 */
#define vchatlog_read_rounds(ckey, start_round, end_round, rendered) VCHATLOG_CALL("read_chatlog_rounds", ckey, start_round, end_round, rendered)

/**
 * Requests the chatlog of a specified length. Upon completion the exported chatlog will be stored at tmp/chatlogs/ckey(.html).
 * The file will have the html ending, if rendered is set to TRUE.
 *
 * Arguments:
 * * ckey - Ckey of the message receiver
 * * length - Amount of recent messages to fetch
 * * rendered - Tells the library if it should contain the rendered chatlog (css styling, etc.)
 */
#define vchatlog_read(ckey, length, rendered) VCHATLOG_CALL("read_chatlog", ckey, length, rendered)

/**
 * This function returns a list of the 10 most recent roundids that are available to be exported.
 * Note: -1 might appear. This id is used for internal library failures. Use with caution.
 *
 * Arguments:
 * * ckey - Ckey of the message receiver
 */
#define vchatlog_get_recent_roundids(ckey) VCHATLOG_CALL("get_recent_roundids", ckey)
