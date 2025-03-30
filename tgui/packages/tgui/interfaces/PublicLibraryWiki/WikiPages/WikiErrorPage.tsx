import { Box, Divider, Section, Stack } from 'tgui-core/components';

import { WikiLogo } from '../WikiCommon/WikiLogo';

export const WikiErrorPage = (props) => {
  return (
    <Section backgroundColor="#0000dd" fill>
      <Stack vertical fill>
        <Stack.Item>
          <WikiLogo />
        </Stack.Item>
        <Divider />
        <Stack.Item grow />
        <Stack.Item>
          <Box textAlign="center" fontSize="32px">
            This program has performed an illegal operation!
          </Box>
          <Box textAlign="center" fontSize="24px">
            The cyber police have been notified of your illegal action!
          </Box>
          <Box textAlign="center" fontSize="16px">
            Stand by for arrest!
          </Box>
        </Stack.Item>
        <Stack.Item grow />
        <Stack.Item>
          <Box textAlign="center" fontSize="8px">
            {'>:( This is your fault stupid. Why did you you do that? You caused a FAULT ID: #' +
              Math.floor(Math.random() * 99999999)
                .toString()
                .padStart(8, '0')}
          </Box>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
