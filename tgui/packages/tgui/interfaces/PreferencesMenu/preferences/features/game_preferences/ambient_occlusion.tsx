import { CheckboxInput, FeatureToggle } from '../base';

export const AMBIENT_OCCLUSION_PREF: FeatureToggle = {
  name: 'Enable ambient occlusion',
  category: 'GAMEPLAY',
  description: 'Enable ambient occlusion, light shadows around characters.',
  component: CheckboxInput,
};
