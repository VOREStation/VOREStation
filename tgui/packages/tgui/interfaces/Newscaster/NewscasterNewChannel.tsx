import { decodeHtmlEntities } from 'common/string';

import { useBackend } from '../../backend';
import { Button, Input, LabeledList, Section } from '../../components';
import { NEWSCASTER_SCREEN_MAIN } from './constants';
import { Data } from './types';

export const NewscasterNewChannel = (props: { setScreen: Function }) => {
  const { act, data } = useBackend<Data>();

  const { channel_name, c_locked, user } = data;

  const { setScreen } = props;

  return (
    <Section
      title="Creating new Feed Channel"
      buttons={
        <Button icon="undo" onClick={() => setScreen(NEWSCASTER_SCREEN_MAIN)}>
          Back
        </Button>
      }
    >
      <LabeledList>
        <LabeledList.Item label="Channel Name">
          <Input
            fluid
            value={decodeHtmlEntities(channel_name)}
            onInput={(e, val: string) => act('set_channel_name', { val: val })}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Channel Author" color="good">
          {user}
        </LabeledList.Item>
        <LabeledList.Item label="Accept Public Feeds">
          <Button
            icon={c_locked ? 'lock' : 'lock-open'}
            selected={!c_locked}
            onClick={() => act('set_channel_lock')}
          >
            {c_locked ? 'No' : 'Yes'}
          </Button>
        </LabeledList.Item>
      </LabeledList>
      <Button
        fluid
        color="good"
        icon="plus"
        onClick={() => act('submit_new_channel')}
      >
        Submit Channel
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
