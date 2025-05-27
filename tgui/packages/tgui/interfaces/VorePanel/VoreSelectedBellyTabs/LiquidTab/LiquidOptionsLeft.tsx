import { Box, LabeledList, Stack } from 'tgui-core/components';

import { reagentToColor } from '../../constants';
import type { liqInteractData } from '../../types';
import { VorePanelEditColor } from '../../VorePanelElements/VorePanelEditColor';
import { VorePanelEditDropdown } from '../../VorePanelElements/VorePanelEditDropdown';
import { VorePanelEditNumber } from '../../VorePanelElements/VorePanelEditNumber';
import { VorePanelEditSwitch } from '../../VorePanelElements/VorePanelEditSwitch';
import { VorePanelEditText } from '../../VorePanelElements/VorePanelEditText';

export const LiquidOptionsLeft = (props: {
  editMode: boolean;
  liquidInteract: liqInteractData;
}) => {
  const { editMode, liquidInteract } = props;
  const {
    liq_reagent_gen,
    liq_reagent_type,
    liq_reagent_types,
    liq_custom_name_max,
    liq_custom_name_min,
    liq_reagent_name,
    liq_sloshing,
    custom_reagentcolor,
    custom_reagentalpha,
    liquid_overlay,
    mush_overlay,
    mush_color,
    mush_alpha,
    min_mush,
    metabolism_overlay,
    metabolism_mush_ratio,
    custom_ingested_color,
    custom_ingested_alpha,
  } = liquidInteract;

  return (
    <LabeledList>
      <LabeledList.Item label="Generate Liquids">
        <VorePanelEditSwitch
          action="liq_set_attribute"
          subAction="b_liq_reagent_gen"
          editMode={editMode}
          active={!!liq_reagent_gen}
          content={liq_reagent_gen ? 'On' : 'Off'}
          tooltip={
            (liq_reagent_gen ? 'Dis' : 'En') +
            'ables reagent creation for this belly.'
          }
        />
      </LabeledList.Item>
      <LabeledList.Item label="Liquid Type">
        <VorePanelEditDropdown
          action="liq_set_attribute"
          subAction="b_liq_reagent_type"
          color={reagentToColor[liq_reagent_type]}
          editMode={editMode}
          options={liq_reagent_types}
          entry={liq_reagent_type}
          tooltip="Select the reagent to produce."
        />
      </LabeledList.Item>
      <LabeledList.Item label="Liquid Name">
        <VorePanelEditText
          action="liq_set_attribute"
          subAction="b_liq_reagent_name"
          editMode={editMode}
          limit={liq_custom_name_max}
          min={liq_custom_name_min}
          entry={liq_reagent_name}
          tooltip={
            "New name for liquid shown when transfering and dumping on floor (The actual liquid's name is still the same) [" +
            liq_custom_name_min +
            '-' +
            liq_custom_name_max +
            ' characters].'
          }
        />
      </LabeledList.Item>
      <LabeledList.Item label="Slosh Sounds">
        <VorePanelEditSwitch
          action="liq_set_attribute"
          subAction="b_liq_sloshing"
          editMode={editMode}
          active={!!liq_sloshing}
          content={liq_sloshing ? 'On' : 'Off'}
          tooltip="Should this belly be considered for sloshing sounds when full?."
        />
      </LabeledList.Item>
      <LabeledList.Item label="Liquid Overlay">
        <Stack align="center">
          <Stack.Item>
            <VorePanelEditSwitch
              action="liq_set_attribute"
              subAction="b_liquid_overlay"
              editMode={editMode}
              active={!!liquid_overlay}
              content={liquid_overlay ? 'On' : 'Off'}
              tooltip="Should this belly display liquid overlays to prey?."
            />
          </Stack.Item>
          <VorePanelEditColor
            removePlaceholder
            editMode={editMode}
            action="liq_set_attribute"
            subAction="b_custom_reagentcolor"
            value_of={null}
            back_color={custom_reagentcolor}
            tooltip="Select your reagent overlay color."
          />
          <VorePanelEditColor
            removePlaceholder
            editMode={editMode}
            action="liq_set_attribute"
            subAction="b_custom_reagentalpha"
            value_of={null}
            back_color="#FFFFFF"
            alpha={custom_reagentalpha || 0}
            tooltip="Set your reagent overlay transparency. 0 to use the Default."
          />
          {!custom_reagentalpha && (
            <Stack.Item>
              <Box color="label">(Default)</Box>
            </Stack.Item>
          )}
        </Stack>
      </LabeledList.Item>
      <LabeledList.Item label="Fullness Overlay">
        <Stack align="center">
          <Stack.Item>
            <VorePanelEditSwitch
              action="liq_set_attribute"
              subAction="b_mush_overlay"
              editMode={editMode}
              active={!!mush_overlay}
              content={mush_overlay ? 'On' : 'Off'}
              tooltip="Should this belly display mush overlays to prey?."
            />
          </Stack.Item>
          <VorePanelEditColor
            removePlaceholder
            editMode={editMode}
            action="liq_set_attribute"
            subAction="b_mush_color"
            value_of={null}
            back_color={mush_color}
            tooltip="Select your mush overlay color."
          />
          <VorePanelEditColor
            removePlaceholder
            editMode={editMode}
            action="liq_set_attribute"
            subAction="b_mush_alpha"
            value_of={null}
            back_color="#FFFFFF"
            alpha={mush_alpha}
            tooltip="Set your mush overlay transparency."
          />
        </Stack>
      </LabeledList.Item>
      <LabeledList.Item label="Minimum Mush Level">
        <VorePanelEditNumber
          action="liq_set_attribute"
          subAction="b_min_mush"
          editMode={editMode}
          value={min_mush}
          unit="%"
          minValue={0}
          maxValue={100}
          tooltip="Set custom minimum mush level."
        />
      </LabeledList.Item>
      <LabeledList.Item label="Metabolism Overlay">
        <Stack align="center">
          <Stack.Item>
            <VorePanelEditSwitch
              action="liq_set_attribute"
              subAction="b_metabolism_overlay"
              editMode={editMode}
              active={!!metabolism_overlay}
              content={metabolism_overlay ? 'On' : 'Off'}
              tooltip="Should this belly display metabolism overlays to prey?."
            />
          </Stack.Item>
          <VorePanelEditColor
            removePlaceholder
            editMode={editMode}
            action="liq_set_attribute"
            subAction="b_custom_ingested_color"
            value_of={null}
            back_color={custom_ingested_color}
            tooltip="Select your metabolism overlay color."
          />
          <VorePanelEditColor
            removePlaceholder
            editMode={editMode}
            action="liq_set_attribute"
            subAction="b_custom_ingested_alpha"
            value_of={null}
            back_color="#FFFFFF"
            alpha={custom_ingested_alpha}
            tooltip="Set your metabolism overlay transparency."
          />
        </Stack>
      </LabeledList.Item>
      <LabeledList.Item label="Metabolism Mush Ratio">
        <VorePanelEditNumber
          action="liq_set_attribute"
          subAction="b_metabolism_mush_ratio"
          editMode={editMode}
          value={metabolism_mush_ratio}
          unit="fullness per u"
          minValue={0}
          maxValue={500}
          tooltip="How much should ingested reagents affect fullness overlay compared to nutrition? Nutrition units per reagent unit. Default 15."
        />
      </LabeledList.Item>
    </LabeledList>
  );
};
