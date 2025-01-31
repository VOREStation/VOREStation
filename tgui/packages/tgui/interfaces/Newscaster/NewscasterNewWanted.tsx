import { useBackend } from 'tgui/backend';
import { Button, Input, LabeledList, Section } from 'tgui-core/components';
import { decodeHtmlEntities } from 'tgui-core/string';

import { NEWSCASTER_SCREEN_MAIN } from './constants';
import { Data } from './types';

export const NewscasterNewWanted = (props: { setScreen: Function }) => {
  const { act, data } = useBackend<Data>();

  const { channel_name, msg, photo_data, user, wanted_issue } = data;

  const { setScreen } = props;

  return (
    <Section
      title="Wanted Issue Handler"
      buttons={
        <Button icon="undo" onClick={() => setScreen(NEWSCASTER_SCREEN_MAIN)}>
          Back
        </Button>
      }
    >
      <LabeledList>
        {!!wanted_issue && (
          <LabeledList.Item label="Already In Circulation">
            A wanted issue is already in circulation. You can edit or cancel it
            below.
          </LabeledList.Item>
        )}
        <LabeledList.Item label="Criminal Name">
          <Input
            fluid
            updateOnPropsChange
            value={decodeHtmlEntities(channel_name)}
            onInput={(e, val) => act('set_channel_name', { val: val })}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Description">
          <Input
            fluid
            updateOnPropsChange
            value={decodeHtmlEntities(msg)}
            onInput={(e, val) => act('set_wanted_desc', { val: val })}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Attach Photo">
          <Button fluid icon="image" onClick={() => act('set_attachment')}>
            {photo_data ? 'Photo Attached' : 'No Photo'}
          </Button>
        </LabeledList.Item>
        <LabeledList.Item label="Prosecutor" color="good">
          {user}
        </LabeledList.Item>
      </LabeledList>
      <Button
        mt={1}
        fluid
        color="good"
        icon="plus"
        onClick={() => act('submit_wanted')}
      >
        Submit Wanted Issue
      </Button>
      {!!wanted_issue && (
        <Button
          fluid
          color="average"
          icon="minus"
          onClick={() => act('cancel_wanted')}
        >
          Take Down Issue
        </Button>
      )}
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
