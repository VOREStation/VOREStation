import { Box, LabeledList, Stack } from 'tgui-core/components';

import { spriteToTooltip } from '../../constants';
import type { bellyVisualData, hostMob } from '../../types';
import { VorePanelEditCheckboxes } from '../../VorePanelElements/VorePanelEditCheckboxes';
import { VorePanelEditColor } from '../../VorePanelElements/VorePanelEditColor';
import { VorePanelEditDropdown } from '../../VorePanelElements/VorePanelEditDropdown';
import { VorePanelEditNumber } from '../../VorePanelElements/VorePanelEditNumber';
import { VorePanelEditSwitch } from '../../VorePanelElements/VorePanelEditSwitch';
import { VoreSelectedMobTypeBellyButtons } from './VoreSelectedMobTypeBellyButtons';

export const VoreSpriteAffects = (props: {
  editMode: boolean;
  bellyVisualData: bellyVisualData;
  hostMobtype: hostMob;
}) => {
  const { editMode, bellyVisualData, hostMobtype } = props;
  const {
    vore_sprite_flags,
    absorbed_voresprite,
    absorbed_multiplier,
    liquid_voresprite,
    liquid_multiplier,
    item_voresprite,
    item_multiplier,
    health_voresprite,
    resist_animation,
    voresprite_size_factor,
    belly_sprite_to_affect,
    belly_sprite_options,
    undergarment_chosen,
    undergarment_if_none,
    undergarment_options,
    undergarment_options_if_none,
    undergarment_color,
    tail_option_shown,
    tail_to_change_to,
    tail_sprite_options,
    mob_belly_controls,
  } = bellyVisualData;

  return (
    <Stack vertical>
      <Stack.Item>
        <LabeledList>
          <LabeledList.Item label="Vore Sprite Mode">
            <VorePanelEditCheckboxes
              editMode={editMode}
              options={vore_sprite_flags}
              action="set_attribute"
              subAction="b_vore_sprite_flags"
              tooltipList={spriteToTooltip}
            />
          </LabeledList.Item>
        </LabeledList>
      </Stack.Item>
      <Stack.Item>
        <Stack>
          <Stack.Item basis="49%" grow>
            <LabeledList>
              <LabeledList.Item label="Count Absorbed prey for vore sprites">
                <VorePanelEditSwitch
                  action="set_attribute"
                  subAction="b_count_absorbed_prey_for_sprites"
                  editMode={editMode}
                  tooltip="Allows you to toggle if absorbed prey accounts for the vore sprite size."
                  content={absorbed_voresprite ? 'Yes' : 'No'}
                  active={!!absorbed_voresprite}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Count liquid reagents for vore sprites">
                <VorePanelEditSwitch
                  action="set_attribute"
                  subAction="b_count_liquid_for_sprites"
                  editMode={editMode}
                  tooltip="Allows you to toggle if belly liquids account for the vore sprite size."
                  content={liquid_voresprite ? 'Yes' : 'No'}
                  active={!!liquid_voresprite}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Count items for vore sprites">
                <VorePanelEditSwitch
                  action="set_attribute"
                  subAction="b_count_items_for_sprites"
                  editMode={editMode}
                  tooltip="Allows you to toggle if ingested items account for the vore sprite size."
                  content={item_voresprite ? 'Yes' : 'No'}
                  active={!!item_voresprite}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Prey health affects vore sprites">
                <VorePanelEditSwitch
                  action="set_attribute"
                  subAction="b_health_impacts_size"
                  editMode={editMode}
                  tooltip="Allows you to toggle if your prey's health is accounted for the vore sprite size. The lower the health, the less a prey will contribute."
                  content={health_voresprite ? 'Yes' : 'No'}
                  active={!!health_voresprite}
                />
              </LabeledList.Item>
              {belly_sprite_options?.length ? (
                <LabeledList.Item label="Belly Sprite to affect">
                  <VorePanelEditDropdown
                    action="set_attribute"
                    subAction="b_belly_sprite_to_affect"
                    editMode={editMode}
                    options={belly_sprite_options}
                    entry={belly_sprite_to_affect}
                    tooltip="Set the belly sprite to effect."
                  />
                </LabeledList.Item>
              ) : (
                <LabeledList.Item label="Belly Sprite to affect">
                  <Box textColor="red">You do not have any bellysprites.</Box>
                </LabeledList.Item>
              )}
              {!!tail_option_shown &&
                vore_sprite_flags
                  .map((flag) => flag.label)
                  .includes('Undergarment addition') && (
                  <>
                    <LabeledList.Item label="Undergarment type to affect">
                      <VorePanelEditDropdown
                        action="set_attribute"
                        subAction="b_undergarment_choice"
                        editMode={editMode}
                        options={undergarment_options}
                        entry={undergarment_chosen}
                        tooltip="Set the undergarment sprite to effect."
                      />
                    </LabeledList.Item>
                    <LabeledList.Item label="Undergarment if none equipped">
                      <Stack align="center">
                        <Stack.Item>
                          <VorePanelEditDropdown
                            action="set_attribute"
                            subAction="b_undergarment_if_none"
                            editMode={editMode}
                            options={undergarment_options_if_none}
                            entry={undergarment_if_none}
                            tooltip="If no undergarment is equipped, which undergarment style do you want to use?"
                          />
                        </Stack.Item>
                        <VorePanelEditColor
                          editMode={editMode}
                          action="liq_set_attribute"
                          subAction="b_undergarment_color"
                          value_of={null}
                          back_color={undergarment_color}
                          tooltip="Select your undergarment color."
                        />
                      </Stack>
                    </LabeledList.Item>
                  </>
                )}
              {!!tail_option_shown &&
                vore_sprite_flags
                  .map((flag) => flag.label)
                  .includes('Tail adjustment') && (
                  <LabeledList.Item label="Tail to change to">
                    <VorePanelEditDropdown
                      action="set_attribute"
                      subAction="b_tail_to_change_to"
                      editMode={editMode}
                      options={tail_sprite_options}
                      entry={
                        typeof tail_to_change_to === 'string'
                          ? tail_to_change_to
                          : 'None'
                      }
                      tooltip="Set the tail sprite to effect."
                    />
                  </LabeledList.Item>
                )}
            </LabeledList>
            <VoreSelectedMobTypeBellyButtons
              editMode={editMode}
              bellyControl={mob_belly_controls}
              host_mobtype={hostMobtype}
            />
          </Stack.Item>
          <Stack.Item basis="49%" grow>
            <LabeledList>
              <LabeledList.Item label="Absorbed Multiplier">
                <VorePanelEditNumber
                  action="set_attribute"
                  subAction="b_absorbed_multiplier"
                  editMode={editMode}
                  value={absorbed_multiplier}
                  minValue={0.1}
                  maxValue={3}
                  step={0.1}
                  unit="x"
                  digits={1}
                  tooltip="Set the impact absorbed prey's size have on your vore sprite. 1 means no scaling, 0.5 means absorbed prey count half as much, 2 means absorbed prey count double. (Range from 0.1 - 3)"
                />
              </LabeledList.Item>
              <LabeledList.Item label="Liquid Multiplier">
                <VorePanelEditNumber
                  action="set_attribute"
                  subAction="b_liquid_multiplier"
                  editMode={editMode}
                  value={liquid_multiplier}
                  minValue={0.1}
                  maxValue={10}
                  step={0.1}
                  unit="x"
                  digits={1}
                  tooltip="Set the impact amount of liquid reagents will have on your vore sprite. 1 means a belly with 100 reagents of fluid will count as 1 normal sized prey-thing's worth, 0.5 means liquid counts half as much, 2 means liquid counts double. (Range from 0.1 - 10)"
                />
              </LabeledList.Item>
              <LabeledList.Item label="Items Multiplier">
                <VorePanelEditNumber
                  action="set_attribute"
                  subAction="b_item_multiplier"
                  editMode={editMode}
                  value={item_multiplier}
                  minValue={0.1}
                  maxValue={10}
                  step={0.1}
                  unit="x"
                  digits={1}
                  tooltip="Set the impact items will have on your vore sprite. 1 means a belly with 8 normal-sized items will count as 1 normal sized prey-thing's worth, 0.5 means items count half as much, 2 means items count double. (Range from 0.1 - 10)"
                />
              </LabeledList.Item>
              <LabeledList.Item label="Vore Sprite Size Factor">
                <VorePanelEditNumber
                  action="set_attribute"
                  subAction="b_size_factor_sprites"
                  editMode={editMode}
                  value={voresprite_size_factor}
                  minValue={0.1}
                  maxValue={3}
                  step={0.1}
                  unit="x"
                  digits={1}
                  tooltip="Set the impact all belly content's collective size has on your vore sprite. 1 means no scaling, 0.5 means content counts half as much, 2 means contents count double. (Range from 0.1 - 3)"
                />
              </LabeledList.Item>
              <LabeledList.Item label="Animation when prey resist">
                <VorePanelEditSwitch
                  action="set_attribute"
                  subAction="b_resist_animation"
                  editMode={editMode}
                  tooltip="Allows you to toggle if prey resists trigger struggle animations if the sprite supports it."
                  active={!!resist_animation}
                />
              </LabeledList.Item>
            </LabeledList>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};
