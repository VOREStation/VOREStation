import { useBackend } from 'tgui/backend';
import { Box, Button, LabeledList, Section } from 'tgui-core/components';

import type { modalMindData as ActiveMindRecordData } from './types';

export const MindRecordModal = (props: { data: ActiveMindRecordData }) => {
  const { act } = useBackend();
  const {
    activerecord,
    realname,
    obviously_dead,
    oocnotes,
    can_sleeve_active,
  } = props.data;
  return (
    <Section
      backgroundColor="#252525"
      m={2}
      title={'Mind Record (' + realname + ')'}
      buttons={
        <Button icon="times" color="red" onClick={() => act('clear_m_rec')} />
      }
    >
      <LabeledList>
        <LabeledList.Item label="Name">{realname}</LabeledList.Item>
        <LabeledList.Item label="Status">{obviously_dead}</LabeledList.Item>
        <LabeledList.Item label="Actions">
          <Button
            disabled={!can_sleeve_active}
            icon="user-plus"
            onClick={() =>
              act('sleeve', {
                ref: activerecord,
                mode: 1,
              })
            }
          >
            Sleeve
          </Button>
          <Button
            icon="user-plus"
            onClick={() =>
              act('sleeve', {
                ref: activerecord,
                mode: 2,
              })
            }
          >
            Card
          </Button>
        </LabeledList.Item>
        <LabeledList.Item label="OOC Notes" verticalAlign="top">
          <Box height={10} mt={1} ml={1} mr={1}>
            <Section
              style={{ wordBreak: 'break-word', borderRadius: '5px' }}
              scrollable
              fill
              backgroundColor="black"
              preserveWhitespace
            >
              {oocnotes}
            </Section>
          </Box>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
