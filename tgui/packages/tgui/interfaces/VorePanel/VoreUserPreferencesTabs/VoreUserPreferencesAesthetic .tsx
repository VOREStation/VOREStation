import { useBackend } from '../../../backend';
import { Button, Flex, Section } from '../../../components';
import { localPrefs } from '../types';
import { VoreUserPreferenceItem } from '../VoreUserPreferenceItem';

export const VoreUserPreferencesAesthetic = (props: {
  preferences: localPrefs;
}) => {
  const { act } = useBackend();
  const { preferences } = props;

  return (
    <Section title="Aesthetic Preferences">
      <Flex spacing={1} wrap="wrap" justify="center">
        <Flex.Item basis="50%" grow={1}>
          <Button fluid icon="grin-tongue" onClick={() => act('setflavor')}>
            Set Taste
          </Button>
        </Flex.Item>
        <Flex.Item basis="50%">
          <Button fluid icon="wind" onClick={() => act('setsmell')}>
            Set Smell
          </Button>
        </Flex.Item>
        <Flex.Item basis="50%" grow={1}>
          <Button
            onClick={() =>
              act('set_attribute', { attribute: 'b_msgs', msgtype: 'en' })
            }
            icon="flask"
            fluid
          >
            Set Nutrition Examine Message
          </Button>
        </Flex.Item>
        <Flex.Item basis="50%">
          <Button
            onClick={() =>
              act('set_attribute', { attribute: 'b_msgs', msgtype: 'ew' })
            }
            icon="weight-hanging"
            fluid
          >
            Set Weight Examine Message
          </Button>
        </Flex.Item>
        <Flex.Item basis="50%" grow={1}>
          <VoreUserPreferenceItem spec={preferences.examine_nutrition} />
        </Flex.Item>
        <Flex.Item basis="50%">
          <VoreUserPreferenceItem spec={preferences.examine_weight} />
        </Flex.Item>
        <Flex.Item basis="50%">
          <Button fluid onClick={() => act('set_vs_color')} icon="palette">
            Vore Sprite Color
          </Button>
        </Flex.Item>
      </Flex>
    </Section>
  );
};
