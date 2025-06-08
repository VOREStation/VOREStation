import { resolveAsset } from 'tgui/assets';
import { Box, Image, Stack } from 'tgui-core/components';
export const VendorLogo = () => {
  return (
    <Stack align="center" justify="center" height="20%">
      <Stack.Item>
        <Box as="logo-container">
          <Image
            src={resolveAsset('recycle.gif')}
            height="48px"
            style={{
              marginRight: '-10px',
            }}
          />
        </Box>
      </Stack.Item>
      <Stack.Item>
        <Box as="logo-container">
          <Image src={resolveAsset('logo.png')} />
        </Box>
      </Stack.Item>
    </Stack>
  );
};
