import { LabeledList } from 'tgui-core/components';

import { nutriTimeToText } from '../../constants';
import type { liqInteractData } from '../../types';
import { VorePanelEditDropdown } from '../../VorePanelElements/VorePanelEditDropdown';
import { VorePanelEditNumber } from '../../VorePanelElements/VorePanelEditNumber';
import { VorePanelEditSwitch } from '../../VorePanelElements/VorePanelEditSwitch';
import { VorePanelEditText } from '../../VorePanelElements/VorePanelEditText';

export const LiquidOptionsRight = (props: {
  editMode: boolean;
  liquidInteract: liqInteractData;
}) => {
  const { editMode, liquidInteract } = props;
  const {
    liq_reagent_transfer_verb,
    liq_reagent_nutri_rate,
    liq_reagent_capacity,
    liq_custom_name_max,
    liq_custom_name_min,
    max_liquid_level,
    reagent_touches,
    max_mush,
    item_mush_val,
    max_ingested,
  } = liquidInteract;

  return (
    <LabeledList>
      <LabeledList.Item label="Liquid Capacity">
        <VorePanelEditNumber
          action="liq_set_attribute"
          subAction="b_liq_reagent_capacity"
          editMode={editMode}
          value={liq_reagent_capacity}
          minValue={10}
          maxValue={300}
          unit="u"
          tooltip="Choose the amount of liquid the belly can contain at most. Ranges from 10 to 300."
        />
      </LabeledList.Item>
      <LabeledList.Item label="Generation Time">
        <VorePanelEditDropdown
          action="liq_set_attribute"
          subAction="b_liq_reagent_nutri_rate"
          editMode={editMode}
          options={Object.values(nutriTimeToText)}
          entry={nutriTimeToText[liq_reagent_nutri_rate]}
          tooltip="Choose the time it takes to fill the belly from empty state using nutrition."
        />
      </LabeledList.Item>
      <LabeledList.Item label="Transfer Verb">
        <VorePanelEditText
          action="liq_set_attribute"
          subAction="b_liq_reagent_transfer_verb"
          editMode={editMode}
          limit={liq_custom_name_max}
          min={liq_custom_name_min}
          entry={liq_reagent_transfer_verb}
          tooltip={
            'Adjust vore liquid verb. [' +
            liq_custom_name_min +
            '-' +
            liq_reagent_transfer_verb +
            ' characters].'
          }
        />
      </LabeledList.Item>
      <LabeledList.Item label="Liquid Application to Prey">
        <VorePanelEditSwitch
          action="liq_set_attribute"
          subAction="b_reagent_touches"
          editMode={editMode}
          active={!!reagent_touches}
          content={reagent_touches ? 'On' : 'Off'}
          tooltip="Should liquids be applied to the prey during digestion?."
        />
      </LabeledList.Item>
      <LabeledList.Item label="Max Liquid Level">
        <VorePanelEditNumber
          action="liq_set_attribute"
          subAction="b_max_liquid_level"
          editMode={editMode}
          value={max_liquid_level}
          unit="%"
          minValue={0}
          maxValue={100}
          tooltip="The overlay coverage of the screen."
        />
      </LabeledList.Item>
      <LabeledList.Item label="Mush Overlay Scaling">
        <VorePanelEditNumber
          action="liq_set_attribute"
          subAction="b_max_mush"
          editMode={editMode}
          value={max_mush}
          unit="nutrition"
          minValue={0}
          maxValue={6000}
          tooltip="Choose the amount of nutrition required for full mush overlay. Ranges from 0 to 6000. Default 500."
        />
      </LabeledList.Item>
      <LabeledList.Item label="Item Mush Value">
        <VorePanelEditNumber
          action="liq_set_attribute"
          subAction="b_item_mush_val"
          editMode={editMode}
          value={item_mush_val}
          unit="fullness per item"
          minValue={0}
          maxValue={1000}
          tooltip="Set how much solid belly contents affect mush level per item."
        />
      </LabeledList.Item>
      <LabeledList.Item label="Metabolism Overlay Scaling">
        <VorePanelEditNumber
          action="liq_set_attribute"
          subAction="b_max_ingested"
          editMode={editMode}
          value={max_ingested}
          unit="u"
          minValue={0}
          maxValue={6000}
          tooltip="Choose the amount of reagents within ingested metabolism required for full mush overlay when not using mush overlay option. Ranges from 0 to 6000. Default 500."
        />
      </LabeledList.Item>
    </LabeledList>
  );
};
