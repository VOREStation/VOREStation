import { useBackend } from '../../backend';
import { Button, LabeledList, Section } from '../../components';
import { modalBBodyData } from './types';

export const viewBodyRecordModalBodyOverride = (modal: modalBBodyData) => {
  const { act } = useBackend();
  const {
    activerecord,
    realname,
    species,
    sex,
    mind_compat,
    synthetic,
    oocnotes,
    can_grow_active,
  } = modal.args;
  return (
    <Section
      m="-1rem"
      pb="1rem"
      title={'Body Record (' + realname + ')'}
      buttons={
        <Button icon="times" color="red" onClick={() => act('modal_close')} />
      }
    >
      <LabeledList>
        <LabeledList.Item label="Name">{realname}</LabeledList.Item>
        <LabeledList.Item label="Species">{species}</LabeledList.Item>
        <LabeledList.Item label="Bio. Sex">{sex}</LabeledList.Item>
        <LabeledList.Item label="Mind Compat">{mind_compat}</LabeledList.Item>
        <LabeledList.Item label="Synthetic">
          {synthetic ? 'Yes' : 'No'}
        </LabeledList.Item>
        <LabeledList.Item label="OOC Notes">
          <Section
            style={{ wordBreak: 'break-all', height: '100px' }}
            scrollable
          >
            {oocnotes}
          </Section>
        </LabeledList.Item>
        <LabeledList.Item label="Actions">
          <Button
            disabled={!can_grow_active}
            icon="user-plus"
            onClick={() =>
              act('create', {
                ref: activerecord,
              })
            }
          >
            {synthetic ? 'Build' : 'Grow'}
          </Button>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
