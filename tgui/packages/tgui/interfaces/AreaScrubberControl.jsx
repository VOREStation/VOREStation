import { toTitleCase } from 'common/string';
import { useState } from 'react';

import { useBackend } from '../backend';
import { Box, Button, Flex, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const AreaScrubberControl = (props) => {
  const { act, data } = useBackend();

  const [showArea, setShowArea] = useState(false);

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
          <Flex wrap="wrap">
            <Flex.Item m="2px" basis="49%">
              <Button
                textAlign="center"
                fluid
                icon="search"
                onClick={() => act('scan')}
              >
                Scan
              </Button>
            </Flex.Item>
            <Flex.Item m="2px" basis="49%" grow={1}>
              <Button
                textAlign="center"
                fluid
                icon="layer-group"
                selected={showArea}
                onClick={() => setShowArea(!showArea)}
              >
                Show Areas
              </Button>
            </Flex.Item>
            <Flex.Item m="2px" basis="49%">
              <Button
                textAlign="center"
                fluid
                icon="toggle-on"
                onClick={() => act('allon')}
              >
                All On
              </Button>
            </Flex.Item>
            <Flex.Item m="2px" basis="49%" grow={1}>
              <Button
                textAlign="center"
                fluid
                icon="toggle-off"
                onClick={() => act('alloff')}
              >
                All Off
              </Button>
            </Flex.Item>
          </Flex>
          <Flex wrap="wrap">
            {scrubbers.map((scrubber) => (
              <Flex.Item m="2px" key={scrubber.id} basis="32%">
                <BigScrubber scrubber={scrubber} showArea={showArea} />
              </Flex.Item>
            ))}
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};

const BigScrubber = (props) => {
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
