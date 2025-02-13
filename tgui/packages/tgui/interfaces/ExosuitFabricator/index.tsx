import { useBackend, useSharedState } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, Section, Stack } from 'tgui-core/components';

import { materialArrayToObj, queueCondFormat } from './functions';
import { Materials } from './Material';
import { PartLists, PartSets } from './Parts';
import { Queue } from './Queue';
import type { Data } from './types';

export const ExosuitFabricator = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    species_types,
    species,
    manufacturers,
    manufacturer,
    queue = [],
    materials = [],
  } = data;

  const materialAsObj = materialArrayToObj(materials);

  const { materialTally, missingMatTally, textColors } = queueCondFormat(
    materialAsObj,
    queue,
  );

  const [displayMatCost, setDisplayMatCost] = useSharedState(
    'display_mats',
    false,
  );

  const [displayAllMat, setDisplayAllMat] = useSharedState(
    'display_all_mats',
    false,
  );

  return (
    <Window width={1100} height={640}>
      <Window.Content scrollable>
        <Stack fillPositionedParent vertical>
          <Stack>
            <Stack.Item ml={1} mr={1} mt={1} basis="75%" grow>
              <Section title="Materials">
                <Materials displayAllMat={displayAllMat} />
              </Section>
            </Stack.Item>
            <Stack.Item mt={1} mr={1}>
              <Section title="Settings" height="100%">
                <Button.Checkbox
                  onClick={() => setDisplayMatCost(!displayMatCost)}
                  checked={displayMatCost}
                >
                  Display Material Costs
                </Button.Checkbox>
                <Button.Checkbox
                  onClick={() => setDisplayAllMat(!displayAllMat)}
                  checked={displayAllMat}
                >
                  Display All Materials
                </Button.Checkbox>
                {(species_types && (
                  <Box color="label">
                    Species:
                    <Button onClick={() => act('species')}>{species}</Button>
                  </Box>
                )) ||
                  null}
                {(manufacturers && (
                  <Box color="label">
                    Manufacturer:
                    <Button onClick={() => act('manufacturer')}>
                      {manufacturer}
                    </Button>
                  </Box>
                )) ||
                  null}
              </Section>
            </Stack.Item>
          </Stack>
          <Stack.Item grow m={1}>
            <Stack height="100%" overflowY="hide">
              <Stack.Item position="relative" basis="20%">
                <Section
                  height="100%"
                  overflowY="auto"
                  title="Categories"
                  buttons={
                    <Button onClick={() => act('sync_rnd')}>R&D Sync</Button>
                  }
                >
                  <PartSets />
                </Section>
              </Stack.Item>
              <Stack.Item position="relative" grow>
                <Box fillPositionedParent overflowY="auto">
                  <PartLists
                    queueMaterials={materialTally}
                    materials={materialAsObj}
                  />
                </Box>
              </Stack.Item>
              <Stack.Item width="420px" position="relative">
                <Queue
                  queueMaterials={materialTally}
                  missingMaterials={missingMatTally}
                  textColors={textColors}
                />
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
