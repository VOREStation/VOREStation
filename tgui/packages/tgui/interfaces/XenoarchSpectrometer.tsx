import { useEffect, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  Icon,
  Knob,
  LabeledList,
  ProgressBar,
  RoundGauge,
  Section,
  Stack,
} from 'tgui-core/components';
import { scale } from 'tgui-core/math';
import type { BooleanLike } from 'tgui-core/react';
import { decodeHtmlEntities } from 'tgui-core/string';

type Data = {
  scanned_item: string;
  scanned_item_desc: string;
  last_scan_data: string;
  scanning: BooleanLike;

  // Mechanics
  scan_progress: number;
  scanner_rpm: number;
  scanner_rpm_delta: number;
  radiation: number;
  heat: number;
  coolant: number;

  // Constants
  IDEAL_RPM: number;
  RPM_MAX_DELTA: number;
  RPM_MAX: number;
  TARGET_RADIATION: number;
  RADIATION_MAX: number;
  HEAT_FAILURE_THRESHOLD: number;
  HEAT_MAX: number;
  COOLANT_MAX: number;
};

export const XenoarchSpectrometer = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    scanned_item,
    scanned_item_desc,
    last_scan_data,
    scanning,
    scan_progress,
    scanner_rpm,
    scanner_rpm_delta,
    radiation,
    heat,
    coolant,
    IDEAL_RPM,
    RPM_MAX_DELTA,
    RPM_MAX,
    TARGET_RADIATION,
    RADIATION_MAX,
    HEAT_FAILURE_THRESHOLD,
    HEAT_MAX,
    COOLANT_MAX,
  } = data;

  return (
    <Window width={700} height={760}>
      <Window.Content scrollable>
        <Section
          title="Status"
          buttons={
            <Stack>
              <Stack.Item>
                <Button
                  icon="signal"
                  selected={scanning}
                  onClick={() => act('scanItem')}
                >
                  {scanning ? 'HALT SCAN' : 'Begin Scan'}
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon="eject"
                  disabled={!scanned_item}
                  onClick={() => act('ejectItem')}
                >
                  Eject Item
                </Button>
              </Stack.Item>
            </Stack>
          }
        >
          <LabeledList>
            <LabeledList.Item label="Item">
              {scanned_item || <Box color="bad">No item inserted.</Box>}
            </LabeledList.Item>
            <LabeledList.Item label="Heuristic Analysis">
              {scanned_item_desc || 'None found.'}
            </LabeledList.Item>
            <LabeledList.Item label="Instructions">
              <Box>Bring the RPM up to {IDEAL_RPM} and keep it there.</Box>
              <Box>
                Bring radiation to {TARGET_RADIATION} and keep it there.
              </Box>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section>
          {/* Mechanics!~ */}
          <Stack fill>
            <LeftPanel />
            <RightPanel />
          </Stack>
        </Section>
        <Section title="Latest Results">
          {decodeHtmlEntities(last_scan_data)
            .split('\n')
            .map((val) => (
              <Box key={val}>{val}</Box>
            ))}
        </Section>
      </Window.Content>
    </Window>
  );
};

export const Spinner = (props: {
  value: number;
  minValue: number;
  maxValue: number;
}) => {
  const { value, minValue, maxValue } = props;
  const factor = scale(value, minValue, maxValue);

  const [rotation, setRotation] = useState(0);
  const SPEED_MULTIPLIER = 0.3;
  const STEP_SIZE = 2;

  useEffect(() => {
    // Only spin if there's ~some~ flow.
    if (!factor) {
      return;
    }
    const id = setInterval(() => {
      setRotation((rot) => (rot + STEP_SIZE) % 359);
    }, SPEED_MULTIPLIER * factor);
    return () => clearInterval(id);
  }, [factor]);

  return (
    <Box
      width={4}
      height={4}
      mt={16}
      mb={16}
      style={{
        fontSize: '4rem',
        transform: `rotate(${rotation}deg)`,
        transformOrigin: 'center',
      }}
      position="relative"
    >
      <Icon
        name="vial"
        position="absolute"
        rotation={-45 - 180}
        top={-4}
        left={0}
      />
      <Icon name="vial" position="absolute" rotation={45} top={0} left={-4} />
      <Icon
        name="vial"
        position="absolute"
        rotation={45 - 90}
        top={4}
        left={0}
      />
      <Icon
        name="vial"
        position="absolute"
        rotation={45 + 180}
        top={0}
        left={4}
      />
    </Box>
  );
};

export const LeftPanel = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    scan_progress,
    scanner_rpm,
    scanner_rpm_delta,
    RPM_MAX_DELTA,
    RPM_MAX,
  } = data;

  return (
    <Stack.Item grow>
      <Stack align="center" justify="center">
        <Stack.Item>
          <Spinner value={scanner_rpm} minValue={0} maxValue={RPM_MAX} />
        </Stack.Item>
      </Stack>
      <LabeledList>
        <LabeledList.Item label="Completion">
          <ProgressBar value={scan_progress} minValue={0} maxValue={100} />
        </LabeledList.Item>
        <LabeledList.Item
          label="RPM"
          buttons={
            <Knob
              value={scanner_rpm_delta}
              minValue={-RPM_MAX_DELTA}
              maxValue={RPM_MAX_DELTA}
              step={1}
              format={(val) => val.toFixed(2)}
              onChange={(e, delta) => act('set_scanner_rpm_delta', { delta })}
            />
          }
        >
          <ProgressBar value={scanner_rpm} minValue={0} maxValue={RPM_MAX}>
            {scanner_rpm}
          </ProgressBar>
        </LabeledList.Item>
      </LabeledList>
    </Stack.Item>
  );
};
export const RightPanel = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    radiation,
    heat,
    coolant,
    RADIATION_MAX,
    HEAT_FAILURE_THRESHOLD,
    HEAT_MAX,
    COOLANT_MAX,
  } = data;

  return (
    <Stack.Item basis={20}>
      <Stack fill vertical align="center" justify="center">
        <Stack.Item grow>
          <Stack fill vertical align="center" justify="center">
            <Stack.Item>
              <RoundGauge
                value={radiation}
                minValue={0}
                maxValue={RADIATION_MAX}
                size={4}
              />
            </Stack.Item>
            <Stack.Item>
              <Button icon="radiation" onClick={() => act('inject_radiation')}>
                Inject Radiation
              </Button>
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item>
          <Stack align="center" justify="center">
            <Stack.Item>
              <Stack vertical align="center" justify="center">
                <Stack.Item>
                  <RoundGauge
                    size={2}
                    value={heat}
                    minValue={0}
                    maxValue={HEAT_MAX}
                    ranges={{
                      good: [0, HEAT_FAILURE_THRESHOLD / 2],
                      average: [
                        HEAT_FAILURE_THRESHOLD / 2,
                        HEAT_FAILURE_THRESHOLD,
                      ],
                      bad: [HEAT_FAILURE_THRESHOLD, HEAT_MAX],
                    }}
                  />
                </Stack.Item>
                <Stack.Item>Temperature</Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item>
              <Stack vertical align="center" justify="center">
                <Stack.Item>
                  <RoundGauge
                    size={2}
                    value={coolant}
                    minValue={0}
                    maxValue={COOLANT_MAX}
                    ranges={{
                      bad: [0, COOLANT_MAX / 4],
                      average: [COOLANT_MAX / 4, COOLANT_MAX / 2],
                      good: [COOLANT_MAX / 2, COOLANT_MAX],
                    }}
                  />
                </Stack.Item>
                <Stack.Item>Coolant</Stack.Item>
              </Stack>
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Stack.Item>
  );
};
