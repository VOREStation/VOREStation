import type { ReactNode } from 'react';
import { useBackend } from 'tgui/backend';
import { LabeledList, Section, Stack, Tabs } from 'tgui-core/components';
import { VorePanelEditSwitch } from './VorePanelEditSwitch';
import { VorePanelEditTextArea } from './VorePanelTextArea';

export const VorePanelEditTextTabs = (
  props: {
    /** Switch between Element editing and display */
    editMode: boolean;
    /** The tab options to switch through */
    messsageOptionsLeft: string[];
    /** The current active tab */
    activeTab: string;
    /** The backend action to perform on tab selection */
    tabAction: string;
    /** Our displayed tooltip displayed above all texts */
    tooltip: ReactNode;
    /** The maximum length of each message */
    maxLength: number;
    /** The current displayed message or message array */
    activeMessage: string | string[] | null;
    /** Our backend action on text area blur */
    action: string;
  } & Partial<{
    /** Optional sub options to switch through */
    messsageOptionsRight: string[] | null;
    /** The current active subtab */
    activeSubTab: string;
    /** The backend action to perform on subtab selection */
    subTabAction: string;
    /** Do we force the input to always send the maxEntries as list length to byond */
    exactLength: boolean;
    /** Our secondary backend action on text area blur */
    subAction: string;
    /** Our secondary backend action if we used a list as input on text area blur */
    listAction: string;
    /** The amount of possible list entries. By default 10 */
    maxEntries: number;
    /** Should we disbale the copy paste legacy field for text to list inputs */
    disableLegacyInput: boolean;
    /** The action of a possibly supplied button shown above all inputs */
    button_action: string;
    /** The sub action of a possibly supplied button shown above all inputs */
    button_subAction: string;
    /** The action of a possibly supplied button shown above all inputs */
    button_label: string;
    /** The data of the button to show its possible selected state */
    button_data: boolean;
    /** The tooltip to display on button hover */
    button_tooltip: ReactNode;
    /** The icon of each tab as record, mapping the messageOptions to icons */
    tabsToIcons: Record<string, string>;
    /** Disable our special highlighting used on belly messages */
    noHighlight: boolean;
    /** Warn if input is below the minimum */
    minLength: number;
  }>,
) => {
  const { act } = useBackend();

  const {
    editMode,
    messsageOptionsLeft,
    messsageOptionsRight,
    activeTab,
    activeSubTab,
    tabAction,
    subTabAction,
    tooltip,
    maxLength,
    activeMessage,
    action,
    exactLength,
    subAction,
    listAction,
    maxEntries = 10,
    disableLegacyInput,
    button_action,
    button_subAction,
    button_label,
    button_data,
    button_tooltip,
    tabsToIcons,
    noHighlight,
    minLength,
  } = props;

  return (
    <Stack vertical fill>
      <Stack.Item>
        <Stack>
          <Stack.Item>
            <Tabs>
              {messsageOptionsLeft.map((value) => (
                <Tabs.Tab
                  key={value}
                  selected={value === activeTab}
                  onClick={() => {
                    if (value !== activeTab) {
                      act(tabAction, { tab: value });
                    }
                  }}
                  icon={tabsToIcons?.[value]}
                >
                  {value}
                </Tabs.Tab>
              ))}
            </Tabs>
          </Stack.Item>
          {!!messsageOptionsRight && subTabAction && (
            <>
              <Stack.Item grow />
              <Stack.Item>
                <Tabs>
                  {messsageOptionsRight.map((value) => (
                    <Tabs.Tab
                      key={value}
                      selected={value === activeSubTab}
                      onClick={() => {
                        if (value !== activeSubTab) {
                          act(subTabAction, { tab: value });
                        }
                      }}
                      icon={tabsToIcons?.[value]}
                    >
                      {value}
                    </Tabs.Tab>
                  ))}
                </Tabs>
              </Stack.Item>
            </>
          )}
        </Stack>
      </Stack.Item>
      <Stack.Item grow>
        <Section fill scrollable>
          <Stack fill vertical>
            {!!button_action && button_data && (
              <Stack.Item>
                <LabeledList>
                  <LabeledList.Item label={button_label}>
                    <VorePanelEditSwitch
                      action={button_action}
                      subAction={button_subAction}
                      editMode={editMode}
                      active={!!button_data}
                      tooltip={`${button_data ? 'Dis' : 'En'}ables ${button_tooltip}`}
                    />
                  </LabeledList.Item>
                </LabeledList>
              </Stack.Item>
            )}
            <Stack.Item grow>
              <VorePanelEditTextArea
                minLength={minLength}
                noHighlight={noHighlight}
                editMode={editMode}
                tooltip={tooltip}
                limit={maxLength}
                entry={activeMessage || ''}
                action={action}
                exactLength={exactLength}
                subAction={subAction}
                listAction={listAction}
                maxEntries={maxEntries}
                disableLegacyInput={disableLegacyInput}
              />
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>
    </Stack>
  );
};
