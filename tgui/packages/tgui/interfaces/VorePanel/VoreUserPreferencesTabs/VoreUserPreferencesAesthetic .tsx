import { useBackend } from 'tgui/backend';
import { Button, Section, Stack } from 'tgui-core/components';

import { localPrefs } from '../types';
import { VoreUserPreferenceItem } from '../VoreUserPreferenceItem';

export const VoreUserPreferencesAesthetic = (props: {
  preferences: localPrefs;
}) => {
  const { act } = useBackend();
  const { preferences } = props;

  return (
    <Section title="Aesthetic Preferences">
      <Stack wrap="wrap" align="center" justify="center">
        <Stack.Item
          grow
          style={{
            marginLeft: '0.5em', // Remove if tgui core implements gap
          }}
        >
          <Button fluid icon="grin-tongue" onClick={() => act('setflavor')}>
            Set Taste
          </Button>
        </Stack.Item>
        <Stack.Item basis="48%">
          <Button fluid icon="wind" onClick={() => act('setsmell')}>
            Set Smell
          </Button>
        </Stack.Item>
        <Stack.Item basis="50%" grow>
          <Button
            onClick={() =>
              act('set_attribute', { attribute: 'b_msgs', msgtype: 'en' })
            }
            icon="flask"
            fluid
          >
            Set Nutrition Examine Message
          </Button>
        </Stack.Item>
        <Stack.Item basis="48%">
          <Button
            onClick={() =>
              act('set_attribute', { attribute: 'b_msgs', msgtype: 'ew' })
            }
            icon="weight-hanging"
            fluid
          >
            Set Weight Examine Message
          </Button>
        </Stack.Item>
        <Stack.Item basis="50%" grow>
          <VoreUserPreferenceItem spec={preferences.examine_nutrition} />
        </Stack.Item>
        <Stack.Item basis="48%">
          <VoreUserPreferenceItem spec={preferences.examine_weight} />
        </Stack.Item>
        <Stack.Item basis="50%">
          <Button fluid onClick={() => act('set_vs_color')} icon="palette">
            Vore Sprite Color
          </Button>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
