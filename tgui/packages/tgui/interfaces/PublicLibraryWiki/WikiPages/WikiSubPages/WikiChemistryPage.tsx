import { Box, LabeledList, Section, Stack } from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';

import type { ReagentData } from '../../types';
import { ChemicalReactionList } from '../../WikiCommon/WikiChemList';
import { ColorizedImage } from '../../WikiCommon/WikiColorIcon';
import { WikiSpoileredList } from '../../WikiCommon/WikiListElements';
import {
  NotAvilableBox,
  SupplyEntry,
  TierdBox,
} from '../../WikiCommon/WikiQuickElements';

export const WikiChemistryPage = (props: { chems: ReagentData }) => {
  const {
    title,
    description,
    addictive,
    industrial_use,
    supply_points,
    market_price,
    sintering,
    overdose,
    flavor,
    allergen,
    grinding,
    instant_reactions,
    distilled_reactions,
    icon_data,
  } = props.chems;

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
                fillLevel={0.5}
              />
            </LabeledList.Item>
            <LabeledList.Divider />
            <LabeledList.Item label="Description">
              {description ? description : <NotAvilableBox />}
            </LabeledList.Item>
            <LabeledList.Divider />
            <LabeledList.Item label="Addictive">
              {!!addictive && <TierdBox level={addictive} label="addictive" />}
            </LabeledList.Item>
            <LabeledList.Item label="Overdose">
              {overdose ? (
                <Box color="red">{overdose + 'u'}</Box>
              ) : (
                <NotAvilableBox />
              )}
            </LabeledList.Item>
            <LabeledList.Item label="Flavor">
              {flavor ? flavor : <NotAvilableBox />}
            </LabeledList.Item>
            <LabeledList.Divider />
            <LabeledList.Item label="Industrial Use">
              {industrial_use ? industrial_use : <NotAvilableBox />}
            </LabeledList.Item>
            <SupplyEntry
              supply_points={supply_points}
              market_price={market_price}
            />
            <LabeledList.Item label="Sintering">
              {sintering ? sintering : <NotAvilableBox />}
            </LabeledList.Item>
            {!!allergen && (
              <WikiSpoileredList
                ourKey={title}
                entries={allergen}
                title={'Allergens'}
              />
            )}
            <ChemicalReactionList
              ourKey={title}
              grinding={grinding}
              instant_reactions={instant_reactions}
              distilled_reactions={distilled_reactions}
            />
          </LabeledList>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
