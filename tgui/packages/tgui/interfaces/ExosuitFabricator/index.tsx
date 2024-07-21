import { useBackend, useSharedState } from '../../backend';
import { Box, Button, Flex, Section } from '../../components';
import { Window } from '../../layouts';
import { materialArrayToObj, queueCondFormat } from './functions';
import { Materials } from './Material';
import { PartLists, PartSets } from './Parts';
import { Queue } from './Queue';
import { Data } from './types';

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
        <Flex fillPositionedParent direction="column">
          <Flex>
            <Flex.Item ml={1} mr={1} mt={1} basis="75%" grow={1}>
              <Section title="Materials">
                <Materials displayAllMat={displayAllMat} />
              </Section>
            </Flex.Item>
            <Flex.Item mt={1} mr={1}>
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
            </Flex.Item>
          </Flex>
          <Flex.Item grow={1} m={1}>
            <Flex spacing={1} height="100%" overflowY="hide">
              <Flex.Item position="relative" basis="20%">
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
              </Flex.Item>
              <Flex.Item position="relative" grow={1}>
                <Box fillPositionedParent overflowY="auto">
                  <PartLists
                    queueMaterials={materialTally}
                    materials={materialAsObj}
                  />
                </Box>
              </Flex.Item>
              <Flex.Item width="420px" position="relative">
                <Queue
                  queueMaterials={materialTally}
                  missingMaterials={missingMatTally}
                  textColors={textColors}
                />
              </Flex.Item>
            </Flex>
          </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  );
};
