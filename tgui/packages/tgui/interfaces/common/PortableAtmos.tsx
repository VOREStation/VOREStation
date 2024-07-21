import { BooleanLike } from 'common/react';

import { useBackend } from '../../backend';
import {
  AnimatedNumber,
  Box,
  Button,
  LabeledList,
  ProgressBar,
  Section,
} from '../../components';

type Data = {
  connected: BooleanLike;
  holding: { name: string; pressure: number } | null;
  on: BooleanLike;
  pressure: number;
  powerDraw: number;
  cellCharge: number;
  cellMaxCharge: number;
};

export const PortableBasicInfo = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    connected,
    holding,
    on,
    pressure,
    powerDraw,
    cellCharge,
    cellMaxCharge,
  } = data;

  return (
    <>
      <Section
        title="Status"
        buttons={
          <Button
            icon={on ? 'power-off' : 'times'}
            selected={on}
            onClick={() => act('power')}
          >
            {on ? 'On' : 'Off'}
          </Button>
        }
      >
        <LabeledList>
          <LabeledList.Item label="Pressure">
            <AnimatedNumber value={pressure} />
            {' kPa'}
          </LabeledList.Item>
          <LabeledList.Item label="Port" color={connected ? 'good' : 'average'}>
            {connected ? 'Connected' : 'Not Connected'}
          </LabeledList.Item>
          <LabeledList.Item label="Load">{powerDraw} W</LabeledList.Item>
          <LabeledList.Item label="Cell Charge">
            <ProgressBar
              value={cellCharge}
              minValue={0}
              maxValue={cellMaxCharge}
              ranges={{
                good: [cellMaxCharge * 0.5, Infinity],
                average: [cellMaxCharge * 0.25, cellMaxCharge * 0.5],
                bad: [-Infinity, cellMaxCharge * 0.25],
              }}
            >
              {cellCharge} W
            </ProgressBar>
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section
        title="Holding Tank"
        minHeight="82px"
        buttons={
          <Button icon="eject" disabled={!holding} onClick={() => act('eject')}>
            Eject
          </Button>
        }
      >
        {holding ? (
          <LabeledList>
            <LabeledList.Item label="Label">{holding.name}</LabeledList.Item>
            <LabeledList.Item label="Pressure">
              <AnimatedNumber value={holding.pressure} />
              {' kPa'}
            </LabeledList.Item>
          </LabeledList>
        ) : (
          <Box color="average">No holding tank</Box>
        )}
      </Section>
    </>
  );
};
