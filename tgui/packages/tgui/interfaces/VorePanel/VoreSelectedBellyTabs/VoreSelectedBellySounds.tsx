import { useBackend } from '../../../backend';
import { Button, Flex, LabeledList } from '../../../components';
import { selectedData } from '../types';

export const VoreSelectedBellySounds = (props: { belly: selectedData }) => {
  const { act } = useBackend();

  const { belly } = props;
  const { is_wet, wet_loop, fancy, sound, release_sound } = belly;

  return (
    <Flex wrap="wrap">
      <Flex.Item basis="49%" grow={1}>
        <LabeledList>
          <LabeledList.Item label="Fleshy Belly">
            <Button
              onClick={() => act('set_attribute', { attribute: 'b_wetness' })}
              icon={is_wet ? 'toggle-on' : 'toggle-off'}
              selected={is_wet}
            >
              {is_wet ? 'Yes' : 'No'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Internal Loop">
            <Button
              onClick={() => act('set_attribute', { attribute: 'b_wetloop' })}
              icon={wet_loop ? 'toggle-on' : 'toggle-off'}
              selected={wet_loop}
            >
              {wet_loop ? 'Yes' : 'No'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Use Fancy Sounds">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_fancy_sound' })
              }
              icon={fancy ? 'toggle-on' : 'toggle-off'}
              selected={fancy}
            >
              {fancy ? 'Yes' : 'No'}
            </Button>
          </LabeledList.Item>
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
      </Flex.Item>
    </Flex>
  );
};
