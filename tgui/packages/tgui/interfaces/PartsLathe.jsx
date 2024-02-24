import { toTitleCase } from 'common/string';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
} from '../components';
import { Window } from '../layouts';
import { Materials } from './ExosuitFabricator';

export const PartsLathe = (props) => {
  const { act, data } = useBackend();
  const {
    panelOpen,
    copyBoard,
    copyBoardReqComponents,
    queue,
    building,
    buildPercent,
    error,
    recipies,
  } = data;
  return (
    <Window width={500} height={500}>
      <Window.Content scrollable>
        {(error && <NoticeBox danger>Missing Materials: {error}</NoticeBox>) ||
          null}
        <Section title="Materials">
          <Materials displayAllMat />
        </Section>
        {(building && (
          <Section title="Currently Building">
            <LabeledList>
              <LabeledList.Item label="Name">
                {toTitleCase(building)}
              </LabeledList.Item>
              <LabeledList.Item label="Progress">
                <ProgressBar color="good" value={buildPercent} maxValue={100} />
              </LabeledList.Item>
            </LabeledList>
          </Section>
        )) ||
          null}
        {copyBoard && (
          <Section title="Circuit Reader">
            <LabeledList>
              <LabeledList.Item
                label="Loaded Circuit"
                buttons={
                  <Button icon="eject" onClick={() => act('ejectBoard')}>
                    Eject
                  </Button>
                }
              >
                {toTitleCase(copyBoard)}
              </LabeledList.Item>
            </LabeledList>
            {(copyBoardReqComponents && copyBoardReqComponents.length && (
              <>
                {copyBoardReqComponents.map((comp) => (
                  <Box key={comp.name}>
                    {comp.qty} x {toTitleCase(comp.name)}
                  </Box>
                ))}
                <Button icon="wrench" onClick={() => act('queueBoard')}>
                  Build All
                </Button>
              </>
            )) || <Box>Board has no required components.</Box>}
          </Section>
        )}
        <Section title="Queue">
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
                  null}
              </Box>
            ))) || <NoticeBox info>Queue Empty</NoticeBox>}
        </Section>
        <Section title="Recipes">
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
      </Window.Content>
    </Window>
  );
};
