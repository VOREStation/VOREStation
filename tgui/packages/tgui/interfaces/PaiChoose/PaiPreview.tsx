import { Box, Stack } from 'tgui-core/components';
import { classes } from 'tgui-core/react';

export const PaiPreview = (props: {
  icon?: string;
  size?: string;
  color: string;
}) => {
  const { icon, size, color } = props;

  if (!icon || !size) {
    return null;
  }

  return (
    <>
      <Stack.Item>
        <Stack>
          <Stack.Item grow />
          <Stack.Item>
            <Box position="relative">
              <Box className={classes([size, `${icon}N`])} />
              <Box
                position="absolute"
                top="0"
                left="0"
                className={classes([size, `${icon}NE`])}
              />
            </Box>
          </Stack.Item>
          <Stack.Item grow />
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <Stack>
          <Stack.Item grow />
          <Stack.Item>
            <Box position="relative">
              <Box className={classes([size, `${icon}S`])} />
              <Box
                position="absolute"
                top="0"
                left="0"
                className={classes([size, `${icon}SE`])}
              />
            </Box>
          </Stack.Item>
          <Stack.Item grow />
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <Stack>
          <Stack.Item grow />
          <Stack.Item>
            <Box position="relative">
              <Box className={classes([size, `${icon}W`])} />
              <Box
                position="absolute"
                top="0"
                left="0"
                className={classes([size, `${icon}WE`])}
              />
            </Box>
          </Stack.Item>
          <Stack.Item grow />
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <Stack>
          <Stack.Item grow />
          <Stack.Item>
            <Box position="relative">
              <Box className={classes([size, `${icon}E`])} />
              <Box
                position="absolute"
                top="0"
                left="0"
                className={classes([size, `${icon}EE`])}
              />
            </Box>
          </Stack.Item>
          <Stack.Item grow />
        </Stack>
      </Stack.Item>
    </>
  );
};
