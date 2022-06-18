import { Fragment } from 'inferno';
import { useBackend } from "../backend";
import { Box, Button, LabeledList, ProgressBar, Section } from "../components";
import { Window } from "../layouts";

export const DiseaseSplicer = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    busy,
  } = data;

  return (
    <Window width={400} height={600}>
      <Window.Content scrollable>
        {busy ? (
          <Section title="The Splicer is currently busy." color="bad">
            <center><Box color="bad">{busy}</Box></center>
          </Section>
        ) : (
          <Fragment>
            <DiseaseSplicerVirusDish />
            <DiseaseSplicerStorage />
          </Fragment>
        )}
      </Window.Content>
    </Window>
  );
};

const DiseaseSplicerVirusDish = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    dish_inserted,
    effects,
    info,
    growth,
    affected_species,
  } = data;

  return (
    <Section title="Virus Dish" buttons={
      <Button
        icon="eject"
        content="Eject Dish"
        disabled={!dish_inserted}
        onClick={() => act("eject")} />
    }>
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
            value={growth} />
        </LabeledList.Item>
      </LabeledList>
      {info ? (
        <Section level={2}>
          <Box color="bad">{info}</Box>
        </Section>
      ) : (
        <Fragment>
          <Section level={2} title="Symptoms">
            {effects && effects.map(effect => (
              <Box color="label" key={effect.stage}>
                ({effect.stage}) {effect.name} {effect.badness > 1 ? "Dangerous!" : null}
              </Box>
            )) || <Box>No virus sample loaded.</Box>}
          </Section>
          <Section level={2} title="Affected Species" color="label">
            {(!affected_species || !affected_species.length) ? "None" : null}
            {affected_species.sort().join(", ")}
          </Section>
          <Section level={2} title="Reverse Engineering">
            <Box color="bad" mb={1}><i>CAUTION: Reverse engineering will destroy the viral sample.</i></Box>
            {effects.map(e => (
              <Button
                key={e.stage}
                content={e.stage}
                icon="exchange-alt"
                onClick={() => act("grab", { grab: e.reference })} />
            ))}
            <Button
              content="Species"
              icon="exchange-alt"
              onClick={() => act("affected_species")} />
          </Section>
        </Fragment>
      )}
    </Section>
  );
};

const DiseaseSplicerStorage = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    dish_inserted,
    buffer,
    species_buffer,
    effects,
    info,
    growth,
    affected_species,
    busy,
  } = data;

  return (
    <Section title="Storage">
      <LabeledList>
        <LabeledList.Item label="Memory Buffer">
          {buffer ? (
            <Box>
              {buffer.name} ({buffer.stage})
            </Box>
          ) : (species_buffer ? (
            <Box>
              {species_buffer}
            </Box>
          ) : "Empty")}
        </LabeledList.Item>
      </LabeledList>
      <Button
        mt={1}
        icon="save"
        content="Save To Disk"
        disabled={!buffer && !species_buffer}
        onClick={() => act("disk")} />
      {buffer ? (
        <Box>
          <Button
            icon="pen"
            content="Splice #1"
            disabled={buffer.stage > 1}
            onClick={() => act("splice", { splice: 1 })} />
          <Button
            icon="pen"
            content="Splice #2"
            disabled={buffer.stage > 2}
            onClick={() => act("splice", { splice: 2 })} />
          <Button
            icon="pen"
            content="Splice #3"
            disabled={buffer.stage > 3}
            onClick={() => act("splice", { splice: 3 })} />
          <Button
            icon="pen"
            content="Splice #4"
            disabled={buffer.stage > 4}
            onClick={() => act("splice", { splice: 4 })} />
        </Box>
      ) : (species_buffer ? (
        <Box>
          <Button
            icon="pen"
            content="Splice Species"
            disabled={!species_buffer || info}
            onClick={() => act("splice", { splice: 5 })} />
        </Box>
      ) : null)}
    </Section>
  );
};
