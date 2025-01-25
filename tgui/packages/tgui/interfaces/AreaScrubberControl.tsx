import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, LabeledList, Section, Stack } from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';
import { toTitleCase } from 'tgui-core/string';

type scrubber = {
  id: string;
  name: string;
  on: BooleanLike;
  pressure: number;
  flow_rate: number;
  load: number;
  area: string;
};

type Data = {
  scrubbers: scrubber[];
};

export const AreaScrubberControl = (props) => {
  const { act, data } = useBackend<Data>();

  const [showArea, setShowArea] = useState<boolean>(false);

  const { scrubbers } = data;

  if (!scrubbers) {
    return (
      <Section title="Error">
        <Box color="bad">No Scrubbers Detected.</Box>
        <Button fluid icon="search" onClick={() => act('scan')}>
          Scan
        </Button>
      </Section>
    );
  }

  return (
    <Window width={600} height={400}>
      <Window.Content scrollable>
        <Section>
          <Stack wrap="wrap">
            <Stack.Item m="2px" basis="49%">
              <Button
                textAlign="center"
                fluid
                icon="search"
                onClick={() => act('scan')}
              >
                Scan
              </Button>
            </Stack.Item>
            <Stack.Item m="2px" basis="49%" grow>
              <Button
                textAlign="center"
                fluid
                icon="layer-group"
                selected={showArea}
                onClick={() => setShowArea(!showArea)}
              >
                Show Areas
              </Button>
            </Stack.Item>
            <Stack.Item m="2px" basis="49%">
              <Button
                textAlign="center"
                fluid
                icon="toggle-on"
                onClick={() => act('allon')}
              >
                All On
              </Button>
            </Stack.Item>
            <Stack.Item m="2px" basis="49%" grow>
              <Button
                textAlign="center"
                fluid
                icon="toggle-off"
                onClick={() => act('alloff')}
              >
                All Off
              </Button>
            </Stack.Item>
          </Stack>
          <Stack wrap="wrap">
            {scrubbers.map((scrubber) => (
              <Stack.Item m="2px" key={scrubber.id} basis="32%">
                <BigScrubber scrubber={scrubber} showArea={showArea} />
              </Stack.Item>
            ))}
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};

const BigScrubber = (props: { scrubber: scrubber; showArea: boolean }) => {
  const { act } = useBackend();

  const { scrubber, showArea } = props;

  return (
    <Section title={scrubber.name}>
      <Button
        fluid
        icon="power-off"
        selected={scrubber.on}
        onClick={() => act('toggle', { id: scrubber.id })}
      >
        {scrubber.on ? 'Enabled' : 'Disabled'}
      </Button>
      <LabeledList>
        <LabeledList.Item label="Pressure">
          {scrubber.pressure} kPa
        </LabeledList.Item>
        <LabeledList.Item label="Flow Rate">
          {scrubber.flow_rate} L/s
        </LabeledList.Item>
        <LabeledList.Item label="Load">{scrubber.load} W</LabeledList.Item>
        {showArea && (
          <LabeledList.Item label="Area">
            {toTitleCase(scrubber.area)}
          </LabeledList.Item>
        )}
      </LabeledList>
    </Section>
  );
};
