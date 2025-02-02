import { useBackend } from 'tgui/backend';
import { Box, Button, LabeledList, Section } from 'tgui-core/components';

import { GeneralRecord, RecordList, SecurityRecord } from '../pda_types';

type Data = {
  records: {
    general: GeneralRecord;
    security: SecurityRecord;
  };
  recordsList: RecordList;
};

export const pda_security = (props) => {
  const { act, data } = useBackend<Data>();

  const { recordsList, records } = data;

  if (records) {
    const { general, security } = records;

    return (
      <Box>
        <Section title="General Data">
          {(general && (
            <LabeledList>
              <LabeledList.Item label="Name">{general.name}</LabeledList.Item>
              <LabeledList.Item label="Sex">{general.sex}</LabeledList.Item>
              <LabeledList.Item label="Species">
                {general.species}
              </LabeledList.Item>
              <LabeledList.Item label="Age">{general.age}</LabeledList.Item>
              <LabeledList.Item label="Rank">{general.rank}</LabeledList.Item>
              <LabeledList.Item label="Fingerprint">
                {general.fingerprint}
              </LabeledList.Item>
              <LabeledList.Item label="Physical Status">
                {general.p_stat}
              </LabeledList.Item>
              <LabeledList.Item label="Mental Status">
                {general.m_stat}
              </LabeledList.Item>
            </LabeledList>
          )) || <Box color="bad">General record lost!</Box>}
        </Section>
        <Section title="Security Data">
          {(security && (
            <LabeledList>
              <LabeledList.Item label="Criminal Status">
                {security.criminal}
              </LabeledList.Item>
              <LabeledList.Item label="Minor Crimes">
                {security.mi_crim}
              </LabeledList.Item>
              <LabeledList.Item label="Details">
                {security.mi_crim_d}
              </LabeledList.Item>
              <LabeledList.Item label="Major Crimes">
                {security.ma_crim}
              </LabeledList.Item>
              <LabeledList.Item label="Details">
                {security.ma_crim_d}
              </LabeledList.Item>
              <LabeledList.Item label="Important Notes:">
                <Box preserveWhitespace>
                  {security.notes || 'No data found.'}
                </Box>
              </LabeledList.Item>
            </LabeledList>
          )) || <Box color="bad">Security record lost!</Box>}
        </Section>
      </Box>
    );
  }

  return (
    <Section title="Select a record">
      {recordsList.map((record) => (
        <Button
          key={record.ref}
          icon="eye"
          fluid
          onClick={() => act('Records', { target: record.ref })}
        >
          {record.name}
        </Button>
      ))}
    </Section>
  );
};
