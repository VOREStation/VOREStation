import { useBackend } from 'tgui/backend';
import { PaiPreview } from 'tgui/interfaces/PaiChoose/PaiPreview';
import { VorePanelTooltip } from 'tgui/interfaces/VorePanel/VorePanelElements/VorePanelTooltip';
import {
  Box,
  Dropdown,
  Input,
  LabeledList,
  Stack,
  TextArea,
} from 'tgui-core/components';
import { PreferenceEditColor } from '../../elements/ColorInput';
import type {
  GeneralData,
  GeneralDataConstant,
  GeneralDataStatic,
} from './data';

export const SubtabPai = (props: {
  data: GeneralData;
  staticData: GeneralDataStatic;
  serverData: GeneralDataConstant;
}) => {
  const { act } = useBackend();
  const { data, staticData, serverData } = props;
  const {
    pai_name,
    pai_desc,
    pai_role,
    pai_ad,
    pai_comments,
    pai_eyecolor,
    pai_chassis,
    pai_chassises,
    pai_emotion,
    pai_emotions,
    pai_sprite_datum_class,
    pai_sprite_datum_size,
  } = data;

  return (
    <Stack vertical fill textAlign="center">
      <Stack.Item mt={2}>
        <Stack>
          <Stack.Item grow>
            <Stack fill vertical align="center">
              <Stack.Item>
                <Box bold>pAI Settings</Box>
                <LabeledList>
                  <LabeledList.Item label="Name">
                    <Stack>
                      <Stack.Item>
                        <Input
                          fluid
                          value={pai_name}
                          maxLength={52}
                          onBlur={(value) =>
                            act('pai_option', {
                              pai_option: 'name',
                              name: value,
                            })
                          }
                        />
                      </Stack.Item>
                      <Stack.Item>
                        <VorePanelTooltip
                          tooltip="What you plan to call yourself. Suggestions: Any character name you would choose for a station character OR an AI."
                          displayText="?"
                        />
                      </Stack.Item>
                    </Stack>
                  </LabeledList.Item>
                  <LabeledList.Item verticalAlign="top" label="Role">
                    <Stack>
                      <Stack.Item>
                        <TextArea
                          fluid
                          maxLength={4096}
                          value={pai_role}
                          height="100px"
                          onBlur={(value) =>
                            act('pai_option', {
                              pai_option: 'role',
                              role: value,
                            })
                          }
                        />
                      </Stack.Item>
                      <Stack.Item>
                        <VorePanelTooltip
                          tooltip="Do you like to partner with sneaky social ninjas? Like to help security hunt down thugs? Enjoy watching an engineer's back while he saves the station yet again? This doesn't have to be limited to just station jobs. Pretty much any general descriptor for what you'd like to be doing works here."
                          displayText="?"
                        />
                      </Stack.Item>
                    </Stack>
                  </LabeledList.Item>
                  <LabeledList.Item verticalAlign="top" label="Description">
                    <Stack>
                      <Stack.Item>
                        <TextArea
                          fluid
                          maxLength={16384}
                          height="100px"
                          value={pai_desc}
                          onBlur={(value) =>
                            act('pai_option', {
                              pai_option: 'desc',
                              desc: value,
                            })
                          }
                        />
                      </Stack.Item>
                      <Stack.Item>
                        <VorePanelTooltip
                          tooltip="What sort of pAI you typically play; your mannerisms, your quirks, etc. This can be as sparse or as detailed as you like."
                          displayText="?"
                        />
                      </Stack.Item>
                    </Stack>
                  </LabeledList.Item>
                  <LabeledList.Item verticalAlign="top" label="Ad">
                    <Stack>
                      <Stack.Item>
                        <TextArea
                          fluid
                          maxLength={4096}
                          height="100px"
                          value={pai_ad}
                          onBlur={(value) =>
                            act('pai_option', {
                              pai_option: 'ad',
                              ad: value,
                            })
                          }
                        />
                      </Stack.Item>
                      <Stack.Item>
                        <VorePanelTooltip
                          tooltip="Enter an advertisement for your pAI."
                          displayText="?"
                        />
                      </Stack.Item>
                    </Stack>
                  </LabeledList.Item>
                  <LabeledList.Item verticalAlign="top" label="OOC Comments">
                    <Stack>
                      <Stack.Item>
                        <TextArea
                          fluid
                          maxLength={4096}
                          height="100px"
                          value={pai_comments}
                          onBlur={(value) =>
                            act('pai_option', {
                              pai_option: 'ooc',
                              ooc: value,
                            })
                          }
                        />
                      </Stack.Item>
                      <Stack.Item>
                        <VorePanelTooltip
                          tooltip={`Anything you'd like to address specifically to the player reading this in an OOC manner. "I prefer more serious RP.", "I'm still learning the interface!", etc. Feel free to leave this blank if you want.`}
                          displayText="?"
                        />
                      </Stack.Item>
                    </Stack>
                  </LabeledList.Item>
                  <LabeledList.Item label="Color">
                    <PreferenceEditColor
                      back_color={pai_eyecolor}
                      tooltip="Choose your pAI's default glow colour."
                      onClose={(value) =>
                        act('pai_option', {
                          pai_option: 'color',
                          color: value,
                        })
                      }
                    />
                  </LabeledList.Item>
                  <LabeledList.Item label="Chassis">
                    <Stack>
                      <Stack.Item>
                        <Dropdown
                          fluid
                          onSelected={(value) =>
                            act('pai_option', {
                              pai_option: 'chassis',
                              chassis: value,
                            })
                          }
                          options={Object.keys(pai_chassises)}
                          selected={pai_chassis}
                        />
                      </Stack.Item>
                      <Stack.Item>
                        <VorePanelTooltip
                          tooltip="Choose your pAI's default chassis."
                          displayText="?"
                        />
                      </Stack.Item>
                    </Stack>
                  </LabeledList.Item>
                  <LabeledList.Item label="Emotion">
                    <Stack>
                      <Stack.Item>
                        <Dropdown
                          fluid
                          onSelected={(value) =>
                            act('pai_option', {
                              pai_option: 'emotion',
                              emotion: value,
                            })
                          }
                          options={Object.keys(pai_emotions)}
                          selected={pai_emotion}
                        />
                      </Stack.Item>
                      <Stack.Item>
                        <VorePanelTooltip
                          tooltip="Choose your pAI's default emotion."
                          displayText="?"
                        />
                      </Stack.Item>
                    </Stack>
                  </LabeledList.Item>
                </LabeledList>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Divider />
          <Stack.Item grow>
            <Stack fill vertical align="center">
              <Stack.Item>
                <Box bold>Sprite Preview</Box>
              </Stack.Item>
              <PaiPreview
                icon={pai_sprite_datum_class}
                size={pai_sprite_datum_size}
                color={pai_eyecolor}
              />
            </Stack>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};
