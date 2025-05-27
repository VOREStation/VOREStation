import { useBackend } from 'tgui/backend';
import { LabeledList, Stack, Tabs } from 'tgui-core/components';

import { VorePanelEditSwitch } from './VorePanelEditSwitch';
import { VorePanelEditTextArea } from './VorePanelTextArea';

export const VorePanelEditTextTabs = (props: {
  /** Switch between Element editing and display */
  editMode: boolean;
  /** The tab options to switch through */
  messsageOptions: string[];
  /** The current active tab */
  activeTab: string;
  /** The backend action to perform on tab selection */
  tabAction: string;
  /** Our displayed tooltip displayed above all texts */
  tooltip: string;
  /** The maximum length of each message */
  maxLength: number;
  /** The current displayed message or message array */
  activeMessage: string | string[] | null;
  /** Do we force the input to always send the maxEntries as list length to byond */
  exactLength?: boolean;
  /** Our backend action on text area blur */
  action: string;
  /** Our secondary backend action on text area blur */
  subAction?: string;
  /** Our secondary backend action if we used a list as input on text area blur */
  listAction?: string;
  /** The amount of possible list entries. By default 10 */
  maxEntries?: number;
  /** Should we disbale the copy paste legacy field for text to list inputs */
  disableLegacyInput?: boolean;
  /** The action of a possibly supplied button shown above all inputs */
  button_action?: string;
  /** The action of a possibly supplied button shown above all inputs */
  button_label?: string;
  /** The data of the button to show its possible selected state */
  button_data?: boolean;
  /** The tooltip to display on button hover */
  button_tooltip?: string;
  /** The icon of each tab as record, mapping the messageOptions to icons */
  tabsToIcons?: Record<string, string>;
  /** Disable our special highlighting used on belly messages */
  noHighlight?: boolean;
}) => {
  const { act } = useBackend();

  const {
    editMode,
    messsageOptions,
    activeTab,
    tabAction,
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
    button_label,
    button_data,
    button_tooltip,
    tabsToIcons,
    noHighlight,
  } = props;

  return (
    <Stack vertical fill>
      <Stack.Item>
        <Tabs>
          {messsageOptions.map((value) => (
            <Tabs.Tab
              key={value}
              selected={value === activeTab}
              onClick={() => {
                if (value !== activeTab) {
                  act(tabAction, { tab: value });
                }
              }}
              icon={tabsToIcons && tabsToIcons[value]}
            >
              {value}
            </Tabs.Tab>
          ))}
        </Tabs>
      </Stack.Item>
      {!!button_action && (
        <Stack.Item>
          <LabeledList>
            <LabeledList.Item label={button_label}>
              <VorePanelEditSwitch
                action="set_attribute"
                subAction={button_action}
                editMode={editMode}
                active={!!button_data}
                tooltip={
                  (button_data ? 'Dis' : 'En') + 'ables ' + button_tooltip
                }
              />
            </LabeledList.Item>
          </LabeledList>
        </Stack.Item>
      )}
      <Stack.Item grow>
        <VorePanelEditTextArea
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
  );
};
