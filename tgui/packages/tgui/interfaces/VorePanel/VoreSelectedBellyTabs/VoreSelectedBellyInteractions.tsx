import { LabeledList, Section, Stack } from 'tgui-core/components';

import { noSelectionName } from '../constants';
import type { bellyInteractionData, DropdownEntry } from '../types';
import { VorePanelEditDropdown } from '../VorePanelElements/VorePanelEditDropdown';
import { VorePanelEditNumber } from '../VorePanelElements/VorePanelEditNumber';
import { VorePanelEditSwitch } from '../VorePanelElements/VorePanelEditSwitch';
import { AutoTransferOptions } from './InteractionTab/AutoTransferOptions';

export const VoreSelectedBellyInteractions = (props: {
  editMode: boolean;
  bellyDropdownNames: DropdownEntry[];
  bellyInteractData: bellyInteractionData;
}) => {
  const { editMode, bellyDropdownNames, bellyInteractData } = props;
  const { escapable, interacts, autotransfer_enabled, autotransfer } =
    bellyInteractData;

  const escapeTimeSeconds = interacts.escapetime / 10;
  const autoTransferTimeSeconds = autotransfer.autotransferwait / 10;

  const locationNames = [...bellyDropdownNames, noSelectionName];

  return (
    <Stack fill vertical>
      <Stack.Item>
        <Section
          title="Belly Interactions"
          buttons={
            <VorePanelEditSwitch
              action="set_attribute"
              subAction="b_escapable"
              editMode={editMode}
              active={!!escapable}
              tooltip={
                "These control how your belly responds to someone using 'resist' while inside you. The percent chance to trigger each is listed below, and you can change them to whatever you see fit. " +
                "Setting them to 0% will disable the possibility of that interaction. These only function as long as interactions are turned on in general. Keep in mind, the 'belly mode' interactions (digest/absorb) " +
                "will affect all prey in that belly, if one resists and triggers digestion/absorption. If multiple trigger at the same time, only the first in the order of 'Escape > Transfer > Absorb > Digest' will occur."
              }
            />
          }
        >
          <Stack fill>
            {!!escapable && (
              <>
                <Stack.Item basis="49%" grow>
                  <LabeledList.Item label="Escape Chance">
                    <VorePanelEditNumber
                      action="set_attribute"
                      subAction="b_escapechance"
                      editMode={editMode}
                      value={interacts.escapechance}
                      minValue={0}
                      maxValue={100}
                      unit="%"
                      tooltip="Set prey escape chance on resist."
                    />
                  </LabeledList.Item>
                  <LabeledList.Item label="Escape Time">
                    <VorePanelEditNumber
                      action="set_attribute"
                      subAction="b_escapetime"
                      editMode={editMode}
                      value={escapeTimeSeconds}
                      minValue={1}
                      maxValue={60}
                      unit={escapeTimeSeconds === 1 ? 'second' : 'seconds'}
                      tooltip="Set number of seconds for prey to escape on resist."
                    />
                  </LabeledList.Item>
                  <LabeledList.Item label="Digest Chance">
                    <VorePanelEditNumber
                      action="set_attribute"
                      subAction="b_digestchance"
                      editMode={editMode}
                      value={interacts.digestchance}
                      minValue={0}
                      maxValue={100}
                      unit="%"
                      tooltip="Set belly digest mode chance on resist."
                    />
                  </LabeledList.Item>
                  <LabeledList.Divider />
                  <LabeledList.Item label="Primary Transfer Chance">
                    <VorePanelEditNumber
                      action="set_attribute"
                      subAction="b_transferchance"
                      editMode={editMode}
                      value={interacts.transferchance}
                      minValue={0}
                      maxValue={100}
                      unit="%"
                      tooltip="Set the primary belly transfer chance on resist. You must also set the location for this to have any effect."
                    />
                  </LabeledList.Item>
                  <LabeledList.Item label="Secondary Transfer Chance">
                    <VorePanelEditNumber
                      action="set_attribute"
                      subAction="b_transferchance_secondary"
                      editMode={editMode}
                      value={interacts.transferchance_secondary}
                      minValue={0}
                      maxValue={100}
                      unit="%"
                      tooltip="Set the secondary belly transfer chance on resist. You must also set the secondary location for this to have any effect."
                    />
                  </LabeledList.Item>
                </Stack.Item>
                <Stack.Item basis="49%" grow>
                  <LabeledList.Item label="Absorbed Escape Chance">
                    <VorePanelEditNumber
                      action="set_attribute"
                      subAction="b_escapechance_absorbed"
                      editMode={editMode}
                      value={interacts.escapechance_absorbed}
                      minValue={0}
                      maxValue={100}
                      unit="%"
                      tooltip="Set absorbed prey escape chance on resist."
                    />
                  </LabeledList.Item>
                  <LabeledList.Item label="Belch Chance">
                    <VorePanelEditNumber
                      action="set_attribute"
                      subAction="b_belchchance"
                      editMode={editMode}
                      value={interacts.belchchance}
                      minValue={0}
                      maxValue={100}
                      unit="%"
                      tooltip="Set chance for belch emote on prey resist."
                    />
                  </LabeledList.Item>
                  <LabeledList.Item label="Absorb Chance">
                    <VorePanelEditNumber
                      action="set_attribute"
                      subAction="b_absorbchance"
                      editMode={editMode}
                      value={interacts.absorbchance}
                      minValue={0}
                      maxValue={100}
                      unit="%"
                      tooltip="Set belly absorb mode chance on resist."
                    />
                  </LabeledList.Item>
                  <LabeledList.Divider />
                  <LabeledList.Item label="Primary Transfer Location">
                    <VorePanelEditDropdown
                      action="set_attribute"
                      subAction="b_transferlocation"
                      editMode={editMode}
                      options={locationNames}
                      color={
                        !editMode && !interacts.transferlocation
                          ? 'red'
                          : undefined
                      }
                      entry={
                        interacts.transferlocation
                          ? interacts.transferlocation
                          : 'Disabled'
                      }
                      tooltip="Target location of the primary transfer trigger on resist."
                    />
                  </LabeledList.Item>
                  <LabeledList.Item label="Secondary Transfer Location">
                    <VorePanelEditDropdown
                      action="set_attribute"
                      subAction="b_transferlocation_secondary"
                      editMode={editMode}
                      options={locationNames}
                      color={
                        !editMode && !interacts.transferlocation
                          ? 'red'
                          : undefined
                      }
                      entry={
                        interacts.transferlocation_secondary
                          ? interacts.transferlocation_secondary
                          : 'Disabled'
                      }
                      tooltip="Target location of the secondary transfer trigger on resist."
                    />
                  </LabeledList.Item>
                </Stack.Item>
              </>
            )}
            <Stack.Divider />
          </Stack>
        </Section>
      </Stack.Item>
      <Stack.Item mt="5px">
        <Section
          title="Auto-Transfer Options"
          buttons={
            <VorePanelEditSwitch
              action="set_attribute"
              subAction="b_autotransfer_enabled"
              editMode={editMode}
              active={!!autotransfer_enabled}
              tooltip={
                'Allows you to setup auto transfer options for this belly. So that prey is automatically moved depending on a timer or content count.'
              }
            />
          }
        >
          {!!autotransfer_enabled && (
            <Stack vertical fill>
              <Stack.Item>
                <Stack>
                  <Stack.Item basis="49%" grow>
                    <LabeledList.Item label="Auto-Transfer Min Amount">
                      <VorePanelEditNumber
                        action="set_attribute"
                        subAction="b_autotransfer_min_amount"
                        editMode={editMode}
                        value={autotransfer.autotransfer_min_amount}
                        minValue={0}
                        maxValue={100}
                        tooltip="Set the minimum amount of items your belly can belly auto-transfer at once. Set to 0 for no limit."
                      />
                    </LabeledList.Item>
                    <LabeledList.Item label="Auto-Transfer Max Amount">
                      <VorePanelEditNumber
                        action="set_attribute"
                        subAction="b_autotransfer_max_amount"
                        editMode={editMode}
                        value={autotransfer.autotransfer_max_amount}
                        minValue={0}
                        maxValue={100}
                        tooltip="Set the minimum amount of items your belly can belly auto-transfer at once. Set to 0 for no limit."
                      />
                    </LabeledList.Item>
                  </Stack.Item>
                  <Stack.Item basis="49%" grow>
                    <LabeledList.Item label="Auto-Transfer Time">
                      <VorePanelEditNumber
                        action="set_attribute"
                        subAction="b_autotransferwait"
                        editMode={editMode}
                        value={autoTransferTimeSeconds}
                        unit={
                          autoTransferTimeSeconds === 1 ? 'second' : 'seconds'
                        }
                        minValue={1}
                        maxValue={1800}
                        tooltip="Set minimum number of seconds for auto-transfer wait delay."
                      />
                    </LabeledList.Item>
                  </Stack.Item>
                </Stack>
              </Stack.Item>
              <Stack.Item>
                <AutoTransferOptions
                  editMode={editMode}
                  title={'primary'}
                  bellyDropdownNames={bellyDropdownNames}
                  locationNames={locationNames}
                  autotransferData={autotransfer.primary_transfer}
                />
              </Stack.Item>
              <Stack.Item>
                <AutoTransferOptions
                  editMode={editMode}
                  title={'secondary'}
                  bellyDropdownNames={bellyDropdownNames}
                  locationNames={locationNames}
                  autotransferData={autotransfer.secondary_transfer}
                />
              </Stack.Item>
            </Stack>
          )}
        </Section>
      </Stack.Item>
    </Stack>
  );
};
