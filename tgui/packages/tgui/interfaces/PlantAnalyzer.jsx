import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const PlantAnalyzer = (props) => {
  const { data } = useBackend();

  let calculatedHeight = 250;
  if (data.seed) {
    calculatedHeight += 18 * data.seed.trait_info.length;
  }
  if (data.reagents && data.reagents.length) {
    calculatedHeight += 55;
    calculatedHeight += 20 * data.reagents.length;
  }

  // Resizable just in case the calculatedHeight fails
  return (
    <Window width={400} height={calculatedHeight}>
      <Window.Content scrollable>
        <PlantAnalyzerContent />
      </Window.Content>
    </Window>
  );
};

const PlantAnalyzerContent = (props) => {
  const { act, data } = useBackend();

  const { no_seed, seed, reagents } = data;

  if (no_seed) {
    return (
      <Section title="Analyzer Unused">
        You should go scan a plant! There is no data currently loaded.
      </Section>
    );
  }

  return (
    <Section
      title="Plant Information"
      buttons={
        <>
          <Button icon="print" onClick={() => act('print')}>
            Print Report
          </Button>
          <Button
            icon="window-close"
            color="red"
            onClick={() => act('close')}
          />
        </>
      }
    >
      <LabeledList>
        <LabeledList.Item label="Plant Name">
          {seed.name}#{seed.uid}
        </LabeledList.Item>
        <LabeledList.Item label="Endurance">{seed.endurance}</LabeledList.Item>
        <LabeledList.Item label="Yield">{seed.yield}</LabeledList.Item>
        <LabeledList.Item label="Maturation Time">
          {seed.maturation_time}
        </LabeledList.Item>
        <LabeledList.Item label="Production Time">
          {seed.production_time}
        </LabeledList.Item>
        <LabeledList.Item label="Potency">{seed.potency}</LabeledList.Item>
      </LabeledList>
      {(reagents.length && (
        <Section level={2} title="Plant Reagents">
          <LabeledList>
            {reagents.map((r) => (
              <LabeledList.Item key={r.name} label={r.name}>
                {r.volume} unit(s).
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Section>
      )) ||
        null}
      <Section level={2} title="Other Data">
        {seed.trait_info.map((trait) => (
          <Box color="label" key={trait} mb={0.4}>
            {trait}
          </Box>
        ))}
      </Section>
    </Section>
  );
};
