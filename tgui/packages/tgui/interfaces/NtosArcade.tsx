import { BooleanLike } from 'common/react';

import { resolveAsset } from '../assets';
import { useBackend } from '../backend';
import {
  AnimatedNumber,
  Box,
  Button,
  LabeledList,
  ProgressBar,
  Section,
  Table,
} from '../components';
import { NtosWindow } from '../layouts';

type Data = {
  Hitpoints: number;
  PlayerHitpoints: number;
  PlayerMP: number;
  TicketCount: number;
  GameActive: BooleanLike;
  PauseState: BooleanLike;
  Status: string;
  BossID: string;
};

export const NtosArcade = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    PlayerHitpoints,
    PlayerMP,
    PauseState,
    Status,
    Hitpoints,
    BossID,
    GameActive,
    TicketCount,
  } = data;

  return (
    <NtosWindow width={450} height={350}>
      <NtosWindow.Content>
        <Section title="Outbomb Cuban Pete Ultra" textAlign="center">
          <Box>
            <Table>
              <Table.Row>
                <Table.Cell size={2}>
                  <Box m={1} />
                  <LabeledList>
                    <LabeledList.Item label="Player Health">
                      <ProgressBar
                        value={PlayerHitpoints}
                        minValue={0}
                        maxValue={30}
                        ranges={{
                          olive: [31, Infinity],
                          good: [20, 31],
                          average: [10, 20],
                          bad: [-Infinity, 10],
                        }}
                      >
                        {PlayerHitpoints}HP
                      </ProgressBar>
                    </LabeledList.Item>
                    <LabeledList.Item label="Player Magic">
                      <ProgressBar
                        value={PlayerMP}
                        minValue={0}
                        maxValue={10}
                        ranges={{
                          purple: [11, Infinity],
                          violet: [3, 11],
                          bad: [-Infinity, 3],
                        }}
                      >
                        {PlayerMP}MP
                      </ProgressBar>
                    </LabeledList.Item>
                  </LabeledList>
                  <Box my={1} mx={4} />
                  <Section
                    backgroundColor={PauseState === 1 ? '#1b3622' : '#471915'}
                  >
                    {Status}
                  </Section>
                </Table.Cell>
                <Table.Cell>
                  <ProgressBar
                    value={Hitpoints}
                    minValue={0}
                    maxValue={45}
                    ranges={{
                      good: [30, Infinity],
                      average: [5, 30],
                      bad: [-Infinity, 5],
                    }}
                  >
                    <AnimatedNumber value={Hitpoints} />
                    HP
                  </ProgressBar>
                  <Box m={1} />
                  <Section inline width="156px" textAlign="center">
                    <img src={resolveAsset(BossID)} />
                  </Section>
                </Table.Cell>
              </Table.Row>
            </Table>
            <Box my={1} mx={4} />
            <Button
              icon="fist-raised"
              tooltip="Go in for the kill!"
              tooltipPosition="top"
              disabled={GameActive === 0 || PauseState === 1}
              onClick={() => act('Attack')}
            >
              Attack!
            </Button>
            <Button
              icon="band-aid"
              tooltip="Heal yourself!"
              tooltipPosition="top"
              disabled={GameActive === 0 || PauseState === 1}
              onClick={() => act('Heal')}
            >
              Heal!
            </Button>
            <Button
              icon="magic"
              tooltip="Recharge your magic!"
              tooltipPosition="top"
              disabled={GameActive === 0 || PauseState === 1}
              onClick={() => act('Recharge_Power')}
            >
              Recharge!
            </Button>
          </Box>
          <Box>
            <Button
              icon="sync-alt"
              tooltip="One more game couldn't hurt."
              tooltipPosition="top"
              disabled={GameActive === 1}
              onClick={() => act('Start_Game')}
            >
              Begin Game
            </Button>
            <Button
              icon="ticket-alt"
              tooltip="Claim at your local Arcade Computer for Prizes!"
              tooltipPosition="top"
              disabled={GameActive === 1}
              onClick={() => act('Dispense_Tickets')}
            >
              Claim Tickets
            </Button>
          </Box>
          <Box color={TicketCount >= 1 ? 'good' : 'normal'}>
            Earned Tickets: {TicketCount}
          </Box>
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
