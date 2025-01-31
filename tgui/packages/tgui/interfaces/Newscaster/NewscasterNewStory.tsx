import { useBackend } from 'tgui/backend';
import { Button, LabeledList, Section, Stack } from 'tgui-core/components';

import { NEWSCASTER_SCREEN_MAIN } from './constants';
import { Data } from './types';

export const NewscasterNewStory = (props: { setScreen: Function }) => {
  const { act, data } = useBackend<Data>();

  const { channel_name, user, title, msg, photo_data } = data;

  const { setScreen } = props;

  return (
    <Section
      title="Creating new Feed Message..."
      buttons={
        <Button icon="undo" onClick={() => setScreen(NEWSCASTER_SCREEN_MAIN)}>
          Back
        </Button>
      }
    >
      <LabeledList>
        <LabeledList.Item label="Receiving Channel">
          <Button fluid onClick={() => act('set_channel_receiving')}>
            {channel_name || 'Unset'}
          </Button>
        </LabeledList.Item>
        <LabeledList.Item label="Message Author" color="good">
          {user}
        </LabeledList.Item>
        <LabeledList.Item label="Message Title" verticalAlign="top">
          <Stack>
            <Stack.Item grow>
              <Section width="99%" inline>
                {title || '(no title yet)'}
              </Section>
            </Stack.Item>
            <Stack.Item>
              <Button
                verticalAlign="top"
                onClick={() => act('set_new_title')}
                icon="pen"
                tooltip="Edit Title"
                tooltipPosition="left"
              />
            </Stack.Item>
          </Stack>
        </LabeledList.Item>
        <LabeledList.Item label="Message Body" verticalAlign="top">
          <Stack>
            <Stack.Item grow>
              <Section width="99%" inline>
                {msg || '(no message yet)'}
              </Section>
            </Stack.Item>
            <Stack.Item>
              <Button
                verticalAlign="top"
                onClick={() => act('set_new_message')}
                icon="pen"
                tooltip="Edit Message"
                tooltipPosition="left"
              />
            </Stack.Item>
          </Stack>
        </LabeledList.Item>
        <LabeledList.Item label="Attach Photo">
          <Button fluid icon="image" onClick={() => act('set_attachment')}>
            {photo_data ? 'Photo Attached' : 'No Photo'}
          </Button>
        </LabeledList.Item>
      </LabeledList>
      <Button
        fluid
        color="good"
        icon="plus"
        onClick={() => act('submit_new_message')}
      >
        Submit Message
      </Button>
      <Button
        fluid
        color="bad"
        icon="undo"
        onClick={() => setScreen(NEWSCASTER_SCREEN_MAIN)}
      >
        Cancel
      </Button>
    </Section>
  );
};
