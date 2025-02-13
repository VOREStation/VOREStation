import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  LabeledList,
  ProgressBar,
  Section,
  Stack,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

type Data = {
  name: string;
  temp: string;
  enemyAction: string;
  enemyName: string;
  playerHP: number;
  playerMP: number;
  enemyHP: number;
  gameOver: BooleanLike;
};

export const ArcadeBattle = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    temp,
    enemyAction,
    enemyName,
    playerHP,
    playerMP,
    enemyHP,
    gameOver,
  } = data;

  return (
    <Window width={400} height={240}>
      <Window.Content>
        <Section title={enemyName} textAlign="center">
          <Section color="label">
            <Box>{temp}</Box>
            <Box>{!gameOver && enemyAction}</Box>
          </Section>
          <Stack>
            <Stack.Item>
              <LabeledList>
                <LabeledList.Item label="Player Health">
                  <ProgressBar
                    value={playerHP}
                    minValue={0}
                    maxValue={30}
                    ranges={{
                      olive: [31, Infinity],
                      good: [20, 31],
                      average: [10, 20],
                      bad: [-Infinity, 10],
                    }}
                  >
                    {playerHP}HP
                  </ProgressBar>
                </LabeledList.Item>
                <LabeledList.Item label="Player Magic">
                  <ProgressBar
                    value={playerMP}
                    minValue={0}
                    maxValue={10}
                    ranges={{
                      purple: [11, Infinity],
                      violet: [3, 11],
                      bad: [-Infinity, 3],
                    }}
                  >
                    {playerMP}MP
                  </ProgressBar>
                </LabeledList.Item>
              </LabeledList>
            </Stack.Item>
            <Stack.Item>
              <LabeledList>
                <LabeledList.Item label="Enemy HP">
                  <ProgressBar
                    value={enemyHP}
                    minValue={0}
                    maxValue={45}
                    ranges={{
                      olive: [31, Infinity],
                      good: [20, 31],
                      average: [10, 20],
                      bad: [-Infinity, 10],
                    }}
                  >
                    {enemyHP}HP
                  </ProgressBar>
                </LabeledList.Item>
              </LabeledList>
            </Stack.Item>
          </Stack>
          {(gameOver && (
            <Button fluid mt={1} color="green" onClick={() => act('newgame')}>
              New Game
            </Button>
          )) || (
            <Stack mt={2} justify="space-between">
              <Stack.Item grow>
                <Button
                  fluid
                  icon="fist-raised"
                  tooltip="Go in for the kill!"
                  tooltipPosition="top"
                  onClick={() => act('attack')}
                >
                  Attack!
                </Button>
              </Stack.Item>
              <Stack.Item grow>
                <Button
                  fluid
                  icon="band-aid"
                  tooltip="Heal yourself!"
                  tooltipPosition="top"
                  onClick={() => act('heal')}
                >
                  Heal!
                </Button>
              </Stack.Item>
              <Stack.Item grow>
                <Button
                  fluid
                  icon="magic"
                  tooltip="Recharge your magic!"
                  tooltipPosition="top"
                  onClick={() => act('charge')}
                >
                  Recharge!
                </Button>
              </Stack.Item>
            </Stack>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
