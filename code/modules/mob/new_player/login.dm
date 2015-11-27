///var/atom/movable/lobby_image = new /atom/movable{icon = 'icons/misc/title.dmi'; icon_state = lobby_image_state; screen_loc = "1,1"; name = "Polaris"}

var/obj/effect/lobby_image = new /obj/effect/lobby_image

/obj/effect/lobby_image
	name = "Polaris"
	desc = "How are you reading this?"
	icon = 'icons/misc/title.dmi'
	icon_state = null //determined randomly later on.
	screen_loc = "1,1"
	var/list/lobby_images = list("mockingjay00")

/obj/effect/lobby_image/New()
	icon_state = pick(lobby_images)

/mob/new_player
	var/client/my_client // Need to keep track of this ourselves, since by the time Logout() is called the client has already been nulled

/mob/new_player/Login()
	update_Login_details()	//handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for multikeying
	if(join_motd)
		src << "<div class=\"motd\">[join_motd]</div>"

	if(!mind)
		mind = new /datum/mind(key)
		mind.active = 1
		mind.current = src

	loc = null
	client.screen += lobby_image
	my_client = client
	sight |= SEE_TURFS
	player_list |= src

	new_player_panel()
	spawn(40)
		if(client)
			handle_privacy_poll()
			client.playtitlemusic()
