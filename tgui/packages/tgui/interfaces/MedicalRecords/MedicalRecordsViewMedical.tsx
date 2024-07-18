import { useBackend } from '../../backend';
import { Box, Button, LabeledList, Section } from '../../components';
import { modalOpen } from '../../interfaces/common/ComplexModal';
import { doEdit } from '../GeneralRecords/functions';
import { Data } from './types';

export const MedicalRecordsViewMedical = (props) => {
  const { act, data } = useBackend<Data>();
  const { medical } = data;
  if (!medical || !medical.fields) {
    return (
      <Box color="bad">
        Medical records lost!
        <Button icon="pen" ml="0.5rem" onClick={() => act('new')}>
          New Record
        </Button>
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
              <Button icon="pen" ml="0.5rem" onClick={() => doEdit(field)} />
            </Box>
          </LabeledList.Item>
        ))}
      </LabeledList>
      <Section title="Comments/Log">
        {medical.comments && medical.comments.length === 0 ? (
          <Box color="label">No comments found.</Box>
        ) : (
          medical.comments &&
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
          color="good"
          mt="0.5rem"
          mb="0"
          onClick={() => modalOpen('add_c')}
        >
          Add Entry
        </Button>
      </Section>
    </>
  );
};
