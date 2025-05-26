import { useBackend } from 'tgui/backend';
import { LabeledList, Stack, Tabs } from 'tgui-core/components';

import { VorePanelEditSwitch } from './VorePanelEditSwitch';
import { VorePanelEditTextArea } from './VorePanelTextArea';

export const VorePanelEditTextTabs = (props: {
  editMode: boolean;
  messsageOptions: string[];
  activeTab: string;
  tabAction: string;
  tooltip: string;
  maxLength: number;
  activeMessage: string | string[] | null;
  exactLength?: boolean;
  action: string;
  subAction?: string;
  listAction?: string;
  maxEntries?: number;
  disableLegacyInput?: boolean;
  button_action?: string;
  button_label?: string;
  button_data?: boolean;
  button_tooltip?: string;
  tabsToIcons?: Record<string, string>;
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
