var/list/vinestart			= list()
var/list/verminstart		= list()

var/list/awayabductors = list() // List of scatter landmarks for Abductors in Gateways
var/list/eventdestinations = list() // List of scatter landmarks for VOREStation event portals
var/list/eventabductors = list() // List of scatter landmarks for VOREStation abductor portals

// Some "scary" sounds.
var/static/list/scawwySownds = list(
	'sound/voice/ScawwySownds/a scawey sownd.ogg',
	'sound/voice/ScawwySownds/is that you.ogg',
	'sound/voice/ScawwySownds/lookit this darkness wow.ogg',
	'sound/voice/ScawwySownds/maint preds.ogg',
	'sound/voice/ScawwySownds/spooky sounds.ogg',
	'sound/voice/ScawwySownds/sus.ogg',
	'sound/voice/ScawwySownds/this is scaewy.ogg',
	'sound/voice/ScawwySownds/what is that behind you.ogg',
	'sound/voice/ScawwySownds/what you doin over dere.ogg',
	'sound/voice/ScawwySownds/whats up with all the trash.ogg',
	'sound/voice/ScawwySownds/youre afraid of the dark arent you.ogg'
	)
