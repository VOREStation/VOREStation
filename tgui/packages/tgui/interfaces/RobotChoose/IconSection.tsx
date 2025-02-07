import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Input,
  Section,
  Stack,
  Tooltip,
} from 'tgui-core/components';
import { classes } from 'tgui-core/react';

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
                updateOnPropsChange
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
            <Stack>
              <Stack.Item grow />
              <Stack.Item>
                <Box className={classes([size, sprite + 'N'])} />
              </Stack.Item>
              <Stack.Item grow />
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <Stack>
              <Stack.Item grow />
              <Stack.Item>
                <Box className={classes([size, sprite + 'S'])} />
              </Stack.Item>
              <Stack.Item grow />
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <Stack>
              <Stack.Item grow />
              <Stack.Item>
                <Box className={classes([size, sprite + 'W'])} />
              </Stack.Item>
              <Stack.Item grow />
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <Stack>
              <Stack.Item grow />
              <Stack.Item>
                <Box className={classes([size, sprite + 'E'])} />
              </Stack.Item>
              <Stack.Item grow />
            </Stack>
          </Stack.Item>
        </>
      )}
    </Section>
  );
};
