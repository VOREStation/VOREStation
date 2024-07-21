import { useBackend } from '../../backend';
import { Box, Button, Flex, Icon, Section } from '../../components';
import { Data } from './types';

export const SleeperEmpty = (props) => {
  const { act, data } = useBackend<Data>();
  const { isBeakerLoaded } = data;
  return (
    <Section textAlign="center" flexGrow>
      <Flex height="100%">
        <Flex.Item grow="1" align="center" color="label">
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
        </Flex.Item>
      </Flex>
    </Section>
  );
};
