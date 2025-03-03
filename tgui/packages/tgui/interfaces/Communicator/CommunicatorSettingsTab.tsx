import { useBackend } from 'tgui/backend';
import { Box, Button, LabeledList, Section } from 'tgui-core/components';
import { decodeHtmlEntities } from 'tgui-core/string';

import type { Data } from './types';

export const CommunicatorSettingsTab = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    address,
    selfie_mode,
    owner,
    occupation,
    connectionStatus,
    visible,
    ring,
  } = data;

  return (
    <Section title="Settings">
      <LabeledList>
        <LabeledList.Item label="Owner">
          <Button icon="pen" fluid onClick={() => act('rename')}>
            {decodeHtmlEntities(owner)}
          </Button>
        </LabeledList.Item>
        <LabeledList.Item label="Camera Mode">
          <Button fluid onClick={() => act('selfie_mode')}>
            {selfie_mode ? 'Front-facing Camera' : 'Rear-facing Camera'}
          </Button>
        </LabeledList.Item>
        <LabeledList.Item label="Occupation">
          {decodeHtmlEntities(occupation)}
        </LabeledList.Item>
        <LabeledList.Item label="Connection">
          {connectionStatus === 1 ? (
            <Box color="good">Connected</Box>
          ) : (
            <Box color="bad">Disconnected</Box>
          )}
        </LabeledList.Item>
        <LabeledList.Item label="Device EPv2 Address">
          {address}
        </LabeledList.Item>
        <LabeledList.Item label="Visibility">
          <Button.Checkbox
            checked={visible}
            selected={visible}
            fluid
            onClick={() => act('toggle_visibility')}
          >
            {visible
              ? 'This device can be seen by other devices.'
              : 'This device is invisible to other devices.'}
          </Button.Checkbox>
        </LabeledList.Item>
        <LabeledList.Item label="Ringer">
          <Button.Checkbox
            checked={ring}
            selected={ring}
            fluid
            onClick={() => act('toggle_ringer')}
          >
            {ring ? 'Ringer on.' : 'Ringer off.'}
          </Button.Checkbox>
          <Button fluid onClick={() => act('set_ringer_tone')}>
            Set Ringer Tone
          </Button>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
