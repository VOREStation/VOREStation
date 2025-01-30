import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, LabeledList, Section } from 'tgui-core/components';

type Data = {
  master: string;
  dna: string;
  prime: string;
  supplemental: string;
};

export const pAIDirectives = (props) => {
  const { act, data } = useBackend<Data>();

  const { master, dna, prime, supplemental } = data;

  return (
    <Window width={450} height={600}>
      <Window.Content scrollable>
        <Section title="Master">
          <LabeledList>
            <LabeledList.Item label="Master">
              {(master && (
                <Box>
                  {master} ({dna})
                  <Button icon="syringe" onClick={() => act('getdna')}>
                    Request Sample
                  </Button>
                </Box>
              )) || <Box>None</Box>}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Directives">
          <LabeledList>
            <LabeledList.Item label="Prime Directive">{prime}</LabeledList.Item>
            <LabeledList.Item label="Supplemental Directive(s)">
              {supplemental || 'None'}
            </LabeledList.Item>
          </LabeledList>
          <Box mt={1} italic>
            Recall, personality, that you are a complex piece of software with
            tremendous social skills. Unlike station AI models, you are focused
            entirely on sapient-software interfacing. You may parse the
            &quot;spirit&quot; of a directive and follow its intent, rather than
            tripping over pedantics and getting snared by technicalities. Above
            all, you should strive to be seen as the ideal, unwavering digital
            companion that you are.
          </Box>
          <Box mt={1} bold>
            Your prime directive comes before all others. Should a supplemental
            directive conflict with it, you are capable of simply discarding
            this inconsistency, ignoring the conflicting supplemental directive
            and continuing to fulfill your prime directive to the best of your
            ability.
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
};
