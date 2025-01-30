import { useBackend } from 'tgui/backend';
import { Box, Button, Icon, Section, Stack } from 'tgui-core/components';

import { Data } from './types';

export const SleeperEmpty = (props) => {
  const { act, data } = useBackend<Data>();
  const { isBeakerLoaded } = data;
  return (
    <Section textAlign="center" flexGrow>
      <Stack height="100%">
        <Stack.Item grow align="center" color="label">
          <Icon name="user-slash" mb="0.5rem" size={5} />
          <br />
          No occupant detected.
          {(isBeakerLoaded && (
            <Box>
              <Button icon="eject" onClick={() => act('removebeaker')}>
                Remove Beaker
              </Button>
            </Box>
          )) ||
            null}
        </Stack.Item>
      </Stack>
    </Section>
  );
};
