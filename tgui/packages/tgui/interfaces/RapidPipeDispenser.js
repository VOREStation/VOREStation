import { classes } from 'common/react';
import { capitalize } from 'common/string';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, ColorBox, Stack, LabeledList, Section, Tabs } from '../components';
import { Window } from '../layouts';

const ROOT_CATEGORIES = [
  'Atmospherics',
  'Disposals',
//   'Transit Tubes',
];

export const ICON_BY_CATEGORY_NAME = {
  'Atmospherics': 'wrench',
  'Disposals': 'trash-alt',
  'Transit Tubes': 'bus',
  'Pipes': 'grip-lines',
  'Disposal Pipes': 'grip-lines',
  'Devices': 'microchip',
  'Heat Exchange': 'thermometer-half',
  'Insulated pipes': 'snowflake',
  'Station Equipment': 'microchip',
};

const TOOLS = [
  {
    name: 'Dispense',
    bitmask: 1,
  },
  {
    name: 'Connect',
    bitmask: 2,
  },
  {
    name: 'Destroy',
    bitmask: 4,
  },
  {
    name: 'Paint',
    bitmask: 8,
  },
];

const SelectionSection = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    category: rootCategoryIndex,
    selected_color,
    mode,
  } = data;
  return (
    <Section>
      <LabeledList>
        <LabeledList.Item
          label="Category">
          {ROOT_CATEGORIES.map((categoryName, i) => (
            <Button
              key={categoryName}
              selected={rootCategoryIndex === i}
              icon={ICON_BY_CATEGORY_NAME[categoryName]}
              color="transparent"
              onClick={() => act('category', { category: i })} >
              {categoryName}
            </Button>
          ))}
        </LabeledList.Item>
        <LabeledList.Item label="Modes">
          <Stack fill>
            {TOOLS.map(tool => (
              <Stack.Item grow key={tool.bitmask}>
                <Button.Checkbox
                  checked={mode & tool.bitmask}
                  fluid
                  content={tool.name}
                  onClick={() => act('mode', {
                    mode: tool.bitmask,
                  })} />
              </Stack.Item>
            ))}
          </Stack>
        </LabeledList.Item>
        <LabeledList.Item
          label="Color">
          <Box
            inline
            width="64px"
            color={data.paint_colors[selected_color]}>
            {capitalize(selected_color)}
          </Box>
          {Object.keys(data.paint_colors)
            .map(colorName => (
              <ColorBox
                key={colorName}
                ml={1}
                color={data.paint_colors[colorName]}
                onClick={() => act('color', {
                  paint_color: colorName,
                })} />
            ))}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const LayerSection = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    category: rootCategoryIndex,
    piping_layer,
  } = data;
  const previews = data.preview_rows.flatMap(row => row.previews);
  return (
    <Section fill width={7.5}>
      {rootCategoryIndex === 0 && (
        <Stack vertical mb={1}>
          {[1, 2, 3, 4, 5].map(layer => (
            <Stack.Item my={0} key={layer}>
              <Button.Checkbox
                checked={layer === piping_layer}
                content={'Layer ' + layer}
                onClick={() => act('piping_layer', {
                  piping_layer: layer,
                })} />
            </Stack.Item>
          ))}
        </Stack>
      )}
      <Box width="120px">
        {previews.map(preview => (
          <Button
            ml={0}
            key={preview.dir}
            title={preview.dir_name}
            selected={preview.selected}
            style={{
              width: '40px',
              height: '40px',
              padding: 0,
            }}
            onClick={() => act('setdir', {
              dir: preview.dir,
              flipped: preview.flipped,
            })}>
            <Box
              className={classes([
                'pipes32x32',
                preview.dir + '-' + preview.icon_state,
              ])}
              style={{
                transform: 'scale(1.5) translate(9.5%, 9.5%)',
              }} />
          </Button>
        ))}
      </Box>
    </Section>
  );
};

const PipeTypeSection = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    categories = [],
  } = data;
  const [
    categoryName,
    setCategoryName,
  ] = useLocalState(context, 'categoryName');
  const shownCategory = categories
    .find(category => category.cat_name === categoryName)
    || categories[0];
  return (
    <Section fill scrollable>
      <Tabs>
        {categories.map((category, i) => (
          <Tabs.Tab
            fluid
            key={category.cat_name}
            icon={ICON_BY_CATEGORY_NAME[category.cat_name]}
            selected={category.cat_name === shownCategory.cat_name}
            onClick={() => setCategoryName(category.cat_name)}>
            {category.cat_name}
          </Tabs.Tab>
        ))}
      </Tabs>
      {shownCategory?.recipes.map(recipe => (
        <Button.Checkbox
          key={recipe.pipe_index}
          fluid
          ellipsis
          checked={recipe.selected}
          content={recipe.pipe_name}
          title={recipe.pipe_name}
          onClick={() => act('pipe_type', {
            pipe_type: recipe.pipe_index,
            category: shownCategory.cat_name,
          })} />
      ))}
    </Section>
  );
};

export const RapidPipeDispenser = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    category: rootCategoryIndex,
  } = data;
  return (
    <Window
      width={550}
      height={570}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <SelectionSection />
          </Stack.Item>
          <Stack.Item grow>
            <Stack fill>
              <Stack.Item>
                <Stack vertical fill>
                  <Stack.Item grow>
                    <LayerSection />
                  </Stack.Item>
                </Stack>
              </Stack.Item>
              <Stack.Item grow>
                <PipeTypeSection />
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};