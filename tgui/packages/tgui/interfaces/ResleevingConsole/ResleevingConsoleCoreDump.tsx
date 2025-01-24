import { useBackend } from 'tgui/backend';
import { Box, Button, Dimmer, Icon, Stack } from 'tgui-core/components';

export const ResleevingConsoleCoreDump = (props) => {
  return (
    <Dimmer>
      <Stack direction="column" justify="space-evenly" align="center">
        <Stack.Item grow>
          <Icon size={12} color="bad" name="exclamation-triangle" />
        </Stack.Item>
        <Stack.Item grow color="bad" mt={5}>
          <h2>TransCore dump completed. Resleeving offline.</h2>
        </Stack.Item>
      </Stack>
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
      <PulsingWarningTriangle />
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

export const PulsingWarningTriangle = (props) => {
  return (
    <Icon
      color="bad"
      size={4}
      name="exclamation-triangle"
      className="ResleevingConsole__WarningTriangle"
    />
  );
};
