/mob/living/proc/private_notes_window(mob/user)
	if(!private_notes)
		private_notes = " "
		return
	var/notes = replacetext(html_decode(src.private_notes), "\n", "<BR>")
	var/dat = {"
	<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
	<html>
		<head>
			<style>
				.collapsible {
					background-color: #263d20;
					color: white;
					width: 100%;
					text-align: left;
					font-size: 20px;
				}
				.collapsible_b {
					background-color: #3f1a1a;
					color: white;
					width: 100%;
					text-align: left;
					font-size: 20px;
				}
				.content {
					padding: 5;
					width: 100%;
					background-color: #363636;
				}

				</style>
			</head>"}

	dat += {"<body><table>"}
	if(user == src)
		dat += {"
			<td class="button">
				<a href='byond://?src=\ref[src];save_private_notes=1' class='button'>Save Character Preferences</a>
			</td>
			"}

	if(user == src)
		dat += {"
				<br>
				<table>
					<td class="button">
						<a href='byond://?src=\ref[src];edit_private_notes=1' class='button'>Edit</a>
					</td>
				</table>
				"}

	dat += {"
		<br>
		<p>[notes]</p>
		<head>
		<meta name="viewport" content="width=device-width, initial-scale=1">"}

	var/key = "private_notes[src.real_name]"	//Generate a unique key so we can make unique clones of windows, that way we can have more than one
	if(src.ckey)
		key = "[key][src.ckey]"				//Add a ckey if they have one, in case their name is the same

	winclone(user, "private_notes", key)		//Allows us to have more than one OOC notes panel open

	winshow(user, key, TRUE)				//Register our window
	var/datum/browser/popup = new(user, key, "Private Notes: [src.name]", 500, 600)		//Create the window
	popup.set_content(dat)	//Populate window contents
	popup.open(FALSE) // Skip registring onclose on the browser pane
	onclose(user, key, src) // We want to register on the window itself
