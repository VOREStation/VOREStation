import { useEffect, useState } from 'react';
import { resolveAsset } from 'tgui/assets';
import { Box, Stack } from 'tgui-core/components';
import { classes } from 'tgui-core/react';
import { fetchSpritePositions } from './functions';

const CORNERS = ['N', 'S', 'W', 'E'] as const;
const MASK_SUFFIX: Record<(typeof CORNERS)[number], string> = {
  N: 'NE',
  S: 'SE',
  W: 'WE',
  E: 'EE',
};

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

  if (!icon || !size) return null;

  return (
    <>
      {CORNERS.map((corner) => (
        <Stack.Item key={corner}>
          <Stack>
            <Stack.Item grow />
            <Stack.Item>
              <Box position="relative">
                <Box className={classes([size, `${icon}${corner}`])} />
                {iconPositions[`${icon}${MASK_SUFFIX[corner]}`] && (
                  <Box
                    position="absolute"
                    top="0"
                    left="0"
                    height="120px"
                    width="120px"
                    style={{
                      WebkitMaskImage: `url(${resolveAsset('pai_icons_120x120.png')})`,
                      WebkitMaskRepeat: 'no-repeat',
                      WebkitMaskPosition:
                        iconPositions[`${icon}${MASK_SUFFIX[corner]}`],
                      backgroundColor: color,
                    }}
                  />
                )}
              </Box>
            </Stack.Item>
            <Stack.Item grow />
          </Stack>
        </Stack.Item>
      ))}
    </>
  );
};
