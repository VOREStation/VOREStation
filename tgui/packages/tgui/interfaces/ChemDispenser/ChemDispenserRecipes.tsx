import { Box, Button, Section, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { handleImportData } from '../PlushieEditor/function';
import { exportRecipes } from './functions';
import type { Recipe } from './types';

export const ChemDispenserRecipes = (props: {
  /** Associated list of saved recipe macros. */
  recipes: Record<string, Recipe[]>;
  /** The current recipe macro that's being recorded, if any. We assume we aren't recording a recipe if this is undefined! */
  recordingRecipe: Recipe[];
  /** Called when the user attempts to start a recipe recording. */
  recordAct: () => void;
  /** Called when the user attempts to cancel a recipe recording. */
  cancelAct: () => void;
  /** Called when the user attempts to save a recipe recording. */
  saveAct: () => void;
  /** Called when the user attempts to clear all recipe recordings. */
  clearAct: () => void;
  /** Called when the user attempts to use a recipe macro. */
  dispenseAct: (recipe: string) => void;
  /** Called when a recipe dispense button is checking whether or not it will appear "selected". Arg is the ID of the button's reagent. Defaults to false if undefined. */
  getDispenseButtonSelected?: (recipe: string) => BooleanLike;
  /** Called when the user attempts to remove a recipe macro. */
  removeAct: (recipe: string) => void;
}) => {
  const {
    recipes,
    recordingRecipe,
    recordAct,
    cancelAct,
    saveAct,
    clearAct,
    dispenseAct,
    getDispenseButtonSelected,
    removeAct,
  } = props;

  const isRecording: boolean = !!recordingRecipe;
  const recipeData = Object.keys(recipes).sort();

  return (
    <Section
      title="Recipes"
      fill
      scrollable
      buttons={
        <Stack>
          {!isRecording && (
            <Stack.Item>
              <Button icon="circle" onClick={recordAct}>
                Record
              </Button>
            </Stack.Item>
          )}
          {isRecording && (
            <Stack.Item>
              <Button icon="ban" color="bad" onClick={cancelAct}>
                Discard
              </Button>
            </Stack.Item>
          )}
          {isRecording && (
            <Stack.Item>
              <Button icon="save" color="green" onClick={saveAct}>
                Save
              </Button>
            </Stack.Item>
          )}
          {!isRecording && (
            <>
              <Stack.Item>
                <Button.File
                  accept=".json"
                  tooltip="Import recipes"
                  icon="file-alt"
                  onSelectFiles={(files) => handleImportData(files)}
                />
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon="download"
                  tooltip="Export recipes"
                  disabled={!recipeData.length}
                  onClick={() => exportRecipes(recipes)}
                />
              </Stack.Item>
              <Stack.Item>
                <Button.Confirm
                  icon="trash"
                  confirmIcon="trash"
                  color="bad"
                  onClick={clearAct}
                >
                  Clear All
                </Button.Confirm>
              </Stack.Item>
            </>
          )}
        </Stack>
      }
    >
      {isRecording && (
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
                  selected={
                    getDispenseButtonSelected
                      ? getDispenseButtonSelected(recipe)
                      : undefined
                  }
                  onClick={() => dispenseAct(recipe)}
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
                  onClick={() => removeAct(recipe)}
                />
              </Stack.Item>
            </Stack>
          ))
        : 'No Recipes.'}
    </Section>
  );
};
