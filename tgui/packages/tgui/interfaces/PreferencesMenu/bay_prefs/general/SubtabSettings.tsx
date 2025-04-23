import { useBackend } from 'tgui/backend';
import { Box, Button, LabeledList, Stack } from 'tgui-core/components';

import {
  type GeneralData,
  type GeneralDataConstant,
  type GeneralDataStatic,
} from './data';

const extra_desc = (name: string) => {
  switch (name) {
    case 'Be positronic brain':
      return 'This unlocks opportunities to become a positronic borg brain when you are a ghost.';
    case 'Be pAI candidate':
      return 'This unlocks opportunities to become a personal AI assistant when you are a ghost.';
    case 'Be lost drone':
      return 'This unlocks opportunities to become a spooky lost drone when you are a ghost.';
    case 'Be maint pred':
      return 'This unlocks opportunities to become use a maintenance predator spawner.';
    case 'Be maint lurker':
      return 'This unlocks opportunities to become use a maintenance mob spawner.';
    case 'Be morph':
      return 'This is totally useless, but once allowed you to become a shapeshifting mimic.';
    case 'Be corgi':
      return 'This is totally useless, but once allowed you to become a corgi.';
    case 'Be cursed sword':
      return 'This is totally useless, but once allowed you to become a cursed sword.';
    case 'Be Ship Survivor':
      return 'This is totally useless, but once allowed you to become a survivor mob in a ship crash POI.';
    default:
      return null;
  }
};

export const SubtabSettings = (props: {
  data: GeneralData;
  staticData: GeneralDataStatic;
  serverData: GeneralDataConstant;
}) => {
  const { act } = useBackend();
  const { data, staticData, serverData } = props;
  const {
    antag_faction,
    antag_vis,
    uplink_type,
    record_banned,
    exploitable_record,
    pai_name,
    pai_desc,
    pai_role,
    pai_comments,
    syndicate_ban,
    special_roles,
    custom_footstep,
    custom_speech_bubble,
  } = data;

  return (
    <Stack vertical fill>
      <Stack.Item>
        <LabeledList>
          <LabeledList.Item label="Spawn Point">
            <Button onClick={() => act('spawnpoint')}>{data.spawnpoint}</Button>
          </LabeledList.Item>
        </LabeledList>
      </Stack.Item>
      <Stack.Item mt={2}>
        <Stack>
          <Stack.Item grow>
            <Box bold>Special Roles</Box>
            {syndicate_ban ? (
              <Box bold color="bad">
                You are banned from antagonist roles.
              </Box>
            ) : (
              <LabeledList>
                {special_roles.map((role) => (
                  <LabeledList.Item
                    key={role.name}
                    label={role.name}
                    tooltip={extra_desc(role.name) || ''}
                  >
                    <Button
                      selected={role.selected}
                      color={role.banned ? 'bad' : null}
                      onClick={() =>
                        act('be_special', { be_special: role.idx })
                      }
                    >
                      {role.banned ? 'BANNED' : role.selected ? 'Yes' : 'No'}
                    </Button>
                  </LabeledList.Item>
                ))}
              </LabeledList>
            )}
          </Stack.Item>
          <Stack.Divider />
          <Stack.Item grow>
            <Box bold>Antag Settings</Box>
            <LabeledList>
              <LabeledList.Item label="Faction">
                <Button onClick={() => act('antagfaction')}>
                  {antag_faction}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="Visibility">
                <Button onClick={() => act('antagvis')}>{antag_vis}</Button>
              </LabeledList.Item>
              <LabeledList.Item label="Uplink Type">
                <Button onClick={() => act('uplinklocation')}>
                  {uplink_type}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="Exploitable Information">
                {record_banned ? (
                  <Box color="bad">You are record-banned.</Box>
                ) : (
                  <Button onClick={() => act('exploitable_record')}>
                    {exploitable_record}
                  </Button>
                )}
              </LabeledList.Item>
            </LabeledList>
            <Box bold>Misc Settings</Box>
            <LabeledList>
              <LabeledList.Item label="Custom Speech Bubble">
                <Button onClick={() => act('customize_speech_bubble')}>
                  {custom_speech_bubble}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="Custom Footstep Sounds">
                <Button onClick={() => act('customize_footsteps')}>
                  {custom_footstep}
                </Button>
              </LabeledList.Item>
            </LabeledList>
          </Stack.Item>
          <Stack.Divider />
          <Stack.Item grow>
            <Box bold>pAI Settings</Box>
            <LabeledList>
              <LabeledList.Item label="Name">
                <Button onClick={() => act('option', { option: 'name' })}>
                  {pai_name}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="Description">
                <Button onClick={() => act('option', { option: 'desc' })}>
                  {pai_desc}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="Role">
                <Button onClick={() => act('option', { option: 'role' })}>
                  {pai_role}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="OOC Comments">
                <Button onClick={() => act('option', { option: 'ooc' })}>
                  {pai_comments}
                </Button>
              </LabeledList.Item>
            </LabeledList>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};
