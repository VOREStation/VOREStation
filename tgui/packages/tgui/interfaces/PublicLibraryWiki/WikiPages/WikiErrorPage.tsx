import { Box, Divider, Section, Stack } from 'tgui-core/components';

export const WikiErrorPage = (props) => {
  return (
    <Section backgroundColor="#0000dd" fill>
      <Stack vertical fill>
        <Stack.Item>
          <Box
            textAlign="center"
            fontSize="128px"
            italic
            style={{
              textShadow: '1px 1px 20px #fc4103',
            }}
          >
            <Box textColor="green" inline>
              B
            </Box>
            <Box textColor="red" inline>
              i
            </Box>
            <Box textColor="blue" inline>
              n
            </Box>
            <Box textColor="orange" inline>
              g
            </Box>
            <Box textColor="yellow" inline>
              l
            </Box>
            <Box textColor="teal" inline>
              e
            </Box>
          </Box>
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
