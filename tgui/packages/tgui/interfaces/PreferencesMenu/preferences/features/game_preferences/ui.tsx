import {
  CheckboxInput,
  FeatureNumeric,
  FeatureSliderInput,
  FeatureToggle,
} from '../base';

export const BROWSER_STYLED: FeatureToggle = {
  name: 'Use Fake NanoUI Browser Style',
  category: 'UI',
  description: 'Enable a dark fake NanoUI browser style for older UIs.',
  component: CheckboxInput,
};

export const VCHAT_ENABLE: FeatureToggle = {
  name: 'Enable TGChat',
  category: 'UI',
  description: 'Enable the TGChat chat panel.',
  component: CheckboxInput,
};

export const TGUI_SAY: FeatureToggle = {
  name: 'Say: Use TGUI',
  category: 'UI',
  description: 'Use TGUI for Say input.',
  component: CheckboxInput,
};

export const TGUI_SAY_LIGHT_MODE: FeatureToggle = {
  name: 'Say: Light mode',
  category: 'UI',
  description: 'Sets TGUI Say to use a light mode.',
  component: CheckboxInput,
};

export const tgui_say_emotes: FeatureToggle = {
  name: 'Say: Use TGUI For Emotes',
  category: 'UI',
  description: 'Sets whether to use TGUI Say for emotes.',
  component: CheckboxInput,
};

export const tgui_say_height: FeatureNumeric = {
  name: 'Say: TGUI Height (Lines)',
  category: 'UI',
  description: 'Amount of lines to show in the tgui say input.',
  component: FeatureSliderInput,
};
