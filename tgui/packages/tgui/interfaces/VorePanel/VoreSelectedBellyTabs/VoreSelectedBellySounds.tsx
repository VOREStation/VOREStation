import { Button, LabeledList, Stack } from 'tgui-core/components';

import { useBackend } from '../../../backend';
import type { bellySoundData, DropdownEntry } from '../types';
import { VorePanelEditDropdown } from '../VorePanelElements/VorePanelEditDropdown';
import { VorePanelEditNumber } from '../VorePanelElements/VorePanelEditNumber';
import { VorePanelEditSwitch } from '../VorePanelElements/VorePanelEditSwitch';

export const VoreSelectedBellySounds = (props: {
  editMode: boolean;
  bellySoundData: bellySoundData;
}) => {
  const { act } = useBackend();

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
    vore_sound_list,
    release_sound_list,
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
              tooltip="When enabled, noises are more fleshy and less rustly."
            />
          </LabeledList.Item>
          <LabeledList.Item label="Internal Loop">
            <VorePanelEditSwitch
              action="set_attribute"
              subAction="b_wetloop"
              editMode={editMode}
              content={wet_loop ? 'Yes' : 'No'}
              active={!!wet_loop}
              tooltip="Loops belly sounds."
            />
          </LabeledList.Item>
          <LabeledList.Item label="Use Fancy Sounds">
            <VorePanelEditSwitch
              action="set_attribute"
              subAction="b_fancy_sound"
              editMode={editMode}
              content={fancy ? 'Yes' : 'No'}
              active={!!fancy}
              tooltip="Switch between the fancy and classic sound set."
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
            <Stack>
              <Stack.Item>
                <VorePanelEditDropdown
                  action="set_attribute"
                  subAction="b_sound"
                  editMode={editMode}
                  options={Object.keys(vore_sound_list)}
                  entry={sound}
                />
              </Stack.Item>
              <Stack.Item>
                <Button
                  onClick={() =>
                    act('set_attribute', { attribute: 'b_soundtest' })
                  }
                  icon="volume-up"
                  tooltip="Test your selected belly sound. Usually played to prey inside your belly."
                />
              </Stack.Item>
            </Stack>
          </LabeledList.Item>
          <LabeledList.Item label="Release Sound">
            <Stack>
              <Stack.Item>
                <VorePanelEditDropdown
                  action="set_attribute"
                  subAction="b_release"
                  editMode={editMode}
                  options={Object.keys(release_sound_list)}
                  entry={release_sound}
                />
              </Stack.Item>
              <Stack.Item>
                <Button
                  onClick={() =>
                    act('set_attribute', { attribute: 'b_releasesoundtest' })
                  }
                  icon="volume-up"
                  tooltip="Test your selected release sound. Usually played once prey is released."
                />
              </Stack.Item>
            </Stack>
          </LabeledList.Item>
        </LabeledList>
      </Stack.Item>
    </Stack>
  );
};
