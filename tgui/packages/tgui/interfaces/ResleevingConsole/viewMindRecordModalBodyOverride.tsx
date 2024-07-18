import { useBackend } from '../../backend';
import { Button, LabeledList, Section } from '../../components';
import { modalMindData } from './types';

export const viewMindRecordModalBodyOverride = (modal: modalMindData) => {
  const { act } = useBackend();
  const {
    activerecord,
    realname,
    obviously_dead,
    oocnotes,
    can_sleeve_active,
  } = modal.args;
  return (
    <Section
      m="-1rem"
      pb="1rem"
      title={'Mind Record (' + realname + ')'}
      buttons={
        <Button icon="times" color="red" onClick={() => act('modal_close')} />
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
        <LabeledList.Item label="OOC Notes">
          <Section
            style={{ wordBreak: 'break-all', height: '100px' }}
            scrollable
          >
            {oocnotes}
          </Section>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
