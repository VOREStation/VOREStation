import { useBackend } from '../../backend';
import { Box, Button, LabeledList, Section } from '../../components';
import { GeneralRecord, RecordList } from './pda_types';

type Data = {
  records: {
    general: GeneralRecord;
    medical: {
      id: string;
      name: string;
      species: string;
      b_type: string;
      b_dna: string;
      id_gender: string;
      brain_type: string;
      mi_dis: string;
      mi_dis_d: string;
      ma_dis: string;
      ma_dis_d: string;
      alg: string;
      alg_d: string;
      cdi: string;
      cdi_d: string;
      notes: string;
    };
  };
  recordsList: RecordList;
};

export const pda_medical = (props) => {
  const { act, data } = useBackend<Data>();

  const { recordsList, records } = data;

  if (records) {
    const { general, medical } = records;

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
        <Section title="Medical Data">
          {(medical && (
            <LabeledList>
              <LabeledList.Item label="Blood Type">
                {medical.b_type}
              </LabeledList.Item>
              <LabeledList.Item label="Minor Disabilities">
                {medical.mi_dis}
              </LabeledList.Item>
              <LabeledList.Item label="Details">
                {medical.mi_dis_d}
              </LabeledList.Item>
              <LabeledList.Item label="Major Disabilities">
                {medical.ma_dis}
              </LabeledList.Item>
              <LabeledList.Item label="Details">
                {medical.ma_dis_d}
              </LabeledList.Item>
              <LabeledList.Item label="Allergies">
                {medical.alg}
              </LabeledList.Item>
              <LabeledList.Item label="Details">
                {medical.alg_d}
              </LabeledList.Item>
              <LabeledList.Item label="Current Disease">
                {medical.cdi}
              </LabeledList.Item>
              <LabeledList.Item label="Details">
                {medical.cdi_d}
              </LabeledList.Item>
              <LabeledList.Item label="Important Notes">
                <Box preserveWhitespace>{medical.notes}</Box>
              </LabeledList.Item>
            </LabeledList>
          )) || <Box color="bad">Medical record lost!</Box>}
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
          {record.Name}
        </Button>
      ))}
    </Section>
  );
};
