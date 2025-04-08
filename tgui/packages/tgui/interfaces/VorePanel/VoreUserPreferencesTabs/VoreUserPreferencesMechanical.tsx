import { useBackend } from 'tgui/backend';
import { Button, Section, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import type { localPrefs } from '../types';
import { VoreUserPreferenceItem } from '../VoreUserPreferenceItem';

export const VoreUserPreferencesMechanical = (props: {
  show_pictures: BooleanLike;
  icon_overflow: BooleanLike;
  preferences: localPrefs;
}) => {
  const { act } = useBackend();
  const { show_pictures, icon_overflow, preferences } = props;

  return (
    <Section
      title="Mechanical Preferences"
      buttons={
        <Button
          icon="eye"
          selected={show_pictures}
          tooltip={
            'Allows to toggle if belly contents are shown as icons or in list format. ' +
            (show_pictures
              ? 'Contents shown as pictures.'
              : 'Contents shown as lists.') +
            (show_pictures && icon_overflow
              ? 'Temporarily disabled. Stomach contents above limits.'
              : '')
          }
          backgroundColor={show_pictures && icon_overflow ? 'orange' : ''}
          onClick={() => act('show_pictures')}
        >
          Contents Preference: {show_pictures ? 'Show Pictures' : 'Show List'}
        </Button>
      }
    >
      <Stack wrap="wrap" justify="center">
        <Stack.Item
          basis="32%"
          style={{
            marginLeft: '0.5em', // Remove if tgui core implements gap
          }}
        >
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
            spec={preferences.vore_fx}
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
        <Stack.Item basis="32%">
          <VoreUserPreferenceItem
            spec={preferences.toggle_consume_liquid_belly}
            tooltipPosition="top"
          />
        </Stack.Item>
      </Stack>
    </Section>
  );
};
