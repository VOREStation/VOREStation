import { useBackend } from 'tgui/backend';
import { Box, Button, Image, LabeledList, Stack } from 'tgui-core/components';

import { doEdit } from '../GeneralRecords/functions';
import type { Data } from './types';

export const SecurityRecordsViewGeneral = (props) => {
  const { act, data } = useBackend<Data>();
  const { general } = data;
  if (!general || !general.fields) {
    return <Box color="bad">General records lost!</Box>;
  }
  return (
    <Stack>
      <Stack.Item>
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
      </Stack.Item>
      <Stack.Item textAlign="right">
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
        <Box>
          <Button onClick={() => act('photo_front')}>Update Front Photo</Button>
          <Button onClick={() => act('photo_side')}>Update Side Photo</Button>
        </Box>
      </Stack.Item>
    </Stack>
  );
};
