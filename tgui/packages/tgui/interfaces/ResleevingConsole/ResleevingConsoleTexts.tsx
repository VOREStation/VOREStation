import { useBackend } from '../../backend';
import { Box, Button, Dimmer, Flex, Icon } from '../../components';

export const ResleevingConsoleCoreDump = (props) => {
  return (
    <Dimmer>
      <Flex direction="column" justify="space-evenly" align="center">
        <Flex.Item grow={1}>
          <Icon size={12} color="bad" name="exclamation-triangle" />
        </Flex.Item>
        <Flex.Item grow={1} color="bad" mt={5}>
          <h2>TransCore dump completed. Resleeving offline.</h2>
        </Flex.Item>
      </Flex>
    </Dimmer>
  );
};

export const ResleevingConsoleDiskPrep = (props) => {
  const { act } = useBackend();
  return (
    <Dimmer textAlign="center">
      <Box color="bad">
        <h1>TRANSCORE DUMP</h1>
      </Box>
      <Box color="bad">
        <h2>!!WARNING!!</h2>
      </Box>
      <Box color="bad">
        This will transfer all minds to the dump disk, and the TransCore will be
        made unusable until post-shift maintenance! This should only be used in
        emergencies!
      </Box>
      <Box mt={4}>
        <Button icon="eject" color="good" onClick={() => act('ejectdisk')}>
          Eject Disk
        </Button>
      </Box>
      <Box mt={4}>
        <Button.Confirm
          icon="exclamation-triangle"
          confirmIcon="exclamation-triangle"
          confirmContent="Disable Transcore?"
          color="bad"
          onClick={() => act('coredump')}
        >
          Core Dump
        </Button.Confirm>
      </Box>
    </Dimmer>
  );
};
