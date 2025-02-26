/datum/asset/changelog_item
	_abstract = /datum/asset/changelog_item
	var/item_filename

/datum/asset/changelog_item/New(date)
	item_filename = sanitize_filename("[date].yml")
	register_asset(item_filename, file("html/changelogs/archive/" + item_filename))

/datum/asset/changelog_item/send(client)
	if (!item_filename)
		return
	. = send_asset(client, item_filename)

/datum/asset/changelog_item/get_url_mappings()
	if (!item_filename)
		return
	. = list("[item_filename]" = get_asset_url(item_filename))
