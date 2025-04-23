import { CheckboxInput, type FeatureToggle } from '../base';

export const RUNECHAT_MOB: FeatureToggle = {
  name: 'Runechat: Mobs',
  category: 'RUNECHAT',
  description: 'Chat messages will show above heads.',
  component: CheckboxInput,
};

export const RUNECHAT_OBJ: FeatureToggle = {
  name: 'Runechat: Objects',
  category: 'RUNECHAT',
  description: 'Chat messages will show above objects when they speak.',
  component: CheckboxInput,
};

export const RUNECHAT_BORDER: FeatureToggle = {
  name: 'Runechat: Letter Borders',
  category: 'RUNECHAT',
  description: 'Enables a border around each letter in a runechat message.',
  component: CheckboxInput,
};

export const RUNECHAT_LONG: FeatureToggle = {
  name: 'Runechat: Long Messages',
  category: 'RUNECHAT',
  description: 'Sets runechat to show more characters.',
  component: CheckboxInput,
};
