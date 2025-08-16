import { useBackend } from 'tgui/backend';
import { Button, LabeledList, Stack } from 'tgui-core/components';

import { digestModeToColor, modeToTooltip } from '../constants';
import type { bellyModeData, DropdownEntry } from '../types';
import { VorePanelEditCheckboxes } from '../VorePanelElements/VorePanelEditCheckboxes';
import { VorePanelEditDropdown } from '../VorePanelElements/VorePanelEditDropdown';
import { VorePanelEditText } from '../VorePanelElements/VorePanelEditText';

export const VoreSelectedBellyControls = (props: {
  bellyDropdownNames: DropdownEntry[];
  editMode: boolean;
  belly_name: string;
  bellyModeData: bellyModeData;
}) => {
  const { act } = useBackend();

  const { bellyDropdownNames, belly_name, bellyModeData, editMode } = props;
  const {
    mode,
    item_mode,
    addons,
    name_length,
    name_min,
    mode_options,
    item_mode_options,
  } = bellyModeData;

  const bellyNames = bellyDropdownNames.map((belly) => {
    return belly.displayText;
  });

  return (
    <LabeledList>
      {editMode && (
        <LabeledList.Item
          buttons={
            <Stack>
              {bellyNames.indexOf(belly_name) !== 0 && (
                <Stack.Item
                  mr={
                    bellyNames.indexOf(belly_name) === bellyNames.length - 1
                      ? '28px'
                      : undefined
                  }
                >
                  <Button
                    icon="arrow-up"
                    tooltipPosition="left"
                    tooltip="Move this belly tab up."
                    onClick={() => act('move_belly', { dir: -1 })}
                  />
                </Stack.Item>
              )}
              {bellyNames.indexOf(belly_name) !== bellyNames.length - 1 && (
                <Stack.Item>
                  <Button
                    icon="arrow-down"
                    tooltipPosition="left"
                    tooltip="Move this belly tab down."
                    onClick={() => act('move_belly', { dir: 1 })}
                  />
                </Stack.Item>
              )}
            </Stack>
          }
        />
      )}
      <LabeledList.Item label="Name">
        <VorePanelEditText
          editMode={editMode}
          limit={name_length}
          min={name_min}
          entry={belly_name}
          action={'set_attribute'}
          subAction={'b_name'}
          tooltip={
            'Adjust the name of your belly. [' +
            name_min +
            '-' +
            name_length +
            ' characters].'
          }
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
          tooltip="The digest mode which will be applied for prey."
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
          tooltip="The digest mode which will be applied for items."
        />
      </LabeledList.Item>
      {editMode && (
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
      )}
    </LabeledList>
  );
};
