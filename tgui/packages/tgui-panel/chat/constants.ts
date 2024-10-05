/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

// export const MAX_VISIBLE_MESSAGES = 2500; No longer a constant
// export const MAX_PERSISTED_MESSAGES = 1000; No longer a constant
// export const MESSAGE_SAVE_INTERVAL = 10000; No longer a constant
export const MESSAGE_PRUNE_INTERVAL = 60000;
// export const COMBINE_MAX_MESSAGES = 5; No longer a constant
// export const COMBINE_MAX_TIME_WINDOW = 5000; No longer a constant
export const IMAGE_RETRY_DELAY = 250;
export const IMAGE_RETRY_LIMIT = 10;
export const IMAGE_RETRY_MESSAGE_AGE = 60000;

// Default message type
export const MESSAGE_TYPE_UNKNOWN = 'unknown';

// Internal message type
export const MESSAGE_TYPE_INTERNAL = 'internal';

// Must match the set of defines in code/__DEFINES/chat.dm
export const MESSAGE_TYPE_SYSTEM = 'system';
export const MESSAGE_TYPE_LOCALCHAT = 'localchat';
export const MESSAGE_TYPE_NPCEMOTE = 'npcemote';
export const MESSAGE_TYPE_MULTIZCHAT = 'multizsay';
export const MESSAGE_TYPE_PLOCALCHAT = 'plocalchat';
export const MESSAGE_TYPE_VORE = 'vore';
export const MESSAGE_TYPE_HIVEMIND = 'hivemind';
export const MESSAGE_TYPE_RADIO = 'radio';
export const MESSAGE_TYPE_NIF = 'nif';
export const MESSAGE_TYPE_INFO = 'info';
export const MESSAGE_TYPE_WARNING = 'warning';
export const MESSAGE_TYPE_DEADCHAT = 'deadchat';
export const MESSAGE_TYPE_OOC = 'ooc';
export const MESSAGE_TYPE_LOOC = 'looc';
export const MESSAGE_TYPE_ADMINPM = 'adminpm';
export const MESSAGE_TYPE_MENTORPM = 'mentorpm';
export const MESSAGE_TYPE_COMBAT = 'combat';
export const MESSAGE_TYPE_CHATPRINT = 'chatprint';
export const MESSAGE_TYPE_ADMINCHAT = 'adminchat';
export const MESSAGE_TYPE_MODCHAT = 'modchat';
export const MESSAGE_TYPE_RLOOC = 'rlooc';
export const MESSAGE_TYPE_PRAYER = 'prayer';
export const MESSAGE_TYPE_EVENTCHAT = 'eventchat';
export const MESSAGE_TYPE_ADMINLOG = 'adminlog';
export const MESSAGE_TYPE_ATTACKLOG = 'attacklog';
export const MESSAGE_TYPE_DEBUG = 'debug';

