import { useBackend } from '../../backend';
import { Box, Button, Flex, Section } from '../../components';
import { Data } from './types';

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
        <>
          {!recording && (
            <Button icon="circle" onClick={() => act('record_recipe')}>
              Record
            </Button>
          )}
          {recording && (
            <Button
              icon="ban"
              color="bad"
              onClick={() => act('cancel_recording')}
            >
              Discard
            </Button>
          )}
          {recording && (
            <Button
              icon="save"
              color="green"
              onClick={() => act('save_recording')}
            >
              Save
            </Button>
          )}
          {!recording && (
            <Button.Confirm
              icon="trash"
              confirmIcon="trash"
              color="bad"
              onClick={() => act('clear_recipes')}
            >
              Clear All
            </Button.Confirm>
          )}
        </>
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
            <Flex key={recipe}>
              <Flex.Item grow={1}>
                <Button
                  fluid
                  icon="flask"
                  onClick={() => act('dispense_recipe', { recipe })}
                >
                  {recipe}
                </Button>
              </Flex.Item>
              <Flex.Item>
                <Button.Confirm
                  icon="trash"
                  confirmIcon="triangle-exclamation"
                  confirmContent={''}
                  color="bad"
                  onClick={() => act('remove_recipe', { recipe })}
                />
              </Flex.Item>
            </Flex>
          ))
        : 'No Recipes.'}
    </Section>
  );
};
