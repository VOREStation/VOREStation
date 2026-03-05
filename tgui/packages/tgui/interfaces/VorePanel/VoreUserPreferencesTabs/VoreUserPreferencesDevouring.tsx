import { Section, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { selectiveModeModel } from '../constants';

import type { DropdownPrefernces, LocalPrefs } from '../types';
import {
  VoreUserPreferenceDropdown,
  VoreUserPreferenceItem,
} from '../VorePanelElements/VoreUserPreferenceItem';

export const VoreUserPreferencesDevouring = (props: {
  devourable: BooleanLike;
  preferences: LocalPrefs;
  dropdownPreferences: DropdownPrefernces;
}) => {
  const { devourable, dropdownPreferences, preferences } = props;

  return (
    <Section
      title="Devouring Preferences"
      buttons={
        <VoreUserPreferenceItem
          spec={preferences.devour}
          tooltipPosition="top"
        />
      }
    >
      {devourable ? (
        <Stack wrap="wrap" justify="center">
          <Stack.Item basis="32%">
            <VoreUserPreferenceItem
              spec={preferences.healbelly}
              tooltipPosition="right"
            />
          </Stack.Item>
          <Stack.Item basis="32%" grow>
            <VoreUserPreferenceItem
              spec={preferences.digestion}
              tooltipPosition="top"
            />
          </Stack.Item>
          <Stack.Item basis="32%">
            <VoreUserPreferenceItem
              spec={preferences.absorbable}
              tooltipPosition="left"
            />
          </Stack.Item>
          <Stack.Item basis="32%">
            <VoreUserPreferenceDropdown
              spec={selectiveModeModel}
              currentActive={dropdownPreferences.selective_active}
              tooltipPosition="right"
            />
          </Stack.Item>
          <Stack.Item basis="32%" grow>
            <VoreUserPreferenceItem
              spec={preferences.mobvore}
              tooltipPosition="top"
            />
          </Stack.Item>
          <Stack.Item basis="32%">
            <VoreUserPreferenceItem
              spec={preferences.autotransferable}
              tooltipPosition="left"
            />
          </Stack.Item>
          <Stack.Item basis="32%">
            <VoreUserPreferenceItem
              spec={preferences.strippref}
              tooltipPosition="right"
            />
          </Stack.Item>
          <Stack.Item basis="32%" grow>
            <VoreUserPreferenceItem
              spec={preferences.contaminatepref}
              tooltipPosition="top"
            />
          </Stack.Item>
          <Stack.Item basis="32%">
            <VoreUserPreferenceItem
              spec={preferences.liquid_apply}
              tooltipPosition="left"
            />
          </Stack.Item>
          <Stack.Item basis="32%">
            <VoreUserPreferenceItem
              spec={preferences.remains}
              tooltipPosition="right"
            />
          </Stack.Item>
          <Stack.Item basis="32%" grow>
            <VoreUserPreferenceItem
              spec={preferences.toggle_digest_pain}
              tooltipPosition="top"
            />
          </Stack.Item>
          <Stack.Item basis="32%">
            <VoreUserPreferenceItem
              spec={preferences.temperature}
              tooltipPosition="left"
            />
          </Stack.Item>
          <Stack.Item basis="35%">
            <VoreUserPreferenceItem
              spec={preferences.afk_prey}
              tooltipPosition="right"
            />
          </Stack.Item>
        </Stack>
      ) : (
        ''
      )}
    </Section>
  );
};
