/client/verb/export_chat()
	set category = "OOC"
	set name = "Export Chatlog"
	set desc = "Allows to trigger the chat export"

	to_chat(usr, "<span data-command=\"$do_export\"></span>")
