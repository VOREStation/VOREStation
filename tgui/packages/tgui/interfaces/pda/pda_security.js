import { useBackend } from '../../backend';
import { Box, Button, LabeledList, Section } from '../../components';

export const pda_security = (props, context) => {
  const { act, data } = useBackend(context);

  const { recordsList, records } = data;

  if (records) {
    const { general, security } = records;

    return (
      <Box>
        <Section level={2} title="General Data">
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
        <Section level={2} title="Security Data">
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
    <Section level={2} title="Select a record">
      {recordsList.map((record) => (
        <Button
          key={record.ref}
          icon="eye"
          fluid
          content={record.Name}
          onClick={() => act('Records', { target: record.ref })}
        />
      ))}
    </Section>
  );
};
