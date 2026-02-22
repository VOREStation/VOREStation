import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Icon,
  LabeledList,
  NumberInput,
  Section,
  Stack,
} from 'tgui-core/components';
import { VorePanelTooltip } from '../VorePanel/VorePanelElements/VorePanelTooltip';
import { gameStateToColor, gameStateToIcon, gameTooltip } from './constants';
import { getRemainingMines, getScoreColor } from './functions';
import type { Data } from './types';

export const PlayerMenu = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    grid_size,
    mine_count,
    max_mines,
    dealer,
    placed_mines,
    placed_flags,
    game_state,
    is_dealer,
  } = data;

  const remainingMines = getRemainingMines(
    game_state,
    mine_count,
    !!is_dealer,
    placed_mines,
    placed_flags,
  );

  return (
    <Section
      title="Game Status"
      buttons={
        <Stack>
          <Stack.Item>
            {(game_state > 0 && (
              <Button.Confirm
                onClick={() => {
                  act('restart_game');
                }}
              >
                Restart Game
              </Button.Confirm>
            )) ||
              (game_state === 0 && dealer && !remainingMines && (
                <Button.Confirm
                  onClick={() => {
                    act('setup_action', { action: 'start_game' });
                  }}
                >
                  Start Game
                </Button.Confirm>
              ))}
          </Stack.Item>
          <Stack.Item>
            <Button onClick={() => act('invite_player')}>Invite Player</Button>
          </Stack.Item>
          <Stack.Item>
            <VorePanelTooltip tooltip={gameTooltip} displayText="?" />
          </Stack.Item>
        </Stack>
      }
    >
      <Stack vertical>
        <Stack.Item>
          <LabeledList>
            <LabeledList.Item label="Dealer">
              {dealer ? (
                <Button.Confirm onClick={() => act('clear_dealer')}>
                  Clear Dealer ({dealer})
                </Button.Confirm>
              ) : game_state !== 1 ? (
                <Button onClick={() => act('be_dealer')}>Be Dealer</Button>
              ) : (
                'Single Player Mode'
              )}
            </LabeledList.Item>
            <LabeledList.Item label="Grid Size">
              {is_dealer ? (
                <NumberInput
                  width="30px"
                  value={grid_size}
                  minValue={4}
                  maxValue={16}
                  stepPixelSize={40}
                  onChange={(value) =>
                    act('setup_action', {
                      action: 'change_grid_size',
                      data: { new_grid: value },
                    })
                  }
                />
              ) : (
                grid_size
              )}
            </LabeledList.Item>
            <LabeledList.Item label="Mine Count">
              {is_dealer ? (
                <NumberInput
                  width="40px"
                  value={mine_count}
                  minValue={
                    placed_mines ? Object.keys(placed_mines).length || 1 : 1
                  }
                  maxValue={max_mines}
                  stepPixelSize={10}
                  onChange={(value) =>
                    act('setup_action', {
                      action: 'change_mine_count',
                      data: { new_mines: value },
                    })
                  }
                />
              ) : (
                mine_count
              )}
            </LabeledList.Item>
            {!!is_dealer && (
              <LabeledList.Item label="Ranomize Mines">
                <Stack>
                  <Stack.Item>
                    <Button.Confirm
                      onClick={() =>
                        act('setup_action', { action: 'auto_place_mines' })
                      }
                    >
                      Place All
                    </Button.Confirm>
                  </Stack.Item>
                  <Stack.Item>
                    <Button.Confirm
                      onClick={() =>
                        act('setup_action', { action: 'clear_all_mines' })
                      }
                    >
                      Clear All
                    </Button.Confirm>
                  </Stack.Item>
                  {(!placed_mines || !Object.keys(placed_mines).length) && (
                    <Stack.Item>
                      <Button.Confirm
                        onClick={() =>
                          act('setup_action', {
                            action: 'auto_place_mines_self',
                          })
                        }
                      >
                        Play Alone
                      </Button.Confirm>
                    </Stack.Item>
                  )}
                </Stack>
              </LabeledList.Item>
            )}
          </LabeledList>
        </Stack.Item>
        <Stack.Item>
          <Stack fill>
            <Stack.Item grow>
              <Box preserveWhitespace inline color="label">
                {`Remaining Mines: `}
              </Box>
              <Box
                fontSize={2}
                inline
                color={getScoreColor(remainingMines, game_state)}
              >
                {remainingMines}
              </Box>
            </Stack.Item>
            <Stack.Item grow>
              <Icon
                size={2}
                name={gameStateToIcon[game_state]}
                color={gameStateToColor[game_state]}
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
