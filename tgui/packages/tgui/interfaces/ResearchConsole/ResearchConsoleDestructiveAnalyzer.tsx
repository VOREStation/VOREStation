import { useBackend } from '../../backend';
import { Box, Button, LabeledList, Section } from '../../components';
import { Data } from './types';

export const ResearchConsoleDestructiveAnalyzer = (props) => {
  const { act, data } = useBackend<Data>();

  const { linked_destroy } = data.info;

  if (!linked_destroy.present) {
    return (
      <Section title="Destructive Analyzer">
        No destructive analyzer found.
      </Section>
    );
  }

  const { loaded_item, origin_tech } = linked_destroy;

  return (
    <Section title="Destructive Analyzer">
      {(loaded_item && (
        <Box>
          <LabeledList>
            <LabeledList.Item label="Name">{loaded_item}</LabeledList.Item>
            <LabeledList.Item label="Origin Tech">
              <LabeledList>
                {(origin_tech.length &&
                  origin_tech.map((tech) => (
                    <LabeledList.Item label={tech.name} key={tech.name}>
                      {tech.level}&nbsp;&nbsp;
                      {tech.current && '(Current: ' + tech.current + ')'}
                    </LabeledList.Item>
                  ))) || (
                  <LabeledList.Item label="Error">
                    No origin tech found.
                  </LabeledList.Item>
                )}
              </LabeledList>
            </LabeledList.Item>
          </LabeledList>
          <Button
            mt={1}
            color="red"
            icon="eraser"
            onClick={() => act('deconstruct')}
          >
            Deconstruct Item
          </Button>
          <Button icon="eject" onClick={() => act('eject_item')}>
            Eject Item
          </Button>
        </Box>
      )) || <Box>No Item Loaded. Standing-by...</Box>}
    </Section>
  );
};
