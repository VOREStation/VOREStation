import {
  CheckboxInput,
  type FeatureNumeric,
  FeatureSliderInput,
  type FeatureToggle,
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

export const tgui_fancy: FeatureToggle = {
  name: 'TGUI: Fancy Mode',
  category: 'UI',
  description: 'When enabled, hide the title bar and fully style tgui windows.',
  component: CheckboxInput,
};

export const tgui_lock: FeatureToggle = {
  name: 'TGUI: Window Lock',
  category: 'UI',
  description:
    'When enabled, forces windows to spawn on the primary monitor - otherwise, any monitor.',
  component: CheckboxInput,
};

export const tgui_input_mode: FeatureToggle = {
  name: 'TGUI: Input Framework',
  category: 'UI',
  description: 'Enable TGUI based input for most input dialogs.',
  component: CheckboxInput,
};

export const tgui_large_buttons: FeatureToggle = {
  name: 'TGUI: Large Buttons',
  category: 'UI',
  description: 'Use large buttons in TGUI Input windows.',
  component: CheckboxInput,
};

export const tgui_swapped_buttons: FeatureToggle = {
  name: 'TGUI: Swapped Buttons',
  category: 'UI',
  description: 'Swap the position of OK and Cancel buttons.',
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

export const ui_scale: FeatureToggle = {
  name: 'Toggle UI scaling',
  category: 'UI',
  description: 'If UIs should scale up to match your monitor scaling.',
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

export const tgui_say_width: FeatureNumeric = {
  name: 'Say: TGUI Width (Pixel)',
  category: 'UI',
  description: 'The width to show in the tgui say input.',
  component: FeatureSliderInput,
};
