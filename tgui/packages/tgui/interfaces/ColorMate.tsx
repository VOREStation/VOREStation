import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Box, Button, Flex, Section } from '../components';
import { Window } from '../layouts';

type Data = {
  items;
  activecolor: string;
};

export const ColorMate = (props, context) => {
  const { act, data } = useBackend<Data>(context);

  const { items, activecolor } = data;

  let height = Math.min(270 + items.length * 15, 600);

  return (
    <Window width={300} height={height} resizable>
      <Window.Content>
        {(items.length && (
          <Fragment>
            <Section title="Paint">
              <Flex justify="center" align="center">
                <Flex.Item basis="50%">
                  <Box backgroundColor={activecolor} width="120px" height="120px" />
                </Flex.Item>
                <Flex.Item basis="50% ">
                  <Button fluid icon="eye-dropper" onClick={() => act('select')}>
                    Select Color
                  </Button>
                  <Button fluid icon="fill-drip" onClick={() => act('paint')}>
                    Paint Items
                  </Button>
                  <Button fluid icon="tint-slash" onClick={() => act('clear')}>
                    Remove Paintjob
                  </Button>
                  <Button fluid icon="eject" onClick={() => act('eject')}>
                    Eject Items
                  </Button>
                </Flex.Item>
              </Flex>
            </Section>
            <Section title="Items">
              {items.map((item, i) => (
                <Box key={i}>
                  #{i + 1}: {item}
                </Box>
              ))}
            </Section>
          </Fragment>
        )) || (
          <Section>
            <Box color="bad">No items inserted.</Box>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
