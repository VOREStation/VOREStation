import { useBackend } from 'tgui/backend';
import { Button, LabeledList, Section, Stack } from 'tgui-core/components';

import { noSelectionName } from '../constants';
import type { bellyInteractionData, DropdownEntry } from '../types';
import { VorePanelEditDropdown } from '../VorePanelElements/VorePanelEditDropdown';
import { VorePanelEditNumber } from '../VorePanelElements/VorePanelEditNumber';
import { VorePanelEditSwitch } from '../VorePanelElements/VorePanelEditSwitch';

export const VoreSelectedBellyInteractions = (props: {
  editMode: boolean;
  bellyDropdownNames: DropdownEntry[];
  bellyInteractData: bellyInteractionData;
}) => {
  const { act } = useBackend();

  const { editMode, bellyDropdownNames, bellyInteractData } = props;
  const { escapable, interacts, autotransfer_enabled, autotransfer } =
    bellyInteractData;

  const escapeTimeSeconds = interacts.escapetime / 10;

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
              content={escapable ? 'Interactions On' : 'Interactions Off'}
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
                      value={interacts.escapechance}
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
      <Stack.Item>
        <Section
          title="Auto-Transfer Options"
          buttons={
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_autotransfer_enabled' })
              }
              icon={autotransfer_enabled ? 'toggle-on' : 'toggle-off'}
              selected={autotransfer_enabled}
            >
              {autotransfer_enabled
                ? 'Auto-Transfer Enabled'
                : 'Auto-Transfer Disabled'}
            </Button>
          }
        >
          {!!autotransfer_enabled && (
            <LabeledList>
              <LabeledList.Item label="Auto-Transfer Time">
                <Button
                  onClick={() =>
                    act('set_attribute', { attribute: 'b_autotransferwait' })
                  }
                >
                  {autotransfer.autotransferwait / 10 + 's'}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="Auto-Transfer Min Amount">
                <Button
                  onClick={() =>
                    act('set_attribute', {
                      attribute: 'b_autotransfer_min_amount',
                    })
                  }
                >
                  {autotransfer.autotransfer_min_amount}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="Auto-Transfer Max Amount">
                <Button
                  onClick={() =>
                    act('set_attribute', {
                      attribute: 'b_autotransfer_max_amount',
                    })
                  }
                >
                  {autotransfer.autotransfer_max_amount}
                </Button>
              </LabeledList.Item>
              <LabeledList.Divider />
              <LabeledList.Item label="Auto-Transfer Primary Chance">
                <Button
                  onClick={() =>
                    act('set_attribute', { attribute: 'b_autotransferchance' })
                  }
                >
                  {autotransfer.autotransferchance + '%'}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="Auto-Transfer Primary Location">
                <Button
                  onClick={() =>
                    act('set_attribute', {
                      attribute: 'b_autotransferlocation',
                    })
                  }
                >
                  {autotransfer.autotransferlocation
                    ? autotransfer.autotransferlocation
                    : 'Disabled'}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="Auto-Transfer Primary Location Extras">
                {(autotransfer.autotransferextralocation &&
                  autotransfer.autotransferextralocation.join(', ')) ||
                  ''}
                <Button
                  onClick={() =>
                    act('set_attribute', {
                      attribute: 'b_autotransferextralocation',
                    })
                  }
                  ml={1}
                  icon="plus"
                />
              </LabeledList.Item>
              <LabeledList.Item label="Auto-Transfer Primary Whitelist (Mobs)">
                {(autotransfer.autotransfer_whitelist.length &&
                  autotransfer.autotransfer_whitelist.join(', ')) ||
                  'Everything'}
                <Button
                  onClick={() =>
                    act('set_attribute', {
                      attribute: 'b_autotransfer_whitelist',
                    })
                  }
                  ml={1}
                  icon="plus"
                />
              </LabeledList.Item>
              <LabeledList.Item label="Auto-Transfer Primary Whitelist (Items)">
                {(autotransfer.autotransfer_whitelist_items.length &&
                  autotransfer.autotransfer_whitelist_items.join(', ')) ||
                  'Everything'}
                <Button
                  onClick={() =>
                    act('set_attribute', {
                      attribute: 'b_autotransfer_whitelist_items',
                    })
                  }
                  ml={1}
                  icon="plus"
                />
              </LabeledList.Item>
              <LabeledList.Item label="Auto-Transfer Primary Blacklist (Mobs)">
                {(autotransfer.autotransfer_blacklist.length &&
                  autotransfer.autotransfer_blacklist.join(', ')) ||
                  'Nothing'}
                <Button
                  onClick={() =>
                    act('set_attribute', {
                      attribute: 'b_autotransfer_blacklist',
                    })
                  }
                  ml={1}
                  icon="plus"
                />
              </LabeledList.Item>
              <LabeledList.Item label="Auto-Transfer Primary Blacklist (Items)">
                {(autotransfer.autotransfer_blacklist_items.length &&
                  autotransfer.autotransfer_blacklist_items.join(', ')) ||
                  'Nothing'}
                <Button
                  onClick={() =>
                    act('set_attribute', {
                      attribute: 'b_autotransfer_blacklist_items',
                    })
                  }
                  ml={1}
                  icon="plus"
                />
              </LabeledList.Item>
              <LabeledList.Divider />
              <LabeledList.Item label="Auto-Transfer Secondary Chance">
                <Button
                  onClick={() =>
                    act('set_attribute', {
                      attribute: 'b_autotransferchance_secondary',
                    })
                  }
                >
                  {autotransfer.autotransferchance_secondary + '%'}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="Auto-Transfer Secondary Location">
                <Button
                  onClick={() =>
                    act('set_attribute', {
                      attribute: 'b_autotransferlocation_secondary',
                    })
                  }
                >
                  {autotransfer.autotransferlocation_secondary
                    ? autotransfer.autotransferlocation_secondary
                    : 'Disabled'}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="Auto-Transfer Secondary Location Extras">
                {(autotransfer.autotransferextralocation_secondary &&
                  autotransfer.autotransferextralocation_secondary.join(
                    ', ',
                  )) ||
                  ''}
                <Button
                  onClick={() =>
                    act('set_attribute', {
                      attribute: 'b_autotransferextralocation_secondary',
                    })
                  }
                  ml={1}
                  icon="plus"
                />
              </LabeledList.Item>
              <LabeledList.Item label="Auto-Transfer Secondary Whitelist (Mobs)">
                {(autotransfer.autotransfer_secondary_whitelist.length &&
                  autotransfer.autotransfer_secondary_whitelist.join(', ')) ||
                  'Everything'}
                <Button
                  onClick={() =>
                    act('set_attribute', {
                      attribute: 'b_autotransfer_secondary_whitelist',
                    })
                  }
                  ml={1}
                  icon="plus"
                />
              </LabeledList.Item>
              <LabeledList.Item label="Auto-Transfer Secondary Whitelist (Items)">
                {(autotransfer.autotransfer_secondary_whitelist_items.length &&
                  autotransfer.autotransfer_secondary_whitelist_items.join(
                    ', ',
                  )) ||
                  'Everything'}
                <Button
                  onClick={() =>
                    act('set_attribute', {
                      attribute: 'b_autotransfer_secondary_whitelist_items',
                    })
                  }
                  ml={1}
                  icon="plus"
                />
              </LabeledList.Item>
              <LabeledList.Item label="Auto-Transfer Secondary Blacklist (Mobs)">
                {(autotransfer.autotransfer_secondary_blacklist.length &&
                  autotransfer.autotransfer_secondary_blacklist.join(', ')) ||
                  'Nothing'}
                <Button
                  onClick={() =>
                    act('set_attribute', {
                      attribute: 'b_autotransfer_secondary_blacklist',
                    })
                  }
                  ml={1}
                  icon="plus"
                />
              </LabeledList.Item>
              <LabeledList.Item label="Auto-Transfer Secondary Blacklist (Items)">
                {(autotransfer.autotransfer_secondary_blacklist_items.length &&
                  autotransfer.autotransfer_secondary_blacklist_items.join(
                    ', ',
                  )) ||
                  'Nothing'}
                <Button
                  onClick={() =>
                    act('set_attribute', {
                      attribute: 'b_autotransfer_secondary_blacklist_items',
                    })
                  }
                  ml={1}
                  icon="plus"
                />
              </LabeledList.Item>
            </LabeledList>
          )}
        </Section>
      </Stack.Item>
    </Stack>
  );
};
