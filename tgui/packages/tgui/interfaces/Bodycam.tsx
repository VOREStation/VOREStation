import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Button,
  Input,
  LabeledList,
  Section,
  Stack,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

type Data = {
  channel: string;
  status: BooleanLike;
  shown_name: string | null;
  broadcasting: BooleanLike;
  frequency: number;
  frequency_name: string;
};

export const Bodycam = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    channel,
    status,
    shown_name,
    broadcasting,
    frequency,
    frequency_name,
  } = data;

  const isStreaming = !!status && !!shown_name;

  return (
    <Window width={350} height={265}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Section title="Camera Options">
              <LabeledList>
                <LabeledList.Item label="Channel Name">
                  <Input
                    fluid
                    value={channel ? channel : 'unidentified broadcast'}
                    onBlur={(value) => act('channel', { name: value })}
                    maxLength={52}
                  />
                </LabeledList.Item>
                <LabeledList.Item label="Video Streaming">
                  <Button
                    color={status ? 'green' : 'red'}
                    onClick={() => act('video')}
                  >
                    {status ? 'On' : 'Off'}
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item label="Mic Status">
                  <Button
                    color={broadcasting ? 'green' : 'red'}
                    onClick={() => act('sound')}
                  >
                    {broadcasting ? 'On' : 'Off'}
                  </Button>
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Section fill title="Camera Feedback">
              <Stack vertical>
                <Stack.Item color={isStreaming ? 'green' : 'red'}>
                  {isStreaming
                    ? `You are showing ${shown_name} to your viewers.`
                    : 'Camera disabled or having no target.'}
                </Stack.Item>
                <Stack.Item color={broadcasting ? 'green' : 'red'}>
                  {broadcasting
                    ? `Sound is being broadcasted on frequency ${frequency} (${frequency_name})`
                    : 'Sound disabled.'}
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
