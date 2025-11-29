/**
 * Asynchronously sends a message to TGS admin chat channels.
 *
 * category - The category of the mssage.
 * message - The message to send.
 */
/proc/send2adminchat(category, message, embed_links = FALSE)
	set waitfor = FALSE

	category = strip_improper(category)
	message = strip_improper(message)
	if(!embed_links)
		message = GLOB.has_discord_embeddable_links.Replace(replacetext(message, "`", ""), " ```$1``` ")
	world.TgsTargetedChatBroadcast(new /datum/tgs_message_content("[category] | [message]"), TRUE)
