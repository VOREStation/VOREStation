import { useBackend } from 'tgui/backend';
import { Box, Button, LabeledList, Stack } from 'tgui-core/components';

import {
  type GeneralData,
  type GeneralDataConstant,
  type GeneralDataStatic,
  REQUIRED_FLAVOR_TEXT_LENGTH,
  REQUIRED_OOC_LENGTH,
} from './data';

export const SubtabNotes = (props: {
  data: GeneralData;
  staticData: GeneralDataStatic;
  serverData: GeneralDataConstant;
}) => {
  const { act } = useBackend();
  const { data, staticData, serverData } = props;
  const {
    economic_status,
    home_system,
    birthplace,
    citizenship,
    faction,
    religion,
    ooc_note_style,
    records_banned,
    med_record,
    gen_record,
    sec_record,
    nif,
  } = data;

  return (
    <Stack vertical fill>
      <Stack.Item>
        <Stack fill justify="space-between">
          <Stack.Item>
            <Stack vertical fill>
              <Stack.Item>
                <Box bold>Background Information</Box>
                <LabeledList>
                  <LabeledList.Item label="Economic Status">
                    <Button onClick={() => act('econ_status')}>
                      {economic_status || 'None'}
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item label="Home System">
                    <Button onClick={() => act('home_system')}>
                      {home_system || 'None'}
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item label="Birthplace">
                    <Button onClick={() => act('birthplace')}>
                      {birthplace || 'None'}
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item label="Citizenship">
                    <Button onClick={() => act('citizenship')}>
                      {citizenship || 'None'}
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item label="Faction">
                    <Button onClick={() => act('faction')}>
                      {faction || 'None'}
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item label="Religion">
                    <Button onClick={() => act('religion')}>
                      {religion || 'None'}
                    </Button>
                  </LabeledList.Item>
                </LabeledList>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item>
            <Stack vertical fill>
              {records_banned ? (
                <Stack.Item>
                  <Box bold>You are banned from using character records.</Box>
                </Stack.Item>
              ) : (
                <>
                  <Stack.Item>
                    <Box bold>Medical Records</Box>
                    <Button onClick={() => act('set_medical_records')}>
                      {med_record || 'None'}
                    </Button>{' '}
                    (
                    <Button onClick={() => act('reset_medrecord')}>
                      Reset
                    </Button>
                    )
                  </Stack.Item>
                  <Stack.Item>
                    <Box bold>Employment Records</Box>
                    <Button onClick={() => act('set_general_records')}>
                      {gen_record || 'None'}
                    </Button>{' '}
                    (
                    <Button onClick={() => act('reset_emprecord')}>
                      Reset
                    </Button>
                    )
                  </Stack.Item>
                  <Stack.Item>
                    <Box bold>Security Records</Box>
                    <Button onClick={() => act('set_security_records')}>
                      {sec_record || 'None'}
                    </Button>{' '}
                    (
                    <Button onClick={() => act('reset_secrecord')}>
                      Reset
                    </Button>
                    )
                  </Stack.Item>
                </>
              )}
              <Stack.Item>NIF: {nif ? 'Installed' : 'None'}</Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <Stack vertical fill>
          <Stack.Item>
            <Box bold>Flavor Text</Box>
            <Stack>
              <Stack.Item>
                <Button
                  onClick={() => act('flavor_text')}
                  color={
                    data.flavor_text_length < REQUIRED_FLAVOR_TEXT_LENGTH
                      ? 'bad'
                      : 'good'
                  }
                  tooltip={
                    data.flavor_text_length < REQUIRED_FLAVOR_TEXT_LENGTH
                      ? 'Your flavor text is not long enough, this will prevent you from spawning. Remember, this is not what you taste like, but what you look like.'
                      : ''
                  }
                >
                  Set Flavor Text
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button onClick={() => act('flavour_text_robot')}>
                  Set Robot Flavor Text
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button onClick={() => act('custom_link')}>
                  Set Custom Link
                </Button>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          {staticData.allow_metadata ? (
            <Stack.Item>
              <Box bold>OOC Notes</Box>
              <Stack>
                <Stack.Item>
                  <Button
                    onClick={() => act('edit_ooc_notes')}
                    color={
                      data.ooc_notes_length < REQUIRED_OOC_LENGTH
                        ? 'bad'
                        : 'good'
                    }
                    tooltip={
                      data.ooc_notes_length < REQUIRED_OOC_LENGTH
                        ? 'Your OOC Notes are not long enough, this will prevent you from spawning.'
                        : ''
                    }
                  >
                    Set OOC Notes
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button onClick={() => act('edit_ooc_note_favs')}>
                    Set Favs
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button onClick={() => act('edit_ooc_note_likes')}>
                    Set Likes
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button onClick={() => act('edit_ooc_note_maybes')}>
                    Set Maybes
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button onClick={() => act('edit_ooc_note_dislikes')}>
                    Set Dislikes
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button onClick={() => act('edit_private_notes')}>
                    Set Private Notes
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button onClick={() => act('edit_ooc_note_style')}>
                    {ooc_note_style ? 'Lists' : 'Fields'}
                  </Button>
                </Stack.Item>
              </Stack>
            </Stack.Item>
          ) : null}
        </Stack>
      </Stack.Item>
    </Stack>
  );
};
