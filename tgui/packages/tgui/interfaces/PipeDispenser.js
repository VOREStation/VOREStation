import { useBackend, useLocalState } from '../backend';
import { Box, Button, Section, Tabs } from '../components';
import { Window } from '../layouts';
import { ICON_BY_CATEGORY_NAME } from './RapidPipeDispenser';

export const PipeDispenser = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    disposals,
    p_layer,
    pipe_layers,
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
    <Window
      width={425}
      height={515}
      resizable>
      <Window.Content scrollable>
        {!disposals && (
          <Section title="Layer">
            <Box>
              {Object.keys(pipe_layers)
                .map(layerName => (
                  <Button.Checkbox
                    key={layerName}
                    fluid
                    checked={pipe_layers[layerName] === p_layer}
                    content={layerName}
                    onClick={() => act('p_layer', {
                      p_layer: pipe_layers[layerName],
                    })} />
                ))}
            </Box>
          </Section>
        )}
        <Section title="Pipes">
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
            <Button
              key={recipe.pipe_name}
              fluid
              ellipsis
              content={recipe.pipe_name}
              title={recipe.pipe_name}
              onClick={() => act('dispense_pipe', {
                ref: recipe.ref,
                bent: recipe.bent,
                category: shownCategory.cat_name,
              })} />
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
};
