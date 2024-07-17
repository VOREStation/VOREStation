import { capitalize } from 'common/string';

import { useBackend } from '../../backend';
import {
  Box,
  Button,
  ColorBox,
  LabeledList,
  Section,
  Stack,
} from '../../components';
import { ICON_BY_CATEGORY_NAME, ROOT_CATEGORIES, TOOLS } from './constants';
import { Data } from './types';

export const SelectionSection = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    category: rootCategoryIndex,
    selected_color,
    mode,
    paint_colors,
  } = data;
  return (
    <Section>
      <LabeledList>
        <LabeledList.Item label="Category">
          {ROOT_CATEGORIES.map((categoryName, i) => (
            <Button
              key={categoryName}
              selected={rootCategoryIndex === i}
              icon={ICON_BY_CATEGORY_NAME[categoryName]}
              color="transparent"
              onClick={() => act('category', { category: i })}
            >
              {categoryName}
            </Button>
          ))}
        </LabeledList.Item>
        <LabeledList.Item label="Modes">
          <Stack fill>
            {TOOLS.map((tool) => (
              <Stack.Item grow key={tool.bitmask}>
                <Button.Checkbox
                  checked={mode & tool.bitmask}
                  fluid
                  onClick={() =>
                    act('mode', {
                      mode: tool.bitmask,
                    })
                  }
                >
                  {tool.name}
                </Button.Checkbox>
              </Stack.Item>
            ))}
          </Stack>
        </LabeledList.Item>
        <LabeledList.Item label="Color">
          <Box inline width="64px" color={paint_colors[selected_color]}>
            {capitalize(selected_color)}
          </Box>
          {Object.keys(paint_colors).map((colorName) => (
            <ColorBox
              key={colorName}
              ml={1}
              color={paint_colors[colorName]}
              onClick={() =>
                act('color', {
                  paint_color: colorName,
                })
              }
            />
          ))}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
