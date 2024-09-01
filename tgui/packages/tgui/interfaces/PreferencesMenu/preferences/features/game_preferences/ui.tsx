import { CheckboxInput, FeatureToggle } from '../base';

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
