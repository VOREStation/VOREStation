import { round } from 'common/math';
import { Fragment } from 'react';
import { useBackend } from '../backend';
import { Button, Section, NumberInput, Flex } from '../components';
import { Window } from '../layouts';
import { formatTime } from '../format';

export const BrigTimer = (props) => {
  const { act, data } = useBackend();
  return (
    <Window width={300} height={138}>
      <Window.Content scrollable>
        <Section
          title="Cell Timer"
          buttons={
            <>
              <Button
                icon="clock-o"
                content={data.timing ? 'Stop' : 'Start'}
                selected={data.timing}
                onClick={() => act(data.timing ? 'stop' : 'start')}
              />
              {(data.flash_found && (
                <Button
                  icon="lightbulb-o"
                  content={data.flash_charging ? 'Recharging' : 'Flash'}
                  disabled={data.flash_charging}
                  onClick={() => act('flash')}
                />
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
            format={(val) => formatTime(round(val))}
            onDrag={(e, val) => act('time', { time: val })}
          />
          <Flex mt={1}>
            <Flex.Item grow={1}>
              <Button
                fluid
                icon="hourglass-start"
                content={'Add ' + formatTime(data.preset_short / 10)}
                onClick={() => act('preset', { preset: 'short' })}
              />
            </Flex.Item>
            <Flex.Item grow={1}>
              <Button
                fluid
                icon="hourglass-start"
                content={'Add ' + formatTime(data.preset_medium / 10)}
                onClick={() => act('preset', { preset: 'medium' })}
              />
            </Flex.Item>
            <Flex.Item grow={1}>
              <Button
                fluid
                icon="hourglass-start"
                content={'Add ' + formatTime(data.preset_long / 10)}
                onClick={() => act('preset', { preset: 'long' })}
              />
            </Flex.Item>
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};
