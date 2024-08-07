import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Box, Button, Flex, LabeledList, Section } from '../components';
import { Window } from '../layouts';

type Data = {
  antibodies: string | null;
  pathogens: { name: string; spread_type: string; reference: string }[];
  is_antibody_sample: BooleanLike;
  busy: string | null;
  sample_inserted: BooleanLike;
};

export const IsolationCentrifuge = (props) => {
  const { act, data } = useBackend<Data>();

  const { busy, antibodies, pathogens, is_antibody_sample, sample_inserted } =
    data;

  let blood_sample = <Box color="average">No vial detected.</Box>;

  if (sample_inserted) {
    if (!antibodies && !pathogens) {
      blood_sample = (
        <Box color="average">No antibodies or viral strains detected.</Box>
      );
    } else {
      blood_sample = (
        <>
          {antibodies ? <Section title="Antibodies">{antibodies}</Section> : ''}
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
          ) : (
            ''
          )}
        </>
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
          <>
            <Section
              title={is_antibody_sample ? 'Antibody Sample' : 'Blood Sample'}
            >
              <Flex spacing={1} mb={1}>
                <Flex.Item grow={1}>
                  <Button
                    fluid
                    icon="print"
                    disabled={!antibodies && !pathogens.length}
                    onClick={() => act('print')}
                  >
                    Print
                  </Button>
                </Flex.Item>
                <Flex.Item grow={1}>
                  <Button
                    fluid
                    icon="eject"
                    disabled={!sample_inserted}
                    onClick={() => act('sample')}
                  >
                    Eject Vial
                  </Button>
                </Flex.Item>
              </Flex>
              {blood_sample}
            </Section>
            {(antibodies && !is_antibody_sample) || pathogens.length ? (
              <Section title="Controls">
                <LabeledList>
                  {antibodies && !is_antibody_sample ? (
                    <LabeledList.Item label="Isolate Antibodies">
                      <Button icon="pen" onClick={() => act('antibody')}>
                        {antibodies}
                      </Button>
                    </LabeledList.Item>
                  ) : (
                    ''
                  )}
                  {pathogens.length ? (
                    <LabeledList.Item label="Isolate Strain">
                      {pathogens.map((virus) => (
                        <Button
                          key={virus.name}
                          icon="pen"
                          onClick={() =>
                            act('isolate', { isolate: virus.reference })
                          }
                        >
                          {virus.name}
                        </Button>
                      ))}
                    </LabeledList.Item>
                  ) : (
                    ''
                  )}
                </LabeledList>
              </Section>
            ) : (
              ''
            )}
          </>
        )}
      </Window.Content>
    </Window>
  );
};
