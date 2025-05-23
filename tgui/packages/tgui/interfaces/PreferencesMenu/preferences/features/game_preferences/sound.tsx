import {
  CheckboxInput,
  FeatureNumberInput,
  FeatureNumeric,
  FeatureToggle,
} from '../base';

export const SOUND_MIDI: FeatureToggle = {
  name: 'Play Admin MIDIs',
  category: 'SOUNDS',
  description: 'Enable hearing admin played sounds.',
  component: CheckboxInput,
};

export const SOUND_LOBBY: FeatureToggle = {
  name: 'Play Lobby Music',
  category: 'SOUNDS',
  description: 'Enable hearing lobby music.',
  component: CheckboxInput,
};

export const SOUND_AMBIENCE: FeatureToggle = {
  name: 'Play Ambience',
  category: 'SOUNDS',
  description: 'Enable hearing ambient sounds and music.',
  component: CheckboxInput,
};

export const SOUND_JUKEBOX: FeatureToggle = {
  name: 'Play Jukebox Music',
  category: 'SOUNDS',
  description: 'Enable hearing music from the jukebox.',
  component: CheckboxInput,
};

export const SOUND_INSTRUMENT: FeatureToggle = {
  name: 'Hear In-game Instruments',
  category: 'SOUNDS',
  description: 'Enable hearing instruments playing.',
  component: CheckboxInput,
};

export const EMOTE_NOISES: FeatureToggle = {
  name: 'Emote Noises',
  category: 'SOUNDS',
  description: 'Enable hearing noises from emotes.',
  component: CheckboxInput,
};

export const RADIO_SOUNDS: FeatureToggle = {
  name: 'Radio Sounds',
  category: 'SOUNDS',
  description: 'Enable hearing a sound when somebody speaks over your headset.',
  component: CheckboxInput,
};

export const SAY_SOUNDS: FeatureToggle = {
  name: 'Say Sounds',
  category: 'SOUNDS',
  description: 'Enable hearing a sound when somebody speaks using say.',
  component: CheckboxInput,
};

export const EMOTE_SOUNDS: FeatureToggle = {
  name: 'Me Sounds',
  category: 'SOUNDS',
  description: 'Enable hearing a sound when somebody uses me.',
  component: CheckboxInput,
};

export const WHISPER_SOUNDS: FeatureToggle = {
  name: 'Whisper Sounds',
  category: 'SOUNDS',
  description: 'Enable hearing a sound when somebody speaks using whisper.',
  component: CheckboxInput,
};

export const SUBTLE_SOUNDS: FeatureToggle = {
  name: 'Subtle Sounds',
  category: 'SOUNDS',
  description: 'Enable hearing a sound when somebody uses subtle.',
  component: CheckboxInput,
};

export const SOUND_AIRPUMP: FeatureToggle = {
  name: 'Air Pump Ambient Noise',
  category: 'SOUNDS',
  description: 'Enable hearing air vent humming.',
  component: CheckboxInput,
};

export const SOUND_OLDDOORS: FeatureToggle = {
  name: 'Old Door Sounds',
  category: 'SOUNDS',
  description: 'Switch to old door sounds.',
  component: CheckboxInput,
};

export const SOUND_DEPARTMENTDOORS: FeatureToggle = {
  name: 'Department Door Sounds',
  category: 'SOUNDS',
  description: 'Enable hearing department-specific door sounds.',
  component: CheckboxInput,
};

export const SOUND_PICKED: FeatureToggle = {
  name: 'Picked-Up Item Sounds',
  category: 'SOUNDS',
  description: 'Enable hearing a sound when items are picked up.',
  component: CheckboxInput,
};

export const SOUND_DROPPED: FeatureToggle = {
  name: 'Dropped Item Sounds',
  category: 'SOUNDS',
  description: 'Enable hearing a sound when items are dropped.',
  component: CheckboxInput,
};

export const SOUND_WEATHER: FeatureToggle = {
  name: 'Weather Sounds',
  category: 'SOUNDS',
  description: 'Enable hearing weather sounds while on a planet.',
  component: CheckboxInput,
};

export const SOUND_SUPERMATTER: FeatureToggle = {
  name: 'Supermatter Hum',
  category: 'SOUNDS',
  description: 'Enable hearing supermatter hums.',
  component: CheckboxInput,
};

export const SOUND_MENTORHELP: FeatureToggle = {
  name: 'Mentorhelp Pings',
  category: 'SOUNDS',
  description: 'Enable hearing mentorhelp pings.',
  component: CheckboxInput,
};

export const ambience_freq: FeatureNumeric = {
  name: 'Ambience Frequency',
  category: 'SOUNDS',
  description:
    'How often you wish to hear ambience repeated! (1-60 MINUTES, 0 for disabled)',
  component: FeatureNumberInput,
};

export const ambience_chance: FeatureNumeric = {
  name: 'Ambience Chance',
  category: 'SOUNDS',
  description:
    "The chance you'd like to hear ambience played to you (On area change, or by random ambience). 35 means a 35% chance to play ambience. This is a range from 0-100. 0 disables ambience playing entirely. This is also affected by Ambience Frequency.",
  component: FeatureNumberInput,
};
