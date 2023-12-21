import { Flex, Button, Box, LabeledList, Section } from '../components';
import { useBackend, useLocalState } from '../backend';
import { Window } from '../layouts';
import { toTitleCase } from 'common/string';

export const AreaScrubberControl = (props) => {
  const { act, data } = useBackend();

  const [showArea, setShowArea] = useLocalState('showArea', false);

  const { scrubbers } = data;

  if (!scrubbers) {
    return (
      <Section title="Error">
        <Box color="bad">No Scrubbers Detected.</Box>
        <Button
          fluid
          icon="search"
          content="Scan"
          onClick={() => act('scan')}
        />
      </Section>
    );
  }

  return (
    <Window width={600} height={400} resizable>
      <Window.Content scrollable>
        <Section>
          <Flex wrap="wrap">
            <Flex.Item m="2px" basis="49%">
              <Button
                textAlign="center"
                fluid
                icon="search"
                content="Scan"
                onClick={() => act('scan')}
              />
            </Flex.Item>
            <Flex.Item m="2px" basis="49%" grow={1}>
              <Button
                textAlign="center"
                fluid
                icon="layer-group"
                content="Show Areas"
                selected={showArea}
                onClick={() => setShowArea(!showArea)}
              />
            </Flex.Item>
            <Flex.Item m="2px" basis="49%">
              <Button
                textAlign="center"
                fluid
                icon="toggle-on"
                content="All On"
                onClick={() => act('allon')}
              />
            </Flex.Item>
            <Flex.Item m="2px" basis="49%" grow={1}>
              <Button
                textAlign="center"
                fluid
                icon="toggle-off"
                content="All Off"
                onClick={() => act('alloff')}
              />
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
        content={scrubber.on ? 'Enabled' : 'Disabled'}
        selected={scrubber.on}
        onClick={() => act('toggle', { id: scrubber.id })}
      />
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
