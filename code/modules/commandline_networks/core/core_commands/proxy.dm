/*
This one's a bit complicated, namely, it sends another command, using THIS node as a source. security nightmare? yes. is it intentional? also yes.
some of the high security prosthetics (ae, heart, brain) might not want people to shut them down easily, so this is kind of a noob check / to prevent the
natural footgun of someone accidently doing >@@ shutdown instead of >@@ reboot
*/

/datum/commandline_network_command/proxy
	name = "proxy"
