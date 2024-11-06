import { CheckboxInput, FeatureToggle } from '../base';

export const AMBIENT_OCCLUSION_PREF: FeatureToggle = {
  name: 'Enable ambient occlusion',
  category: 'GAMEPLAY',
  description: 'Enable ambient occlusion, light shadows around characters.',
  component: CheckboxInput,
};

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

export const ATTACK_ICONS: FeatureToggle = {
  name: 'Attack Icons',
  category: 'GAMEPLAY',
  description:
    'Enable showing an overlay of what a mob was hit with during the attack animation.',
  component: CheckboxInput,
};

export const PRECISE_PLACEMENT: FeatureToggle = {
  name: 'Precision Placement',
  category: 'GAMEPLAY',
  description:
    'Objects placed on table will be on cursor position when enabled, or centered when disabled.',
  component: CheckboxInput,
};

export const HUD_HOTKEYS: FeatureToggle = {
  name: 'Hotkeys Default',
  category: 'GAMEPLAY',
  description: 'Enables turning hotkey mode on by default.',
  component: CheckboxInput,
};

export const SHOW_PROGRESS: FeatureToggle = {
  name: 'Progress Bar',
  category: 'GAMEPLAY',
  description: 'Enables seeing progress bars for various actions.',
  component: CheckboxInput,
};

export const SAFE_FIRING: FeatureToggle = {
  name: 'Gun Firing Intent Requirement',
  category: 'GAMEPLAY',
  description: 'When enabled, firing a gun requires a non-help intent to fire.',
  component: CheckboxInput,
};

export const SHOW_STATUS: FeatureToggle = {
  name: 'Status Indicators',
  category: 'GAMEPLAY',
  description: "Enables seeing status indicators over people's heads.",
  component: CheckboxInput,
};

export const AUTO_AFK: FeatureToggle = {
  name: 'Automatic AFK Status',
  category: 'GAMEPLAY',
  description:
    'When enabled, you will automatically be marked as AFK if you are idle for too long.',
  component: CheckboxInput,
};

export const MessengerEmbeds: FeatureToggle = {
  name: 'Messenger Embeds',
  category: 'UI',
  description:
    'When enabled, PDAs and Communicators will attempt to embed links from discord & imgur.',
  component: CheckboxInput,
};

export const AutoPunctuation: FeatureToggle = {
  name: 'Automatic Punctuation',
  category: 'GAMEPLAY',
  description:
    'When enabled, if your message ends in a letter with no punctuation, a period will be added.',
  component: CheckboxInput,
};

export const BrowserDevTools: FeatureToggle = {
  name: 'Browser Dev Tools',
  category: 'UI',
  description:
    'When enabled, you can right click -> inspect to open Microsoft Edge dev tools. BYOND 516+ Only.',
  component: CheckboxInput,
};
