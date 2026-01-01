import { Button, Section, Stack } from 'tgui-core/components';
import { useBackend } from 'tgui/backend';
import type { BooleanLike } from 'tgui-core/react';

import type { LocalPrefs } from '../types';
import { VoreUserPreferenceItem } from '../VorePanelElements/VoreUserPreferenceItem';

export const VoreUserPreferencesSpontaneous = (props: {
  can_be_drop_prey: BooleanLike;
  can_be_drop_pred: BooleanLike;
  preferences: LocalPrefs;
}) => {
  const { act } = useBackend();
  const { can_be_drop_prey, can_be_drop_pred, preferences } = props;

  return (
    <Section
      title="Spontaneous Preferences"
      buttons={
        <Stack>
          <Stack.Item>
            <VoreUserPreferenceItem
              spec={preferences.dropnom_prey}
              tooltipPosition="top"
            />
          </Stack.Item>
          <Stack.Item>
            <VoreUserPreferenceItem
              spec={preferences.dropnom_pred}
              tooltipPosition="top"
            />
          </Stack.Item>
        </Stack>
      }
    >
      {can_be_drop_prey || can_be_drop_pred ? (
        <Stack wrap="wrap" justify="center">
          <Stack.Item basis="32%">
            <VoreUserPreferenceItem
              spec={preferences.toggle_drop_vore}
              tooltipPosition="right"
            />
          </Stack.Item>
          <Stack.Item basis="32%" grow>
            <VoreUserPreferenceItem
              spec={preferences.toggle_slip_vore}
              tooltipPosition="top"
            />
          </Stack.Item>
          <Stack.Item basis="32%">
            <VoreUserPreferenceItem
              spec={preferences.toggle_stumble_vore}
              tooltipPosition="left"
            />
          </Stack.Item>
          <Stack.Item basis="32%">
            <VoreUserPreferenceItem
              spec={preferences.toggle_throw_vore}
              tooltipPosition="right"
            />
          </Stack.Item>
          <Stack.Item basis="32%" grow>
            <VoreUserPreferenceItem
              spec={preferences.toggle_food_vore}
              tooltipPosition="top"
            />
          </Stack.Item>
          <Stack.Item basis="32%">
            <VoreUserPreferenceItem
              spec={preferences.toggle_phase_vore}
              tooltipPosition="left"
            />
          </Stack.Item>
          <Stack.Item basis="35%">
            <Button
              fluid
              tooltip="Choose a specific belly for spontaneous prey to land in, regardless of which is currently selected."
              tooltipPosition="right"
              onClick={() => act('switch_spont_belly')}
            >
              {`Set Spontaneous Bellies`}
            </Button>
          </Stack.Item>
        </Stack>
      ) : (
        ''
      )}
    </Section>
  );
};
