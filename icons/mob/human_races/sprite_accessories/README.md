Looking to add a new tail? Issue with one?

Due to limitations with Byond, we have to essentially copypasta all tail sections to avoid ghosts or layering issues. The current overlay system expects all four directions to be present and on the same layer. If you try to force a north only, but your sprite still contains all four directionals, then they'll be all four directions. And so, only the exposed tail markings will be shown.

Yes it's very silly but it was tried so many times to only get the north face of the main sprite to lay atop of things... 

Tailsocks layer on top of tails. Suits without a tailsock will apply their markings and still layer over clothing. HIDETAIL clothing tag is removed as a result of these changes, the verb to hide your tail works anyway if that's your choice!

Snowflake colored tails (usually do_coloration = FALSE ones) need to have a whitescaled version of themselves added appended with _sock, as well as tailsock_iconstate = "[icon_state]_sock" in order to properly get a unique, tailsock colorized overlay. Tailmaws are another example, they've been given little space suit bubble helmets!
