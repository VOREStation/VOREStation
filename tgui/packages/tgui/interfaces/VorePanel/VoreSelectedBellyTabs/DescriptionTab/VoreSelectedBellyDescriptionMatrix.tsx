import { useBackend } from 'tgui/backend';
import {
  Button,
  LabeledList,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';
import { type BooleanLike } from 'tgui-core/react';

import { messageTabLabel } from '../../constants';
import type { bellyDescriptionData } from '../../types';
import { VorePanelEditSwitch } from '../../VorePanelElements/VorePanelEditSwitch';
import { VorePanelEditTextArea } from '../../VorePanelElements/VorePanelTextArea';

export const VoreSelectedBellyDescriptionMatrix = (props: {
  showAll: BooleanLike;
  showFormatHelp: boolean;
  onShowFormatHelp: React.Dispatch<React.SetStateAction<boolean>>;
  editMode: boolean;
  bellyDescriptionData: bellyDescriptionData;
}) => {
  const { act } = useBackend();

  const {
    showAll,
    showFormatHelp,
    onShowFormatHelp,
    editMode,
    bellyDescriptionData,
  } = props;
  const {
    displayed_options,
    message_option,
    message_subtab,
    displayed_message_types,
    selected_message,
  } = bellyDescriptionData;

  return (
    <Section
      title="Messages"
      fill
      buttons={
        <Stack>
          {editMode && (
            <Stack.Item>
              <Button
                color="red"
                onClick={() =>
                  act('set_attribute', {
                    attribute: 'b_msgs',
                    msgtype: 'reset',
                  })
                }
              >
                Reset Messages
              </Button>
            </Stack.Item>
          )}
          <Stack.Item>
            <Button
              tooltip={
                (showAll ? 'Hides' : 'Shows') + ' all possible belly messages.'
              }
              onClick={() =>
                act('set_attribute', {
                  attribute: 'b_message_mode',
                })
              }
              icon={'eye'}
              selected={showAll}
            />
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="question"
              tooltip="Formatting help"
              onClick={() => onShowFormatHelp(!showFormatHelp)}
              selected={showFormatHelp}
            />
          </Stack.Item>
        </Stack>
      }
    >
      <Stack fill>
        <Stack.Item basis="16%">
          <Stack vertical>
            <Stack.Item basis="1.667rem" />
            <Stack.Item>
              <Tabs vertical>
                {displayed_options.map((index) => (
                  <Tabs.Tab
                    key={index}
                    selected={index === message_option}
                    onClick={() => {
                      if (index !== message_option) {
                        act('change_message_option', { tab: index });
                      }
                    }}
                  >
                    {messageTabLabel[index]}
                  </Tabs.Tab>
                ))}
              </Tabs>
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item grow>
          <Stack fill vertical ml="5px">
            <Stack.Item>
              <Stack>
                <Stack.Item>
                  {!!displayed_message_types &&
                    !!displayed_message_types.subtypes && (
                      <Tabs>
                        {displayed_message_types.subtypes.map((subtype) => (
                          <Tabs.Tab
                            key={subtype}
                            selected={subtype === message_subtab}
                            onClick={() => {
                              if (subtype !== message_subtab) {
                                act('change_message_type', { tab: subtype });
                              }
                            }}
                          >
                            {subtype}
                          </Tabs.Tab>
                        ))}
                      </Tabs>
                    )}
                </Stack.Item>
                <Stack.Item grow />
                <Stack.Item>
                  {!!displayed_message_types &&
                    !!displayed_message_types.possible_messages && (
                      <Tabs>
                        {displayed_message_types.possible_messages.map(
                          (message_tyxpe) => (
                            <Tabs.Tab
                              key={message_tyxpe}
                              selected={message_tyxpe === selected_message}
                              onClick={() => {
                                if (message_tyxpe !== selected_message) {
                                  act('set_current_message', {
                                    tab: message_tyxpe,
                                  });
                                }
                              }}
                            >
                              {message_tyxpe}
                            </Tabs.Tab>
                          ),
                        )}
                      </Tabs>
                    )}
                </Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item grow>
              {!!selected_message && !!displayed_message_types && (
                <Stack vertical fill>
                  {!!displayed_message_types.button_action && (
                    <Stack.Item>
                      <LabeledList>
                        <LabeledList.Item
                          label={displayed_message_types.button_label}
                        >
                          <VorePanelEditSwitch
                            action="set_attribute"
                            subAction={displayed_message_types.button_action}
                            editMode={editMode}
                            active={!!displayed_message_types.button_data}
                            tooltip={
                              (displayed_message_types.button_data
                                ? 'Dis'
                                : 'En') +
                              'ables ' +
                              displayed_message_types.button_tooltip
                            }
                          />
                        </LabeledList.Item>
                      </LabeledList>
                    </Stack.Item>
                  )}
                  <Stack.Item grow>
                    <VorePanelEditTextArea
                      editMode={editMode}
                      tooltip={displayed_message_types.tooltip}
                      limit={displayed_message_types.max_length}
                      entry={displayed_message_types.active_message || ''}
                      action={'set_attribute'}
                      listAction={'b_msgs'}
                      subAction={displayed_message_types.set_action}
                    />
                  </Stack.Item>
                </Stack>
              )}
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
