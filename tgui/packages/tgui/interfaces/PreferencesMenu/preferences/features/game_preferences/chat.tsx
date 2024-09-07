import { CheckboxInput, FeatureToggle } from '../base';

export const CHAT_SHOWICONS: FeatureToggle = {
  name: 'Chat Tags',
  category: 'CHAT',
  description: 'Show tags/badges on special channels like OOC.',
  component: CheckboxInput,
};

export const SHOW_TYPING: FeatureToggle = {
  name: 'Typing Indicator',
  category: 'CHAT',
  description: 'Show a typing indicator when you are typing ingame.',
  component: CheckboxInput,
};

export const SHOW_TYPING_SUBTLE: FeatureToggle = {
  name: 'Typing Indicator: Subtle',
  category: 'CHAT',
  description: 'Show typing indicator for subtle and whisper messages.',
  component: CheckboxInput,
};

export const CHAT_OOC: FeatureToggle = {
  name: 'OOC Chat',
  category: 'CHAT',
  description: 'Enables OOC chat.',
  component: CheckboxInput,
};

export const CHAT_LOOC: FeatureToggle = {
  name: 'LOOC Chat',
  category: 'CHAT',
  description: 'Enables L(ocal)OOC chat.',
  component: CheckboxInput,
};

export const CHAT_DEAD: FeatureToggle = {
  name: 'Dead Chat',
  category: 'CHAT',
  description: 'Enables observer/dead/ghost chat.',
  component: CheckboxInput,
};

export const CHAT_MENTION: FeatureToggle = {
  name: 'Emphasize Name Mention',
  category: 'CHAT',
  description:
    'Makes messages containing your name or nickname appear larger to get your attention.',
  component: CheckboxInput,
};

export const VORE_HEALTH_BARS: FeatureToggle = {
  name: 'Vore Health Bars',
  category: 'CHAT',
  description:
    'Periodically shows status health bars in chat occasionally during vore absorption/digestion.',
  component: CheckboxInput,
};

export const NEWS_POPUP: FeatureToggle = {
  name: 'Lore News Popups',
  category: 'CHAT',
  description: 'Show new lore news on login.',
  component: CheckboxInput,
};

export const RECEIVE_TIPS: FeatureToggle = {
  name: 'Receive Tips Periodically',
  category: 'CHAT',
  description: 'Show helpful tips for new players periodically.',
  component: CheckboxInput,
};

export const PAIN_FREQUENCY: FeatureToggle = {
  name: 'Pain Message Cooldown',
  category: 'CHAT',
  description:
    'When enabled, reduces the amount of pain messages for minor wounds that you see.',
  component: CheckboxInput,
};
