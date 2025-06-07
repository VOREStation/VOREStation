/* This comment bypasses grep checks */ /var/__vchatlog

/proc/__detect_vchatlog()
	if (world.system_type == UNIX)
		return __vchatlog = (fexists("./libvchatlog.so") ? "./libvchatlog.so" : "libvchatlog")
	else
		return __vchatlog = "vchatlog"

var/vchatlog_tokenfun
var/vchatlog_writefun
var/vchatlog_roundfun

#define VCHATLOG (__vchatlog || __detect_vchatlog())

/**
 * Generates and returns a random access token, for external API communication.
 * The token is only valid for the current round.
 *
 * Arguments:
 * * ckey - Ckey of the message receiver
 * * token - Randomized token
 */
/proc/vchatlog_generate_token(ckey)
	vchatlog_tokenfun ||= load_ext(VCHATLOG, "byond:generate_token")

	var/token = call_ext(vchatlog_tokenfun)(ckey)
	return token

/**
 * Writes a new chatlog entry to the database. This function does not return anything.
 *
 * Arguments:
 * * ckey - Ckey of the message receiver
 * * html - HTML of the received message
 * * round_id - Current ID of the round (library will resolve this to -1 if invalid or non-existant)
 */
#define vchatlog_write(ckey, html, round_id, type) \
	vchatlog_writefun ||= load_ext(VCHATLOG, "byond:write_chatlog");\
	call_ext(vchatlog_writefun)(ckey, html, round_id, type)

/**
 * This function returns a list of the 10 most recent roundids that are available to be exported.
 * Note: -1 might appear. This id is used for internal library failures. Use with caution.
 *
 * Arguments:
 * * ckey - Ckey of the message receiver
 */
/proc/vchatlog_get_recent_roundids(ckey)
	vchatlog_roundfun ||= load_ext(VCHATLOG, "byond:get_recent_roundids")

	var/rounds = call_ext(vchatlog_roundfun)(ckey)
	return rounds
