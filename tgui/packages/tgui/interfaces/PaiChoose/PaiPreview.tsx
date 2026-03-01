import { useEffect, useState } from 'react';
import { resolveAsset } from 'tgui/assets';
import { Box, Stack } from 'tgui-core/components';
import { fetchRetry } from 'tgui-core/http';
import { classes } from 'tgui-core/react';

export const PaiPreview = (props: {
  icon?: string;
  size?: string;
  color: string;
  southOnly?: boolean;
}) => {
  const { icon, size, color, southOnly } = props;
  const [iconPositions, setIconPositions] = useState<Record<string, string>>(
    {},
  );

  async function fetchSpritePositions(assetCssUrl: string) {
    const response = await fetchRetry(assetCssUrl);
    const cssText = await response.text();

    const spritePositions: Record<string, string> = {};
    const regex =
      /.*(datumpaisprite[A-Za-z0-9]+)\s*\{\s*background-position:\s*([^;]+);/g;

    let match = regex.exec(cssText);
    while (match !== null) {
      const spriteName = match[1];
      const position = match[2];
      if (!spriteName || !position) {
        match = regex.exec(cssText);
        continue;
      }
      spritePositions[spriteName] = position;
      match = regex.exec(cssText);
    }

    return spritePositions;
  }

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
      {!southOnly && (
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
      )}
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
      {!southOnly && (
        <>
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
      )}
    </>
  );
};
