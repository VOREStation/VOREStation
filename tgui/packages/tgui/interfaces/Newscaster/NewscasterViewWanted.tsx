import { useBackend } from 'tgui/backend';
import { Box, Button, Image, LabeledList, Section } from 'tgui-core/components';
import { decodeHtmlEntities } from 'tgui-core/string';

import { NEWSCASTER_SCREEN_MAIN } from './constants';
import type { Data } from './types';

export const NewscasterViewWanted = (props: { setScreen: Function }) => {
  const { data } = useBackend<Data>();

  const { wanted_issue } = data;

  const { setScreen } = props;

  if (!wanted_issue) {
    return (
      <Section
        title="No Outstanding Wanted Issues"
        buttons={
          <Button icon="undo" onClick={() => setScreen(NEWSCASTER_SCREEN_MAIN)}>
            Back
          </Button>
        }
      >
        There are no wanted issues currently outstanding.
      </Section>
    );
  }

  return (
    <Section
      title="--STATIONWIDE WANTED ISSUE--"
      color="bad"
      buttons={
        <Button icon="undo" onClick={() => setScreen(NEWSCASTER_SCREEN_MAIN)}>
          Back
        </Button>
      }
    >
      <Box color="white">
        <LabeledList>
          <LabeledList.Item label="Submitted by" color="good">
            {decodeHtmlEntities(wanted_issue.author)}
          </LabeledList.Item>
          <LabeledList.Divider />
          <LabeledList.Item label="Criminal">
            {decodeHtmlEntities(wanted_issue.criminal)}
          </LabeledList.Item>
          <LabeledList.Item label="Description">
            {decodeHtmlEntities(wanted_issue.desc)}
          </LabeledList.Item>
          <LabeledList.Item label="Photo">
            {(wanted_issue.img && <Image src={wanted_issue.img} />) || 'None'}
          </LabeledList.Item>
        </LabeledList>
      </Box>
    </Section>
  );
};
