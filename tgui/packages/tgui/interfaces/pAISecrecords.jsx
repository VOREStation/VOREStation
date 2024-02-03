import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const pAISecrecords = (props) => {
  const { act, data } = useBackend();

  const { records, general, security, could_not_find } = data;

  return (
    <Window width={450} height={600} resizable>
      <Window.Content scrollable>
        <Section>
          {records.map((record) => (
            <Button
              key={record.ref}
              content={record.name}
              onClick={() => act('select', { select: record.ref })}
            />
          ))}
        </Section>
        {(general || security) && (
          <Section title="Selected Record">
            {!!could_not_find && (
              <Box color="bad">
                Warning: Failed to find some records. The information below may
                not be complete.
              </Box>
            )}
            <LabeledList>
              <LabeledList.Item label="Name">{general.name}</LabeledList.Item>
              <LabeledList.Item label="Record ID">
                {general.id}
              </LabeledList.Item>
              <LabeledList.Item label="Entity Classification">
                {general.brain_type}
              </LabeledList.Item>
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
              <LabeledList.Divider />
              <LabeledList.Item label="Criminal Status">
                <Box>{security.criminal}</Box>
              </LabeledList.Item>
              <LabeledList.Item label="Minor Crimes">
                <Box>{security.mi_crim}</Box>
                <Box>{security.mi_crim_d}</Box>
              </LabeledList.Item>
              <LabeledList.Item label="Major Crimes">
                <Box>{security.ma_crim}</Box>
                <Box>{security.ma_crim_d}</Box>
              </LabeledList.Item>
              <LabeledList.Item label="Important Notes">
                {security.notes}
              </LabeledList.Item>
            </LabeledList>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
