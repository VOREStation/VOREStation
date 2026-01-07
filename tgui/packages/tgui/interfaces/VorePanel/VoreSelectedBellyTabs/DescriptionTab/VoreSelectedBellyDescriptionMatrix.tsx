import { useBackend } from 'tgui/backend';
import { Button, Section, Stack, Tabs } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { messageTabLabel } from '../../constants';
import type { BellyDescriptionData } from '../../types';
import { VorePanelEditTextTabs } from '../../VorePanelElements/VorePaneldEditTextTabs';

export const VoreSelectedBellyDescriptionMatrix = (props: {
  showAll: BooleanLike;
  showFormatHelp: boolean;
  onShowFormatHelp: React.Dispatch<React.SetStateAction<boolean>>;
  editMode: boolean;
  bellyDescriptionData: BellyDescriptionData;
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
              tooltip={`${showAll ? 'Hides' : 'Shows'} all possible belly messages.`}
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
            <Stack.Item grow>
              {!!displayed_message_types?.possible_messages && (
                <VorePanelEditTextTabs
                  editMode={editMode}
                  messsageOptionsLeft={
                    displayed_message_types.possible_messages
                  }
                  messsageOptionsRight={displayed_message_types.subtypes}
                  activeTab={selected_message}
                  activeSubTab={message_subtab}
                  tabAction="set_current_message"
                  subTabAction="change_message_type"
                  tooltip={displayed_message_types.tooltip}
                  maxLength={displayed_message_types.max_length}
                  minLength={10}
                  activeMessage={displayed_message_types.active_message}
                  action="set_attribute"
                  listAction="b_msgs"
                  subAction={displayed_message_types.set_action}
                  button_action="set_attribute"
                  button_subAction={displayed_message_types.button_action}
                  button_data={!!displayed_message_types.button_data}
                  button_label={displayed_message_types.button_label}
                  button_tooltip={
                    (displayed_message_types.button_data ? 'Dis' : 'En') +
                    'ables ' +
                    displayed_message_types.button_tooltip
                  }
                />
              )}
            </Stack.Item>
          </Stack>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
