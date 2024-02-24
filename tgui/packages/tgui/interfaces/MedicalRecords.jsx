import { Fragment } from 'react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  Collapsible,
  Icon,
  Input,
  LabeledList,
  Section,
  Tabs,
} from '../components';
import {
  ComplexModal,
  modalOpen,
  modalRegisterBodyOverride,
} from '../interfaces/common/ComplexModal';
import { Window } from '../layouts';
import { LoginInfo } from './common/LoginInfo';
import { LoginScreen } from './common/LoginScreen';
import { TemporaryNotice } from './common/TemporaryNotice';

const severities = {
  Minor: 'good',
  Medium: 'average',
  'Dangerous!': 'bad',
  Harmful: 'bad',
  'BIOHAZARD THREAT!': 'bad',
};

const doEdit = (field) => {
  modalOpen('edit', {
    field: field.edit,
    value: field.value,
  });
};

const virusModalBodyOverride = (modal) => {
  const { act } = useBackend();
  const virus = modal.args;
  return (
    <Section
      level={2}
      m="-1rem"
      title={virus.name || 'Virus'}
      buttons={
        <Button icon="times" color="red" onClick={() => act('modal_close')} />
      }
    >
      <Box mx="0.5rem">
        <LabeledList>
          <LabeledList.Item label="Spread">
            {virus.spread_text} Transmission
          </LabeledList.Item>
          <LabeledList.Item label="Possible cure">
            {virus.antigen}
          </LabeledList.Item>
          <LabeledList.Item label="Rate of Progression">
            {virus.rate}
          </LabeledList.Item>
          <LabeledList.Item label="Antibiotic Resistance">
            {virus.resistance}%
          </LabeledList.Item>
          <LabeledList.Item label="Species Affected">
            {virus.species}
          </LabeledList.Item>
          <LabeledList.Item label="Symptoms">
            <LabeledList>
              {virus.symptoms.map((s) => (
                <LabeledList.Item key={s.stage} label={s.stage + '. ' + s.name}>
                  <Box inline color="label">
                    Strength:
                  </Box>{' '}
                  {s.strength}&nbsp;
                  <Box inline color="label">
                    Aggressiveness:
                  </Box>{' '}
                  {s.aggressiveness}
                </LabeledList.Item>
              ))}
            </LabeledList>
          </LabeledList.Item>
        </LabeledList>
      </Box>
    </Section>
  );
};

export const MedicalRecords = (_properties) => {
  const { data } = useBackend();
  const { authenticated, screen } = data;
  if (!authenticated) {
    return (
      <Window width={800} height={380}>
        <Window.Content>
          <LoginScreen />
        </Window.Content>
      </Window>
    );
  }

  let body;
  if (screen === 2) {
    // List Records
    body = <MedicalRecordsList />;
  } else if (screen === 3) {
    // Record Maintenance
    body = <MedicalRecordsMaintenance />;
  } else if (screen === 4) {
    // View Records
    body = <MedicalRecordsView />;
  } else if (screen === 5) {
    // Virus Database
    body = <MedicalRecordsViruses />;
  } else if (screen === 6) {
    // Medbot Tracking
    body = <MedicalRecordsMedbots />;
  }

  return (
    <Window width={800} height={380}>
      <ComplexModal maxHeight="100%" maxWidth="80%" />
      <Window.Content className="Layout__content--flexColumn" scrollable>
        <LoginInfo />
        <TemporaryNotice />
        <MedicalRecordsNavigation />
        <Section height="calc(100% - 5rem)" flexGrow="1">
          {body}
        </Section>
      </Window.Content>
    </Window>
  );
};

const MedicalRecordsList = (_properties) => {
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
            content={record.id + ': ' + record.name}
            onClick={() => act('d_rec', { d_rec: record.ref })}
          />
        ))}
      </Box>
    </>
  );
};

const MedicalRecordsMaintenance = (_properties) => {
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
        content="Delete All Medical Records"
        onClick={() => act('del_all')}
      />
    </>
  );
};

