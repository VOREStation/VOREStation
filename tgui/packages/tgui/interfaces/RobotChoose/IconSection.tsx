import { useBackend } from 'tgui/backend';
import { Box, Button, Flex, Input, Section, Stack } from 'tgui-core/components';
import { classes } from 'tgui-core/react';

import { Tooltip } from '../../components';

export const IconSection = (props: {
  currentName: string;
  isDefaultName: boolean;
  sprite?: string | null;
  size?: string | null;
}) => {
  const { act } = useBackend();
  const { currentName, isDefaultName, sprite, size } = props;

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
      <Stack.Item>
        <Stack fill>
          <Stack.Item>
            <Box>Name: </Box>
          </Stack.Item>
          <Stack.Item basis="100%">
            <Tooltip content="Adjust your name">
              <Input
                fluid
                value={currentName}
                onChange={(e, value) => act('rename', { value })}
                maxLength={52}
                textColor={isDefaultName ? 'red' : undefined}
              />
            </Tooltip>
          </Stack.Item>
        </Stack>
      </Stack.Item>
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
