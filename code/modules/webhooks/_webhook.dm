/decl/webhook
	var/id
	var/list/urls
	var/list/mentions

/decl/webhook/proc/get_message(var/list/data)
	. = list()

/decl/webhook/proc/http_post(var/target_url, var/payload)
	if (!target_url)
		return -1

	var/result = LIBCALL(HTTP_POST_DLL_LOCATION, "send_post_request")(target_url, payload, json_encode(list("Content-Type" = "application/json")))

	result = cached_json_decode(result)
	if (result["error_code"])
		log_debug("byhttp error: [result["error"]] ([result["error_code"]])")
		return result["error_code"]

	return list(
		"status_code" = result["status_code"],
		"body" = result["body"]
	)

/decl/webhook/proc/send(var/list/data)
	var/list/message = get_message(data)
	if(!length(message))
		return FALSE

	if(CONFIG_GET(flag/disable_webhook_embeds))
		var/list/embed_content
		for(var/list/embed in message["embeds"])
			if(embed["title"])
				LAZYADD(embed_content, "**[embed["title"]]**")
			if(embed["description"])
				LAZYADD(embed_content, embed["description"])
		if(length(embed_content))
			if(message["content"])
				message["content"] = "[message["content"]]\n[jointext(embed_content, "\n")]"
			else
				message["content"] = jointext(embed_content, "\n")
		message -= "embeds"

	. = TRUE
	for(var/target_url in urls)

		var/url_message = message.Copy()
		var/list/url_mentions = get_mentions(target_url)
		if(islist(url_mentions) && length(url_mentions))
			if(url_message["content"])
				url_message["content"] = "[jointext(url_mentions, ", ")]: [url_message["content"]]"
			else
				url_message["content"] = "[jointext(url_mentions, ", ")]"

		var/list/httpresponse = http_post(target_url, json_encode(url_message))
		if(!islist(httpresponse))
			. = FALSE
			continue
		switch(httpresponse["status_code"])
			if (200 to 299)
				continue
			if (400 to 599)
				log_debug("Webhooks: HTTP error code while sending to '[target_url]': [httpresponse["status_code"]]. Data: [httpresponse["body"]].")
			else
				log_debug("Webhooks: unknown HTTP code while sending to '[target_url]': [httpresponse["status_code"]]. Data: [httpresponse["body"]].")
		. = FALSE

/decl/webhook/proc/get_mentions(var/mentioning_url)
	. = mentions?.Copy()
	var/url_mentions = LAZYACCESS(urls, mentioning_url)
	if(length(url_mentions))
		LAZYDISTINCTADD(., url_mentions)
