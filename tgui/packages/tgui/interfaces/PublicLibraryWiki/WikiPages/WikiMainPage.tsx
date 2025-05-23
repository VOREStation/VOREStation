import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Divider,
  Section,
  Stack,
  Tooltip,
} from 'tgui-core/components';

import { WikiPages } from '../constants';

export const WikiMainPage = (props: {
  displayedAds: string[][];
  donationSuccess: boolean;
}) => {
  const { act } = useBackend();

  const { displayedAds, donationSuccess } = props;

  return (
    <Section fill>
      <Stack vertical fill>
        <Stack.Item>
          <Box fontSize="18px" bold>
            The galaxys 18th most tollerated
            {
              <Tooltip
                position="bottom"
                content="At least according to our own studies!"
              >
                <Box inline>*</Box>
              </Tooltip>
            }{' '}
            infocore dispenser!
          </Box>
        </Stack.Item>
        <Divider />
        <Stack.Item>
          <Stack fill vertical mt="50px" ml="100px" mr="100px">
            {WikiPages.sort((a, b) => a.localeCompare(b)).map((title) => (
              <Stack.Item key={title}>
                <Button
                  fluid
                  icon="search"
                  onClick={() => act('swapsearch', { data: title })}
                >
                  {title}
                </Button>
              </Stack.Item>
            ))}
            {!donationSuccess &&
              displayedAds.map((ad, index) => (
                <Stack.Item key={index}>
                  <Button
                    fluid
                    icon="download"
                    onClick={() => act('crash')}
                    color={ad[1]}
                  >
                    {ad[0]}
                  </Button>
                </Stack.Item>
              ))}
          </Stack>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
