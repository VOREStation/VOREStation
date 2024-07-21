import { useBackend } from '../../backend';
import { Button, Section } from '../../components';
import {
  NEWSCASTER_SCREEN_NEWCHANNEL,
  NEWSCASTER_SCREEN_NEWSTORY,
  NEWSCASTER_SCREEN_NEWWANTED,
  NEWSCASTER_SCREEN_PRINT,
  NEWSCASTER_SCREEN_VIEWLIST,
  NEWSCASTER_SCREEN_VIEWWANTED,
} from './constants';
import { Data } from './types';

export const NewscasterMainMenu = (props: { setScreen: Function }) => {
  const { data } = useBackend<Data>();

  const { securityCaster, wanted_issue } = data;

  const { setScreen } = props;

  return (
    <>
      <Section title="Main Menu">
        {wanted_issue && (
          <Button
            fluid
            icon="eye"
            onClick={() => setScreen(NEWSCASTER_SCREEN_VIEWWANTED)}
            color="bad"
          >
            Read WANTED Issue
          </Button>
        )}
        <Button
          fluid
          icon="eye"
          onClick={() => setScreen(NEWSCASTER_SCREEN_VIEWLIST)}
        >
          View Feed Channels
        </Button>
        <Button
          fluid
          icon="plus"
          onClick={() => setScreen(NEWSCASTER_SCREEN_NEWCHANNEL)}
        >
          Create Feed Channel
        </Button>
        <Button
          fluid
          icon="plus"
          onClick={() => setScreen(NEWSCASTER_SCREEN_NEWSTORY)}
        >
          Create Feed Message
        </Button>
        <Button
          fluid
          icon="print"
          onClick={() => setScreen(NEWSCASTER_SCREEN_PRINT)}
        >
          Print Newspaper
        </Button>
      </Section>
      {!!securityCaster && (
        <Section title="Feed Security Functions">
          <Button
            fluid
            icon="plus"
            onClick={() => setScreen(NEWSCASTER_SCREEN_NEWWANTED)}
          >
            Manage &quot;Wanted&quot; Issue
          </Button>
        </Section>
      )}
    </>
  );
};
