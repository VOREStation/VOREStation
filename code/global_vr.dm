var/list/vinestart			= list()
var/list/verminstart		= list()

var/list/awayabductors = list() // List of scatter landmarks for Abductors in Gateways
var/list/eventdestinations = list() // List of scatter landmarks for VOREStation event portals
var/list/eventabductors = list() // List of scatter landmarks for VOREStation abductor portals

var/global/list/acceptable_fruit_types= list(
											PLANT_AMBROSIA,
											PLANT_APPLE,
											PLANT_BANANA,
											PLANT_BERRIES,
											PLANT_CABBAGE,
											PLANT_CARROT,
											PLANT_CELERY,
											PLANT_CHERRY,
											PLANT_CHILI,
											PLANT_COCOA,
											PLANT_CORN,
											PLANT_DURIAN,
											PLANT_EGGPLANT,
											PLANT_GRAPES,
											PLANT_GREENGRAPES,
											PLANT_HAREBELLS,
											PLANT_LAVENDER,
											PLANT_LEMON,
											PLANT_LETTUCE,
											PLANT_LIME,
											PLANT_ONION,
											PLANT_ORANGE,
											PLANT_PEANUT,
											PLANT_POPPIES,
											PLANT_POTATO,
											PLANT_PUMPKIN,
											PLANT_RICE,
											PLANT_ROSE,
											PLANT_ROSE,
											PLANT_SOYBEAN,
											PLANT_SPINEAPPLE,
											PLANT_SUGARCANE,
											PLANT_SUNFLOWERS,
											PLANT_TOMATO,
											PLANT_VANILLA,
											PLANT_WATERMELON,
											PLANT_WHEAT,
											PLANT_WHITEBEET)

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
