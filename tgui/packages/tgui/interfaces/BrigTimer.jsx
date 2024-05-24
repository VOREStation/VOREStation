import { round } from 'common/math';

import { useBackend } from '../backend';
import { Button, Flex, NumberInput, Section } from '../components';
import { formatTime } from '../format';
import { Window } from '../layouts';

export const BrigTimer = (props) => {
  const { act, data } = useBackend();
  return (
    <Window width={400} height={138}>
      <Window.Content scrollable>
        <Section
          title="Cell Timer"
          buttons={
            <>
              <Button
                icon="clock-o"
                selected={data.timing}
                onClick={() => act(data.timing ? 'stop' : 'start')}
              >
                {data.timing ? 'Stop' : 'Start'}
              </Button>
              {(data.flash_found && (
                <Button
                  icon="lightbulb-o"
                  disabled={data.flash_charging}
                  onClick={() => act('flash')}
                >
                  {data.flash_charging ? 'Recharging' : 'Flash'}
                </Button>
              )) ||
                null}
            </>
          }
        >
          <NumberInput
            animated
            fluid
            value={data.time_left / 10}
            minValue={0}
            maxValue={data.max_time_left / 10}
            format={(val) => formatTime(round(val * 10))}
            onDrag={(e, val) => act('time', { time: val })}
          />
          <Flex mt={1}>
            <Flex.Item grow={1}>
              <Button
                fluid
                icon="hourglass-start"
                onClick={() => act('preset', { preset: 'short' })}
              >
                {'Add ' + formatTime(data.preset_short)}
              </Button>
            </Flex.Item>
            <Flex.Item grow={1}>
              <Button
                fluid
                icon="hourglass-start"
                onClick={() => act('preset', { preset: 'medium' })}
              >
                {'Add ' + formatTime(data.preset_medium)}
              </Button>
            </Flex.Item>
            <Flex.Item grow={1}>
              <Button
                fluid
                icon="hourglass-start"
                onClick={() => act('preset', { preset: 'long' })}
              >
                {'Add ' + formatTime(data.preset_long)}
              </Button>
            </Flex.Item>
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};
