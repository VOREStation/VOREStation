import { useBackend } from 'tgui/backend';
import { Stack, Tabs } from 'tgui-core/components';

import type { scMessageData } from '../../types';
import { VorePanelEditTextArea } from '../../VorePanelElements/VorePanelTextArea';

export const SoulcatcherMessages = (props: {
  editMode: boolean;
  soulcatcherMessageData: scMessageData;
}) => {
  const { act } = useBackend();

  const { editMode, soulcatcherMessageData } = props;
  const {
    possible_messages,
    sc_subtab,
    max_length,
    active_message,
    set_action,
    tooltip,
  } = soulcatcherMessageData;

  return (
    <Stack vertical fill>
      <Stack.Item>
        <Tabs>
          {possible_messages.map((index) => (
            <Tabs.Tab
              key={index}
              selected={index === sc_subtab}
              onClick={() => {
                if (index !== sc_subtab) {
                  act('change_sc_message_option', { tab: index });
                }
              }}
            >
              {index}
            </Tabs.Tab>
          ))}
        </Tabs>
      </Stack.Item>
      <Stack.Item grow>
        <VorePanelEditTextArea
          editMode={editMode}
          tooltip={tooltip}
          limit={max_length}
          entry={active_message || ''}
          action={set_action}
          subAction={''}
        />
      </Stack.Item>
    </Stack>
  );
};
