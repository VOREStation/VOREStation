import { CheckboxInput, FeatureToggle } from '../base';

// Vorey sounds
export const BELCH_NOISES: FeatureToggle = {
  name: 'Belch Noises',
  category: 'ADULT CONTENT',
  description: 'Enable hearing burping noises.',
  component: CheckboxInput,
};

export const EATING_NOISES: FeatureToggle = {
  name: 'Eating Noises',
  category: 'ADULT CONTENT',
  description: 'Enable hearing vore eating noises.',
  component: CheckboxInput,
};

export const DIGEST_NOISES: FeatureToggle = {
  name: 'Digestion Noises',
  category: 'ADULT CONTENT',
  description: 'Enable hearing vore digestion noises.',
  component: CheckboxInput,
};

export const VORE_HEALTH_BARS: FeatureToggle = {
  name: 'Vore Health Bars',
  category: 'ADULT CONTENT',
  description:
    'Periodically shows status health bars in chat occasionally during vore absorption/digestion.',
  component: CheckboxInput,
};

export const VISIBLE_TUMMIES: FeatureToggle = {
  name: 'Visible Stomach Sprites',
  category: 'ADULT CONTENT',
  description: 'Enable Seeing the various stomach sprites.',
  component: CheckboxInput,
};
