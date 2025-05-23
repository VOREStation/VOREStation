import { CheckboxInput, FeatureToggle } from '../base';

export const WHISUBTLE_VIS: FeatureToggle = {
  name: 'Allow ghosts to see whispers/subtles',
  category: 'GHOST',
  description: 'Enables ghosts to see your whispers and subtle emotes.',
  component: CheckboxInput,
};

export const GHOST_SEE_WHISUBTLE: FeatureToggle = {
  name: 'See whispers/subtles as ghost',
  category: 'GHOST',
  description: 'As a ghost, see whispers and subtles.',
  component: CheckboxInput,
};

export const CHAT_GHOSTEARS: FeatureToggle = {
  name: 'Ghost Ears',
  category: 'GHOST',
  description: 'When enabled, hear all speech; otherwise, only hear nearby.',
  component: CheckboxInput,
};

export const CHAT_GHOSTSIGHT: FeatureToggle = {
  name: 'Ghost Sight',
  category: 'GHOST',
  description: 'When enabled, hear all emotes; otherwise, only hear nearby.',
  component: CheckboxInput,
};

export const CHAT_GHOSTRADIO: FeatureToggle = {
  name: 'Ghost Radio',
  category: 'GHOST',
  description: 'When enabled, hear all radio; otherwise, only hear nearby.',
  component: CheckboxInput,
};
