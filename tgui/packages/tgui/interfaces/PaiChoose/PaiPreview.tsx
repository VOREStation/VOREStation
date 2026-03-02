import { useEffect, useState } from 'react';
import { resolveAsset } from 'tgui/assets';
import { Box, Stack } from 'tgui-core/components';
import { classes } from 'tgui-core/react';
import { fetchSpritePositions } from './functions';

export const PaiPreview = (props: {
  icon?: string;
  size?: string;
  color: string;
}) => {
  const { icon, size, color } = props;
  const [iconPositions, setIconPositions] = useState<Record<string, string>>(
    {},
  );

  useEffect(() => {
    async function fetchPositions() {
      const positions = await fetchSpritePositions(
        resolveAsset('spritesheet_pai_icons.css'),
      );
      setIconPositions(positions);
    }
    fetchPositions();
  }, []);

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
              {!!iconPositions[`${icon}NE`] && (
                <Box
                  position="absolute"
                  top="0"
                  left="0"
                  className={size}
                  style={{
                    WebkitMaskImage: `url(${resolveAsset('pai_icons_120x120.png')})`,
                    WebkitMaskRepeat: 'no-repeat',
                    WebkitMaskPosition: `${iconPositions[`${icon}NE`]}`,
                    backgroundColor: `${color}`,
                  }}
                />
              )}
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
              {!!iconPositions[`${icon}SE`] && (
                <Box
                  position="absolute"
                  top="0"
                  left="0"
                  className={size}
                  style={{
                    WebkitMaskImage: `url(${resolveAsset('pai_icons_120x120.png')})`,
                    WebkitMaskRepeat: 'no-repeat',
                    WebkitMaskPosition: `${iconPositions[`${icon}SE`]}`,
                    backgroundColor: `${color}`,
                  }}
                />
              )}
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
              {!!iconPositions[`${icon}WE`] && (
                <Box
                  position="absolute"
                  top="0"
                  left="0"
                  className={size}
                  style={{
                    WebkitMaskImage: `url(${resolveAsset('pai_icons_120x120.png')})`,
                    WebkitMaskRepeat: 'no-repeat',
                    WebkitMaskPosition: `${iconPositions[`${icon}WE`]}`,
                    backgroundColor: `${color}`,
                  }}
                />
              )}
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
              {!!iconPositions[`${icon}EE`] && (
                <Box
                  position="absolute"
                  top="0"
                  left="0"
                  className={size}
                  style={{
                    WebkitMaskImage: `url(${resolveAsset('pai_icons_120x120.png')})`,
                    WebkitMaskRepeat: 'no-repeat',
                    WebkitMaskPosition: `${iconPositions[`${icon}EE`]}`,
                    backgroundColor: `${color}`,
                  }}
                />
              )}
            </Box>
          </Stack.Item>
          <Stack.Item grow />
        </Stack>
      </Stack.Item>
    </>
  );
};
