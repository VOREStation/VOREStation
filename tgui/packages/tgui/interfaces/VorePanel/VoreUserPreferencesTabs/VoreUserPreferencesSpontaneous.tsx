import { Section, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import type { localPrefs } from '../types';
import { VoreUserPreferenceItem } from '../VoreUserPreferenceItem';

export const VoreUserPreferencesSpontaneous = (props: {
  can_be_drop_prey: BooleanLike;
  can_be_drop_pred: BooleanLike;
  preferences: localPrefs;
}) => {
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
        </Stack>
      ) : (
        ''
      )}
    </Section>
  );
};
