import { useBackend } from '../backend';
import { Box, Button, Flex, LabeledList, Section, Slider } from '../components';
import { BeakerContents } from '../interfaces/common/BeakerContents';
import { Window } from '../layouts';

const dispenseAmounts = [5, 10, 20, 30, 40, 60];
const removeAmounts = [1, 5, 10];

export const ChemDispenser = (props) => {
  return (
    <Window width={390} height={655}>
      <Window.Content className="Layout__content--flexColumn">
        <ChemDispenserSettings />
        <ChemDispenserChemicals />
        <ChemDispenserBeaker />
      </Window.Content>
    </Window>
  );
};

const ChemDispenserSettings = (properties) => {
  const { act, data } = useBackend();
  const { amount } = data;
  return (
    <Section title="Settings" flex="content">
      <LabeledList>
        <LabeledList.Item label="Dispense" verticalAlign="middle">
          {dispenseAmounts.map((a, i) => (
            <Button
              key={i}
              textAlign="center"
              selected={amount === a}
              m="0"
              onClick={() =>
                act('amount', {
                  amount: a,
                })
              }
            >
              {a + 'u'}
            </Button>
          ))}
        </LabeledList.Item>
        <LabeledList.Item label="Custom Amount">
          <Slider
            step={1}
            stepPixelSize={5}
            value={amount}
            minValue={1}
            maxValue={120}
            onDrag={(e, value) =>
              act('amount', {
                amount: value,
              })
            }
          />
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const ChemDispenserChemicals = (properties) => {
  const { act, data } = useBackend();
  const { chemicals = [] } = data;
  const flexFillers = [];
  for (let i = 0; i < (chemicals.length + 1) % 3; i++) {
    flexFillers.push(true);
  }
  return (
    <Section
      title={data.glass ? 'Drink Dispenser' : 'Chemical Dispenser'}
      flexGrow="1"
    >
      <Flex direction="row" wrap="wrap" height="100%" align="flex-start">
        {chemicals.map((c, i) => (
          <Flex.Item key={i} grow="1" m={0.2} basis="40%" height="20px">
            <Button
              icon="arrow-circle-down"
              width="100%"
              height="100%"
              align="flex-start"
              onClick={() =>
                act('dispense', {
                  reagent: c.id,
                })
              }
            >
              {c.title + ' (' + c.amount + ')'}
            </Button>
          </Flex.Item>
        ))}
        {flexFillers.map((_, i) => (
          <Flex.Item key={i} grow="1" basis="25%" height="20px" />
        ))}
      </Flex>
    </Section>
  );
};

const ChemDispenserBeaker = (properties) => {
  const { act, data } = useBackend();
  const {
    isBeakerLoaded,
    beakerCurrentVolume,
    beakerMaxVolume,
    beakerContents = [],
  } = data;
  return (
    <Section
      title="Beaker"
      flex="content"
      minHeight="25%"
      buttons={
        <Box>
          {!!isBeakerLoaded && (
            <Box inline color="label" mr={2}>
              {beakerCurrentVolume} / {beakerMaxVolume} units
            </Box>
          )}
          <Button
            icon="eject"
            disabled={!isBeakerLoaded}
            onClick={() => act('ejectBeaker')}
          >
            Eject
          </Button>
        </Box>
      }
    >
      <BeakerContents
        beakerLoaded={isBeakerLoaded}
        beakerContents={beakerContents}
        buttons={(chemical) => (
          <>
            <Button
              icon="compress-arrows-alt"
              onClick={() =>
                act('remove', {
                  reagent: chemical.id,
                  amount: -1,
                })
              }
            >
              Isolate
            </Button>
            {removeAmounts.map((a, i) => (
              <Button
                key={i}
                onClick={() =>
                  act('remove', {
                    reagent: chemical.id,
                    amount: a,
                  })
                }
              >
                {a}
              </Button>
            ))}
            <Button
              onClick={() =>
                act('remove', {
                  reagent: chemical.id,
                  amount: chemical.volume,
                })
              }
            >
              ALL
            </Button>
          </>
        )}
      />
    </Section>
  );
};
