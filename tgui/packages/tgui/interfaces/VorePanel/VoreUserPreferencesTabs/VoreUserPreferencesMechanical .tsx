import { useBackend } from 'tgui/backend';
import { Button, Section, Stack } from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

import { localPrefs } from '../types';
import { VoreUserPreferenceItem } from '../VoreUserPreferenceItem';

export const VoreUserPreferencesMechanical = (props: {
  show_pictures: BooleanLike;
  preferences: localPrefs;
}) => {
  const { act } = useBackend();
  const { show_pictures, preferences } = props;

  return (
    <Section
      title="Mechanical Preferences"
      buttons={
        <Button
          icon="eye"
          selected={show_pictures}
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
          <VoreUserPreferenceItem spec={preferences.digestion} />
        </Stack.Item>
        <Stack.Item basis="32%" grow>
          <VoreUserPreferenceItem spec={preferences.absorbable} />
        </Stack.Item>
        <Stack.Item basis="32%">
          <VoreUserPreferenceItem spec={preferences.devour} />
        </Stack.Item>
        <Stack.Item basis="32%">
          <VoreUserPreferenceItem spec={preferences.mobvore} />
        </Stack.Item>
        <Stack.Item basis="32%" grow>
          <VoreUserPreferenceItem spec={preferences.feed} />
        </Stack.Item>
        <Stack.Item basis="32%">
          <VoreUserPreferenceItem
            spec={preferences.healbelly}
            tooltipPosition="top"
          />
        </Stack.Item>
        <Stack.Item basis="32%">
          <VoreUserPreferenceItem spec={preferences.dropnom_prey} />
        </Stack.Item>
        <Stack.Item basis="32%" grow>
          <VoreUserPreferenceItem spec={preferences.dropnom_pred} />
        </Stack.Item>
        <Stack.Item basis="32%">
          <VoreUserPreferenceItem spec={preferences.toggle_drop_vore} />
        </Stack.Item>
        <Stack.Item basis="32%">
          <VoreUserPreferenceItem spec={preferences.toggle_slip_vore} />
        </Stack.Item>
        <Stack.Item basis="32%" grow>
          <VoreUserPreferenceItem spec={preferences.toggle_stumble_vore} />
        </Stack.Item>
        <Stack.Item basis="32%">
          <VoreUserPreferenceItem spec={preferences.toggle_throw_vore} />
        </Stack.Item>
        <Stack.Item basis="32%">
          <VoreUserPreferenceItem spec={preferences.toggle_food_vore} />
        </Stack.Item>
        <Stack.Item basis="32%" grow>
          <VoreUserPreferenceItem spec={preferences.toggle_digest_pain} />
        </Stack.Item>
        <Stack.Item basis="32%">
          <VoreUserPreferenceItem spec={preferences.inbelly_spawning} />
        </Stack.Item>
        <Stack.Item basis="32%">
          <VoreUserPreferenceItem spec={preferences.noisy} />
        </Stack.Item>
        <Stack.Item basis="32%" grow>
          <VoreUserPreferenceItem spec={preferences.resize} />
        </Stack.Item>
        <Stack.Item basis="32%">
          <VoreUserPreferenceItem
            spec={preferences.steppref}
            tooltipPosition="top"
          />
        </Stack.Item>
        <Stack.Item basis="32%">
          <VoreUserPreferenceItem
            spec={preferences.vore_fx}
            tooltipPosition="top"
          />
        </Stack.Item>
        <Stack.Item basis="32%" grow>
          <VoreUserPreferenceItem
            spec={preferences.remains}
            tooltipPosition="top"
          />
        </Stack.Item>
        <Stack.Item basis="32%">
          <VoreUserPreferenceItem
            spec={preferences.pickuppref}
            tooltipPosition="top"
          />
        </Stack.Item>
        <Stack.Item basis="32%">
          <VoreUserPreferenceItem spec={preferences.spontaneous_tf} />
        </Stack.Item>
        <Stack.Item basis="32%" grow>
          <Button fluid onClick={() => act('switch_selective_mode_pref')}>
            Selective Mode Preference
          </Button>
        </Stack.Item>
        <Stack.Item basis="32%">
          <VoreUserPreferenceItem spec={preferences.mind_transfer} />
        </Stack.Item>
        <Stack.Item basis="32%" grow>
          <VoreUserPreferenceItem spec={preferences.eating_privacy_global} />
        </Stack.Item>
        <Stack.Item basis="32%" grow>
          <VoreUserPreferenceItem spec={preferences.allow_mimicry} />
        </Stack.Item>
      </Stack>
    </Section>
  );
};
