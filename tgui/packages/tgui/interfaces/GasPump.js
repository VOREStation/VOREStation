import { useBackend } from '../backend';
import { Button, LabeledList, ProgressBar, Section, LabeledControls, AnimatedNumber } from '../components';
import { Window } from '../layouts';

export const GasPump = (props, context) => {
  const { act, data } = useBackend(context);

  const { on, pressure_set, last_flow_rate, last_power_draw, max_power_draw } =
    data;

  return (
    <Window width={470} height={290} resizable>
      <Window.Content>
        <Section title="Status">
          <LabeledList>
            <LabeledList.Item label="Flow Rate">
              <AnimatedNumber value={last_flow_rate / 10} /> L/s
            </LabeledList.Item>
            <LabeledList.Item label="Load">
              <ProgressBar
                value={last_power_draw}
                minValue={0}
                maxValue={max_power_draw}
                color={
                  last_power_draw < max_power_draw - 5 ? 'good' : 'average'
                }>
                {last_power_draw + ' W'}
              </ProgressBar>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section
          title="Controls"
          buttons={
            <Button
              icon="power-off"
              content={on ? 'On' : 'Off'}
              selected={on}
              onClick={() => act('power')}
            />
          }>
          <LabeledControls>
            <LabeledControls.Item>
              <Button
                icon="compress-arrows-alt"
                content="MIN"
                onClick={() => act('set_press', { press: 'min' })}
              />
              <Button
                icon="expand-arrows-alt"
                content="MAX"
                onClick={() => act('set_press', { press: 'max' })}
              />
              <Button
                icon="wrench"
                content="SET"
                onClick={() => act('set_press', { press: 'set' })}
              />
            </LabeledControls.Item>
            <LabeledControls.Item label="Desired Output Pressure">
              {pressure_set / 100} kPa
            </LabeledControls.Item>
          </LabeledControls>
        </Section>
      </Window.Content>
    </Window>
  );
};
