import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  AnimatedNumber,
  Box,
  Button,
  LabeledList,
  ProgressBar,
  Section,
} from 'tgui-core/components';
import { formatPower } from 'tgui-core/format';
import { toFixed } from 'tgui-core/math';

import { Plane } from './Plane';
import { Data } from './types';

export const ICAssembly = (props) => {
  const [showInfo, setShowInfo] = useState(false);

  const { act } = useBackend();
  return (
    <Window
      buttons={
        <>
          <Button
            color="transparent"
            width={2.5}
            height={2}
            textAlign="center"
            icon="pencil"
            tooltip="Edit Name"
            tooltipPosition="bottom-start"
            onClick={() => act('rename')}
          />
          <Button
            color="transparent"
            width={2.5}
            height={2}
            textAlign="center"
            icon="info"
            tooltip="Circuit Info"
            tooltipPosition="bottom-start"
            selected={showInfo}
            onClick={() => setShowInfo(!showInfo)}
          />
        </>
      }
      width={1280}
      height={800}
    >
      <Window.Content style={{ background: 'none' }}>
        <Plane />
        {showInfo && <CircuitInfo />}
      </Window.Content>
    </Window>
  );
};

const CircuitInfo = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    total_parts,
    max_components,
    total_complexity,
    max_complexity,
    battery_charge,
    battery_max,
    net_power,
  } = data;

  return (
    <Section
      position="absolute"
      top={4}
      right={2}
      backgroundColor="rgba(0, 0, 0, 0.7)"
      style={{ borderRadius: '16px' }}
      width={40}
      p={2}
      title="Circuit Info"
    >
      <LabeledList>
        <LabeledList.Item label="Space in Assembly">
          <ProgressBar
            ranges={{
              good: [0, 0.25],
              average: [0.5, 0.75],
              bad: [0.75, 1],
            }}
            value={total_parts / max_components}
            maxValue={1}
          >
            {total_parts +
              ' / ' +
              max_components +
              ' (' +
              toFixed((total_parts / max_components) * 100, 1) +
              '%)'}
          </ProgressBar>
        </LabeledList.Item>
        <LabeledList.Item label="Complexity">
          <ProgressBar
            ranges={{
              good: [0, 0.25],
              average: [0.5, 0.75],
              bad: [0.75, 1],
            }}
            value={total_complexity / max_complexity}
            maxValue={1}
          >
            {total_complexity +
              ' / ' +
              max_complexity +
              ' (' +
              toFixed((total_complexity / max_complexity) * 100, 1) +
              '%)'}
          </ProgressBar>
        </LabeledList.Item>
        <LabeledList.Item
          label="Cell Charge"
          buttons={
            <Button
              icon="eject"
              onClick={() => act('remove_cell')}
              tooltip="Remove Cell"
            />
          }
        >
          {(battery_charge && (
            <ProgressBar
              ranges={{
                bad: [0, 0.25],
                average: [0.5, 0.75],
                good: [0.75, 1],
              }}
              value={battery_charge / battery_max}
              maxValue={1}
            >
              {battery_charge +
                ' / ' +
                battery_max +
                ' (' +
                toFixed((battery_charge / battery_max) * 100, 1) +
                '%)'}
            </ProgressBar>
          )) || <Box color="bad">No cell detected.</Box>}
        </LabeledList.Item>
        <LabeledList.Item label="Net Energy">
          {(net_power === 0 && '0 W/s') || (
            <AnimatedNumber
              value={net_power}
              format={(val) => '-' + formatPower(Math.abs(val)) + '/s'}
            />
          )}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
