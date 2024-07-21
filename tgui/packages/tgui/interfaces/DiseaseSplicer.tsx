import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Box, Button, LabeledList, ProgressBar, Section } from '../components';
import { Window } from '../layouts';

type Data = {
  dish_inserted: BooleanLike;
  buffer: { name: string; stage: number } | null;
  species_buffer: string | null;
  busy: string | null;
  growth: number;
  effects:
    | { name: string; stage: number; reference: string; badness: number }[]
    | null;
  info: string;
  affected_species: string[] | null;
};

export const DiseaseSplicer = (props) => {
  const { act, data } = useBackend<Data>();

  const { busy } = data;

  return (
    <Window width={400} height={600}>
      <Window.Content scrollable>
        {busy ? (
          <Section title="The Splicer is currently busy." color="bad">
            <center>
              <Box color="bad">{busy}</Box>
            </center>
          </Section>
        ) : (
          <>
            <DiseaseSplicerVirusDish />
            <DiseaseSplicerStorage />
          </>
        )}
      </Window.Content>
    </Window>
  );
};

const DiseaseSplicerVirusDish = (props) => {
  const { act, data } = useBackend<Data>();

  const { dish_inserted, effects, info, growth, affected_species } = data;

  return (
    <Section
      title="Virus Dish"
      buttons={
        <Button
          icon="eject"
          disabled={!dish_inserted}
          onClick={() => act('eject')}
        >
          Eject Dish
        </Button>
      }
    >
      <LabeledList>
        <LabeledList.Item label="Growth Density">
          <ProgressBar
            minValue={0}
            maxValue={100}
            ranges={{
              good: [50, Infinity],
              average: [25, 50],
              bad: [-Infinity, 25],
            }}
            value={growth}
          />
        </LabeledList.Item>
      </LabeledList>
      {info ? (
        <Section>
          <Box color="bad">{info}</Box>
        </Section>
      ) : (
        <>
          <Section title="Symptoms">
            {(effects &&
              effects.map((effect) => (
                <Box color="label" key={effect.stage}>
                  ({effect.stage}) {effect.name}{' '}
                  {effect.badness > 1 ? 'Dangerous!' : null}
                </Box>
              ))) || <Box>No virus sample loaded.</Box>}
          </Section>
          <Section title="Affected Species" color="label">
            {!affected_species || !affected_species.length
              ? 'None'
              : affected_species.sort().join(', ')}
          </Section>
          <Section title="Reverse Engineering">
            <Box color="bad" mb={1}>
              <i>CAUTION: Reverse engineering will destroy the viral sample.</i>
            </Box>
            {effects &&
              effects.map((e) => (
                <Button
                  key={e.stage}
                  icon="exchange-alt"
                  onClick={() => act('grab', { grab: e.reference })}
                >
                  {e.stage}
                </Button>
              ))}
            <Button icon="exchange-alt" onClick={() => act('affected_species')}>
              Species
            </Button>
          </Section>
        </>
      )}
    </Section>
  );
};

const DiseaseSplicerStorage = (props) => {
  const { act, data } = useBackend<Data>();

  const { buffer, species_buffer, info } = data;

  return (
    <Section title="Storage">
      <LabeledList>
        <LabeledList.Item label="Memory Buffer">
          {buffer ? (
            <Box>
              {buffer.name} ({buffer.stage})
            </Box>
          ) : species_buffer ? (
            <Box>{species_buffer}</Box>
          ) : (
            'Empty'
          )}
        </LabeledList.Item>
      </LabeledList>
      <Button
        mt={1}
        icon="save"
        disabled={!buffer && !species_buffer}
        onClick={() => act('disk')}
      >
        Save To Disk
      </Button>
      {buffer ? (
        <Box>
          <Button
            icon="pen"
            disabled={buffer.stage > 1}
            onClick={() => act('splice', { splice: 1 })}
          >
            Splice #1
          </Button>
          <Button
            icon="pen"
            disabled={buffer.stage > 2}
            onClick={() => act('splice', { splice: 2 })}
          >
            Splice #2
          </Button>
          <Button
            icon="pen"
            disabled={buffer.stage > 3}
            onClick={() => act('splice', { splice: 3 })}
          >
            Splice #3
          </Button>
          <Button
            icon="pen"
            disabled={buffer.stage > 4}
            onClick={() => act('splice', { splice: 4 })}
          >
            Splice #4
          </Button>
        </Box>
      ) : species_buffer ? (
        <Box>
          <Button
            icon="pen"
            disabled={!species_buffer || !!info}
            onClick={() => act('splice', { splice: 5 })}
          >
            Splice Species
          </Button>
        </Box>
      ) : null}
    </Section>
  );
};
