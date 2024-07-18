import { useBackend } from '../../backend';
import { Box, Button, Image, LabeledList, Section } from '../../components';
import { modalOpen } from '../common/ComplexModal';
import { doEdit } from './functions';
import { Data } from './types';

export const GeneralRecordsViewGeneral = (props) => {
  const { act, data } = useBackend<Data>();
  const { general } = data;
  if (!general || !general.fields) {
    return (
      <Box color="bad">
        General record lost!
        <Button icon="pen" ml="0.5rem" onClick={() => act('new')}>
          New Record
        </Button>
      </Box>
    );
  }
  return (
    <>
      <Box
        width="50%"
        style={{
          float: 'left',
        }}
      >
        <LabeledList>
          {general.fields.map((field, i) => (
            <LabeledList.Item key={i} label={field.field}>
              <Box height="20px" inline>
                {field.value}
                {!!field.edit && (
                  <Button
                    icon="pen"
                    ml="0.5rem"
                    onClick={() => doEdit(field)}
                  />
                )}
              </Box>
            </LabeledList.Item>
          ))}
        </LabeledList>
        <Section title="Employment/skills summary" preserveWhitespace>
          {general.skills || 'No data found.'}
        </Section>
        <Section title="Comments/Log">
          {general.comments && general.comments.length === 0 ? (
            <Box color="label">No comments found.</Box>
          ) : (
            general.comments &&
            general.comments.map((comment, i) => (
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
      </Box>
      <Box
        width="50%"
        style={{
          float: 'right',
        }}
        textAlign="right"
      >
        {!!general.has_photos &&
          general.photos!.map((p, i) => (
            <Box key={i} inline textAlign="center" color="label">
              <Image
                src={p.substring(1, p.length - 1)}
                style={{
                  width: '96px',
                  marginBottom: '0.5rem',
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
