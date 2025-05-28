import {
  CheckboxInput,
  type Feature,
  FeatureColorInput,
  type FeatureToggle,
} from '../base';

export const CHAT_ATTACKLOGS: FeatureToggle = {
  name: 'Attack Log Messages',
  category: 'ADMIN',
  description: 'Show attack logs.',
  component: CheckboxInput,
};

export const CHAT_DEBUGLOGS: FeatureToggle = {
  name: 'Debug Logs',
  category: 'ADMIN',
  description: 'Show debug logs.',
  component: CheckboxInput,
};

export const CHAT_PRAYER: FeatureToggle = {
  name: 'Chat Prayers',
  category: 'ADMIN',
  description: 'Show prayers.',
  component: CheckboxInput,
};

export const SOUND_ADMINHELP: FeatureToggle = {
  name: 'Adminhelp Sound',
  category: 'ADMIN',
  description: 'Enables playing the bwoink when a new adminhelp is sent.',
  component: CheckboxInput,
};

export const CHAT_RADIO: FeatureToggle = {
  name: 'Radio Chatter',
  category: 'ADMIN',
  description: 'Completely enable/disable hearing any radio anywhere.',
  component: CheckboxInput,
};

export const CHAT_RLOOC: FeatureToggle = {
  name: 'Remote LOOC Chat',
  category: 'ADMIN',
  description: 'Hear LOOC from anywhere.',
  component: CheckboxInput,
};

export const CHAT_ADSAY: FeatureToggle = {
  name: 'Living Deadchat',
  category: 'ADMIN',
  description: 'Enables seeing deadchat when not observing.',
  component: CheckboxInput,
};

export const ooccolor: Feature<string> = {
  name: 'OOC Color',
  category: 'ADMIN',
  description:
    'The color your OOC messages will be. Set to #010000 to use default',
  component: FeatureColorInput,
};
