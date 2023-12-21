import { useBackend } from '../backend';
import { Box, Button, LabeledList, ProgressBar, Section } from '../components';
import { Window } from '../layouts';

export const XenoarchArtifactHarvester = (props) => {
  const { act, data } = useBackend();

  const { no_scanner, harvesting, inserted_battery } = data.info;

  return (
    <Window width={450} height={200}>
      <Window.Content>
        {(no_scanner && (
          <Box color="bad">Warning: No scanner detected.</Box>
        )) || (
          <Section>
            {(harvesting > 0 && (
              <Box>
                <Box color="label" textAlign="center" mb={1}>
                  Please wait. Harvesting in progress.
                </Box>
                <ArtHarvestBatteryProgress />
                <Button
                  mt={1}
                  fluid
                  icon="stop"
                  onClick={() => act('stopharvest')}>
                  Stop Early
                </Button>
              </Box>
            )) ||
              (harvesting < 0 && (
                <Box>
                  <Box color="label" textAlign="center" mb={1}>
                    Please wait. Energy dump in progress.
                  </Box>
                  <ArtHarvestBatteryProgress />
                  <Button
                    mt={1}
                    fluid
                    icon="stop"
                    onClick={() => act('stopharvest')}>
                    Stop Early
                  </Button>
                </Box>
              )) ||
              (Object.keys(inserted_battery).length && (
                <Box>
                  <LabeledList>
                    <LabeledList.Item label="Name">
                      {inserted_battery.name}
                    </LabeledList.Item>
                    <LabeledList.Item label="Charge">
                      <ArtHarvestBatteryProgress />
                    </LabeledList.Item>
                    <LabeledList.Item label="Energy Signature ID">
                      {inserted_battery.artifact_id}
                    </LabeledList.Item>
                  </LabeledList>
                  <Button
                    mt={1}
                    fluid
                    icon="eject"
                    onClick={() => act('ejectbattery')}>
                    Eject Battery
                  </Button>
                  <Button fluid icon="bolt" onClick={() => act('drainbattery')}>
                    Drain Battery
                  </Button>
                  <Button fluid icon="star" onClick={() => act('harvest')}>
                    Begin Harvest
                  </Button>
                </Box>
              )) || <Box color="bad">No battery inserted.</Box>}
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};

const ArtHarvestBatteryProgress = (props) => {
  const { act, data } = useBackend();

  const { inserted_battery } = data.info;

  if (!Object.keys(inserted_battery).length) {
    return <Box color="bad">No battery inserted.</Box>;
  }

  return (
    <ProgressBar
      minValue={0}
      value={inserted_battery.stored_charge}
      maxValue={inserted_battery.capacity}
    />
  );
};
