import { Button, LabeledList, Stack } from 'tgui-core/components';

import type { bellySoundData, DropdownEntry } from '../types';
import { VorePanelEditDropdown } from '../VorePanelElements/VorePanelEditDropdown';
import { VorePanelEditNumber } from '../VorePanelElements/VorePanelEditNumber';
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
    min_voice_freq,
    max_voice_freq,
  } = bellySoundData;

  const ourPresets: DropdownEntry[] = [
    { displayText: 'high', value: max_voice_freq.toString() },
    { displayText: 'middle-high', value: '56250' },
    { displayText: 'middle', value: '42500' },
    { displayText: 'middle-low', value: '28750' },
    { displayText: 'low', value: min_voice_freq.toString() },
    { displayText: 'random', value: '0' },
  ];

  function getDropdownDisplay(currentFeq: number) {
    const ourEntry = ourPresets.find(
      (preset) => preset.value === currentFeq.toString(),
    );
    if (!ourEntry) {
      return 'custom';
    }
    return ourEntry.displayText;
  }

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
          <LabeledList.Item label="Sound Volume">
            <VorePanelEditNumber
              action="set_attribute"
              subAction="b_sound_volume"
              editMode={editMode}
              value={sound_volume}
              minValue={0}
              maxValue={100}
              unit="%"
              tooltip="Adjust the volume of your vore sounds."
            />
          </LabeledList.Item>
          <LabeledList.Item label="Noise Frequency">
            <Stack>
              <Stack.Item>
                <VorePanelEditNumber
                  action="set_attribute"
                  subAction="b_noise_freq"
                  editMode={editMode}
                  value={noise_freq}
                  minValue={min_voice_freq}
                  maxValue={max_voice_freq}
                />
              </Stack.Item>
              <Stack.Item>
                <VorePanelEditDropdown
                  action="set_attribute"
                  subAction="b_noise_freq"
                  editMode={editMode}
                  options={ourPresets}
                  entry={getDropdownDisplay(noise_freq)}
                  tooltip="Adjust the frequency of your vore sounds. The dropdown contains presets."
                />
              </Stack.Item>
            </Stack>
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
        </LabeledList>
      </Stack.Item>
    </Stack>
  );
};
