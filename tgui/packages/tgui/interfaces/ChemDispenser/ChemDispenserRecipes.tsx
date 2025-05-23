import { useBackend } from 'tgui/backend';
import { Box, Button, Section, Stack } from 'tgui-core/components';

import type { Data } from './types';

export const ChemDispenserRecipes = (props) => {
  const { act, data } = useBackend<Data>();
  const { recipes, recordingRecipe } = data;

  const recording: boolean = !!recordingRecipe;
  const recipeData = Object.keys(recipes).sort();

  return (
    <Section
      title="Recipes"
      fill
      scrollable
      buttons={
        <Stack>
          {!recording && (
            <Stack.Item>
              <Button icon="circle" onClick={() => act('record_recipe')}>
                Record
              </Button>
            </Stack.Item>
          )}
          {recording && (
            <Stack.Item>
              <Button
                icon="ban"
                color="bad"
                onClick={() => act('cancel_recording')}
              >
                Discard
              </Button>
            </Stack.Item>
          )}
          {recording && (
            <Stack.Item>
              <Button
                icon="save"
                color="green"
                onClick={() => act('save_recording')}
              >
                Save
              </Button>
            </Stack.Item>
          )}
          {!recording && (
            <Stack.Item>
              <Button.Confirm
                icon="trash"
                confirmIcon="trash"
                color="bad"
                onClick={() => act('clear_recipes')}
              >
                Clear All
              </Button.Confirm>
            </Stack.Item>
          )}
        </Stack>
      }
    >
      {recording && (
        <>
          <Box color="green" fontSize={1.2} bold>
            Recording In Progress...
          </Box>
          <Box color="label">
            Press dispenser buttons in the order you wish for them to be
            repeated, then click{' '}
            <Box color="good" inline>
              Save
            </Box>
            .
          </Box>
          <Box color="average" mb={1}>
            Alternatively, if you mess up the recipe and want to discard this
            recording, click{' '}
            <Box color="bad" inline>
              Discard
            </Box>
            .
          </Box>
        </>
      )}
      {recipeData.length
        ? recipeData.map((recipe) => (
            <Stack key={recipe}>
              <Stack.Item grow>
                <Button
                  fluid
                  icon="flask"
                  onClick={() => act('dispense_recipe', { recipe })}
                >
                  {recipe}
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button.Confirm
                  icon="trash"
                  confirmIcon="triangle-exclamation"
                  confirmContent={''}
                  color="bad"
                  onClick={() => act('remove_recipe', { recipe })}
                />
              </Stack.Item>
            </Stack>
          ))
        : 'No Recipes.'}
    </Section>
  );
};
