import { useBackend } from 'tgui/backend';
import { Button, LabeledList, Stack } from 'tgui-core/components';

import { digestModeToColor, modeToTooltip } from '../constants';
import type { bellyModeData } from '../types';
import { VorePanelEditCheckboxes } from '../VorePanelElements/VorePanelEditCheckboxes';
import { VorePanelEditDropdown } from '../VorePanelElements/VorePanelEditDropdown';
import { VorePanelEditText } from '../VorePanelElements/VorePanelEditText';

export const VoreSelectedBellyControls = (props: {
  editMode: boolean;
  belly_name: string;
  bellyModeData: bellyModeData;
}) => {
  const { act } = useBackend();

  const { belly_name, bellyModeData, editMode } = props;
  const {
    mode,
    item_mode,
    addons,
    name_length,
    mode_options,
    item_mode_options,
  } = bellyModeData;

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
        <VorePanelEditDropdown
          editMode={editMode}
          options={mode_options}
          entry={mode}
          action={'set_attribute'}
          subAction={'b_mode'}
          color={digestModeToColor[mode]}
        />
      </LabeledList.Item>
      <LabeledList.Item label="Mode Addons">
        <VorePanelEditCheckboxes
          editMode={editMode}
          options={addons}
          action={'set_attribute'}
          subAction={'b_addons'}
          tooltipList={modeToTooltip}
        />
      </LabeledList.Item>
      <LabeledList.Item label="Item Mode">
        <VorePanelEditDropdown
          editMode={editMode}
          options={item_mode_options}
          entry={item_mode}
          action={'set_attribute'}
          subAction={'b_item_mode'}
          color={digestModeToColor[item_mode]}
        />
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
