import {
  CheckboxInput,
  type FeatureChoiced,
  type FeatureToggle,
} from '../base';
import { FeatureDropdownInput } from '../dropdowns';

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

export const EXAMINE_MODE: FeatureChoiced = {
  name: 'Examine Mode',
  category: 'CHAT',
  description:
    'Choose how you want to examine items. "Verbose" will include all information found in the examine panel as foldable groups, "Switch To Panel" will switch you to the examine panel upon examining, and "Slim" will do neither. ',
  component: FeatureDropdownInput,
};

export const MULTI_LANGUAGE_YAP_MODE: FeatureChoiced = {
  name: 'Multilingual Speech Parsing Mode',
  category: 'CHAT',
  description: `
    Default: Multilingual parsing will only check for the delimiter-key combination (e.g., ,0galcom-2tradeband).\n
    Space: Multilingual parsing will enforce a space after the delimiter-key combination (,0 galcom -2still galcom). The extra space will be consumed by the pattern-matching.\n
    Double Delimiter: Multilingual parsing will enforce the language delimiter after the delimiter-key combination (,0,galcom -2 still galcom). The extra delimiter will be consumed by the pattern-matching.\n
    Off: Multilingual parsing is now disabled. Entire messages will be in the language specified at the start of the message.
  `,
  component: FeatureDropdownInput,
};
