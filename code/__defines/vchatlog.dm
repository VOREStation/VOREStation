/* This comment bypasses grep checks */ /var/__vchatlog

/proc/__detect_vchatlog()
	if (world.system_type == UNIX)
		return __vchatlog = (fexists("./libvchatlog.so") ? "./libvchatlog.so" : "libvchatlog")
	else
		return __vchatlog = "vchatlog"

#define VCHATLOG (__vchatlog || __detect_vchatlog())
#define VCHATLOG_CALL(name, args...) call_ext(VCHATLOG, "byond:" + name)(args)

/**
 * Generates and returns a random access token, for external API communication.
 * The token is only valid for the current round.
 *
 * Arguments:
 * * ckey - Ckey of the message receiver
 * * token - Randomized token
 */
#define vchatlog_generate_token(ckey) VCHATLOG_CALL("generate_token", ckey)

/**
 * Writes a new chatlog entry to the database. This function does not return anything.
 *
 * Arguments:
 * * ckey - Ckey of the message receiver
 * * html - HTML of the received message
 * * round_id - Current ID of the round (library will resolve this to -1 if invalid or non-existant)
 */
#define vchatlog_write(ckey, html, round_id, type) VCHATLOG_CALL("write_chatlog", ckey, html, round_id, type)

/**
 * This function returns a list of the 10 most recent roundids that are available to be exported.
 * Note: -1 might appear. This id is used for internal library failures. Use with caution.
 *
 * Arguments:
 * * ckey - Ckey of the message receiver
 */
#define vchatlog_get_recent_roundids(ckey) VCHATLOG_CALL("get_recent_roundids", ckey)
