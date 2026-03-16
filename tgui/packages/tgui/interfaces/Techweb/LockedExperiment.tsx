import { Box, Button, Icon, Stack } from 'tgui-core/components';

export function LockedExperiment(props) {
  return (
    <Box m={1} className="ExperimentConfigure__ExperimentPanel">
      <Button
        fluid
        backgroundColor="#40628a"
        className="ExperimentConfigure__ExperimentName"
        disabled
      >
        <Stack g={0} align="center" justify="space-between">
          <Stack.Item color="rgba(0, 0, 0, 0.6)">
            <Icon name="lock" />
            Undiscovered Experiment
          </Stack.Item>
          <Stack.Item color="rgba(0, 0, 0, 0.5)">???</Stack.Item>
        </Stack>
      </Button>
      <Box className="ExperimentConfigure__ExperimentContent">
        This experiment has not been discovered yet, continue researching nodes
        in the tree to discover the contents of this experiment.
      </Box>
    </Box>
  );
}
