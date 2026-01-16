import { useBackend } from 'tgui/backend';
import { Button, Section, Stack } from 'tgui-core/components';

import type { LocalPrefs } from '../types';
import { VoreUserPreferenceItem } from '../VorePanelElements/VoreUserPreferenceItem';

export const VoreUserPreferencesMechanical = (props: {
  preferences: LocalPrefs;
  stripModeToColor: Record<string, string | undefined>;
  strip_activeToText: Record<number, string | undefined>;
  strip_active: number;
}) => {
  const { act } = useBackend();
  const { preferences, strip_active, strip_activeToText, stripModeToColor } =
    props;

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
          <Button
            fluid
            backgroundColor={stripModeToColor[strip_active]}
            tooltip="Allows to set whether all your clothing and/or underwear comes off when size changed. Currently affects: Size guns and bluespace crackers."
            tooltipPosition="right"
            onClick={() => act('switch_strip_mode_pref')}
          >
            {`Size Change Stripping: ${strip_activeToText[strip_active]}`}
          </Button>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
