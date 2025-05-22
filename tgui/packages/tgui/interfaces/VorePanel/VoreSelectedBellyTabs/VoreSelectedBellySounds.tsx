import { Button, LabeledList, Stack } from 'tgui-core/components';

import type { bellySoundData } from '../types';
import { VorePanelEditSwitch } from '../VorePanelElements/VorePanelEditSwitch';

export const VoreSelectedBellySounds = (props: {
  editMode: boolean;
  bellySoundData: bellySoundData;
}) => {
  const { editMode, bellySoundData } = props;
  const {
    is_wet,
    wet_loop,
    fancy,
    sound,
    release_sound,
    sound_volume,
    noise_freq,
  } = bellySoundData;

  return (
    <Stack>
      <Stack.Item basis="49%" grow>
        <LabeledList>
          <LabeledList.Item label="Fleshy Belly">
            <VorePanelEditSwitch
              action="set_attribute"
              subAction="b_wetness"
              editMode={editMode}
              content={is_wet ? 'Yes' : 'No'}
              active={!!is_wet}
            />
          </LabeledList.Item>
          <LabeledList.Item label="Internal Loop">
            <VorePanelEditSwitch
              action="set_attribute"
              subAction="b_wetloop"
              editMode={editMode}
              content={wet_loop ? 'Yes' : 'No'}
              active={!!wet_loop}
            />
          </LabeledList.Item>
          <LabeledList.Item label="Use Fancy Sounds">
            <VorePanelEditSwitch
              action="set_attribute"
              subAction="b_fancy_sound"
              editMode={editMode}
              content={fancy ? 'Yes' : 'No'}
              active={!!fancy}
            />
          </LabeledList.Item>
        </LabeledList>
      </Stack.Item>
      <Stack.Item basis="49%" grow>
        <LabeledList>
          <LabeledList.Item label="Vore Sound">
            <Button
              onClick={() => act('set_attribute', { attribute: 'b_sound' })}
            >
              {sound}
            </Button>
            <Button
              onClick={() => act('set_attribute', { attribute: 'b_soundtest' })}
              icon="volume-up"
            />
          </LabeledList.Item>
          <LabeledList.Item label="Release Sound">
            <Button
              onClick={() => act('set_attribute', { attribute: 'b_release' })}
            >
              {release_sound}
            </Button>
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_releasesoundtest' })
              }
              icon="volume-up"
            />
          </LabeledList.Item>
          <LabeledList.Item label="Sound Volume">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_sound_volume' })
              }
            >
              {sound_volume + '%'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Noise Frequency">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_noise_freq' })
              }
            >
              {noise_freq}
            </Button>
          </LabeledList.Item>
        </LabeledList>
      </Stack.Item>
    </Stack>
  );
};
