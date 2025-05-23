import { useBackend } from 'tgui/backend';
import { Button, LabeledList, Section, Stack } from 'tgui-core/components';

import type { selectedData } from '../types';

export const VoreSelectedBellyLiquidMessages = (props: {
  belly: selectedData;
}) => {
  const { act } = useBackend();

  const { belly } = props;
  const { show_liq_fullness, liq_messages } = belly;

  return (
    <Section
      title="Liquid Messages"
      buttons={
        <Button
          onClick={() =>
            act('liq_set_messages', { liq_messages: 'b_show_liq_fullness' })
          }
          icon={show_liq_fullness ? 'toggle-on' : 'toggle-off'}
          selected={show_liq_fullness}
          tooltipPosition="left"
          tooltip={
            'These are the settings for belly visibility when involving liquids fullness.'
          }
        >
          {show_liq_fullness ? 'Messages On' : 'Messages Off'}
        </Button>
      }
    >
      {show_liq_fullness ? (
        <LabeledList>
          <LabeledList.Item label="0 to 20%">
            <Stack>
              <Stack.Item>
                <Button
                  onClick={() =>
                    act('liq_set_messages', {
                      liq_messages: 'b_liq_msg_toggle1',
                    })
                  }
                  icon={
                    liq_messages.liq_msg_toggle1 ? 'toggle-on' : 'toggle-off'
                  }
                  selected={liq_messages.liq_msg_toggle1}
                >
                  {liq_messages.liq_msg_toggle1 ? 'On' : 'Off'}
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button
                  onClick={() =>
                    act('liq_set_messages', { liq_messages: 'b_liq_msg1' })
                  }
                >
                  Examine Message (0 to 20%)
                </Button>
              </Stack.Item>
            </Stack>
          </LabeledList.Item>
          <LabeledList.Item label="20 to 40%">
            <Stack>
              <Stack.Item>
                <Button
                  onClick={() =>
                    act('liq_set_messages', {
                      liq_messages: 'b_liq_msg_toggle2',
                    })
                  }
                  icon={
                    liq_messages.liq_msg_toggle2 ? 'toggle-on' : 'toggle-off'
                  }
                  selected={liq_messages.liq_msg_toggle2}
                >
                  {liq_messages.liq_msg_toggle2 ? 'On' : 'Off'}
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button
                  onClick={() =>
                    act('liq_set_messages', { liq_messages: 'b_liq_msg2' })
                  }
                >
                  Examine Message (20 to 40%)
                </Button>
              </Stack.Item>
            </Stack>
          </LabeledList.Item>
          <LabeledList.Item label="40 to 60%">
            <Stack>
              <Stack.Item>
                <Button
                  onClick={() =>
                    act('liq_set_messages', {
                      liq_messages: 'b_liq_msg_toggle3',
                    })
                  }
                  icon={
                    liq_messages.liq_msg_toggle3 ? 'toggle-on' : 'toggle-off'
                  }
                  selected={liq_messages.liq_msg_toggle3}
                >
                  {liq_messages.liq_msg_toggle3 ? 'On' : 'Off'}
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button
                  onClick={() =>
                    act('liq_set_messages', { liq_messages: 'b_liq_msg3' })
                  }
                >
                  Examine Message (40 to 60%)
                </Button>
              </Stack.Item>
            </Stack>
          </LabeledList.Item>
          <LabeledList.Item label="60 to 80%">
            <Stack>
              <Stack.Item>
                <Button
                  onClick={() =>
                    act('liq_set_messages', {
                      liq_messages: 'b_liq_msg_toggle4',
                    })
                  }
                  icon={
                    liq_messages.liq_msg_toggle4 ? 'toggle-on' : 'toggle-off'
                  }
                  selected={liq_messages.liq_msg_toggle4}
                >
                  {liq_messages.liq_msg_toggle4 ? 'On' : 'Off'}
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button
                  onClick={() =>
                    act('liq_set_messages', { liq_messages: 'b_liq_msg4' })
                  }
                >
                  Examine Message (60 to 80%)
                </Button>
              </Stack.Item>
            </Stack>
          </LabeledList.Item>
          <LabeledList.Item label="80 to 100%">
            <Stack>
              <Stack.Item>
                <Button
                  onClick={() =>
                    act('liq_set_messages', {
                      liq_messages: 'b_liq_msg_toggle5',
                    })
                  }
                  icon={
                    liq_messages.liq_msg_toggle5 ? 'toggle-on' : 'toggle-off'
                  }
                  selected={liq_messages.liq_msg_toggle5}
                >
                  {liq_messages.liq_msg_toggle5 ? 'On' : 'Off'}
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button
                  onClick={() =>
                    act('liq_set_messages', { liq_messages: 'b_liq_msg5' })
                  }
                >
                  Examine Message (80 to 100%)
                </Button>
              </Stack.Item>
            </Stack>
          </LabeledList.Item>
        </LabeledList>
      ) : (
        'These options only display while liquid examination settings are turned on.'
      )}
    </Section>
  );
};
