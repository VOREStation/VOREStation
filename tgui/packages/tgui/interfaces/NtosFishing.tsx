import { useBackend } from 'tgui/backend';
import { NtosWindow } from 'tgui/layouts';

import { GameWindow as FishingGame } from './FishingMinigame';

type Data = {
  PC_device_theme: string;
};

export const NtosFishing = (props) => {
  const { act, data } = useBackend<Data>();
  return (
    <NtosWindow theme={data.PC_device_theme} width={340} height={530}>
      <NtosWindow.Content>
        <FishingGame onLose={() => act('lose')} onWin={() => act('win')} />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
