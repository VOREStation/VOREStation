import { Fragment } from 'inferno';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, Collapsible, Icon, Input, LabeledList, Section, Tabs } from "../components";
import { ComplexModal, modalOpen, modalRegisterBodyOverride } from "../interfaces/common/ComplexModal";
import { Window } from "../layouts";
import { LoginInfo } from './common/LoginInfo';
import { LoginScreen } from './common/LoginScreen';
import { TemporaryNotice } from './common/TemporaryNotice';
import { createSearch } from 'common/string';
import { filter, sortBy } from 'common/collections';
import { flow } from 'common/fp';

const doEdit = (context, field) => {
  modalOpen(context, 'edit', {
    field: field.edit,
    value: field.value,
  });
};

export const GeneralRecords = (_properties, context) => {
  const { data } = useBackend(context);
  const {
    authenticated,
    screen,
  } = data;
  if (!authenticated) {
    return (
      <Window
        width={800}
        height={380}
        resizable>
        <Window.Content>
          <LoginScreen />
        </Window.Content>
      </Window>
    );
  }

  let body;
  if (screen === 2) { // List Records
    body = <GeneralRecordsList />;
  } else if (screen === 3) { // Record Maintenance
    body = <GeneralRecordsMaintenance />;
  } else if (screen === 4) { // View Records
    body = <GeneralRecordsView />;
  }

  return (
    <Window
      width={800}
      height={640}
      resizable>
      <ComplexModal />
      <Window.Content className="Layout__content--flexColumn">
        <LoginInfo />
        <TemporaryNotice />
        <GeneralRecordsNavigation />
        <Section height="calc(100% - 5rem)" flexGrow="1">
          {body}
        </Section>
      </Window.Content>
    </Window>
  );
};

/**
 * Record selector.
 *
 * Filters records, applies search terms and sorts the alphabetically.
 */
const selectRecords = (records, searchText = '') => {
  const nameSearch = createSearch(searchText, record => record.name);
  const idSearch = createSearch(searchText, record => record.id);
  const dnaSearch = createSearch(searchText, record => record.b_dna);
  let fl = flow([
    // Optional search term
    searchText && filter(record => {
      return (nameSearch(record) || idSearch(record) || dnaSearch(record));
    }),
  ])(records);
  return fl;
};

const GeneralRecordsList = (_properties, context) => {
  const { act, data } = useBackend(context);

  const [
    searchText,
    setSearchText,
  ] = useLocalState(context, 'searchText', '');

  const records = selectRecords(data.records, searchText);
  return (
    <Fragment>
      <Box mb="0.2rem">
        <Button
          icon="pen"
          content="New Record"
          onClick={() => act('new')} />
      </Box>
      <Input
        fluid
        placeholder="Search by Name, DNA, or ID"
        onInput={(e, value) => setSearchText(value)} />
      <Box mt="0.5rem">
        {records.map((record, i) => (
          <Button
            key={i}
            icon="user"
            mb="0.5rem"
            content={record.id + ": " + record.name}
            onClick={() => act('d_rec', { d_rec: record.ref })}
          />
        ))}
      </Box>
    </Fragment>
  );
};

const GeneralRecordsMaintenance = (_properties, context) => {
  const { act } = useBackend(context);
  return (
    <Button.Confirm
      icon="trash"
      content="Delete All Employment Records"
      onClick={() => act('del_all')}
    />
  );
};

const GeneralRecordsView = (_properties, context) => {
  const { act, data } = useBackend(context);
  const {
    general,
    printing,
  } = data;
  return (
    <Fragment>
      <Section title="General Data" level={2} mt="-6px">
        <GeneralRecordsViewGeneral />
      </Section>
      <Section title="Actions" level={2}>
        <Button.Confirm
          icon="trash"
          disabled={!!general.empty}
          content="Delete Employment Record"
          color="bad"
          onClick={() => act('del_r')}
        />
        <Button
          icon={printing ? 'spinner' : 'print'}
          disabled={printing}
          iconSpin={!!printing}
          content="Print Entry"
          ml="0.5rem"
          onClick={() => act('print_p')}
        /><br />
        <Button
          icon="arrow-left"
          content="Back"
          mt="0.5rem"
          onClick={() => act('screen', { screen: 2 })}
        />
      </Section>
    </Fragment>
  );
};

const GeneralRecordsViewGeneral = (_properties, context) => {
  const { act, data } = useBackend(context);
  const {
    general,
  } = data;
  if (!general || !general.fields) {
    return (
      <Box color="bad">
        General record lost!
        <Button
          icon="pen"
          content="New Record"
          ml="0.5rem"
          onClick={() => act('new')} />
      </Box>
    );
  }
  return (
    <Fragment>
      <Box width="50%" float="left">
        <LabeledList>
          {general.fields.map((field, i) => (
            <LabeledList.Item key={i} label={field.field}>
              <Box height="20px" display="inline-block">
                {field.value}
              </Box>
              {!!field.edit && (
                <Button
                  icon="pen"
                  ml="0.5rem"
                  onClick={() => doEdit(context, field)}
                />
              )}
            </LabeledList.Item>
          ))}
        </LabeledList>
        <Section title="Employment/skills summary" level={2} preserveWhitespace>
          {general.skills || "No data found."}
        </Section>
        <Section title="Comments/Log" level={2}>
          {general.comments.length === 0 ? (
            <Box color="label">
              No comments found.
            </Box>
          )
            : general.comments.map((comment, i) => (
              <Box key={i}>
                <Box color="label" inline>
                  {comment.header}
                </Box><br />
                {comment.text}
                <Button
                  icon="comment-slash"
                  color="bad"
                  ml="0.5rem"
                  onClick={() => act('del_c', { del_c: i + 1 })}
                />
              </Box>
            ))}

          <Button
            icon="comment"
            content="Add Entry"
            color="good"
            mt="0.5rem"
            mb="0"
            onClick={() => modalOpen(context, 'add_c')}
          />
        </Section>
      </Box>
      <Box width="50%" float="right" textAlign="right">
        {!!general.has_photos && (
          general.photos.map((p, i) => (
            <Box
              key={i}
              display="inline-block"
              textAlign="center"
              color="label">
              <img
                src={p.substr(1, p.length - 1)}
                style={{
                  width: '96px',
                  'margin-bottom': '0.5rem',
                  '-ms-interpolation-mode': 'nearest-neighbor',
                }}
              /><br />
              Photo #{i + 1}
            </Box>
          ))
        )}
      </Box>
    </Fragment>
  );
};

const GeneralRecordsNavigation = (_properties, context) => {
  const { act, data } = useBackend(context);
  const {
    screen,
  } = data;
  return (
    <Tabs>
      <Tabs.Tab
        selected={screen === 2}
        onClick={() => act('screen', { screen: 2 })}>
        <Icon name="list" />
        List Records
      </Tabs.Tab>
      <Tabs.Tab
        selected={screen === 3}
        onClick={() => act('screen', { screen: 3 })}>
        <Icon name="wrench" />
        Record Maintenance
      </Tabs.Tab>
    </Tabs>
  );
};