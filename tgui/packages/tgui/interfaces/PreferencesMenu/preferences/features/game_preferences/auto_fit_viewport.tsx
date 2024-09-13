import { CheckboxInput, FeatureToggle } from '../base';

export const auto_fit_viewport: FeatureToggle = {
  name: 'Auto fit viewport',
  category: 'UI',
  description:
    'Automatically adjust vertical split to make map perfectly scaled.',
  component: CheckboxInput,
};
