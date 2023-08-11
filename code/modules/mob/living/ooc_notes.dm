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
				body {
					margin-top:5px;
					font-family:Verdana;
					color:white;
					font-size:13px;
					background-image:url('ooc_notes.png');
					background-repeat:repeat-x;
					background-color:#272727;
					background-position:center top;
				}
				table {
					font-size:13px;
					margin-left:-2px;
				}
				h2 {
					font-size:15px;
				}
				.collapsible {
					background-color: #263d20;
					color: white;
					padding: 5px;
					width: 100%;
					border: none;
					text-align: left;
					outline: none;
					font-size: 20px;
				}
				.collapsible_b {
					background-color: #3f1a1a;
					color: white;
					padding: 5px;
					width: 100%;
					border: none;
					text-align: left;
					outline: none;
					font-size: 20px;
				}

				.content {
					padding: 5;
					width: 100%;
					background-color: #363636;
				}

				.button {
					background-color: #40628a;
					text-align: center;
				}
				td.button {
					border: 1px solid #161616;
					background-color: #40628a;
					text-align: center;
				}
				a.button {
					color:white;
					text-decoration: none;
				}

				</style>
			</head>"}

	dat += {"<body>
			<b><font size='3px'>[src.name]'s OOC notes</font><br>"}
	if(user == src)
		dat += {"
				<table>
					<td class="button">
						<a href='byond://?src=\ref[src];save_ooc_panel=1' class='button'>Save Character Preferences</a>
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
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<body>

		<div class="collapsible"><b>Likes</b></div>"}
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
	dat += {"
	<br>
	<div class="collapsible_b"><b>Dislikes</b></div>"}
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

	user << browse("<html><head><title>OOC Notes: [src]</title></head>[dat]</html>", "window=[src.name]mvp;size=500x600;can_resize=1;can_minimize=1")

	onclose(usr, "[src.name]")
