import { CheckboxInput, FeatureToggle } from '../base';

export const MOB_TOOLTIPS: FeatureToggle = {
  name: 'Enable mob tooltips',
  category: 'GAMEPLAY',
  description: 'Enable tooltips when hovering over mobs.',
  component: CheckboxInput,
};

export const INV_TOOLTIPS: FeatureToggle = {
  name: 'Enable inventory tooltips',
  category: 'GAMEPLAY',
  description: 'Enable tooltips when hovering over inventory items.',
  component: CheckboxInput,
};
