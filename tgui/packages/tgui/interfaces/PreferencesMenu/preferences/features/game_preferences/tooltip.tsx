import {
  CheckboxInput,
  type FeatureChoiced,
  type FeatureToggle,
} from '../base';
import { FeatureDropdownInput } from '../dropdowns';

export const MOB_TOOLTIPS: FeatureToggle = {
  name: 'Enable mob tooltips',
  category: 'TOOLTIPS',
  description: 'Enable tooltips when hovering over mobs.',
  component: CheckboxInput,
};

export const INV_TOOLTIPS: FeatureToggle = {
  name: 'Enable inventory tooltips',
  category: 'TOOLTIPS',
  description: 'Enable tooltips when hovering over inventory items.',
  component: CheckboxInput,
};

export const tooltipstyle: FeatureChoiced = {
  name: 'Tooltip Style',
  category: 'TOOLTIPS',
  component: FeatureDropdownInput,
};
