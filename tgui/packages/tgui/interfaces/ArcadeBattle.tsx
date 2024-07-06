import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  Flex,
  LabeledList,
  ProgressBar,
  Section,
} from '../components';
import { Window } from '../layouts';

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
          <Flex spacing={1}>
            <Flex.Item>
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
            </Flex.Item>
            <Flex.Item>
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
            </Flex.Item>
          </Flex>
          {(gameOver && (
            <Button fluid mt={1} color="green" onClick={() => act('newgame')}>
              New Game
            </Button>
          )) || (
            <Flex mt={2} justify="space-between" spacing={1}>
              <Flex.Item grow={1}>
                <Button
                  fluid
                  icon="fist-raised"
                  tooltip="Go in for the kill!"
                  tooltipPosition="top"
                  onClick={() => act('attack')}
                >
                  Attack!
                </Button>
              </Flex.Item>
              <Flex.Item grow={1}>
                <Button
                  fluid
                  icon="band-aid"
                  tooltip="Heal yourself!"
                  tooltipPosition="top"
                  onClick={() => act('heal')}
                >
                  Heal!
                </Button>
              </Flex.Item>
              <Flex.Item grow={1}>
                <Button
                  fluid
                  icon="magic"
                  tooltip="Recharge your magic!"
                  tooltipPosition="top"
                  onClick={() => act('charge')}
                >
                  Recharge!
                </Button>
              </Flex.Item>
            </Flex>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
