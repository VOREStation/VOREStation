import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { ActivityTab } from 'tgui/components/ActivityTab';
import { Window } from 'tgui/layouts';
import { Box } from 'tgui-core/components';
import { CrewManifestContent } from '../CrewManifest';
import { CommunicatorContactTab } from './CommunicatorContactTab';
import {
  CommunicatorFooter,
  CommunicatorHeader,
  TemplateError,
  VideoComm,
} from './CommunicatorGeneral';
import { CommunicatorHomeTab } from './CommunicatorHomeTab';
import { CommunicatorMessageSubTab } from './CommunicatorMessageSubTab';
import { CommunicatorMessageTab } from './CommunicatorMessageTab';
import { CommunicatorNewsTab } from './CommunicatorNewsTab';
import { CommunicatorNoteTab } from './CommunicatorNoteTab';
import { CommunicatorPhoneTab } from './CommunicatorPhoneTab';
import { CommunicatorSettingsTab } from './CommunicatorSettingsTab';
import { CommunicatorWeatherTab } from './CommunicatorWeatherTab';
import { notFound, tabs } from './constants';
import type { Data } from './types';

export const Communicator = () => {
  const { act, data } = useBackend<Data>();

  const { currentTab, video_comm } = data;

  const tab: React.JSX.Element[] = [];

  const [videoSetting, setVideoSetting] = useState(0);
  const [clipboardMode, setClipboardMode] = useState(false);

  tab[tabs[0]] = <ActivityTab Component={CommunicatorHomeTab} props={{}} />;
  tab[tabs[1]] = <ActivityTab Component={CommunicatorPhoneTab} props={{}} />;
  tab[tabs[2]] = <ActivityTab Component={CommunicatorContactTab} props={{}} />;
  tab[tabs[3]] = <ActivityTab Component={CommunicatorMessageTab} props={{}} />;
  tab[tabs[4]] = (
    <ActivityTab
      Component={CommunicatorMessageSubTab}
      props={{ clipboardMode, onClipboardMode: setClipboardMode }}
    />
  );
  tab[tabs[5]] = <ActivityTab Component={CommunicatorNewsTab} props={{}} />;
  tab[tabs[6]] = <ActivityTab Component={CommunicatorNoteTab} props={{}} />;
  tab[tabs[7]] = <ActivityTab Component={CommunicatorWeatherTab} props={{}} />;
  tab[tabs[8]] = <ActivityTab Component={CrewManifestContent} props={{}} />;
  tab[tabs[9]] = <ActivityTab Component={CommunicatorSettingsTab} props={{}} />;

  return (
    <Window width={475} height={700}>
      <Window.Content>
        {video_comm && (
          <VideoComm
            videoSetting={videoSetting}
            setVideoSetting={setVideoSetting}
          />
        )}
        {(!video_comm || videoSetting !== 0) && (
          <>
            <CommunicatorHeader />
            <Box
              height="88%"
              mb={1}
              style={{
                overflowY: 'auto',
              }}
            >
              {tab[currentTab] ||
                (notFound(currentTab) && (
                  <TemplateError currentTab={currentTab} />
                ))}
            </Box>
            <CommunicatorFooter
              videoSetting={videoSetting}
              setVideoSetting={setVideoSetting}
            />
          </>
        )}
      </Window.Content>
    </Window>
  );
};
