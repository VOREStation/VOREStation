import { useEffect, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Icon, Section, Stack, Table } from 'tgui-core/components';
import { classes } from 'tgui-core/react';

import type { Data, LinkedDestroyer } from '../data';

export const DestructiveAnalyzer = (props) => {
  const { act, data } = useBackend<Data>();

  let inner;

  if (!data.linked_destroy) {
    inner = <Box color="bad">No Destructive Analyzer linked.</Box>;
  } else if (!data.linked_destroy.loaded_item) {
    inner = <Box color="average">No item loaded.</Box>;
  } else {
    inner = <DestroyButton destroyer={data.linked_destroy} />;
  }

  return (
    <Section title="Destructive Analyzer" fill textAlign="center">
      {inner}
    </Section>
  );
};

const DestroyButton = (props: { destroyer: LinkedDestroyer }) => {
  const { act } = useBackend();
  const { destroyer } = props;

  let [buttonPressed, setButtonPressed] = useState(false);

  return (
    <Stack fill>
      <Stack.Item basis="60%" textAlign="left">
        <Section
          title="Loaded Item"
          fill
          buttons={<Button onClick={() => act('eject_item')}>Eject</Button>}
          fontSize={1.2}
          mt={2}
          ml={1}
          backgroundColor="#0a0a0a"
          height="95%"
          style={{ borderRadius: '5px' }}
        >
          <Box
            fontSize={2}
            mb={2}
            ml={2}
            color="good"
            style={{ textTransform: 'capitalize' }}
          >
            {destroyer.loaded_item}
          </Box>
          <Table>
            <Table.Row header>
              <Table.Cell header>Tech Levels - Name</Table.Cell>
              <Table.Cell header textAlign="center">
                Level
              </Table.Cell>
              <Table.Cell header textAlign="center">
                Current
              </Table.Cell>
            </Table.Row>
            {destroyer.origin_tech.map((tech) => (
              <Table.Row key={tech.name}>
                <Table.Cell>{tech.name}</Table.Cell>
                <Table.Cell textAlign="center">{tech.level}</Table.Cell>
                <Table.Cell textAlign="center" position="relative">
                  {tech.current}
                  {tech.level >= tech.current ? (
                    <AnimatedArrows
                      on
                      position="absolute"
                      top={0.25}
                      right={0}
                      style={{ transform: 'rotate(-90deg)' }}
                    />
                  ) : null}
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        <Stack fill align="center" justify="center">
          <Stack.Item>
            {/* https://codepen.io/ovr/pen/yLXBbB */}
            <Button
              color="danger"
              className={classes(
                buttonPressed
                  ? ['BigButton', 'BigButton__Pressed']
                  : ['BigButton'],
              )}
              verticalAlignContent="middle"
              onClick={() => {
                setButtonPressed(true);
                setTimeout(() => {
                  setButtonPressed(false);
                  act('deconstruct');
                }, 200);
              }}
            >
              Deconstruct
            </Button>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

export const AnimatedArrows = (props: { on: boolean } & any) => {
  const { on, ...rest } = props;

  const [activeArrow, setActiveArrow] = useState(0);

  // Lower to make it animate faster
  const SPEED = 200;

  useEffect(() => {
    const id = setInterval(() => {
      setActiveArrow((arrow) => (arrow + 1) % 3);
    }, SPEED);
    return () => clearInterval(id);
  }, []);

  return (
    <Box {...rest}>
      <Icon
        color={!on ? 'gray' : activeArrow === 0 ? 'green' : 'white'}
        name="chevron-right"
        size={0.8}
        mr={-0.5}
      />
      <Icon
        color={!on ? 'gray' : activeArrow === 1 ? 'green' : 'white'}
        name="chevron-right"
        size={0.8}
        mr={-0.5}
      />
      <Icon
        color={!on ? 'gray' : activeArrow === 2 ? 'green' : 'white'}
        name="chevron-right"
        size={0.8}
        mr={-0.5}
      />
    </Box>
  );
};
