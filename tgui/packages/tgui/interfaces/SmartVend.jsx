import { map } from 'common/collections';
import { useBackend } from '../backend';
import { Button, Box, NoticeBox, Section, Table } from '../components';
import { Window } from '../layouts';

export const SmartVend = (props, context) => {
  const { act, config, data } = useBackend(context);
  return (
    <Window width={500} height={550} resizable>
      <Window.Content scrollable>
        <Section title="Storage">
          {(data.secure && (
            <NoticeBox danger={data.locked === -1} info={data.locked !== -1}>
              {data.locked === -1 ? (
                <Box>
                  Sec.re ACC_** //):securi_nt.diag=&gt;##&apos;or
                  1=1&apos;%($...
                </Box>
              ) : (
                <Box>Secure Access: Please have your identification ready.</Box>
              )}
            </NoticeBox>
          )) ||
            null}
          {(data.contents.length === 0 && (
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
              {map((value, key) => (
                <Table.Row key={key}>
                  <Table.Cell collapsing>{value.name}</Table.Cell>
                  <Table.Cell collapsing textAlign="center">
                    {value.amount} in stock
                  </Table.Cell>
                  <Table.Cell collapsing>
                    <Button
                      content="1"
                      disabled={value.amount < 1}
                      onClick={() =>
                        act('Release', {
                          index: value.index,
                          amount: 1,
                        })
                      }
                    />
                    <Button
                      content="5"
                      disabled={value.amount < 5}
                      onClick={() =>
                        act('Release', {
                          index: value.index,
                          amount: 5,
                        })
                      }
                    />
                    <Button
                      content="25"
                      disabled={value.amount < 25}
                      onClick={() =>
                        act('Release', {
                          index: value.index,
                          amount: 25,
                        })
                      }
                    />
                    <Button
                      content="50"
                      disabled={value.amount < 50}
                      onClick={() =>
                        act('Release', {
                          index: value.index,
                          amount: 50,
                        })
                      }
                    />
                    <Button
                      content="Custom"
                      disabled={value.amount < 1}
                      onClick={() =>
                        act('Release', {
                          index: value.index,
                        })
                      }
                    />
                    <Button
                      content="All"
                      disabled={value.amount < 1}
                      onClick={() =>
                        act('Release', {
                          index: value.index,
                          amount: value.amount,
                        })
                      }
                    />
                  </Table.Cell>
                </Table.Row>
              ))(data.contents)}
            </Table>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
