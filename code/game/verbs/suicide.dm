/mob/living/var/suiciding = 0

/mob/living/verb/suicide()
	set hidden = 1

	to_chat(src, "<span class='warning'>No. Adminhelp if there is a legitimate reason, and please review our server rules.</span>")
	message_admins("[ckey] has tried to trigger the suicide verb, but it is disabled.")
