import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Button,
  LabeledList,
  NumberInput,
  Section,
  Slider,
  Stack,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

type Data = {
  connected: BooleanLike;
  timing: BooleanLike;
  time: number;
  power_level: number | null;
};

export const PodComputer = (props) => {
  const { act, data } = useBackend<Data>();

  const { connected, timing, time, power_level } = data;

  return (
    <Window width={300} height={250}>
      <Window.Content>
        <Section
          fill
          title="Door Controls"
          buttons={
            <Button onClick={() => act('toggle_door')}>
              Toggle Outer Door
            </Button>
          }
        >
          {!!connected && (
            <Section
              fill
              title="Timer System"
              buttons={
                <Button
                  disabled={!connected}
                  onClick={() => act('start_stop')}
                  color={timing ? 'red' : 'green'}
                >
                  {`${timing ? 'Stop' : 'Initiate'} Time Launch`}
                </Button>
              }
            >
              <Stack vertical>
                <Stack.Item>
                  <LabeledList>
                    <LabeledList.Item label="Time Left">
                      <NumberInput
                        width="50px"
                        maxValue={120}
                        minValue={0}
                        stepPixelSize={5}
                        value={time}
                        format={(val) => `${val} s`}
                        onChange={(value) => act('adjust_time', { value })}
                      />
                    </LabeledList.Item>
                    <LabeledList.Divider />
                    <LabeledList.Item label="Power Level">
                      <Slider
                        maxValue={16}
                        minValue={0.25}
                        value={power_level || 0}
                        onChange={(e, value) => act('adjust_power', { value })}
                      />
                    </LabeledList.Item>
                  </LabeledList>
                </Stack.Item>
                <Stack.Divider />
                <Stack.Item>
                  <Stack>
                    <Stack.Item>
                      <Button onClick={() => act('test_alarm')}>
                        Firing Sequence
                      </Button>
                    </Stack.Item>
                    <Stack.Item>
                      <Button onClick={() => act('test_drive')}>
                        Test Fire Driver
                      </Button>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
              </Stack>
            </Section>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
