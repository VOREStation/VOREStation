import { Fragment } from 'react';
import { useBackend } from '../backend';
import { Box, Button, Flex, LabeledList, Section } from '../components';
import { Window } from '../layouts';
import { decodeHtmlEntities } from 'common/string';
import { formatPower } from '../format';

export const ICCircuit = (props) => {
  const { act, data } = useBackend();

  const {
    name,
    desc,
    displayed_name,
    removable,
    complexity,
    power_draw_idle,
    power_draw_per_use,
    extended_desc,
    inputs,
    outputs,
    activators,
  } = data;

  return (
    <Window width={600} height={400} resizable title={displayed_name}>
      <Window.Content scrollable>
        <Section
          title="Stats"
          buttons={
            <>
              <Button onClick={() => act('rename')}>Rename</Button>
              <Button onClick={() => act('scan')}>Scan with Device</Button>
              <Button onClick={() => act('remove')}>Remove</Button>
            </>
          }>
          <LabeledList>
            <LabeledList.Item label="Complexity">{complexity}</LabeledList.Item>
            {(power_draw_idle && (
              <LabeledList.Item label="Power Draw (Idle)">
                {formatPower(power_draw_idle)}
              </LabeledList.Item>
            )) ||
              null}
            {(power_draw_per_use && (
              <LabeledList.Item label="Power Draw (Active)">
                {formatPower(power_draw_per_use)}
              </LabeledList.Item>
            )) ||
              null}
          </LabeledList>
          {extended_desc}
        </Section>
        <Section title="Circuit">
          <Flex textAlign="center" spacing={1}>
            {(inputs.length && (
              <Flex.Item grow={1}>
                <Section title="Inputs">
                  <ICIODisplay list={inputs} />
                </Section>
              </Flex.Item>
            )) ||
              null}
            <Flex.Item
              basis={
                inputs.length && outputs.length
                  ? '33%'
                  : inputs.length || outputs.length
                    ? '45%'
                    : '100%'
              }>
              <Section title={displayed_name} mb={1}>
                <Box>{desc}</Box>
              </Section>
            </Flex.Item>
            {(outputs.length && (
              <Flex.Item grow={1}>
                <Section title="Outputs">
                  <ICIODisplay list={outputs} />
                </Section>
              </Flex.Item>
            )) ||
              null}
          </Flex>
          <Section title="Triggers">
            {activators.map((activator) => (
              <LabeledList.Item key={activator.name} label={activator.name}>
                <Button onClick={() => act('pin_name', { pin: activator.ref })}>
                  {activator.pulse_out ? '<PULSE OUT>' : '<PULSE IN>'}
                </Button>
                <ICLinkDisplay pin={activator} />
              </LabeledList.Item>
            ))}
          </Section>
        </Section>
      </Window.Content>
    </Window>
  );
};

const ICIODisplay = (props) => {
  const { act } = useBackend();

  const { list } = props;

  return list.map((iopin) => (
    <Box key={iopin.ref}>
      <Button onClick={() => act('pin_name', { pin: iopin.ref })}>
        {decodeHtmlEntities(iopin.type)}: {iopin.name}
      </Button>
      <Button onClick={() => act('pin_data', { pin: iopin.ref })}>
        {iopin.data}
      </Button>
      <ICLinkDisplay pin={iopin} />
    </Box>
  ));
};

const ICLinkDisplay = (props) => {
  const { act } = useBackend();

  const { pin } = props;

  return pin.linked.map((link) => (
    <Box inline key={link.ref}>
      <Button
        onClick={() => act('pin_unwire', { pin: pin.ref, link: link.ref })}>
        {link.name}
      </Button>
      @&nbsp;
      <Button onClick={() => act('examine', { ref: link.holder_ref })}>
        {link.holder_name}
      </Button>
    </Box>
  ));
};
