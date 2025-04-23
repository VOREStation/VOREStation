import { useBackend } from 'tgui/backend';
import { Box, Button, LabeledList, Stack } from 'tgui-core/components';

import {
  type GeneralData,
  type GeneralDataConstant,
  type GeneralDataStatic,
  PersistanceEnum,
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
    persistence_settings,
    show_in_directory,
    directory_tag,
    directory_erptag,
    sensorpref,
    capture_crystal,
    auto_backup_implant,
    borg_petting,
    resleeve_lock,
    resleeve_scan,
    mind_scan,
    vantag_volunteer,
    vantag_preference,
  } = data;

  return (
    <Stack vertical fill textAlign="center">
      <Stack.Item mt={2}>
        <Stack>
          <Stack.Item grow>
            <Stack fill vertical align="center">
              <Stack.Item>
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
              </Stack.Item>
              <Stack.Item>
                <Box bold>Misc Settings</Box>
                <LabeledList>
                  <LabeledList.Item
                    label="Allow Capture Crystal"
                    tooltip="Would you like to be able to be put in a capture crystal?"
                  >
                    <Button
                      onClick={() => act('toggle_capture_crystal')}
                      selected={capture_crystal}
                    >
                      {capture_crystal ? 'Yes' : 'No'}
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item
                    label="Allow Robot Petting"
                    tooltip="Would you like to be able to be pet as a robot?"
                  >
                    <Button
                      onClick={() => act('toggle_borg_petting')}
                      selected={borg_petting}
                    >
                      {borg_petting ? 'Yes' : 'No'}
                    </Button>
                  </LabeledList.Item>
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
                  <LabeledList.Item
                    label="Event Volunteer"
                    tooltip="Would you like to be offered a chance to participate in events?"
                  >
                    <Button
                      onClick={() => act('toggle_vantag_volunteer')}
                      selected={vantag_volunteer}
                    >
                      {vantag_volunteer ? 'Yes' : 'No'}
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item
                    label="Event Pref"
                    tooltip="How do you want to be involved with event characters, ERP wise?"
                  >
                    <Button onClick={() => act('change_vantag')}>
                      {vantag_preference}
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item
                    label="Prevent Body Impersonation"
                    tooltip="Prevent anyone from impersonating your character via resleeving and other methods"
                  >
                    <Button
                      onClick={() => act('toggle_resleeve_lock')}
                      selected={resleeve_lock}
                    >
                      {resleeve_lock ? 'Yes' : 'No'}
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item
                    label="Spawn With Backup Implant"
                    tooltip="Automatically back your mind up to be resleeved?"
                  >
                    <Button
                      onClick={() => act('toggle_implant')}
                      selected={auto_backup_implant}
                    >
                      {auto_backup_implant ? 'Yes' : 'No'}
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item
                    label="Start With Body Scan"
                    tooltip="Select if you start the round with your body records ready to be resleeved"
                  >
                    <Button
                      onClick={() => act('toggle_resleeve_scan')}
                      selected={resleeve_scan}
                    >
                      {resleeve_scan ? 'Yes' : 'No'}
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item
                    label="Start With Mind Scan"
                    tooltip="Select if you start the round with your mind ready to be resleeved"
                  >
                    <Button
                      onClick={() => act('toggle_mind_scan')}
                      selected={mind_scan}
                    >
                      {mind_scan ? 'Yes' : 'No'}
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item
                    label="Suit Sensors"
                    tooltip="Select whether you can be tracked by medical by default"
                  >
                    <Button onClick={() => act('toggle_sensor_setting')}>
                      {sensorpref}
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item label="Spawn Point">
                    <Button onClick={() => act('spawnpoint')}>
                      {data.spawnpoint}
                    </Button>
                  </LabeledList.Item>
                </LabeledList>
              </Stack.Item>
              <Stack.Item>
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
                          {role.banned
                            ? 'BANNED'
                            : role.selected
                              ? 'Yes'
                              : 'No'}
                        </Button>
                      </LabeledList.Item>
                    ))}
                  </LabeledList>
                )}
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Divider />
          <Stack.Item grow>
            <Stack fill vertical align="center">
              <Stack.Item>
                <Box bold>Character Directory</Box>
                <LabeledList>
                  <LabeledList.Item
                    label="Show In Directory"
                    tooltip="Do you want other players to see you in the character directory?"
                  >
                    <Button onClick={() => act('toggle_show_in_directory')}>
                      {show_in_directory ? 'Yes' : 'No'}
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item
                    label="Vore Tag"
                    tooltip="Are you a predator, prey, or somewhere in-between?"
                  >
                    <Button onClick={() => act('directory_tag')}>
                      {directory_tag}
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item
                    label="ERP Tag"
                    tooltip="Are you a top, bottom or somewhere in-between?"
                  >
                    <Button onClick={() => act('directory_erptag')}>
                      {directory_erptag}
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item
                    label="Advertisement"
                    tooltip="Set an advertisement to show in the character directory"
                  >
                    <Button onClick={() => act('directory_ad')}>Set Ad</Button>
                  </LabeledList.Item>
                </LabeledList>
              </Stack.Item>
              <Stack.Item>
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
              <Stack.Item>
                <Box bold>Persistence Settings</Box>
                <LabeledList>
                  <LabeledList.Item
                    label="Save Spawn Location"
                    tooltip="Set spawn location based on where you left the round"
                  >
                    <Button
                      selected={
                        persistence_settings & PersistanceEnum.PERSIST_SPAWN
                      }
                      onClick={() =>
                        act('toggle_persist', {
                          bit: PersistanceEnum.PERSIST_SPAWN,
                        })
                      }
                    >
                      {persistence_settings & PersistanceEnum.PERSIST_SPAWN
                        ? 'Yes'
                        : 'No'}
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item
                    label="Save Weight"
                    tooltip="Save your character's weight until next round"
                  >
                    <Button
                      selected={
                        persistence_settings & PersistanceEnum.PERSIST_WEIGHT
                      }
                      onClick={() =>
                        act('toggle_persist', {
                          bit: PersistanceEnum.PERSIST_WEIGHT,
                        })
                      }
                    >
                      {persistence_settings & PersistanceEnum.PERSIST_WEIGHT
                        ? 'Yes'
                        : 'No'}
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item
                    label="Save Organs"
                    tooltip="Update organ preferences (normal/amputated/robotic/etc) and model (for robotic) based on what you have at round end"
                  >
                    <Button
                      selected={
                        persistence_settings & PersistanceEnum.PERSIST_ORGANS
                      }
                      onClick={() =>
                        act('toggle_persist', {
                          bit: PersistanceEnum.PERSIST_ORGANS,
                        })
                      }
                    >
                      {persistence_settings & PersistanceEnum.PERSIST_ORGANS
                        ? 'Yes'
                        : 'No'}
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item
                    label="Save Markings"
                    tooltip="Update marking preferences (type and color) based on what you have at round end"
                  >
                    <Button
                      selected={
                        persistence_settings & PersistanceEnum.PERSIST_MARKINGS
                      }
                      onClick={() =>
                        act('toggle_persist', {
                          bit: PersistanceEnum.PERSIST_MARKINGS,
                        })
                      }
                    >
                      {persistence_settings & PersistanceEnum.PERSIST_MARKINGS
                        ? 'Yes'
                        : 'No'}
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item
                    label="Save Scale"
                    tooltip="Update character scale based on what you were at round end"
                  >
                    <Button
                      selected={
                        persistence_settings & PersistanceEnum.PERSIST_SIZE
                      }
                      onClick={() =>
                        act('toggle_persist', {
                          bit: PersistanceEnum.PERSIST_SIZE,
                        })
                      }
                    >
                      {persistence_settings & PersistanceEnum.PERSIST_SIZE
                        ? 'Yes'
                        : 'No'}
                    </Button>
                  </LabeledList.Item>
                </LabeledList>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};
