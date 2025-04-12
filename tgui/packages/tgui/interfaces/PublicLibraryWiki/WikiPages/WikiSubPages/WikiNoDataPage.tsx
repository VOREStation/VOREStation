import { Blink, Box, Section, Stack } from 'tgui-core/components';

import { WikiLogo } from '../../WikiCommon/WikiLogo';

export const WikiNoDataPage = (props) => {
  return (
    <Section fill scrollable>
      <Blink>
        <Stack vertical fill>
          <Stack.Item>
            <WikiLogo />
          </Stack.Item>
          <Stack.Item>
            <Box textAlign="center" fontSize="32px">
              Oh No... No Data...
            </Box>
          </Stack.Item>
          <Stack.Item>
            <Box textAlign="center" fontSize="24px">
              We deeply sorry!!!
            </Box>
          </Stack.Item>
          <Stack.Item>
            <Box textAlign="center" color="label" fontSize="16px">
              Maybe check back later!
            </Box>
          </Stack.Item>
        </Stack>
      </Blink>
    </Section>
  );
};