// Metadata for each message type
export const MESSAGE_TYPES = [
  // Always-on types
  {
    type: MESSAGE_TYPE_SYSTEM,
    name: 'System Messages',
    description: 'Messages from your client, always enabled',
    selector: '.boldannounce',
    important: true,
  },
  // Basic types
  {
    type: MESSAGE_TYPE_NPCEMOTE, // Needs to be first
    name: 'NPC Emotes / Says',
    description: 'In-character emotes and says from NPCs',
    selector: '.npcemote, .npcsay',
  },
  {
    type: MESSAGE_TYPE_MULTIZCHAT,
    name: 'MultiZ Emotes / Says',
    description: 'In-character emotes and says from levels above/below',
    selector: '.multizsay',
  },
  {
    type: MESSAGE_TYPE_LOCALCHAT,
    name: 'Local',
    description: 'In-character local messages (say, emote, etc)',
    selector: '.say, .emote, .emotesubtle',
  },
  {
    type: MESSAGE_TYPE_PLOCALCHAT,
    name: 'Local (Pred/Prey)',
    description: 'Messages from / to absorbed or dominated prey',
    selector: '.psay, .pemote',
  },
  {
    type: MESSAGE_TYPE_VORE,
    name: 'Vorgan Messages',
    description: 'Messages regarding vore interactions',
    selector: '.valert, .vwarning, .vnotice, .vdanger',
  },
  {
    type: MESSAGE_TYPE_HIVEMIND,
    name: 'Global Say',
    description: 'All global languages (Hivemind / Binary)',
    selector: '.hivemind, .binarysay',
  },
  {
    type: MESSAGE_TYPE_RADIO,
    name: 'Radio',
    description: 'All departments of radio messages',
    selector:
      '.alert, .minorannounce, .syndradio, .centradio, .airadio, .comradio, .secradio, .gangradio, .engradio, .medradio, .sciradio, .supradio, .srvradio, .expradio, .radio, .deptradio, .newscaster, .resonate, .abductor, .alien, .changeling',
  },
  {
    type: MESSAGE_TYPE_NIF,
    name: 'NIF',
    description: 'Messages from the NIF itself and people inside',
    selector: '.nif',
  },
  {
    type: MESSAGE_TYPE_INFO,
    name: 'Info',
    description: 'Non-urgent messages from the game and items',
    selector:
      '.notice:not(.pm):not(.mentor), .adminnotice:not(.pm), .info, .sinister, .cult, .alium, .infoplain, .announce, .hear, .smallnotice, .holoparasite, .boldnotice, .suicide, .unconscious',
  },
  {
    type: MESSAGE_TYPE_WARNING,
    name: 'Warnings',
    description: 'Urgent messages from the game and items',
    selector:
      '.warning:not(.pm):not(.mentor), .boldwarning:not(.pm):not(.mentor), .critical, .userdanger, .alertsyndie, .warningplain, .sinister',
  },
  {
    type: MESSAGE_TYPE_DEADCHAT,
    name: 'Deadchat',
    description: 'All of deadchat',
    selector: '.deadsay, .ghostalert',
  },
  {
    type: MESSAGE_TYPE_OOC,
    name: 'OOC',
    description: 'The bluewall of global OOC messages',
    selector: '.ooc, .adminooc, .adminobserverooc, .oocplain, .aooc',
  },
  {
    type: MESSAGE_TYPE_LOOC,
    name: 'Local OOC',
    description: 'Local OOC messages, always enabled',
    selector: '.looc',
    important: true,
  },
  {
    type: MESSAGE_TYPE_ADMINPM,
    name: 'Admin PMs',
    description: 'Messages to/from admins (adminhelp)',
    selector: '.pm, .adminhelp',
  },
  {
    type: MESSAGE_TYPE_MENTORPM,
    name: 'Mentor PMs',
    description: 'Mentorchat and mentor pms',
    selector: '.mentor_channel, .mentor',
  },
  {
    type: MESSAGE_TYPE_COMBAT,
    name: 'Combat Log',
    description: 'Urist McTraitor has stabbed you with a knife!',
    selector: '.danger, .attack, .disarm, .passive, .bolddanger',
  },
  {
    type: MESSAGE_TYPE_CHATPRINT,
    name: 'Chat prints',
    description: 'Chat outputs of ooc notes or vorebelly exports',
    selector: '.chatexport',
  },
  {
    type: MESSAGE_TYPE_UNKNOWN,
    name: 'Unsorted',
    description: 'Everything we could not sort, always enabled',
  },
  // Admin stuff
  {
    type: MESSAGE_TYPE_ADMINCHAT,
    name: 'Admin Chat',
    description: 'ASAY messages',
    selector: '.admin_channel, .adminsay',
    admin: true,
  },
  {
    type: MESSAGE_TYPE_MODCHAT,
    name: 'Mod Chat',
    description: 'MSAY messages',
    selector: '.mod_channel',
    admin: true,
  },
  {
    type: MESSAGE_TYPE_EVENTCHAT,
    name: 'Event Chat',
    description: 'ESAY messages',
    selector: '.event_channel',
    admin: true,
  },
  {
    type: MESSAGE_TYPE_RLOOC,
    name: 'Remote LOOC',
    description: 'Remote LOOC messages',
    selector: '.rlooc',
    admin: true,
  },
  {
    type: MESSAGE_TYPE_PRAYER,
    name: 'Prayers',
    description: 'Prayers from players',
    admin: true,
  },
  {
    type: MESSAGE_TYPE_ADMINLOG,
    name: 'Admin Log',
    description: 'ADMIN LOG: Urist McAdmin has jumped to coordinates X, Y, Z',
    selector: '.log_message, .filter_adminlog',
    admin: true,
  },
  {
    type: MESSAGE_TYPE_ATTACKLOG,
    name: 'Attack Log',
    description: 'Urist McTraitor has shot John Doe',
    admin: true,
  },
  {
    type: MESSAGE_TYPE_DEBUG,
    name: 'Debug Log',
    description: 'DEBUG: SSPlanets subsystem Recover().',
    selector:
      '.filter_debuglogs, .debug_error, .debug_warning, .debug_info, .debug_debug, .debug_trace',
    admin: true,
  },
];
