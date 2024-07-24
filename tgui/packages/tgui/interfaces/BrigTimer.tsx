import { round } from 'common/math';
import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Button, Flex, NumberInput, Section } from '../components';
import { formatTime } from '../format';
import { Window } from '../layouts';

type Data = {
  time_left: number;
  max_time_left: number;
  timing: BooleanLike;
  flash_found: BooleanLike;
  flash_charging: BooleanLike;
  preset_short: number;
  preset_medium: number;
  preset_long: number;
};

export const BrigTimer = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    time_left,
    max_time_left,
    timing,
    flash_found,
    flash_charging,
    preset_short,
    preset_medium,
    preset_long,
  } = data;

  return (
    <Window width={400} height={138}>
      <Window.Content scrollable>
        <Section
          title="Cell Timer"
          buttons={
            <>
              <Button
                icon="clock-o"
                selected={timing}
                onClick={() => act(timing ? 'stop' : 'start')}
              >
                {timing ? 'Stop' : 'Start'}
              </Button>
              {(flash_found && (
                <Button
                  icon="lightbulb-o"
                  disabled={flash_charging}
                  onClick={() => act('flash')}
                >
                  {flash_charging ? 'Recharging' : 'Flash'}
                </Button>
              )) ||
                null}
            </>
          }
        >
          <NumberInput
            animated
            fluid
            step={1}
            value={time_left / 10}
            minValue={0}
            maxValue={max_time_left / 10}
            format={(val: number) => formatTime(round(val * 10, 0))}
            onDrag={(val: number) => act('time', { time: val })}
          />
          <Flex mt={1}>
            <Flex.Item grow={1}>
              <Button
                fluid
                icon="hourglass-start"
                onClick={() => act('preset', { preset: 'short' })}
              >
                {'Add ' + formatTime(preset_short)}
              </Button>
            </Flex.Item>
            <Flex.Item grow={1}>
              <Button
                fluid
                icon="hourglass-start"
                onClick={() => act('preset', { preset: 'medium' })}
              >
                {'Add ' + formatTime(preset_medium)}
              </Button>
            </Flex.Item>
            <Flex.Item grow={1}>
              <Button
                fluid
                icon="hourglass-start"
                onClick={() => act('preset', { preset: 'long' })}
              >
                {'Add ' + formatTime(preset_long)}
              </Button>
            </Flex.Item>
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};
