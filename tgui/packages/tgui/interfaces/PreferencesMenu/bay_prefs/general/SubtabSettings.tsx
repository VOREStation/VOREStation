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
      return 'This notifies you when there is an opportunity to become a positronic borg brain.';
    case 'Be pAI candidate':
      return 'This notifies you when there is an opportunity to become a personal AI assistant.';
    case 'Be lost drone':
      return 'This notifies you when there is an opportunity to become a spooky lost drone.';
    case 'Be maint pred':
      return 'This notifies you when there is an opportunity to become use a maintenance predator spawner.';
    case 'Be maint lurker':
      return 'This notifies you when there is an opportunity to use a maintenance mob spawner.';
    case 'Be maint critter':
      return 'This notifies you when there is an opportunity to use a maintenance critter spawner to become a mob, a morph, or a lurker.';
    case 'Be morph':
      return 'This notifies you when there is an opportunity to become a morph, a goopy shapeshifting critter.';
    case 'Be corgi':
      return 'This notifies you when there is an opportunity to become a corgi.';
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
    ignore_shoes,
    custom_species_sound,
    custom_speech_bubble,
    persistence_settings,
    show_in_directory,
    directory_tag,
    directory_gendertag,
    directory_sexualitytag,
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
                  <LabeledList.Item label="Allow Capture Crystal">
                    <Button
                      onClick={() => act('toggle_capture_crystal')}
                      selected={capture_crystal}
                      tooltip="Would you like to be able to be put in a capture crystal?"
                    >
                      {capture_crystal ? 'Yes' : 'No'}
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item label="Allow Robot Petting">
                    <Button
                      onClick={() => act('toggle_borg_petting')}
                      selected={borg_petting}
                      tooltip="Would you like to be able to be pet as a robot?"
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
                  <LabeledList.Item label="Ignore Shoes">
                    <Button
                      onClick={() => act('toggle_ignore_shoes')}
                      selected={ignore_shoes}
                      tooltip="Allow footstep sounds to pass through shoes."
                    >
                      {ignore_shoes ? 'Yes' : 'No'}
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item label="Custom Species Sounds">
                    <Button onClick={() => act('customize_species_sounds')}>
                      {custom_species_sound}
                    </Button>
                    <Stack>
                      <Stack.Item>
                        <Button
                          icon="head-side-cough"
                          tooltip="Test Cough Sound"
                          onClick={() => act('cough_test')}
                        />
                      </Stack.Item>
                      <Stack.Item>
                        <Button
                          icon="box-tissue"
                          tooltip="Test Sneeze Sound"
                          onClick={() => act('sneeze_test')}
                        />
                      </Stack.Item>
                      <Stack.Item>
                        <Button
                          icon="person-harassing"
                          tooltip="Test Screan Sound"
                          onClick={() => act('scream_test')}
                        />
                      </Stack.Item>
                    </Stack>
                    <Stack>
                      <Stack.Item>
                        <Button
                          icon="bandage"
                          tooltip="Test Pain Sound"
                          onClick={() => act('pain_test')}
                        />
                      </Stack.Item>
                      <Stack.Item>
                        <Button
                          icon="lungs"
                          tooltip="Test Gasp Sound"
                          onClick={() => act('gasp_test')}
                        />
                      </Stack.Item>
                      <Stack.Item>
                        <Button
                          icon="skull"
                          tooltip="Test Death Sound"
                          onClick={() => act('death_test')}
                        />
                      </Stack.Item>
                    </Stack>
                  </LabeledList.Item>
                  <LabeledList.Item label="Event Volunteer">
                    <Button
                      onClick={() => act('toggle_vantag_volunteer')}
                      selected={vantag_volunteer}
                      tooltip="Would you like to be offered a chance to participate in events?"
                    >
                      {vantag_volunteer ? 'Yes' : 'No'}
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item label="Event Pref">
                    <Button
                      onClick={() => act('change_vantag')}
                      tooltip="How do you want to be involved with event characters, ERP wise?"
                    >
                      {vantag_preference}
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item label="Prevent Body Impersonation">
                    <Button
                      onClick={() => act('toggle_resleeve_lock')}
                      selected={resleeve_lock}
                      tooltip="Prevent anyone from impersonating your character via resleeving and other methods"
                    >
                      {resleeve_lock ? 'Yes' : 'No'}
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item label="Spawn With Backup Implant">
                    <Button
                      onClick={() => act('toggle_implant')}
                      selected={auto_backup_implant}
                      tooltip="Automatically back your mind up to be resleeved?"
                    >
                      {auto_backup_implant ? 'Yes' : 'No'}
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item label="Start With Body Scan">
                    <Button
                      onClick={() => act('toggle_resleeve_scan')}
                      selected={resleeve_scan}
                      tooltip="Select if you start the round with your body records ready to be resleeved"
                    >
                      {resleeve_scan ? 'Yes' : 'No'}
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item label="Start With Mind Scan">
                    <Button
                      onClick={() => act('toggle_mind_scan')}
                      selected={mind_scan}
                      tooltip="Select if you start the round with your mind ready to be resleeved"
                    >
                      {mind_scan ? 'Yes' : 'No'}
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item label="Suit Sensors">
                    <Button
                      onClick={() => act('toggle_sensor_setting')}
                      tooltip="Select whether you can be tracked by medical by default"
                    >
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
                    label="Gender Tag"
                    tooltip="What's your gender?"
                  >
                    <Button onClick={() => act('directory_gendertag')}>
                      {directory_gendertag}
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item
                    label="Sexuality Tag"
                    tooltip="What's your orientation?"
                  >
                    <Button onClick={() => act('directory_sexualitytag')}>
                      {directory_sexualitytag}
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
                <Box bold>Custom Text</Box>
                <LabeledList>
                  <LabeledList.Item label="Custom Say">
                    <Button fluid onClick={() => act('custom_say')}>
                      Set Say Verb
                    </Button>
                    <Button fluid onClick={() => act('reset_say')}>
                      Reset
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item label="Custom Whisper">
                    <Button fluid onClick={() => act('custom_whisper')}>
                      Set Whisper Verb
                    </Button>
                    <Button fluid onClick={() => act('reset_whisper')}>
                      Reset
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item label="Custom Ask">
                    <Button fluid onClick={() => act('custom_ask')}>
                      Set Ask Verb
                    </Button>
                    <Button fluid onClick={() => act('reset_ask')}>
                      Reset
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item label="Custom Exclaim">
                    <Button fluid onClick={() => act('custom_exclaim')}>
                      Set Exclaim Verb
                    </Button>
                    <Button fluid onClick={() => act('reset_exclaim')}>
                      Reset
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item label="Custom Heat Discomfort">
                    <Button fluid onClick={() => act('custom_heat')}>
                      Set Heat Messages
                    </Button>
                    <Button fluid onClick={() => act('reset_heat')}>
                      Reset
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item label="Custom Cold Discomfort">
                    <Button fluid onClick={() => act('custom_cold')}>
                      Set Cold Messages
                    </Button>
                    <Button fluid onClick={() => act('reset_cold')}>
                      Reset
                    </Button>
                  </LabeledList.Item>
                </LabeledList>
              </Stack.Item>
              <Stack.Item>
                <Box bold>pAI Settings</Box>
                <LabeledList>
                  <LabeledList.Item label="Name">
                    <Button onClick={() => act('option', { option: 'name' })}>
                      {pai_name || 'None Set'}
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item label="Description">
                    <Button onClick={() => act('option', { option: 'desc' })}>
                      {pai_desc || 'None Set'}
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item label="Role">
                    <Button onClick={() => act('option', { option: 'role' })}>
                      {pai_role || 'None Set'}
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item label="OOC Comments">
                    <Button onClick={() => act('option', { option: 'ooc' })}>
                      {pai_comments || 'None Set'}
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
