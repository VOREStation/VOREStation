import { useBackend } from '../backend';
import { Window } from '../layouts';
import { Fragment } from 'inferno';
import { Button, Box, Section, LabeledList, NumberInput, Icon } from '../components';
import { round } from 'common/math';
import { formatSiUnit, formatPower } from '../format';
import { FullscreenNotice } from './common/FullscreenNotice';

export const ShieldGenerator = (props) => {
  const { act, data } = useBackend();

  const { locked } = data;

  return (
    <Window width={500} height={400} resizable>
      <Window.Content>
        {locked ? <ShieldGeneratorLocked /> : <ShieldGeneratorContent />}
      </Window.Content>
    </Window>
  );
};

const ShieldGeneratorLocked = (props) => (
  <FullscreenNotice title="Locked">
    <Box fontSize="1.5rem" bold>
      <Icon
        name="exclamation-triangle"
        verticalAlign="middle"
        size={3}
        mr="1rem"
      />
    </Box>
    <Box color="label" my="1rem">
      Swipe your ID to begin.
    </Box>
  </FullscreenNotice>
);

const ShieldGeneratorContent = (props) => {
  const { act, data } = useBackend();

  const {
    capacitors,
    active,
    failing,
    radius,
    max_radius,
    z_range,
    max_z_range,
    average_field_strength,
    target_field_strength,
    max_field_strength,
    shields,
    upkeep,
    strengthen_rate,
    max_strengthen_rate,
    gen_power,
  } = data.lockedData;

  const capacitorLen = (capacitors || []).length;
  return (
    <Fragment>
      <Section title="Status">
        <LabeledList>
          <LabeledList.Item label="Field Status">
            {failing ? (
              <Box color="bad">Unstable</Box>
            ) : (
              <Box color="good">Stable</Box>
            )}
          </LabeledList.Item>
          <LabeledList.Item label="Overall Field Strength">
            {round(average_field_strength, 2)} Renwick (
            {(target_field_strength &&
              round(
                (100 * average_field_strength) / target_field_strength,
                1
              )) ||
              'NA'}
            %)
          </LabeledList.Item>
          <LabeledList.Item label="Upkeep Power">
            {formatPower(upkeep)}
          </LabeledList.Item>
          <LabeledList.Item label="Shield Generation Power">
            {formatPower(gen_power)}
          </LabeledList.Item>
          <LabeledList.Item label="Currently Shielded">
            {shields} m&sup2;
          </LabeledList.Item>
          <LabeledList.Item label="Capacitors">
            <LabeledList>
              {capacitorLen ? (
                capacitors.map((cap, i) => (
                  <LabeledList.Item key={i} label={'Capacitor #' + i}>
                    {cap.active ? (
                      <Box color="good">Online</Box>
                    ) : (
                      <Box color="bad">Offline</Box>
                    )}
                    <LabeledList>
                      <LabeledList.Item label="Charge">
                        {formatSiUnit(cap.stored_charge, 0, 'J')} (
                        {100 * round(cap.stored_charge / cap.max_charge, 2)}
                        %)
                      </LabeledList.Item>
                      <LabeledList.Item label="Status">
                        {cap.failing ? (
                          <Box color="bad">Discharging</Box>
                        ) : (
                          <Box color="good">OK.</Box>
                        )}
                      </LabeledList.Item>
                    </LabeledList>
                  </LabeledList.Item>
                ))
              ) : (
                <LabeledList.Item color="bad">
                  No Capacitors Connected
                </LabeledList.Item>
              )}
            </LabeledList>
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section
        title="Controls"
        buttons={
          <Button
            icon="power-off"
            content={active ? 'Online' : 'Offline'}
            selected={active}
            onClick={() => act('toggle')}
          />
        }>
        <LabeledList>
          <LabeledList.Item label="Coverage Radius">
            <NumberInput
              fluid
              stepPixelSize={6}
              minValue={0}
              maxValue={max_radius}
              value={radius}
              unit="m"
              onDrag={(e, val) => act('change_radius', { val: val })}
            />
          </LabeledList.Item>
          <LabeledList.Item label="Vertical Shielding">
            <NumberInput
              fluid
              stepPixelSize={12}
              minValue={0}
              maxValue={max_z_range}
              value={z_range}
              unit="vertical range"
              onDrag={(e, val) => act('z_range', { val: val })}
            />
          </LabeledList.Item>
          <LabeledList.Item label="Charge Rate">
            <NumberInput
              fluid
              stepPixelSize={12}
              minValue={0}
              step={0.1}
              maxValue={max_strengthen_rate}
              value={strengthen_rate}
              format={(val) => round(val, 1)}
              unit="Renwick/s"
              onDrag={(e, val) => act('strengthen_rate', { val: val })}
            />
          </LabeledList.Item>
          <LabeledList.Item label="Maximum Field Strength">
            <NumberInput
              fluid
              stepPixelSize={12}
              minValue={1}
              maxValue={max_field_strength}
              value={target_field_strength}
              unit="Renwick"
              onDrag={(e, val) => act('target_field_strength', { val: val })}
            />
          </LabeledList.Item>
        </LabeledList>
      </Section>
    </Fragment>
  );
};
