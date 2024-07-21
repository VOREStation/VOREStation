import { useState } from 'react';

import { useBackend } from '../../backend';
import {
  Box,
  Button,
  Modal,
  NoticeBox,
  Section,
  Table,
} from '../../components';
import { Window } from '../../layouts';
import { NIFMain } from './NIFMain';
import { NIFSettings } from './NIFSettings';
import { Data, module } from './types';

export const NIF = (props) => {
  const { act, config, data } = useBackend<Data>();

  const { theme, last_notification } = data;

  const [settingsOpen, setSettingsOpen] = useState<boolean>(false);
  const [viewingModule, setViewing] = useState<module | null>(null);

  return (
    <Window theme={theme} width={500} height={400}>
      <Window.Content scrollable>
        {!!last_notification && (
          <NoticeBox info>
            <Table verticalAlign="middle">
              <Table.Row verticalAlign="middle">
                <Table.Cell verticalAlign="middle">
                  {last_notification}
                </Table.Cell>
                <Table.Cell verticalAlign="middle" collapsing>
                  <Button
                    color="red"
                    icon="times"
                    tooltip="Dismiss"
                    tooltipPosition="left"
                    onClick={() => act('dismissNotification')}
                  />
                </Table.Cell>
              </Table.Row>
            </Table>
          </NoticeBox>
        )}
        {!!viewingModule && (
          <Modal m={1} p={0} color="label">
            <Section
              m={0}
              title={viewingModule.name}
              buttons={
                <>
                  <Button.Confirm
                    icon="ban"
                    color="bad"
                    confirmIcon="ban"
                    confirmContent={'Uninstall ' + viewingModule.name + '?'}
                    onClick={() => {
                      act('uninstall', { module: viewingModule.ref });
                      setViewing(null);
                    }}
                  >
                    Uninstall
                  </Button.Confirm>
                  <Button
                    icon="window-close"
                    onClick={() => setViewing(null)}
                  />
                </>
              }
            >
              <Box>{viewingModule.desc}</Box>
              <Box>
                It consumes
                <Box color="good" inline>
                  {viewingModule.p_drain}
                </Box>
                energy units while installed, and
                <Box color="average" inline>
                  {viewingModule.a_drain}
                </Box>
                additionally while active.
              </Box>
              <Box color={viewingModule.illegal ? 'bad' : 'good'}>
                It is {viewingModule.illegal ? 'NOT ' : ''}a legal software
                package.
              </Box>
              <Box>
                The MSRP of the package is
                <Box color="good" inline>
                  {viewingModule.cost}₮.
                </Box>
              </Box>
              <Box>
                The difficulty to construct the associated implant is&nbsp;
                <Box color="good" inline>
                  Rating {viewingModule.wear}
                </Box>
                .
              </Box>
            </Section>
          </Modal>
        )}
        <Section
          title={'Welcome to your NIF, ' + config.user.name}
          buttons={
            <Button
              icon="cogs"
              tooltip="Settings"
              tooltipPosition="bottom-end"
              selected={settingsOpen}
              onClick={() => setSettingsOpen(!settingsOpen)}
            />
          }
        >
          {(settingsOpen && <NIFSettings />) || (
            <NIFMain setViewing={setViewing} />
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
