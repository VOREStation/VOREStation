import { useSharedState } from '../../backend';
import { Box } from '../../components';
import { Window } from '../../layouts';
import { TemporaryNotice } from '../common/TemporaryNotice';
import {
  NEWSCASTER_SCREEN_MAIN,
  NEWSCASTER_SCREEN_NEWCHANNEL,
  NEWSCASTER_SCREEN_NEWSTORY,
  NEWSCASTER_SCREEN_NEWWANTED,
  NEWSCASTER_SCREEN_PRINT,
  NEWSCASTER_SCREEN_SELECTEDCHANNEL,
  NEWSCASTER_SCREEN_VIEWLIST,
  NEWSCASTER_SCREEN_VIEWWANTED,
} from './constants';
import { NewscasterMainMenu } from './NewscasterMainMenu';
import { NewscasterNewChannel } from './NewscasterNewChannel';
import { NewscasterNewStory } from './NewscasterNewStory';
import { NewscasterNewWanted } from './NewscasterNewWanted';
import { NewscasterPrint } from './NewscasterPrint';
import { NewscasterViewList } from './NewscasterViewList';
import { NewscasterViewSelected } from './NewscasterViewSelected';
import { NewscasterViewWanted } from './NewscasterViewWanted';

export const Newscaster = (props) => {
  return (
    <Window width={600} height={600}>
      <Window.Content scrollable>
        <TemporaryNotice decode />
        <NewscasterContent />
      </Window.Content>
    </Window>
  );
};

const NewscasterContent = (props) => {
  const [screen, setScreen] = useSharedState('screen', NEWSCASTER_SCREEN_MAIN);

  const screenToTemplate: React.JSX.Element[] = [];

  screenToTemplate[NEWSCASTER_SCREEN_MAIN] = (
    <NewscasterMainMenu setScreen={setScreen} />
  );
  screenToTemplate[NEWSCASTER_SCREEN_NEWCHANNEL] = (
    <NewscasterNewChannel setScreen={setScreen} />
  );
  screenToTemplate[NEWSCASTER_SCREEN_VIEWLIST] = (
    <NewscasterViewList setScreen={setScreen} />
  );
  screenToTemplate[NEWSCASTER_SCREEN_NEWSTORY] = (
    <NewscasterNewStory setScreen={setScreen} />
  );
  screenToTemplate[NEWSCASTER_SCREEN_PRINT] = (
    <NewscasterPrint setScreen={setScreen} />
  );
  screenToTemplate[NEWSCASTER_SCREEN_NEWWANTED] = (
    <NewscasterNewWanted setScreen={setScreen} />
  );
  screenToTemplate[NEWSCASTER_SCREEN_VIEWWANTED] = (
    <NewscasterViewWanted setScreen={setScreen} />
  );
  screenToTemplate[NEWSCASTER_SCREEN_SELECTEDCHANNEL] = (
    <NewscasterViewSelected setScreen={setScreen} />
  );

  return <Box>{screenToTemplate[screen]}</Box>;
};
