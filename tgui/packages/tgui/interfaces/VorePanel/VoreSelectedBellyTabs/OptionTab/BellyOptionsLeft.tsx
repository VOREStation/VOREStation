import { LabeledList, Stack } from 'tgui-core/components';

import { eatingMessagePrivacy } from '../../constants';
import { sanitize_color } from '../../functions';
import type { bellyOptionData, hostMob } from '../../types';
import { VorePanelColorBox } from '../../VorePanelElements/VorePanelCommonElements';
import { VorePanelEditDropdown } from '../../VorePanelElements/VorePanelEditDropdown';
import { VorePanelEditNumber } from '../../VorePanelElements/VorePanelEditNumber';
import { VorePanelEditSwitch } from '../../VorePanelElements/VorePanelEditSwitch';
import { VoreSelectedWhitelist } from '../VisualTab/VoreSelecetedWhitelist';
import { VoreSelectedMobTypeBellyButtons } from '../VisualTab/VoreSelectedMobTypeBellyButtons';

export const BellyOptionsLeft = (props: {
  editMode: boolean;
  bellyOptionData: bellyOptionData;
  host_mobtype: hostMob;
}) => {
  const { editMode, bellyOptionData, host_mobtype } = props;
  const {
    can_taste,
    is_feedable,
    nutrition_percent,
    bulge_size,
    contaminates,
    contaminate_flavor,
    contaminate_color,
    contaminate_options,
    contaminate_colors,
    save_digest_mode,
    eating_privacy_local,
    private_struggle,
    mob_belly_controls,
    vorespawn_blacklist,
    vorespawn_whitelist,
    vorespawn_absorbed,
  } = bellyOptionData;

  return (
    <>
      <LabeledList>
        <LabeledList.Item label="Can Taste">
          <VorePanelEditSwitch
            action="set_attribute"
            subAction="b_tastes"
            editMode={editMode}
            active={!!can_taste}
            content={can_taste ? 'Yes' : 'No'}
            tooltip={
              (can_taste ? 'Dis' : 'En') +
              'ables the ability for this belly to taste prey.'
            }
          />
        </LabeledList.Item>
        <LabeledList.Item label="Feedable">
          <VorePanelEditSwitch
            action="set_attribute"
            subAction="b_feedable"
            editMode={editMode}
            active={!!is_feedable}
            content={is_feedable ? 'Yes' : 'No'}
            tooltip={
              (is_feedable ? 'Dis' : 'En') +
              'ables the ability for this belly to have prey fed to.'
            }
          />
        </LabeledList.Item>
        <LabeledList.Item label="Contaminates">
          <VorePanelEditSwitch
            action="set_attribute"
            subAction="b_contaminates"
            editMode={editMode}
            active={!!contaminates}
            content={contaminates ? 'Yes' : 'No'}
            tooltip={
              (contaminates ? 'Dis' : 'En') +
              'ables the ability for this belly to contaminate items, requiring them to be washed clean.'
            }
          />
        </LabeledList.Item>
        {!!contaminates && (
          <>
            <LabeledList.Item label="Contamination Flavor">
              <VorePanelEditDropdown
                editMode={editMode}
                options={
                  contaminate_options ? Object.keys(contaminate_options) : []
                }
                entry={contaminate_flavor ? contaminate_flavor : ''}
                action="set_attribute"
                subAction="b_contamination_flavor"
                tooltip="The flavour of your item contamination."
              />
            </LabeledList.Item>
            <LabeledList.Item label="Contamination Color">
              <Stack>
                <Stack.Item>
                  <VorePanelEditDropdown
                    editMode={editMode}
                    options={contaminate_colors ? contaminate_colors : []}
                    entry={contaminate_color ? contaminate_color : ''}
                    action="set_attribute"
                    subAction="b_contamination_color"
                    tooltip="The color overlay of your item contamination."
                  />
                </Stack.Item>
                {!editMode && (
                  <Stack.Item>
                    <VorePanelColorBox
                      pixelSize={15}
                      back_color={sanitize_color(contaminate_color) || 'white'}
                    />
                  </Stack.Item>
                )}
              </Stack>
            </LabeledList.Item>
          </>
        )}
        <LabeledList.Item label="Nutritional Gain">
          <VorePanelEditNumber
            action="set_attribute"
            subAction="b_nutritionpercent"
            editMode={editMode}
            value={nutrition_percent}
            minValue={0.01}
            maxValue={100}
            step={0.01}
            stepPixel={0.1}
            digits={2}
            unit="%"
            tooltip="The multiplier for nutrition you'll fain from prey."
          />
        </LabeledList.Item>
        <LabeledList.Item label="Required Examine Size">
          <VorePanelEditNumber
            action="set_attribute"
            subAction="b_bulge_size"
            editMode={editMode}
            value={bulge_size * 100}
            minValue={0}
            maxValue={200}
            unit="%"
            tooltip="The minimum size for prey to show in examine. Type 0 to disable."
          />
        </LabeledList.Item>
        <LabeledList.Item label="Toggle Vore Privacy">
          <VorePanelEditDropdown
            editMode={editMode}
            options={Object.keys(eatingMessagePrivacy)}
            entry={eating_privacy_local}
            action="set_attribute"
            subAction="b_eating_privacy"
            color={eatingMessagePrivacy[eating_privacy_local]}
            tooltip="Allows to override the global audible range of your attempt and success messages for this belly."
          />
        </LabeledList.Item>
        <LabeledList.Item label="Toggle Struggle Privacy">
          <VorePanelEditSwitch
            action="set_attribute"
            subAction="b_private_struggle"
            editMode={editMode}
            active={!!private_struggle}
            content={private_struggle ? 'Private' : 'Loud'}
            tooltip={
              (private_struggle ? 'Dis' : 'En') +
              'ables subtle struggle messages.'
            }
          />
        </LabeledList.Item>
        <LabeledList.Item label="Save Digest Mode">
          <VorePanelEditSwitch
            action="set_attribute"
            subAction="b_save_digest_mode"
            editMode={editMode}
            active={!!save_digest_mode}
            tooltip={
              (save_digest_mode ? 'Dis' : 'En') +
              'ables persistent digest mode.'
            }
          />
        </LabeledList.Item>
      </LabeledList>
      <VoreSelectedMobTypeBellyButtons
        editMode={editMode}
        bellyControl={mob_belly_controls}
        host_mobtype={host_mobtype}
      />
      <VoreSelectedWhitelist
        editMode={editMode}
        vorespawnBlacklist={vorespawn_blacklist}
        vorespawnWhitelist={vorespawn_whitelist}
        vorespawnAbsorbed={vorespawn_absorbed}
      />
    </>
  );
};
