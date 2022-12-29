/* eslint react/no-danger: "off" */
import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

const Level = {
  0: 'Adminhelp',
  1: 'Mentorhelp',
  2: 'GM Request',
};

const LevelColor = {
  0: 'red',
  1: 'green',
  2: 'pink',
};

const Tag = {
  'example': 'Example',
};

const State = {
  'open': 'Open',
  'resolved': 'Resolved',
  'closed': 'Closed',
  'unknown': 'Unknown',
};

type Data = {
  id: number;
  title: string;
  name: string;
  state: string;
  level: number;
  handler: string;
  opened_at: number;
  closed_at: number;
  opened_at_date: string;
  closed_at_date: string;
  actions: string;
  log: string[];
};

export const Ticket = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const {
    id,
    title,
    name,
    state,
    level,
    handler,
    opened_at,
    closed_at,
    opened_at_date,
    closed_at_date,
    actions,
    log,
  } = data;
  return (
    <Window width={900} height={600}>
      <Window.Content scrollable>
        <Section
          title={'Ticket #' + id}
          buttons={
            <Box nowrap>
              <Button
                icon="pen"
                content="Rename Ticket"
                onClick={() => act('retitle')}
              />{' '}
              <Button content="Legacy UI" onClick={() => act('legacy')} />{' '}
              <Button content={Level[level]} color={LevelColor[level]} />
            </Box>
          }>
          <LabeledList>
            <LabeledList.Item label="Ticket ID">
              #{id}: <div dangerouslySetInnerHTML={{ __html: name }} />
            </LabeledList.Item>
            <LabeledList.Item label="Type">{Level[level]}</LabeledList.Item>
            <LabeledList.Item label="State">{State[state]}</LabeledList.Item>
            <LabeledList.Item label="Assignee">{handler}</LabeledList.Item>
            {State[state] === State.open ? (
              <LabeledList.Item label="Opened At">
                {opened_at_date} ({Math.round((opened_at / 600) * 10) / 10}{' '}
                minutes ago.)
              </LabeledList.Item>
            ) : (
              <LabeledList.Item label="Closed At">
                {closed_at_date} ({Math.round((closed_at / 600) * 10) / 10}{' '}
                minutes ago.){' '}
                <Button content="Reopen" onClick={() => act('reopen')} />
              </LabeledList.Item>
            )}
            <LabeledList.Item label="Actions">
              <div dangerouslySetInnerHTML={{ __html: actions }} />
            </LabeledList.Item>
            <LabeledList.Item label="Log">
              {Object.keys(log).map((L) => (
                <div dangerouslySetInnerHTML={{ __html: log[L] }} />
              ))}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
