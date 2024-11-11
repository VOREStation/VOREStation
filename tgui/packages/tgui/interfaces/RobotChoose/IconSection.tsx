import { useBackend } from 'tgui/backend';
import { Box, Button, Flex, Section, Stack } from 'tgui-core/components';
import { classes } from 'tgui-core/react';

export const IconSection = (props: {
  sprite?: string | null;
  size?: string | null;
}) => {
  const { act } = useBackend();
  const { sprite, size } = props;

  return (
    <Section
      title="Sprite"
      fill
      scrollable
      width="40%"
      buttons={
        <Button disabled={!sprite} onClick={() => act('confirm')}>
          Confirm
        </Button>
      }
    >
      {!!sprite && !!size && (
        <>
          <Stack.Item>
            <Flex>
              <Flex.Item grow />
              <Flex.Item>
                <Box className={classes([size, sprite + 'N'])} />
              </Flex.Item>
              <Flex.Item grow />
            </Flex>
          </Stack.Item>
          <Stack.Item>
            <Flex>
              <Flex.Item grow />
              <Flex.Item>
                <Box className={classes([size, sprite + 'S'])} />
              </Flex.Item>
              <Flex.Item grow />
            </Flex>
          </Stack.Item>
          <Stack.Item>
            <Flex>
              <Flex.Item grow />
              <Flex.Item>
                <Box className={classes([size, sprite + 'W'])} />
              </Flex.Item>
              <Flex.Item grow />
            </Flex>
          </Stack.Item>
          <Stack.Item>
            <Flex>
              <Flex.Item grow />
              <Flex.Item>
                <Box className={classes([size, sprite + 'E'])} />
              </Flex.Item>
              <Flex.Item grow />
            </Flex>
          </Stack.Item>
        </>
      )}
    </Section>
  );
};
