import { Box, Button, LabeledList, Section } from 'tgui-core/components';

import { useBackend } from '../../backend';
import type { ActiveBodyRecordData } from './types';

export const BodyRecordModal = (props: { data: ActiveBodyRecordData }) => {
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
  } = props.data;
  return (
    <Section
      backgroundColor="#252525"
      m={2}
      title={'Body Record (' + realname + ')'}
      buttons={
        <Button icon="times" color="red" onClick={() => act('clear_b_rec')} />
      }
    >
      <LabeledList>
        <LabeledList.Item label="Name">{realname}</LabeledList.Item>
        <LabeledList.Item label="Species">{species}</LabeledList.Item>
        <LabeledList.Item label="Bio. Sex">
          <Box style={{ textTransform: 'capitalize' }}>{sex}</Box>
        </LabeledList.Item>
        <LabeledList.Item label="Mind Compat">{mind_compat}</LabeledList.Item>
        <LabeledList.Item label="Synthetic">
          {synthetic ? 'Yes' : 'No'}
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
          {/* Traitgenes create a dna injector based off the BR currently selected, to allow normal doctors to reset someone's SEs */}
          {!synthetic ? (
            <Button
              icon="syringe"
              onClick={() =>
                act('genereset', {
                  ref: activerecord,
                })
              }
            >
              DNA Reset Injector
            </Button>
          ) : (
            ''
          )}
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
