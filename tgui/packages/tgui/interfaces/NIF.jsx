import { useState } from 'react';

import { useBackend } from '../backend';
import {
  AnimatedNumber,
  Box,
  Button,
  Dropdown,
  LabeledList,
  Modal,
  NoticeBox,
  ProgressBar,
  Section,
  Table,
} from '../components';
import { Window } from '../layouts';

const NIF_WORKING = 0;
const NIF_POWFAIL = 1;
const NIF_TEMPFAIL = 2;
const NIF_INSTALLING = 3;
const NIF_PREINSTALL = 4;

const validThemes = [
  'abductor',
  'cardtable',
  'hackerman',
  'malfunction',
  'ntos',
  'paper',
  'retro',
  'syndicate',
];

export const NIF = (props) => {
  const { act, config, data } = useBackend();

  const { theme, last_notification } = data;

  const [settingsOpen, setSettingsOpen] = useState(false);
  const [viewingModule, setViewing] = useState(null);

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
                    content="Uninstall"
                    confirmIcon="ban"
                    confirmContent={'Uninstall ' + viewingModule.name + '?'}
                    onClick={() => {
                      act('uninstall', { module: viewingModule.ref });
                      setViewing(null);
                    }}
                  />
                  <Button
                    icon="window-close"
                    onClick={() => setViewing(null)}
                  />
                </>
              }
            >
              <Box>{viewingModule.desc}</Box>
              <Box>
                It consumes{' '}
                <Box color="good" inline>
                  {viewingModule.p_drain}
                </Box>{' '}
                energy units while installed, and{' '}
                <Box color="average" inline>
                  {viewingModule.a_drain}
                </Box>{' '}
                additionally while active.
              </Box>
              <Box color={viewingModule.illegal ? 'bad' : 'good'}>
                It is {viewingModule.illegal ? 'NOT ' : ''}a legal software
                package.
              </Box>
              <Box>
                The MSRP of the package is{' '}
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

const getNifCondition = (nif_stat, nif_percent) => {
  switch (nif_stat) {
    case NIF_WORKING:
      if (nif_percent < 25) {
        return 'Service Needed Soon';
      } else {
        return 'Operating Normally';
      }
      break;
    case NIF_POWFAIL:
      return 'Insufficient Energy!';
      break;
    case NIF_TEMPFAIL:
      return 'System Failure!';
      break;
    case NIF_INSTALLING:
      return 'Adapting To User';
      break;
  }
  return 'Unknown';
};

const getNutritionText = (nutrition, isSynthetic) => {
  if (isSynthetic) {
    if (nutrition >= 450) {
      return 'Overcharged';
    } else if (nutrition >= 250) {
      return 'Good Charge';
    }
    return 'Low Charge';
  }

  if (nutrition >= 250) {
    return 'NIF Power Requirement met.';
  } else if (nutrition >= 150) {
    return 'Fluctuations in available power.';
  }
  return 'Power failure imminent.';
};

const NIFMain = (props) => {
  const { act, config, data } = useBackend();

  const {
    nif_percent,
    nif_stat,
    last_notification,
    nutrition,
    isSynthetic,
    modules,
  } = data;

  const { setViewing } = props;

  return (
    <Box>
      <LabeledList>
        <LabeledList.Item label="NIF Condition">
          <ProgressBar
            value={nif_percent}
            minValue={0}
            maxValue={100}
            ranges={{
              good: [50, Infinity],
              average: [25, 50],
              bad: [-Infinity, 0],
            }}
          >
            {getNifCondition(nif_stat, nif_percent)} (
            <AnimatedNumber value={nif_percent} />
            %)
          </ProgressBar>
        </LabeledList.Item>
        <LabeledList.Item label={'NIF Power'}>
          <ProgressBar
            value={nutrition}
            minValue={0}
            maxValue={700}
            ranges={{
              good: [250, Infinity],
              average: [150, 250],
              bad: [0, 150],
            }}
          >
            {getNutritionText(nutrition, isSynthetic)}
          </ProgressBar>
        </LabeledList.Item>
      </LabeledList>
      <Section level={2} title="NIFSoft Modules" mt={1}>
        <LabeledList>
          {modules.map((module) => (
            <LabeledList.Item
              label={module.name}
              key={module.ref}
              buttons={
                <>
                  <Button.Confirm
                    icon="trash"
                    color="bad"
                    confirmContent="UNINSTALL?"
                    confirmIcon="trash"
                    tooltip="Uninstall Module"
                    tooltipPosition="left"
                    onClick={() => act('uninstall', { module: module.ref })}
                  />
                  <Button
                    icon="search"
                    onClick={() => setViewing(module)}
                    tooltip="View Information"
                    tooltipPosition="left"
                  />
                </>
              }
            >
              {(module.activates && (
                <Button
                  fluid
                  selected={module.active}
                  content={module.stat_text}
                  onClick={() => act('toggle_module', { module: module.ref })}
                />
              )) || <Box>{module.stat_text}</Box>}
            </LabeledList.Item>
          ))}
        </LabeledList>
      </Section>
    </Box>
  );
};

const NIFSettings = (props) => {
  const { act, data } = useBackend();

  const { theme } = data;

  return (
    <LabeledList>
      <LabeledList.Item label="NIF Theme" verticalAlign="top">
        <Dropdown
          width="100%"
          placeholder="Default"
          selected={theme}
          options={validThemes}
          onSelected={(val) => act('setTheme', { theme: val })}
        />
      </LabeledList.Item>
    </LabeledList>
  );
};
