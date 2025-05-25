import { useBackend } from 'tgui/backend';
import { Button, LabeledList, Section, Stack } from 'tgui-core/components';

import { liquidToTooltip } from '../constants';
import type { bellyLiquidData } from '../types';
import { VorePanelEditCheckboxes } from '../VorePanelElements/VorePanelEditCheckboxes';
import { VorePanelEditSwitch } from '../VorePanelElements/VorePanelEditSwitch';
import { LiquidOptionsLeft } from './LiquidTab/LiquidOptionsLeft';
import { LiquidOptionsRight } from './LiquidTab/LiquidOptionsRight';

export const VoreSelectedBellyLiquidOptions = (props: {
  editMode: boolean;
  bellyLiquidData: bellyLiquidData;
}) => {
  const { act } = useBackend();

  const { editMode, bellyLiquidData } = props;
  const { show_liq, liq_interacts } = bellyLiquidData;

  return (
    <Section
      title="Liquid Options"
      fill
      buttons={
        <Stack align="center">
          <Stack.Item>
            <Button.Confirm
              color="red"
              tooltip="Clear this belly's liquids."
              confirmContent="Confirm Purge?"
              onClick={() =>
                act('liq_set_attribute', { liq_attribute: 'b_liq_purge' })
              }
            >
              Purge Liquids
            </Button.Confirm>
          </Stack.Item>
          <Stack.Item>
            <VorePanelEditSwitch
              action="liq_set_attribute"
              subAction="b_show_liq"
              editMode={editMode}
              active={!!show_liq}
              tooltip={
                'These are the settings for liquid bellies, every belly has a liquid storage.'
              }
            />
          </Stack.Item>
        </Stack>
      }
    >
      {!!show_liq && (
        <Stack fill vertical>
          <Stack.Item>
            <LabeledList>
              <LabeledList.Item label="Liquid Addons">
                <VorePanelEditCheckboxes
                  editMode={editMode}
                  options={liq_interacts.liq_reagent_addons}
                  action="liq_set_attribute"
                  subAction="b_liq_reagent_addons"
                  tooltipList={liquidToTooltip}
                  tooltip='Liquid production modes to apply as soon as "Produce Liquids" is turned on.'
                />
              </LabeledList.Item>
            </LabeledList>
          </Stack.Item>
          <Stack.Item mt="5px">
            <Stack fill>
              <Stack.Item basis="49%" grow>
                <LiquidOptionsLeft
                  editMode={editMode}
                  liquidInteract={liq_interacts}
                />
              </Stack.Item>
              <Stack.Item basis="49%" grow>
                <LiquidOptionsRight
                  editMode={editMode}
                  liquidInteract={liq_interacts}
                />
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      )}
    </Section>
  );
};
