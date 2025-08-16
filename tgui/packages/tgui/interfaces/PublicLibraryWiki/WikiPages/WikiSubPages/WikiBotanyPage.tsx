import { Box, LabeledList, Section, Stack } from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';

import type { BotanyData } from '../../types';
import { ColorizedImage } from '../../WikiCommon/WikiColorIcon';
import { WikiSpoileredList } from '../../WikiCommon/WikiListElements';
import { NotAvilableBox } from '../../WikiCommon/WikiQuickElements';

export const WikiBotanyPage = (props: { seeds: BotanyData }) => {
  const {
    title,
    feeding,
    watering,
    lighting,
    crop_yield,
    traits,
    mob_product,
    chem_breakdown,
    gas_consumed,
    gas_exuded,
    mutations,
    icon_data,
  } = props.seeds;

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
            <LabeledList.Item label="Feeding">
              {feeding ? (
                <Box color="brown">{feeding}</Box>
              ) : (
                <NotAvilableBox />
              )}
            </LabeledList.Item>
            <LabeledList.Item label="Watering">
              {watering ? (
                <Box color="blue">{watering}</Box>
              ) : (
                <NotAvilableBox />
              )}
            </LabeledList.Item>
            <LabeledList.Item label="Lighting">
              {lighting ? (
                <Box color="yellow">{lighting}</Box>
              ) : (
                <NotAvilableBox />
              )}
            </LabeledList.Item>
            <LabeledList.Item label="Yield">
              {!!crop_yield && crop_yield > 0 ? crop_yield : <NotAvilableBox />}
            </LabeledList.Item>
            {!!traits && (
              <WikiSpoileredList
                ourKey={title}
                entries={traits}
                title={'Traits'}
              />
            )}
            {!!mob_product && (
              <>
                <LabeledList.Divider />
                <LabeledList.Item label="">
                  <Box bold color="red">
                    DANGER - MAY BE MOBILE
                  </Box>
                </LabeledList.Item>
              </>
            )}
            {!!chem_breakdown && (
              <WikiSpoileredList
                ourKey={title}
                entries={chem_breakdown}
                title={'Chemical Breakdown'}
              />
            )}
            {!!gas_consumed && (
              <WikiSpoileredList
                ourKey={title}
                entries={gas_consumed}
                title={'Gas Consumed'}
              />
            )}
            {!!gas_exuded && (
              <WikiSpoileredList
                ourKey={title}
                entries={gas_exuded}
                title={'Gas Exuded'}
              />
            )}
            {!!mutations && (
              <WikiSpoileredList
                ourKey={title}
                entries={mutations}
                title={'Mutations'}
              />
            )}
          </LabeledList>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
