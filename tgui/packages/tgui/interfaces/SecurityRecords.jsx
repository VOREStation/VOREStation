import { useBackend } from '../backend';
import {
  Box,
  Button,
  Flex,
  Input,
  LabeledList,
  Section,
  Tabs,
} from '../components';
import { ComplexModal, modalOpen } from '../interfaces/common/ComplexModal';
import { Window } from '../layouts';
import { LoginInfo } from './common/LoginInfo';
import { LoginScreen } from './common/LoginScreen';
import { TemporaryNotice } from './common/TemporaryNotice';

const doEdit = (field) => {
  modalOpen('edit', {
    field: field.edit,
    value: field.value,
  });
};

export const SecurityRecords = (_properties) => {
  const { data } = useBackend();
  const { authenticated, screen } = data;
  if (!authenticated) {
    return (
      <Window width={700} height={680}>
        <Window.Content>
          <LoginScreen />
        </Window.Content>
      </Window>
    );
  }

  let body;
  if (screen === 2) {
    // List Records
    body = <SecurityRecordsList />;
  } else if (screen === 3) {
    // Record Maintenance
    body = <SecurityRecordsMaintenance />;
  } else if (screen === 4) {
    // View Records
    body = <SecurityRecordsView />;
  }

  return (
    <Window width={700} height={680}>
      <ComplexModal maxHeight="100%" maxWidth="400px" />
      <Window.Content scrollable>
        <LoginInfo />
        <TemporaryNotice />
        <SecurityRecordsNavigation />
        <Section flexGrow>{body}</Section>
      </Window.Content>
    </Window>
  );
};

const SecurityRecordsList = (_properties) => {
  const { act, data } = useBackend();
  const { records } = data;
  return (
    <>
      <Input
        fluid
        placeholder="Search by Name, DNA, or ID"
        onChange={(_event, value) => act('search', { t1: value })}
      />
      <Box mt="0.5rem">
        {records.map((record, i) => (
          <Button
            key={i}
            icon="user"
            mb="0.5rem"
            color={record.color}
            content={
              record.id +
              ': ' +
              record.name +
              ' (Criminal Status: ' +
              record.criminal +
              ')'
            }
            onClick={() => act('d_rec', { d_rec: record.ref })}
          />
        ))}
      </Box>
    </>
  );
};

const SecurityRecordsMaintenance = (_properties) => {
  const { act } = useBackend();
  return (
    <>
      <Button icon="download" content="Backup to Disk" disabled />
      <br />
      <Button
        icon="upload"
        content="Upload from Disk"
        my="0.5rem"
        disabled
      />{' '}
      <br />
      <Button.Confirm
        icon="trash"
        content="Delete All Security Records"
        onClick={() => act('del_all')}
      />
    </>
  );
};

const SecurityRecordsView = (_properties) => {
  const { act, data } = useBackend();
  const { security, printing } = data;
  return (
    <>
      <Section title="General Data" mt="-6px">
        <SecurityRecordsViewGeneral />
      </Section>
      <Section title="Security Data">
        <SecurityRecordsViewSecurity />
      </Section>
      <Section title="Actions">
        <Button.Confirm
          icon="trash"
          disabled={!!security.empty}
          content="Delete Security Record"
          color="bad"
          onClick={() => act('del_r')}
        />
        <Button.Confirm
          icon="trash"
          disabled={!!security.empty}
          content="Delete Record (All)"
          color="bad"
          onClick={() => act('del_r_2')}
        />
        <Button
          icon={printing ? 'spinner' : 'print'}
          disabled={printing}
          iconSpin={!!printing}
          content="Print Entry"
          ml="0.5rem"
          onClick={() => act('print_p')}
        />
        <br />
        <Button
          icon="arrow-left"
          content="Back"
          mt="0.5rem"
          onClick={() => act('screen', { screen: 2 })}
        />
      </Section>
    </>
  );
};

const SecurityRecordsViewGeneral = (_properties) => {
  const { act, data } = useBackend();
  const { general } = data;
  if (!general || !general.fields) {
    return <Box color="bad">General records lost!</Box>;
  }
  return (
    <Flex>
      <Flex.Item>
        <LabeledList>
          {general.fields.map((field, i) => (
            <LabeledList.Item key={i} label={field.field}>
              <Box height="20px" inline preserveWhitespace>
                {field.value}
              </Box>
              {!!field.edit && (
                <Button icon="pen" ml="0.5rem" onClick={() => doEdit(field)} />
              )}
            </LabeledList.Item>
          ))}
        </LabeledList>
      </Flex.Item>
      <Flex.Item textAlign="right">
        {!!general.has_photos &&
          general.photos.map((p, i) => (
            <Box
              key={i}
              display="inline-block"
              textAlign="center"
              color="label"
            >
              <img
                src={p.substr(1, p.length - 1)}
                style={{
                  width: '96px',
                  'margin-bottom': '0.5rem',
                  '-ms-interpolation-mode': 'nearest-neighbor',
                }}
              />
              <br />
              Photo #{i + 1}
            </Box>
          ))}
        <Box>
          <Button onClick={() => act('photo_front')}>Update Front Photo</Button>
          <Button onClick={() => act('photo_side')}>Update Side Photo</Button>
        </Box>
      </Flex.Item>
    </Flex>
  );
};

const SecurityRecordsViewSecurity = (_properties) => {
  const { act, data } = useBackend();
  const { security } = data;
  if (!security || !security.fields) {
    return (
      <Box color="bad">
        Security records lost!
        <Button
          icon="pen"
          content="New Record"
          ml="0.5rem"
          onClick={() => act('new')}
        />
      </Box>
    );
  }
  return (
    <>
      <LabeledList>
        {security.fields.map((field, i) => (
          <LabeledList.Item key={i} label={field.field}>
            <Box preserveWhitespace>
              {field.value}
              <Button
                icon="pen"
                ml="0.5rem"
                mb={field.line_break ? '1rem' : 'initial'}
                onClick={() => doEdit(field)}
              />
            </Box>
          </LabeledList.Item>
        ))}
      </LabeledList>
      <Section title="Comments/Log">
        {security.comments.length === 0 ? (
          <Box color="label">No comments found.</Box>
        ) : (
          security.comments.map((comment, i) => (
            <Box key={i}>
              <Box color="label" inline>
                {comment.header}
              </Box>
              <br />
              {comment.text}
              <Button
                icon="comment-slash"
                color="bad"
                ml="0.5rem"
                onClick={() => act('del_c', { del_c: i + 1 })}
              />
            </Box>
          ))
        )}

        <Button
          icon="comment"
          content="Add Entry"
          color="good"
          mt="0.5rem"
          mb="0"
          onClick={() => modalOpen('add_c')}
        />
      </Section>
    </>
  );
};

const SecurityRecordsNavigation = (_properties) => {
  const { act, data } = useBackend();
  const { screen } = data;
  return (
    <Tabs>
      <Tabs.Tab
        selected={screen === 2}
        icon="list"
        onClick={() => act('screen', { screen: 2 })}
      >
        List Records
      </Tabs.Tab>
      <Tabs.Tab
        icon="wrench"
        selected={screen === 3}
        onClick={() => act('screen', { screen: 3 })}
      >
        Record Maintenance
      </Tabs.Tab>
    </Tabs>
  );
};
