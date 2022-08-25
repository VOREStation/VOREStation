import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Box, Button, Flex, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const IsolationCentrifuge = (props, context) => {
  const { act, data } = useBackend(context);

  const { busy, antibodies, pathogens, is_antibody_sample, sample_inserted } = data;

  let blood_sample = <Box color="average">No vial detected.</Box>;

  if (sample_inserted) {
    if (!antibodies && !pathogens) {
      blood_sample = <Box color="average">No antibodies or viral strains detected.</Box>;
    } else {
      blood_sample = (
        <Fragment>
          {antibodies ? <Section title="Antibodies">{antibodies}</Section> : null}
          {pathogens.length ? (
            <Section title="Pathogens">
              <LabeledList>
                {pathogens.map((virus) => (
                  <LabeledList.Item label={virus.name} key={virus.name}>
                    {virus.spread_type}
                  </LabeledList.Item>
                ))}
              </LabeledList>
            </Section>
          ) : null}
        </Fragment>
      );
    }
  }

  return (
    <Window width={400} height={500}>
      <Window.Content scrollable>
        {busy ? (
          <Section title="The Centrifuge is currently busy." color="bad">
            <center>
              <Box color="bad">{busy}</Box>
            </center>
          </Section>
        ) : (
          <Fragment>
            <Section title={is_antibody_sample ? 'Antibody Sample' : 'Blood Sample'}>
              <Flex spacing={1} mb={1}>
                <Flex.Item grow={1}>
                  <Button
                    fluid
                    icon="print"
                    content="Print"
                    disabled={!antibodies && !pathogens.length}
                    onClick={() => act('print')}
                  />
                </Flex.Item>
                <Flex.Item grow={1}>
                  <Button
                    fluid
                    icon="eject"
                    content="Eject Vial"
                    disabled={!sample_inserted}
                    onClick={() => act('sample')}
                  />
                </Flex.Item>
              </Flex>
              {blood_sample}
            </Section>
            {(antibodies && !is_antibody_sample) || pathogens.length ? (
              <Section title="Controls">
                <LabeledList>
                  {antibodies && !is_antibody_sample ? (
                    <LabeledList.Item label="Isolate Antibodies">
                      <Button icon="pen" content={antibodies} onClick={() => act('antibody')} />
                    </LabeledList.Item>
                  ) : null}
                  {pathogens.length ? (
                    <LabeledList.Item label="Isolate Strain">
                      {pathogens.map((virus) => (
                        <Button
                          key={virus.name}
                          icon="pen"
                          content={virus.name}
                          onClick={() => act('isolate', { isolate: virus.reference })}
                        />
                      ))}
                    </LabeledList.Item>
                  ) : null}
                </LabeledList>
              </Section>
            ) : null}
          </Fragment>
        )}
      </Window.Content>
    </Window>
  );
};
