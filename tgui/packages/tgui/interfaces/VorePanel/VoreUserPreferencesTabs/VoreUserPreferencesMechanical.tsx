import { Section, Stack } from 'tgui-core/components';
import { stripModeModel } from '../constants';
import type { DropdownPrefernces, LocalPrefs } from '../types';
import {
  VoreUserPreferenceDropdown,
  VoreUserPreferenceItem,
} from '../VorePanelElements/VoreUserPreferenceItem';

export const VoreUserPreferencesMechanical = (props: {
  preferences: LocalPrefs;
  dropdownPreferences: DropdownPrefernces;
}) => {
  const { preferences, dropdownPreferences } = props;

  return (
    <Section title="Mechanical Preferences">
      <Stack wrap="wrap" justify="center">
        <Stack.Item basis="32%">
          <VoreUserPreferenceItem
            spec={preferences.steppref}
            tooltipPosition="right"
          />
        </Stack.Item>
        <Stack.Item basis="32%" grow>
          <VoreUserPreferenceItem
            spec={preferences.pickuppref}
            tooltipPosition="top"
          />
        </Stack.Item>
        <Stack.Item basis="32%">
          <VoreUserPreferenceItem
            spec={preferences.resize}
            tooltipPosition="left"
          />
        </Stack.Item>
        <Stack.Item basis="32%">
          <VoreUserPreferenceItem
            spec={preferences.feed}
            tooltipPosition="right"
          />
        </Stack.Item>
        <Stack.Item basis="32%" grow>
          <VoreUserPreferenceItem
            spec={preferences.liquid_receive}
            tooltipPosition="top"
          />
        </Stack.Item>
        <Stack.Item basis="32%">
          <VoreUserPreferenceItem
            spec={preferences.liquid_give}
            tooltipPosition="left"
          />
        </Stack.Item>
        <Stack.Item basis="32%">
          <VoreUserPreferenceItem
            spec={preferences.noisy}
            tooltipPosition="right"
          />
        </Stack.Item>
        <Stack.Item basis="32%" grow>
          <VoreUserPreferenceItem
            spec={preferences.noisy_full}
            tooltipPosition="top"
          />
        </Stack.Item>
        <Stack.Item basis="32%">
          <VoreUserPreferenceItem
            spec={preferences.eating_privacy_global}
            tooltipPosition="left"
          />
        </Stack.Item>
        <Stack.Item basis="32%">
          <VoreUserPreferenceItem
            spec={preferences.vore_death_privacy}
            tooltipPosition="right"
          />
        </Stack.Item>
        <Stack.Item basis="32%" grow>
          <VoreUserPreferenceItem
            spec={preferences.spontaneous_tf}
            tooltipPosition="top"
          />
        </Stack.Item>
        <Stack.Item basis="32%">
          <VoreUserPreferenceItem
            spec={preferences.mind_transfer}
            tooltipPosition="left"
          />
        </Stack.Item>
        <Stack.Item basis="32%">
          <VoreUserPreferenceItem
            spec={preferences.allow_mimicry}
            tooltipPosition="right"
          />
        </Stack.Item>
        <Stack.Item basis="32%" grow>
          <VoreUserPreferenceItem
            spec={preferences.toggle_consume_liquid_belly}
            tooltipPosition="top"
          />
        </Stack.Item>
        <Stack.Item basis="32%">
          <VoreUserPreferenceItem
            spec={preferences.afk_pred}
            tooltipPosition="left"
          />
        </Stack.Item>
        <Stack.Item basis="35%">
          <VoreUserPreferenceDropdown
            spec={stripModeModel}
            currentActive={dropdownPreferences.strip_active.toString()}
            tooltipPosition="top"
          />
        </Stack.Item>
      </Stack>
    </Section>
  );
};
