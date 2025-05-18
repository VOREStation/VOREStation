import { useBackend } from 'tgui/backend';
import { Button, LabeledList, Stack } from 'tgui-core/components';

import { digestModeToColor } from '../constants';
import type { bellyModeData } from '../types';
import { VorePanelEditText } from '../VorePanelElements/VorePanelEditables';

export const VoreSelectedBellyControls = (props: {
  editMode: boolean;
  belly_name: string;
  bellyModeData: bellyModeData;
}) => {
  const { act } = useBackend();

  const { belly_name, bellyModeData, editMode } = props;
  const { mode, item_mode, addons, name_length } = bellyModeData;

  return (
    <LabeledList>
      <LabeledList.Item
        label="Name"
        buttons={
          <Stack>
            <Stack.Item>
              <Button
                icon="arrow-up"
                tooltipPosition="left"
                tooltip="Move this belly tab up."
                onClick={() => act('move_belly', { dir: -1 })}
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                icon="arrow-down"
                tooltipPosition="left"
                tooltip="Move this belly tab down."
                onClick={() => act('move_belly', { dir: 1 })}
              />
            </Stack.Item>
          </Stack>
        }
      >
        <VorePanelEditText
          editMode={editMode}
          limit={name_length}
          entry={belly_name}
          action={'set_attribute'}
          subAction={'b_name'}
        />
      </LabeledList.Item>
      <LabeledList.Item label="Mode">
        <Button
          color={digestModeToColor[mode]}
          onClick={() => act('set_attribute', { attribute: 'b_mode' })}
        >
          {mode}
        </Button>
      </LabeledList.Item>
      <LabeledList.Item label="Mode Addons">
        {(addons.length && addons.join(', ')) || 'None'}
        <Button
          onClick={() => act('set_attribute', { attribute: 'b_addons' })}
          ml={1}
          icon="plus"
        />
      </LabeledList.Item>
      <LabeledList.Item label="Item Mode">
        <Button
          onClick={() => act('set_attribute', { attribute: 'b_item_mode' })}
        >
          {item_mode}
        </Button>
      </LabeledList.Item>
      <LabeledList.Item>
        <Button.Confirm
          fluid
          icon="exclamation-triangle"
          confirmIcon="trash"
          color="red"
          confirmContent="This is irreversable!"
          onClick={() => act('set_attribute', { attribute: 'b_del' })}
        >
          Delete Belly
        </Button.Confirm>
      </LabeledList.Item>
    </LabeledList>
  );
};
