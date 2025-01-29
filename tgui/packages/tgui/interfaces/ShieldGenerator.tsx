import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  Icon,
  LabeledList,
  NumberInput,
  Section,
} from 'tgui-core/components';
import { formatPower, formatSiUnit } from 'tgui-core/format';
import { toFixed } from 'tgui-core/math';
import { BooleanLike } from 'tgui-core/react';

import { FullscreenNotice } from './common/FullscreenNotice';

type Data = {
  locked: BooleanLike;
  lockedData: {
    capacitors: capacitor[];
    active: BooleanLike;
    failing: BooleanLike;
    radius: number;
    max_radius: number;
    z_range: number;
    max_z_range: number;
    average_field_strength: number;
    target_field_strength: number;
    max_field_strength: number;
    shields: number;
    upkeep: number;
    strengthen_rate: number;
    max_strengthen_rate: number;
    gen_power: number;
  };
};

type capacitor = {
  active: BooleanLike;
  stored_charge: number;
  max_charge: number;
  failing: BooleanLike;
};

export const ShieldGenerator = (props) => {
  const { data } = useBackend<Data>();

  const { locked } = data;

  return (
    <Window width={500} height={400}>
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
  const { act, data } = useBackend<Data>();

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
    <>
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
            {toFixed(average_field_strength, 2) +
              ' Renwick (' +
              (target_field_strength &&
                toFixed(
                  (100 * average_field_strength) / target_field_strength,
                  1,
                ) + '%)') || 'NA)'}
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
                        {formatSiUnit(cap.stored_charge, 0, 'J') +
                          ' (' +
                          toFixed(
                            100 * (cap.stored_charge / cap.max_charge),
                            2,
                          ) +
                          '%)'}
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
            selected={active}
            onClick={() => act('toggle')}
          >
            {active ? 'Online' : 'Offline'}
          </Button>
        }
      >
        <LabeledList>
          <LabeledList.Item label="Coverage Radius">
            <NumberInput
              fluid
              stepPixelSize={6}
              step={1}
              minValue={0}
              maxValue={max_radius}
              value={radius}
              unit="m"
              onDrag={(val: number) => act('change_radius', { val: val })}
            />
          </LabeledList.Item>
          <LabeledList.Item label="Vertical Shielding">
            <NumberInput
              fluid
              stepPixelSize={12}
              step={1}
              minValue={0}
              maxValue={max_z_range}
              value={z_range}
              unit="vertical range"
              onDrag={(val: number) => act('z_range', { val: val })}
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
              format={(val: number) => toFixed(val, 1)}
              unit="Renwick/s"
              onDrag={(val: number) => act('strengthen_rate', { val: val })}
            />
          </LabeledList.Item>
          <LabeledList.Item label="Maximum Field Strength">
            <NumberInput
              fluid
              stepPixelSize={12}
              step={1}
              minValue={1}
              maxValue={max_field_strength}
              value={target_field_strength}
              unit="Renwick"
              onDrag={(val: number) =>
                act('target_field_strength', { val: val })
              }
            />
          </LabeledList.Item>
        </LabeledList>
      </Section>
    </>
  );
};
