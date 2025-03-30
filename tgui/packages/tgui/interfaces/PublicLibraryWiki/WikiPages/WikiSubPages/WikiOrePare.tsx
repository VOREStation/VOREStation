import { LabeledList, Section, Stack } from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';

import type { OreData } from '../../types';
import { ColorizedImage } from '../../WikiCommon/WikiColorIcon';
import { WikiList } from '../../WikiCommon/WikiListElements';
import { NotAvilableBox } from '../../WikiCommon/WikiQuickElements';

export const WikiOrePage = (props: { ores: OreData }) => {
  const {
    title,
    smelting,
    compressing,
    alloys,
    pump_reagent,
    grind_reagents,
    icon_data,
  } = props.ores;

  return (
    <Section fill scrollable title={capitalize(title)}>
      <Stack vertical fill>
        <Stack.Item grow>
          <LabeledList>
            <LabeledList.Item label="Icon">
              <ColorizedImage
                icon={icon_data.icon}
                iconState={icon_data.state}
                color={icon_data.color}
              />
            </LabeledList.Item>
            <LabeledList.Divider />
            <LabeledList.Item label="Smelting">
              {smelting ? smelting : <NotAvilableBox />}
            </LabeledList.Item>
            <LabeledList.Divider />
            <LabeledList.Item label="Compressing">
              {compressing ? compressing : <NotAvilableBox />}
            </LabeledList.Item>
            {!!alloys && <WikiList entries={alloys} title="Alloys" />}
            <LabeledList.Divider />
            <LabeledList.Item label="Pump Reagents">
              {pump_reagent ? pump_reagent : <NotAvilableBox />}
            </LabeledList.Item>
            {!!grind_reagents && (
              <WikiList entries={grind_reagents} title="Grind Reagents" />
            )}
          </LabeledList>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
