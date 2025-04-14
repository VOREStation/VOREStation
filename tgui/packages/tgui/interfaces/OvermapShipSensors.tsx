import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  LabeledList,
  ProgressBar,
  Section,
  Stack,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

type Data = {
  viewing: BooleanLike;
  on: BooleanLike;
  range: string | number;
  health: number;
  max_health: number;
  heat: number;
  critical_heat: number;
  status: string;
  contacts: { name: string; ref: string; bearing: number }[];
};

export const OvermapShipSensors = (props) => {
  return (
    <Window width={375} height={545}>
      <Window.Content>
        <OvermapShipSensorsContent />
      </Window.Content>
    </Window>
  );
};

export const OvermapShipSensorsContent = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    viewing,
    on,
    range,
    health,
    max_health,
    heat,
    critical_heat,
    status,
    contacts,
  } = data;

  return (
    <>
      <Section
        title="Status"
        buttons={
          <Stack>
            <Stack.Item>
              <Button
                icon="eye"
                selected={viewing}
                onClick={() => act('viewing')}
              >
                Map View
              </Button>
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="power-off"
                selected={on}
                onClick={() => act('toggle_sensor')}
              >
                {on ? 'Sensors Enabled' : 'Sensors Disabled'}
              </Button>
            </Stack.Item>
          </Stack>
        }
      >
        <LabeledList>
          <LabeledList.Item label="Status">{status}</LabeledList.Item>
          <LabeledList.Item label="Range">
            <Button icon="signal" onClick={() => act('range')}>
              {range}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Integrity">
            <ProgressBar
              ranges={{
                good: [max_health * 0.75, Infinity],
                average: [max_health * 0.25, max_health * 0.75],
                bad: [-Infinity, max_health * 0.25],
              }}
              value={health}
              maxValue={max_health}
            >
              {health} / {max_health}
            </ProgressBar>
          </LabeledList.Item>
          <LabeledList.Item label="Temperature">
            <ProgressBar
              ranges={{
                bad: [critical_heat * 0.75, Infinity],
                average: [critical_heat * 0.5, critical_heat * 0.75],
                good: [-Infinity, critical_heat * 0.5],
              }}
              value={heat}
              maxValue={critical_heat}
            >
              {(heat < critical_heat * 0.5 && <Box>Temperature low.</Box>) ||
                (heat < critical_heat * 0.75 && (
                  <Box>Sensor temperature high!</Box>
                )) || (
                  <Box>
                    TEMPERATURE CRITICAL: Disable or reduce power immediately!
                  </Box>
                )}
            </ProgressBar>
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section title="Contacts">
        {(contacts.length &&
          contacts.map((alien) => (
            <Button
              key={alien.ref}
              fluid
              icon="search"
              onClick={() => act('scan', { scan: alien.ref })}
            >
              <Box bold inline>
                Scan: {alien.name}
              </Box>
              <Box inline>, bearing: {alien.bearing}&deg;</Box>
            </Button>
          ))) || <Box color="average">No contacts on sensors.</Box>}
      </Section>
      {(data.status === 'MISSING' && (
        <Section title="Error">
          <Button icon="wifi" onClick={() => act('link')}>
            Link up with sensor suite?
          </Button>
        </Section>
      )) ||
        ''}
    </>
  );
};
