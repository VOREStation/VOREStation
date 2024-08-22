import { map } from 'common/collections';
import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Box, Button, NoticeBox, Section, Table } from '../components';
import { Window } from '../layouts';

type Data = {
  contents: content[];
  name: string;
  locked: BooleanLike;
  secure: BooleanLike;
};

type content = { name: string; index: number; amount: number };

export const SmartVend = (props) => {
  const { act, config, data } = useBackend<Data>();

  const { secure, locked, contents } = data;

  return (
    <Window width={500} height={550}>
      <Window.Content scrollable>
        <Section title="Storage">
          {(secure && locked === -1 && (
            <NoticeBox danger>
              <Box>
                Sec.re ACC_** //):securi_nt.diag=&gt;##&apos;or 1=1&apos;%($...
              </Box>
            </NoticeBox>
          )) ||
            (secure && locked !== -1 && (
              <NoticeBox info>
                <Box>Secure Access: Please have your identification ready.</Box>
              </NoticeBox>
            )) ||
            ''}
          {(contents.length === 0 && (
            <NoticeBox>Unfortunately, this {config.title} is empty.</NoticeBox>
          )) || (
            <Table>
              <Table.Row header>
                <Table.Cell collapsing>Item</Table.Cell>
                <Table.Cell collapsing textAlign="center">
                  Amount
                </Table.Cell>
                <Table.Cell collapsing textAlign="center">
                  Dispense
                </Table.Cell>
              </Table.Row>
              {map(contents, (value: content, key) => (
                <Table.Row key={key}>
                  <Table.Cell collapsing>{value.name}</Table.Cell>
                  <Table.Cell collapsing textAlign="center">
                    {value.amount} in stock
                  </Table.Cell>
                  <Table.Cell collapsing>
                    <Button
                      disabled={value.amount < 1}
                      onClick={() =>
                        act('Release', {
                          index: value.index,
                          amount: 1,
                        })
                      }
                    >
                      1
                    </Button>
                    <Button
                      disabled={value.amount < 5}
                      onClick={() =>
                        act('Release', {
                          index: value.index,
                          amount: 5,
                        })
                      }
                    >
                      5
                    </Button>
                    <Button
                      disabled={value.amount < 25}
                      onClick={() =>
                        act('Release', {
                          index: value.index,
                          amount: 25,
                        })
                      }
                    >
                      25
                    </Button>
                    <Button
                      disabled={value.amount < 50}
                      onClick={() =>
                        act('Release', {
                          index: value.index,
                          amount: 50,
                        })
                      }
                    >
                      50
                    </Button>
                    <Button
                      disabled={value.amount < 1}
                      onClick={() =>
                        act('Release', {
                          index: value.index,
                        })
                      }
                    >
                      Custom
                    </Button>
                    <Button
                      disabled={value.amount < 1}
                      onClick={() =>
                        act('Release', {
                          index: value.index,
                          amount: value.amount,
                        })
                      }
                    >
                      All
                    </Button>
                  </Table.Cell>
                </Table.Row>
              ))}
            </Table>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