const MedicalRecordsView = (_properties) => {
  const { act, data } = useBackend();
  const { medical, printing } = data;
  return (
    <>
      <Section title="General Data" level={2} mt="-6px">
        <MedicalRecordsViewGeneral />
      </Section>
      <Section title="Medical Data" level={2}>
        <MedicalRecordsViewMedical />
      </Section>
      <Section title="Actions" level={2}>
        <Button.Confirm
          icon="trash"
          disabled={!!medical.empty}
          content="Delete Medical Record"
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

const MedicalRecordsViewGeneral = (_properties) => {
  const { data } = useBackend();
  const { general } = data;
  if (!general || !general.fields) {
    return <Box color="bad">General records lost!</Box>;
  }
  return (
    <>
      <Box width="50%" float="left">
        <LabeledList>
          {general.fields.map((field, i) => (
            <LabeledList.Item key={i} label={field.field}>
              <Box height="20px" display="inline-block" preserveWhitespace>
                {field.value}
              </Box>
              {!!field.edit && (
                <Button icon="pen" ml="0.5rem" onClick={() => doEdit(field)} />
              )}
            </LabeledList.Item>
          ))}
        </LabeledList>
      </Box>
      <Box width="50%" float="right" textAlign="right">
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
      </Box>
    </>
  );
};

const MedicalRecordsViewMedical = (_properties) => {
  const { act, data } = useBackend();
  const { medical } = data;
  if (!medical || !medical.fields) {
    return (
      <Box color="bad">
        Medical records lost!
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
        {medical.fields.map((field, i) => (
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
      <Section title="Comments/Log" level={2}>
        {medical.comments.length === 0 ? (
          <Box color="label">No comments found.</Box>
        ) : (
          medical.comments.map((comment, i) => (
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
          icon="comment-medical"
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

const MedicalRecordsViruses = (_properties) => {
  const { act, data } = useBackend();
  const { virus } = data;
  virus.sort((a, b) => (a.name > b.name ? 1 : -1));
  return virus.map((vir, i) => (
    <Fragment key={i}>
      <Button
        icon="flask"
        content={vir.name}
        mb="0.5rem"
        onClick={() => act('vir', { vir: vir.D })}
      />
      <br />
    </Fragment>
  ));
};

const MedicalRecordsMedbots = (_properties) => {
  const { data } = useBackend();
  const { medbots } = data;
  if (medbots.length === 0) {
    return <Box color="label">There are no Medbots.</Box>;
  }
  return medbots.map((medbot, i) => (
    <Collapsible key={i} open title={medbot.name}>
      <Box px="0.5rem">
        <LabeledList>
          <LabeledList.Item label="Location">
            {medbot.area || 'Unknown'} ({medbot.x}, {medbot.y})
          </LabeledList.Item>
          <LabeledList.Item label="Status">
            {medbot.on ? (
              <>
                <Box color="good">Online</Box>
                <Box mt="0.5rem">
                  {medbot.use_beaker
                    ? 'Reservoir: ' +
                      medbot.total_volume +
                      '/' +
                      medbot.maximum_volume
                    : 'Using internal synthesizer.'}
                </Box>
              </>
            ) : (
              <Box color="average">Offline</Box>
            )}
          </LabeledList.Item>
        </LabeledList>
      </Box>
    </Collapsible>
  ));
};

const MedicalRecordsNavigation = (_properties) => {
  const { act, data } = useBackend();
  const { screen } = data;
  return (
    <Tabs>
      <Tabs.Tab
        selected={screen === 2}
        onClick={() => act('screen', { screen: 2 })}
      >
        <Icon name="list" />
        List Records
      </Tabs.Tab>
      <Tabs.Tab
        selected={screen === 5}
        onClick={() => act('screen', { screen: 5 })}
      >
        <Icon name="database" />
        Virus Database
      </Tabs.Tab>
      <Tabs.Tab
        selected={screen === 6}
        onClick={() => act('screen', { screen: 6 })}
      >
        <Icon name="plus-square" />
        Medbot Tracking
      </Tabs.Tab>
      <Tabs.Tab
        selected={screen === 3}
        onClick={() => act('screen', { screen: 3 })}
      >
        <Icon name="wrench" />
        Record Maintenance
      </Tabs.Tab>
    </Tabs>
  );
};

modalRegisterBodyOverride('virus', virusModalBodyOverride);
