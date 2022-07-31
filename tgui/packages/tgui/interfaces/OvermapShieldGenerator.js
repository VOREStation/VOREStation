import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Box, Button, LabeledList, ProgressBar, Section, AnimatedNumber } from '../components';
import { Window } from '../layouts';

export const OvermapShieldGenerator = (props, context) => {
  return (
    <Window width={500} height={760} resizable>
      <Window.Content scrollable>
        <OvermapShieldGeneratorContent />
      </Window.Content>
    </Window>
  );
};

const OvermapShieldGeneratorContent = (props, context) => {
  const { act, data } = useBackend(context);
  const { modes, offline_for } = data;

  if (offline_for) {
    return (
      <Section title="EMERGENCY SHUTDOWN" color="bad">
        An emergency shutdown has been initiated - generator cooling down. Please wait until the generator cools down
        before resuming operation. Estimated time left: {offline_for} seconds.
      </Section>
    );
  }

  return (
    <Fragment>
      <OvermapShieldGeneratorStatus />
      <OvermapShieldGeneratorControls />
      <Section title="Field Calibration">
        {modes.map((mode) => (
          <Section
            title={mode.name}
            level={2}
            key={mode.name}
            buttons={
              <Button
                icon="power-off"
                selected={mode.status}
                onClick={() => act('toggle_mode', { toggle_mode: mode.flag })}>
                {mode.status ? 'Enabled' : 'Disabled'}
              </Button>
            }>
            <Box color="label">{mode.desc}</Box>
            <Box mt={0.5}>Multiplier: {mode.multiplier}</Box>
          </Section>
        ))}
      </Section>
    </Fragment>
  );
};

const OvermapShieldGeneratorStatus = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    running,
    overloaded,
    mitigation_max,
    mitigation_physical,
    mitigation_em,
    mitigation_heat,
    field_integrity,
    max_energy,
    current_energy,
    percentage_energy,
    total_segments,
    functional_segments,
    field_radius,
    target_radius,
    input_cap_kw,
    upkeep_power_usage,
    power_usage,
    spinup_counter,
  } = data;

  return (
    <Section title="System Status">
      <LabeledList>
        <LabeledList.Item label="Generator is">
          {(running === 1 && <Box color="average">Shutting Down</Box>) ||
            (running === 2 && ((overloaded && <Box color="bad">Overloaded</Box>) || <Box color="good">Running</Box>)) ||
            (running === 3 && <Box color="average">Inactive</Box>) ||
            (running === 4 && (
              <Box color="blue">
                Spinning Up&nbsp;
                {(target_radius !== field_radius && <Box inline>(Adjusting Radius)</Box>) || (
                  <Box inline>{spinup_counter * 2}s</Box>
                )}
              </Box>
            )) || <Box color="bad">Offline</Box>}
        </LabeledList.Item>
        <LabeledList.Item label="Energy Storage">
          <ProgressBar value={current_energy} maxValue={max_energy}>
            {current_energy} / {max_energy} MJ ({percentage_energy}%)
          </ProgressBar>
        </LabeledList.Item>
        <LabeledList.Item label="Shield Integrity">
          <AnimatedNumber value={field_integrity} />%
        </LabeledList.Item>
        <LabeledList.Item label="Mitigation">
          {mitigation_em}% EM / {mitigation_physical}% PH / {mitigation_heat}% HE / {mitigation_max}% MAX
        </LabeledList.Item>
        <LabeledList.Item label="Upkeep Energy Use">
          <AnimatedNumber value={upkeep_power_usage} /> kW
        </LabeledList.Item>
        <LabeledList.Item label="Total Energy Use">
          {(input_cap_kw && (
            <Box>
              <ProgressBar value={power_usage} maxValue={input_cap_kw}>
                {power_usage} / {input_cap_kw} kW
              </ProgressBar>
            </Box>
          )) || (
            <Box>
              <AnimatedNumber value={power_usage} /> kW (No Limit)
            </Box>
          )}
        </LabeledList.Item>
        <LabeledList.Item label="Field Size">
          <AnimatedNumber value={functional_segments} />
          &nbsp;/&nbsp;
          <AnimatedNumber value={total_segments} /> m&sup2; (radius <AnimatedNumber value={field_radius} />, target{' '}
          <AnimatedNumber value={target_radius} />)
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const OvermapShieldGeneratorControls = (props, context) => {
  const { act, data } = useBackend(context);
  const { running, hacked, idle_multiplier, idle_valid_values } = data;

  return (
    <Section
      title="Controls"
      buttons={
        <Fragment>
          {(running >= 2 && (
            <Box>
              <Button icon="power-off" onClick={() => act('begin_shutdown')} selected>
                Turn off
              </Button>
              {(running === 3 && (
                <Button icon="power-off" onClick={() => act('toggle_idle', { toggle_idle: 0 })}>
                  Activate
                </Button>
              )) || (
                <Button icon="power-off" onClick={() => act('toggle_idle', { toggle_idle: 1 })} selected>
                  Deactivate
                </Button>
              )}
            </Box>
          )) || (
            <Button icon="power-off" onClick={() => act('start_generator')}>
              Turn on
            </Button>
          )}
          {(running && hacked && (
            <Button icon="exclamation-triangle" onClick={() => act('emergency_shutdown')} color="bad">
              EMERGENCY SHUTDOWN
            </Button>
          )) ||
            null}
        </Fragment>
      }>
      <Button icon="expand-arrows-alt" onClick={() => act('set_range')}>
        Set Field Range
      </Button>
      <Button icon="bolt" onClick={() => act('set_input_cap')}>
        Set Input Cap
      </Button>
      <LabeledList>
        <LabeledList.Item label="Set inactive power use intensity">
          {idle_valid_values.map((val) => (
            <Button
              key={val}
              selected={val === idle_multiplier}
              disabled={running === 4}
              onClick={() => act('switch_idle', { switch_idle: val })}>
              {val}
            </Button>
          ))}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
