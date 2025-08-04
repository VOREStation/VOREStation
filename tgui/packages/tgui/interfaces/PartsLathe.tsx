import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
  Stack,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { toTitleCase } from 'tgui-core/string';
import { MaterialAccessBar } from './common/MaterialAccessBar';
import type { Material } from './Fabrication/Types';

type Data = {
  panelOpen: BooleanLike;
  materials: Material[];
  SHEET_MATERIAL_AMOUNT: number;
  copyBoard: string | null;
  copyBoardReqComponents: { name: string; qty: number }[] | null;
  queue: string[];
  building: string | null;
  buildPercent: number | null;
  error: string | null;
  recipies: { name: string; type: string }[];
};

export const PartsLathe = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    copyBoard,
    copyBoardReqComponents,
    queue,
    building,
    buildPercent,
    error,
    recipies,
    SHEET_MATERIAL_AMOUNT,
  } = data;
  return (
    <Window width={500} height={500}>
      <Window.Content>
        <Stack fill vertical>
          {error ? (
            <NoticeBox danger>Missing Materials: {error}</NoticeBox>
          ) : null}
          <Stack.Item grow>
            <Stack fill>
              <Stack.Item grow>
                <Section title="Recipes" fill>
                  {recipies.length &&
                    recipies.map((recipe) => (
                      <Box key={recipe.name}>
                        <Button
                          icon="wrench"
                          onClick={() => act('queue', { queue: recipe.type })}
                        >
                          {toTitleCase(recipe.name)}
                        </Button>
                      </Box>
                    ))}
                </Section>
              </Stack.Item>
              <Stack.Item grow>
                <Stack vertical fill>
                  {building ? (
                    <Stack.Item grow>
                      <Section title="Currently Building" fill>
                        <LabeledList>
                          <LabeledList.Item label="Name">
                            {toTitleCase(building)}
                          </LabeledList.Item>
                          <LabeledList.Item label="Progress">
                            <ProgressBar
                              color="good"
                              value={buildPercent!}
                              maxValue={100}
                            />
                          </LabeledList.Item>
                        </LabeledList>
                      </Section>
                    </Stack.Item>
                  ) : (
                    ''
                  )}
                  {copyBoard ? (
                    <Stack.Item grow>
                      <Section title="Circuit Reader">
                        <LabeledList>
                          <LabeledList.Item
                            label="Loaded Circuit"
                            buttons={
                              <Button
                                icon="eject"
                                onClick={() => act('ejectBoard')}
                              >
                                Eject
                              </Button>
                            }
                          >
                            {toTitleCase(copyBoard)}
                          </LabeledList.Item>
                        </LabeledList>
                        {(copyBoardReqComponents?.length && (
                          <>
                            {copyBoardReqComponents.map((comp) => (
                              <Box key={comp.name}>
                                {comp.qty} x {toTitleCase(comp.name)}
                              </Box>
                            ))}
                            <Button
                              icon="wrench"
                              onClick={() => act('queueBoard')}
                            >
                              Build All
                            </Button>
                          </>
                        )) || <Box>Board has no required components.</Box>}
                      </Section>
                    </Stack.Item>
                  ) : (
                    ''
                  )}
                  <Stack.Item grow>
                    <Section title="Queue" fill>
                      {(queue.length &&
                        queue.map((item, i) => (
                          <Box key={item} color="label">
                            #{i + 1}: {toTitleCase(item)}
                            {((i > 0 || !building) && (
                              <Button
                                ml={1}
                                icon="times"
                                onClick={() => act('cancel', { cancel: i + 1 })}
                              >
                                Cancel
                              </Button>
                            )) ||
                              ''}
                          </Box>
                        ))) || <NoticeBox info>Queue Empty</NoticeBox>}
                    </Section>
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <Section fill>
              <MaterialAccessBar
                availableMaterials={data.materials}
                SHEET_MATERIAL_AMOUNT={SHEET_MATERIAL_AMOUNT}
                onEjectRequested={(mat: Material, qty: number) =>
                  act('remove_mat', {
                    id: mat.name,
                    amount: qty,
                  })
                }
              />
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
