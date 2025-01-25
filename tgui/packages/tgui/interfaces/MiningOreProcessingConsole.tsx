import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Stack } from 'tgui-core/components';
import {
  AnimatedNumber,
  Box,
  Button,
  Dropdown,
  LabeledList,
  Section,
} from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';
import { toTitleCase } from 'tgui-core/string';

import { MiningUser } from './common/Mining';

type Data = {
  unclaimedPoints: number;
  ores: {
    ore: string;
    name: string;
    amount: number;
    processing: number;
  }[];
  showAllOres: BooleanLike;
  power: BooleanLike;
  speed: BooleanLike;
};

export const MiningOreProcessingConsole = (props) => {
  const { act, data } = useBackend<Data>();

  const { unclaimedPoints, power, speed } = data;

  return (
    <Window width={400} height={600}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <MiningUser
              insertIdText={
                <Box>
                  <Button
                    icon="arrow-right"
                    mr={1}
                    onClick={() => act('insert')}
                  >
                    Insert ID
                  </Button>
                  in order to claim points.
                </Box>
              }
            />
          </Stack.Item>
          <Stack.Item>
            <Section
              title="Status"
              buttons={
                <>
                  <Button
                    icon="bolt"
                    selected={speed}
                    onClick={() => act('speed_toggle')}
                  >
                    {speed ? 'High-Speed Active' : 'High-Speed Inactive'}
                  </Button>
                  <Button
                    icon="power-off"
                    selected={power}
                    onClick={() => act('power')}
                  >
                    {power ? 'Smelting' : 'Not Smelting'}
                  </Button>
                </>
              }
            >
              <LabeledList>
                <LabeledList.Item
                  label="Current unclaimed points"
                  buttons={
                    <Button
                      disabled={unclaimedPoints < 1}
                      icon="download"
                      onClick={() => act('claim')}
                    >
                      Claim
                    </Button>
                  }
                >
                  <AnimatedNumber value={unclaimedPoints} />
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Stack.Item>
          <MOPCOres />
        </Stack>
      </Window.Content>
    </Window>
  );
};

// ORDER IS IMPORTANT HERE.
const processingOptions = [
  'Not Processing',
  'Smelting',
  'Compressing',
  'Alloying',
];

// Higher in the list == closer to top
// This is just kind of an arbitrary list to sort by because the machine has no predictable ore order in it's list
// and alphabetizing them doesn't really make sense
const oreOrder = [
  'verdantium',
  'mhydrogen',
  'diamond',
  'platinum',
  'uranium',
  'gold',
  'silver',
  'rutile',
  'phoron',
  'marble',
  'lead',
  'sand',
  'carbon',
  'hematite',
];

const oreSorter = (a, b) => {
  if (oreOrder.indexOf(a.ore) === -1) {
    return a.ore - b.ore;
  }
  if (oreOrder.indexOf(b.ore) === -1) {
    return a.ore - b.ore;
  }
  return oreOrder.indexOf(b.ore) - oreOrder.indexOf(a.ore);
};

const MOPCOres = (props) => {
  const { act, data } = useBackend<Data>();
  const { ores, showAllOres } = data;
  return (
    <Section
      scrollable
      fill
      title="Ore Processing Controls"
      buttons={
        <Button
          icon={showAllOres ? 'toggle-on' : 'toggle-off'}
          selected={showAllOres}
          onClick={() => act('showAllOres')}
        >
          {showAllOres ? 'All Ores' : 'Ores in Machine'}
        </Button>
      }
    >
      <LabeledList>
        {(ores.length &&
          ores.sort(oreSorter).map((ore) => (
            <LabeledList.Item
              key={ore.ore}
              label={toTitleCase(ore.name)}
              buttons={
                <Dropdown
                  autoScroll={false}
                  width="120px"
                  color={
                    (ore.processing === 0 && 'red') ||
                    (ore.processing === 1 && 'green') ||
                    (ore.processing === 2 && 'blue') ||
                    (ore.processing === 3 && 'yellow') ||
                    undefined
                  }
                  options={processingOptions}
                  selected={processingOptions[ore.processing]}
                  onSelected={(val) =>
                    act('toggleSmelting', {
                      ore: ore.ore,
                      set: processingOptions.indexOf(val),
                    })
                  }
                />
              }
            >
              <Box inline>
                <AnimatedNumber value={ore.amount} />
              </Box>
            </LabeledList.Item>
          ))) || (
          <Box color="bad" textAlign="center">
            No ores in machine.
          </Box>
        )}
      </LabeledList>
    </Section>
  );
};
