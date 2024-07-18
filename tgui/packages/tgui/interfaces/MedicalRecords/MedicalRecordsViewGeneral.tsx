import { useBackend } from '../../backend';
import { Box, Button, Image, LabeledList } from '../../components';
import { doEdit } from '../GeneralRecords/functions';
import { Data } from './types';

export const MedicalRecordsViewGeneral = (props) => {
  const { data } = useBackend<Data>();
  const { general } = data;
  if (!general || !general.fields) {
    return <Box color="bad">General records lost!</Box>;
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
              <Box height="20px" inline preserveWhitespace>
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
