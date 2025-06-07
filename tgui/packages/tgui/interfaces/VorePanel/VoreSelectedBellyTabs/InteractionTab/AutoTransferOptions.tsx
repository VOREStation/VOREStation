import { LabeledList, Section, Stack } from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';

import type { autoTransferOption, DropdownEntry } from '../../types';
import { VorePanelEditCheckboxes } from '../../VorePanelElements/VorePanelEditCheckboxes';
import { VorePanelEditDropdown } from '../../VorePanelElements/VorePanelEditDropdown';
import { VorePanelEditNumber } from '../../VorePanelElements/VorePanelEditNumber';

export const AutoTransferOptions = (props: {
  editMode: boolean;
  title: string;
  bellyDropdownNames: DropdownEntry[];
  locationNames: DropdownEntry[];
  autotransferData: autoTransferOption;
}) => {
  const {
    editMode,
    title,
    bellyDropdownNames,
    locationNames,
    autotransferData,
  } = props;
  const {
    autotransferchance,
    autotransferlocation,
    autotransferextralocation,
    autotransfer_whitelist,
    autotransfer_blacklist,
    autotransfer_whitelist_items,
    autotransfer_blacklist_items,
  } = autotransferData;

  const transferCheckboxes = bellyDropdownNames.map((entry) => {
    return {
      label: entry.displayText,
      ref: entry.value,
      selection: autotransferextralocation.includes(entry.displayText),
    };
  });

  return (
    <Section title={capitalize(title) + ' Auto-Transfer'}>
      <Stack vertical fill>
        <Stack.Item>
          <Stack>
            <Stack.Item basis="49%" grow>
              <LabeledList.Item label="Auto-Transfer Chance">
                <VorePanelEditNumber
                  action="set_attribute"
                  subAction={'b_autotransferchance_' + title}
                  editMode={editMode}
                  value={autotransferchance}
                  unit="%"
                  minValue={0}
                  maxValue={100}
                  tooltip={
                    'Set ' +
                    title +
                    ' belly auto-transfer chance. You must also set the location for this to have any effect.'
                  }
                />
              </LabeledList.Item>
            </Stack.Item>
            <Stack.Item basis="49%" grow>
              <LabeledList.Item label="Auto-Transfer Location">
                <VorePanelEditDropdown
                  action="set_attribute"
                  subAction={'b_autotransferlocation_' + title}
                  editMode={editMode}
                  options={locationNames}
                  color={!editMode && !autotransferlocation ? 'red' : undefined}
                  entry={
                    autotransferlocation ? autotransferlocation : 'Disabled'
                  }
                  tooltip={
                    'Target location of the ' + title + ' auto-transfer.'
                  }
                />
              </LabeledList.Item>
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item>
          <LabeledList>
            <LabeledList.Item label="Auto-Transfer Extra Location">
              <VorePanelEditCheckboxes
                editMode={editMode}
                options={transferCheckboxes}
                action="set_attribute"
                subAction={'b_autotransferextralocation_' + title}
                tooltip={'Set additional ' + title + ' transfer locations.'}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Auto-Transfer Whitelist (Mobs)">
              <VorePanelEditCheckboxes
                editMode={editMode}
                options={autotransfer_whitelist}
                action="set_attribute"
                subAction={'b_autotransfer_whitelist_' + title}
                tooltip={
                  'Whitelist mob types for your ' +
                  title +
                  ' transfer location.'
                }
              />
            </LabeledList.Item>
            <LabeledList.Item label="Auto-Transfer Whitelist (Items)">
              <VorePanelEditCheckboxes
                editMode={editMode}
                options={autotransfer_whitelist_items}
                action="set_attribute"
                subAction={'b_autotransfer_whitelist_items_' + title}
                tooltip={
                  'Whitelist item types for your ' +
                  title +
                  ' transfer location.'
                }
              />
            </LabeledList.Item>
            <LabeledList.Item label="Auto-Transfer Primary Blacklist (Mobs)">
              <VorePanelEditCheckboxes
                editMode={editMode}
                options={autotransfer_blacklist}
                action="set_attribute"
                subAction={'b_autotransfer_blacklist_' + title}
                tooltip={
                  'Blacklist mob types for your ' +
                  title +
                  ' transfer location.'
                }
              />
            </LabeledList.Item>
            <LabeledList.Item label="Auto-Transfer Primary Blacklist (Items)">
              <VorePanelEditCheckboxes
                editMode={editMode}
                options={autotransfer_blacklist_items}
                action="set_attribute"
                subAction={'b_autotransfer_blacklist_items_' + title}
                tooltip={
                  'Blacklist item types for your ' +
                  title +
                  ' transfer location.'
                }
              />
            </LabeledList.Item>
          </LabeledList>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
