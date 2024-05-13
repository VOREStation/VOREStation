import { round } from 'common/math';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  LabeledList,
  NumberInput,
  ProgressBar,
  Section,
  Table,
} from '../components';
import { Window } from '../layouts';

export const SolarControl = (props) => {
  const { act, data } = useBackend();
  const {
    generated,
    generated_ratio,
    sun_angle,
    array_angle,
    rotation_rate,
    max_rotation_rate,
    tracking_state,
    connected_panels,
    connected_tracker,
  } = data;
  return (
    <Window width={380} height={230}>
      <Window.Content>
        <Section
          title="Status"
          buttons={
            <Button icon="sync" onClick={() => act('refresh')}>
              Scan for new hardware
            </Button>
          }
        >
          <Table>
            <Table.Row>
              <Table.Cell>
                <LabeledList>
                  <LabeledList.Item
                    label="Solar tracker"
                    color={connected_tracker ? 'good' : 'bad'}
                  >
                    {connected_tracker ? 'OK' : 'N/A'}
                  </LabeledList.Item>
                  <LabeledList.Item
                    label="Solar panels"
                    color={connected_panels > 0 ? 'good' : 'bad'}
                  >
                    {connected_panels}
                  </LabeledList.Item>
                </LabeledList>
              </Table.Cell>
              <Table.Cell size={1.5}>
                <LabeledList>
                  <LabeledList.Item label="Power output">
                    <ProgressBar
                      ranges={{
                        good: [0.66, Infinity],
                        average: [0.33, 0.66],
                        bad: [-Infinity, 0.33],
                      }}
                      minValue={0}
                      maxValue={1}
                      value={generated_ratio}
                    >
                      {generated + ' W'}
                    </ProgressBar>
                  </LabeledList.Item>
                  <LabeledList.Item label="Star orientation">
                    {sun_angle}°
                  </LabeledList.Item>
                </LabeledList>
              </Table.Cell>
            </Table.Row>
          </Table>
        </Section>
        <Section title="Controls">
          <LabeledList>
            <LabeledList.Item label="Tracking">
              <Button
                icon="times"
                selected={tracking_state === 0}
                onClick={() => act('tracking', { mode: 0 })}
              >
                Off
              </Button>
              <Button
                icon="clock-o"
                selected={tracking_state === 1}
                onClick={() => act('tracking', { mode: 1 })}
              >
                Timed
              </Button>
              <Button
                icon="sync"
                selected={tracking_state === 2}
                disabled={!connected_tracker}
                onClick={() => act('tracking', { mode: 2 })}
              >
                Auto
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Azimuth">
              {(tracking_state === 0 || tracking_state === 1) && (
                <NumberInput
                  width="52px"
                  unit="°"
                  step={1}
                  stepPixelSize={2}
                  minValue={-360}
                  maxValue={+720}
                  value={array_angle}
                  format={(rate) => {
                    const sign = Math.sign(rate) > 0 ? ' (CW)' : ' (CCW)';
                    return Math.abs(round(rate)) + sign;
                  }}
                  onDrag={(e, value) => act('azimuth', { value })}
                />
              )}
              {tracking_state === 1 && (
                <NumberInput
                  width="80px"
                  unit="deg/h"
                  step={1}
                  minValue={-max_rotation_rate - 0.01}
                  maxValue={max_rotation_rate + 0.01}
                  value={rotation_rate}
                  format={(rate) => {
                    const sign = Math.sign(rate) > 0 ? ' (CW)' : ' (CCW)';
                    return Math.abs(round(rate)) + sign;
                  }}
                  onDrag={(e, value) => act('azimuth_rate', { value })}
                />
              )}
              {tracking_state === 2 && (
                <Box inline color="label" mt="3px">
                  {array_angle + '°'} (auto)
                </Box>
              )}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
