import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Flex, Input, Section, Stack } from 'tgui-core/components';
import { classes } from 'tgui-core/react';

import { Tooltip } from '../../components';

export const IconSection = (props: {
  currentName: string;
  mindName: string;
  isDefaultName: boolean;
  sprite?: string | null;
  size?: string | null;
}) => {
  const { act } = useBackend();
  const { currentName, mindName, isDefaultName, sprite, size } = props;
  const [robotName, setRobotName] = useState<string>(currentName);

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
          <Stack.Item grow>
            <Tooltip content="Adjust your name">
              <Input
                fluid
                value={robotName}
                onChange={(e, value) => {
                  act('rename', { value });
                  setRobotName(value);
                }}
                maxLength={52}
                textColor={isDefaultName ? 'red' : undefined}
              />
            </Tooltip>
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="floppy-disk"
              tooltip="Load character slot name"
              onClick={() => {
                act('rename', { value: mindName });
                setRobotName(mindName);
              }}
            />
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
