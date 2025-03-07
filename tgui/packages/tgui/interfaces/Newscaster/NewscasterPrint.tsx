import { useBackend } from 'tgui/backend';
import { Box, Button, LabeledList, Section } from 'tgui-core/components';

import { NEWSCASTER_SCREEN_MAIN } from './constants';
import type { Data } from './types';

export const NewscasterPrint = (props: { setScreen: Function }) => {
  const { act, data } = useBackend<Data>();

  const { total_num, active_num, message_num, paper_remaining } = data;

  const { setScreen } = props;

  return (
    <Section
      title="Printing"
      buttons={
        <Button icon="undo" onClick={() => setScreen(NEWSCASTER_SCREEN_MAIN)}>
          Back
        </Button>
      }
    >
      <Box color="label" mb={1}>
        Newscaster currently serves a total of {total_num} Feed channels,{' '}
        {active_num} of which are active, and a total of {message_num} Feed
        stories.
      </Box>
      <LabeledList>
        <LabeledList.Item label="Liquid Paper remaining">
          {paper_remaining * 100} cm&sup3;
        </LabeledList.Item>
      </LabeledList>
      <Button
        mt={1}
        fluid
        color="good"
        icon="plus"
        onClick={() => act('print_paper')}
      >
        Print Paper
      </Button>
      <Button
        fluid
        color="bad"
        icon="undo"
        onClick={() => setScreen(NEWSCASTER_SCREEN_MAIN)}
      >
        Cancel
      </Button>
    </Section>
  );
};
