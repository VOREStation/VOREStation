import { useState } from 'react';

import { useBackend } from '../../backend';
import { Box } from '../../components';
import { Window } from '../../layouts';
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
import { Data } from './types';

export const Communicator = () => {
  const { act, data } = useBackend<Data>();

  const { currentTab, video_comm } = data;

  const tab: React.JSX.Element[] = [];

  const [videoSetting, setVideoSetting] = useState(0);
  const [clipboardMode, setClipboardMode] = useState(false);

  function handleClipboardMode(value: boolean) {
    setClipboardMode(value);
  }

  tab[tabs[0]] = <CommunicatorHomeTab />;
  tab[tabs[1]] = <CommunicatorPhoneTab />;
  tab[tabs[2]] = <CommunicatorContactTab />;
  tab[tabs[3]] = <CommunicatorMessageTab />;
  tab[tabs[4]] = (
    <CommunicatorMessageSubTab
      clipboardMode={clipboardMode}
      onClipboardMode={handleClipboardMode}
    />
  );
  tab[tabs[5]] = <CommunicatorNewsTab />;
  tab[tabs[6]] = <CommunicatorNoteTab />;
  tab[tabs[7]] = <CommunicatorWeatherTab />;
  tab[tabs[8]] = <CrewManifestContent />;
  tab[tabs[9]] = <CommunicatorSettingsTab />;

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
