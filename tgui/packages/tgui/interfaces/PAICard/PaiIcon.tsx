import { useEffect, useState } from 'react';
import { resolveAsset } from 'tgui/assets';
import { Box, Stack } from 'tgui-core/components';
import { classes } from 'tgui-core/react';
import { fetchSpritePositions } from '../PaiChoose/functions';

export const PaiIcon = (props: {
  icon?: string;
  size?: string;
  color: string;
  chassis: string;
  label?: boolean;
}) => {
  const { icon, size, color, chassis, label } = props;
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
    <Stack align="center">
      <Stack.Item width="60px" height="60px">
        <Box
          position="relative"
          style={{ transform: 'scale(0.5) translate(-60px, -60px)' }}
        >
          <Box className={classes([size, `${icon}S`])} style={{}} />
          {!!iconPositions[`${icon}SE`] && (
            <Box
              position="absolute"
              top="0"
              left="0"
              height="120px"
              width="120px"
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
      {label && <Stack.Item>{chassis}</Stack.Item>}
    </Stack>
  );
};
