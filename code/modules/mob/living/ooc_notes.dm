/mob/living/proc/ooc_notes_window(mob/user)
	if(!ooc_notes)
		return
	//I tried to get it to accept things like emojis and all that, but, it wouldn't do! It would be cool if it did.
	var/notes = replacetext(html_decode(src.ooc_notes), "\n", "<BR>")
	var/likes = replacetext(html_decode(src.ooc_notes_likes), "\n", "<BR>")
	var/dislikes = replacetext(html_decode(src.ooc_notes_dislikes), "\n", "<BR>")
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
				<a href='byond://?src=\ref[src];save_ooc_panel=1' class='button'>Save Character Preferences</a>
			</td>
			"}
	dat += {"
			<td class="button">
				<a href='byond://?src=\ref[src];print_ooc_notes_to_chat=1' class='button'>Print to chat</a>
			</td>
			</table>
			"}

	if(user == src)
		dat += {"
				<br>
				<table>
					<td class="button">
						<a href='byond://?src=\ref[src];edit_ooc_notes=1' class='button'>Edit</a>
					</td>
				</table>
				"}

	dat += {"
		<br>
		<p>[notes]</p>
		<head>
		<meta name="viewport" content="width=device-width, initial-scale=1">"}

	if(likes || user == src)
		dat += {"<div class="collapsible"><b><center>Likes</center></b></div>"}
	if(user == src)
		dat += {"
				<table>
					<td class="button">
						<a href='byond://?src=\ref[src];edit_ooc_note_likes=1' class='button'>Edit</a>
					</td>
				</table>
				"}

	if(likes)
		dat += {"
			<div class="content">
			  <p>[likes]</p>
			</div>"}
	if(dislikes || user == src)
		dat += {"
		<br>
		<div class="collapsible_b"><b><center>Dislikes</center></b></div>"}
	if(user == src)
		dat += {"
				<table>
					<td class="button">
						<a href='byond://?src=\ref[src];edit_ooc_note_dislikes=1' class='button'>Edit</a>
					</td>
				</table>
				"}

	if(dislikes)
		dat += {"
			<div class="content">
			  <p>[dislikes]</p>
			</div>
				</body>
			</html>
			"}

//	user << browse("<html><head><title>OOC Notes: [src]</title></head>[dat]</html>", "window=[src.name]ooc_notes;size=500x600;can_resize=1;can_minimize=1")

//	onclose(usr, "[src.name]")

	winshow(user, "ooc_notes", TRUE)
	var/datum/browser/popup = new(user, "ooc_notes_panel", "OOC Notes: [src.name]", 500, 600)
	popup.set_content(dat)
	popup.open(FALSE) // Skip registring onclose on the browser pane
	onclose(user, "ooc_notes", src) // We want to register on the window itself
