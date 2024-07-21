import { useBackend } from '../../backend';
import { Box, Button, LabeledList, Section } from '../../components';
import { modalOpen } from '../../interfaces/common/ComplexModal';
import { doEdit } from '../GeneralRecords/functions';
import { Data } from './types';

export const SecurityRecordsViewSecurity = (props) => {
  const { act, data } = useBackend<Data>();
  const { security } = data;
  if (!security || !security.fields) {
    return (
      <Box color="bad">
        Security records lost!
        <Button icon="pen" ml="0.5rem" onClick={() => act('new')}>
          New Record
        </Button>
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
                mb={'initial'}
                onClick={() => doEdit(field)}
              />
            </Box>
          </LabeledList.Item>
        ))}
      </LabeledList>
      <Section title="Comments/Log">
        {security.comments && security.comments.length === 0 ? (
          <Box color="label">No comments found.</Box>
        ) : (
          security.comments &&
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
