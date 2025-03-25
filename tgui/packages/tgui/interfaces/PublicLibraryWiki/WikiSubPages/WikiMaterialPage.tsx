import { Box, LabeledList, Section, Stack } from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';

import type { MaterialData } from '../types';
import { ColorizedImage } from '../WikiCommon/WikiColorIcon';
import { WikiSpoileredList } from '../WikiCommon/WikiListElements';
import {
  NoBox,
  NotAvilableBox,
  TemperatureBox,
  YesBox,
} from '../WikiCommon/WikiQuickElements';

export const WikiMaterialPage = (props: { materials: MaterialData }) => {
  const {
    title,
    integrity,
    hardness,
    weight,
    stack_size,
    supply_points,
    market_price,
    opacity,
    conductive,
    protectiveness,
    explosion_resistance,
    radioactivity,
    reflectivity,
    melting_point,
    ignition_point,
    grind_reagents,
    recipies,
    icon_data,
  } = props.materials;

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
            <LabeledList.Item label="Integrity">{integrity}</LabeledList.Item>
            <LabeledList.Item label="Hardness">{hardness}</LabeledList.Item>
            <LabeledList.Item label="Weight">{weight}</LabeledList.Item>
            <LabeledList.Divider />
            <LabeledList.Item label="Supply Points">
              {supply_points +
                ' per sheet, ' +
                supply_points * stack_size +
                ' per stack of ' +
                stack_size}
            </LabeledList.Item>
            <LabeledList.Item label="Market Price">
              {market_price +
                ' thaler' +
                (market_price > 1 ? 's' : '') +
                ' per sheet  |  ' +
                market_price * stack_size +
                ' thaler' +
                (market_price * stack_size > 1 ? 's' : '') +
                ' per stack of ' +
                stack_size}
            </LabeledList.Item>
            <LabeledList.Divider />
            <LabeledList.Item label="Transparent">
              {opacity > 0.5 ? <YesBox /> : <NoBox />}
            </LabeledList.Item>
            <LabeledList.Item label="Conductive">
              {conductive ? <YesBox /> : <NoBox />}
            </LabeledList.Item>
            <LabeledList.Divider />
            <LabeledList.Item label="Stability">
              {protectiveness ? protectiveness : <NotAvilableBox />}
            </LabeledList.Item>
            <LabeledList.Item label="Blast Resistance">
              {explosion_resistance ? explosion_resistance : <NotAvilableBox />}
            </LabeledList.Item>
            <LabeledList.Item label="Radioactivity">
              {radioactivity ? (
                <Box color="yellow">{radioactivity}</Box>
              ) : (
                <NotAvilableBox />
              )}
            </LabeledList.Item>
            <LabeledList.Item label="Reflectivity">
              {reflectivity ? (
                <Box color="teal">{reflectivity * 100}</Box>
              ) : (
                <NotAvilableBox />
              )}
            </LabeledList.Item>
            <LabeledList.Divider />
            <LabeledList.Item label="Melting Point">
              {melting_point > 0 ? (
                <TemperatureBox temperature={melting_point} color="red" />
              ) : (
                <NotAvilableBox />
              )}
            </LabeledList.Item>
            <LabeledList.Item label="Ignition Point">
              {ignition_point > 0 ? (
                <TemperatureBox temperature={ignition_point} color="orange" />
              ) : (
                <NotAvilableBox />
              )}
            </LabeledList.Item>
            {grind_reagents && (
              <WikiSpoileredList
                title="Sheet Grind Result"
                entries={grind_reagents}
              />
            )}
            {recipies && (
              <WikiSpoileredList title="Recipes" entries={recipies} />
            )}
          </LabeledList>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
