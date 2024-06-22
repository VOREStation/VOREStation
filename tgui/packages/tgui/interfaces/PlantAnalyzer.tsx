import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

type Data = {
  no_seed: BooleanLike;
  seed: {
    name: string;
    uid: number;
    endurance: string;
    yield: string;
    maturation_time: string;
    production_time: string;
    potency: string;
    trait_info: string[];
  };
  reagents: { name: string; volume: number }[];
};

export const PlantAnalyzer = (props) => {
  const { data } = useBackend<Data>();

  const { seed, reagents } = data;

  let calculatedHeight = 250;
  if (seed) {
    calculatedHeight += 18 * seed.trait_info.length;
  }
  if (reagents && reagents.length) {
    calculatedHeight += 55;
    calculatedHeight += 20 * reagents.length;
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
  const { act, data } = useBackend<Data>();

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
        <Section title="Plant Reagents">
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
      <Section title="Other Data">
        {seed.trait_info.map((trait) => (
          <Box color="label" key={trait} mb={0.4}>
            {trait}
          </Box>
        ))}
      </Section>
    </Section>
  );
};
