import { useBackend } from 'tgui/backend';
import { Box, Button, Section, Stack } from 'tgui-core/components';
import { classes } from 'tgui-core/react';

export const IconSection = (props: {
  sprite?: string | null;
  size?: string;
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
            <Box className={classes([size, sprite + 'N'])} />
          </Stack.Item>
          <Stack.Item>
            <Box className={classes([size, sprite + 'S'])} />
          </Stack.Item>
          <Stack.Item>
            <Box className={classes([size, sprite + 'W'])} />
          </Stack.Item>
          <Stack.Item>
            <Box className={classes([size, sprite + 'E'])} />
          </Stack.Item>
        </>
      )}
    </Section>
  );
};
