import { useBackend } from 'tgui/backend';
import { Button, LabeledList, Section } from 'tgui-core/components';

import { reagentToColor } from '../constants';
import { LiquidColorInput } from '../LiquidColorInput';
import type { selectedData } from '../types';

export const VoreSelectedBellyLiquidOptions = (props: {
  belly: selectedData;
}) => {
  const { act } = useBackend();

  const { belly } = props;
  const { show_liq, liq_interacts } = belly;

  const generationTime = (liq_interacts.liq_reagent_nutri_rate + 1) * 10;
  const generationMinutes = generationTime % 60;
  const generationHours = Math.floor(generationTime / 60);

  return (
    <Section
      title="Liquid Options"
      buttons={
        <Button
          onClick={() =>
            act('liq_set_attribute', { liq_attribute: 'b_show_liq' })
          }
          icon={show_liq ? 'toggle-on' : 'toggle-off'}
          selected={show_liq}
          tooltipPosition="left"
          tooltip={
            'These are the settings for liquid bellies, every belly has a liquid storage.'
          }
        >
          {show_liq ? 'Liquids On' : 'Liquids Off'}
        </Button>
      }
    >
      {show_liq ? (
        <LabeledList>
          <LabeledList.Item label="Generate Liquids">
            <Button
              onClick={() =>
                act('liq_set_attribute', { liq_attribute: 'b_liq_reagent_gen' })
              }
              icon={liq_interacts.liq_reagent_gen ? 'toggle-on' : 'toggle-off'}
              selected={liq_interacts.liq_reagent_gen}
            >
              {liq_interacts.liq_reagent_gen ? 'On' : 'Off'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Liquid Type">
            <Button
              onClick={() =>
                act('liq_set_attribute', {
                  liq_attribute: 'b_liq_reagent_type',
                })
              }
              icon="pen"
              color={reagentToColor[liq_interacts.liq_reagent_type]}
            >
              {liq_interacts.liq_reagent_type}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Liquid Name">
            <Button
              onClick={() =>
                act('liq_set_attribute', {
                  liq_attribute: 'b_liq_reagent_name',
                })
              }
            >
              {liq_interacts.liq_reagent_name}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Transfer Verb">
            <Button
              onClick={() =>
                act('liq_set_attribute', {
                  liq_attribute: 'b_liq_reagent_transfer_verb',
                })
              }
            >
              {liq_interacts.liq_reagent_transfer_verb}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Generation Time">
            <Button
              onClick={() =>
                act('liq_set_attribute', {
                  liq_attribute: 'b_liq_reagent_nutri_rate',
                })
              }
              icon="clock"
            >
              {(generationHours < 10
                ? '0' + generationHours
                : generationHours) +
                ':' +
                (generationMinutes < 10
                  ? '0' + generationMinutes
                  : generationMinutes) +
                ' hh:mm'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Liquid Capacity">
            <Button
              onClick={() =>
                act('liq_set_attribute', {
                  liq_attribute: 'b_liq_reagent_capacity',
                })
              }
            >
              {liq_interacts.liq_reagent_capacity}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Slosh Sounds">
            <Button
              onClick={() =>
                act('liq_set_attribute', { liq_attribute: 'b_liq_sloshing' })
              }
              icon={liq_interacts.liq_sloshing ? 'toggle-on' : 'toggle-off'}
              selected={liq_interacts.liq_sloshing}
            >
              {liq_interacts.liq_sloshing ? 'On' : 'Off'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Liquid Addons">
            {(liq_interacts.liq_reagent_addons.length &&
              liq_interacts.liq_reagent_addons.join(', ')) ||
              'None'}
            <Button
              onClick={() =>
                act('liq_set_attribute', {
                  liq_attribute: 'b_liq_reagent_addons',
                })
              }
              ml={1}
              icon="plus"
            />
          </LabeledList.Item>
          <LabeledList.Item label="Liquid Application to Prey">
            <Button
              onClick={() =>
                act('liq_set_attribute', { liq_attribute: 'b_reagent_touches' })
              }
              icon={liq_interacts.reagent_touches ? 'toggle-on' : 'toggle-off'}
              selected={liq_interacts.reagent_touches}
            >
              {liq_interacts.reagent_touches ? 'On' : 'Off'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Custom Liquid Color">
            <LiquidColorInput
              action_name="b_custom_reagentcolor"
              value_of={null}
              back_color={liq_interacts.custom_reagentcolor}
              name_of="Custom Liquid Color"
            />
          </LabeledList.Item>
          <LabeledList.Item label="Liquid Overlay">
            <Button
              onClick={() =>
                act('liq_set_attribute', { liq_attribute: 'b_liquid_overlay' })
              }
              icon={liq_interacts.liquid_overlay ? 'toggle-on' : 'toggle-off'}
              selected={liq_interacts.liquid_overlay}
            >
              {liq_interacts.liquid_overlay ? 'On' : 'Off'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Max Liquid Level">
            <Button
              onClick={() =>
                act('liq_set_attribute', {
                  liq_attribute: 'b_max_liquid_level',
                })
              }
            >
              {liq_interacts.max_liquid_level + '%'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Custom Liquid Alpha">
            <Button
              onClick={() =>
                act('liq_set_attribute', {
                  liq_attribute: 'b_custom_reagentalpha',
                })
              }
            >
              {liq_interacts.custom_reagentalpha}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Fullness Overlay">
            <Button
              onClick={() =>
                act('liq_set_attribute', { liq_attribute: 'b_mush_overlay' })
              }
              icon={liq_interacts.mush_overlay ? 'toggle-on' : 'toggle-off'}
              selected={liq_interacts.mush_overlay}
            >
              {liq_interacts.mush_overlay ? 'On' : 'Off'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Mush Overlay Color">
            <LiquidColorInput
              action_name="b_mush_color"
              value_of={null}
              back_color={liq_interacts.mush_color}
              name_of="Custom Mush Color"
            />
          </LabeledList.Item>
          <LabeledList.Item label="Mush Overlay Alpha">
            <Button
              onClick={() =>
                act('liq_set_attribute', {
                  liq_attribute: 'b_mush_alpha',
                })
              }
            >
              {liq_interacts.mush_alpha}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Mush Overlay Scaling">
            <Button
              onClick={() =>
                act('liq_set_attribute', {
                  liq_attribute: 'b_max_mush',
                })
              }
            >
              {liq_interacts.max_mush}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Minimum Mush Level">
            <Button
              onClick={() =>
                act('liq_set_attribute', {
                  liq_attribute: 'b_min_mush',
                })
              }
            >
              {liq_interacts.min_mush + '%'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Item Mush Value">
            <Button
              onClick={() =>
                act('liq_set_attribute', {
                  liq_attribute: 'b_item_mush_val',
                })
              }
            >
              {liq_interacts.item_mush_val + ' fullness per item'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Metabolism Overlay">
            <Button
              onClick={() =>
                act('liq_set_attribute', {
                  liq_attribute: 'b_metabolism_overlay',
                })
              }
              icon={
                liq_interacts.metabolism_overlay ? 'toggle-on' : 'toggle-off'
              }
              selected={liq_interacts.metabolism_overlay}
            >
              {liq_interacts.metabolism_overlay ? 'On' : 'Off'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Metabolism Mush Ratio">
            <Button
              onClick={() =>
                act('liq_set_attribute', {
                  liq_attribute: 'b_metabolism_mush_ratio',
                })
              }
            >
              {liq_interacts.metabolism_mush_ratio +
                ' fullness per reagent unit'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Metabolism Overlay Scaling">
            <Button
              onClick={() =>
                act('liq_set_attribute', {
                  liq_attribute: 'b_max_ingested',
                })
              }
            >
              {liq_interacts.max_ingested}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Custom Metabolism Color">
            <LiquidColorInput
              action_name="b_custom_ingested_color"
              value_of={null}
              back_color={liq_interacts.custom_ingested_color}
              name_of="Custom Metabolism Color"
            />
          </LabeledList.Item>
          <LabeledList.Item label="Metabolism Overlay Alpha">
            <Button
              onClick={() =>
                act('liq_set_attribute', {
                  liq_attribute: 'b_custom_ingested_alpha',
                })
              }
            >
              {liq_interacts.custom_ingested_alpha}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Purge Liquids">
            <Button
              color="red"
              onClick={() =>
                act('liq_set_attribute', { liq_attribute: 'b_liq_purge' })
              }
            >
              Purge Liquids
            </Button>
          </LabeledList.Item>
        </LabeledList>
      ) : (
        'These options only display while liquid settings are turned on.'
      )}
    </Section>
  );
};
