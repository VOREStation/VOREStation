import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Icon,
  LabeledList,
  Section,
  Stack,
} from 'tgui-core/components';

import type { buffData, Data } from './types';

export const DNAModifierMainBuffers = (props) => {
  const { data } = useBackend<Data>();

  const { buffers } = data;

  const bufferElements = buffers.map((buffer, i) => (
    <Stack.Item key={i}>
      <DNAModifierMainBuffersElement
        id={i + 1}
        name={'Buffer ' + (i + 1)}
        buffer={buffer}
      />
    </Stack.Item>
  ));
  return (
    <Stack vertical fill>
      <Stack.Item grow>
        <Section fill scrollable title="Buffers">
          <Stack vertical fill>
            {bufferElements}
          </Stack>
        </Section>
      </Stack.Item>
      <Stack.Item minHeight="150px">
        <DNAModifierMainBuffersDisk />
      </Stack.Item>
    </Stack>
  );
};

const DNAModifierMainBuffersElement = (props: {
  id: number;
  name: string;
  buffer: buffData;
}) => {
  const { act, data } = useBackend<Data>();
  const { id, name, buffer } = props;
  const { isInjectorReady, hasOccupant, occupant } = data;
  const realName: string = name + (buffer.data ? ' - ' + buffer.label : '');
  return (
    <Section
      fill
      title={realName}
      mx="0"
      lineHeight="18px"
      buttons={
        <>
          <Button.Confirm
            disabled={!buffer.data || !buffer.owner}
            icon="trash"
            onClick={() =>
              act('bufferOption', {
                option: 'clear',
                id: id,
              })
            }
          >
            Clear
          </Button.Confirm>
          <Button
            disabled={!buffer.data || !buffer.owner}
            icon="pen"
            onClick={() =>
              act('bufferOption', {
                option: 'changeLabel',
                id: id,
              })
            }
          >
            Rename
          </Button>
          <Button
            disabled={!buffer.data || !buffer.owner}
            icon="user-plus"
            tooltip="Grow a clone from the buffer's data."
            tooltipPosition="bottom-end"
            onClick={() =>
              act('bufferOption', {
                option: 'sleeveDisk',
                id: id,
              })
            }
          >
            Grow Body
          </Button>
          <Button
            disabled={!buffer.data || !data.hasDisk || !buffer.owner}
            icon="save"
            tooltip="Exports this buffer to the currently loaded data disk."
            tooltipPosition="bottom-end"
            onClick={() =>
              act('bufferOption', {
                option: 'saveDisk',
                id: id,
              })
            }
          >
            Export
          </Button>
        </>
      }
    >
      <Box backgroundColor="rgba(0, 0, 0, 0.33)" mb="0.5rem">
        <LabeledList>
          <LabeledList.Item label="Write">
            <Button
              disabled={!hasOccupant || !occupant.isViableSubject}
              icon="arrow-circle-down"
              mb="0"
              onClick={() =>
                act('bufferOption', {
                  option: 'saveDNA',
                  id: id,
                })
              }
            >
              From Subject
            </Button>
            <Button
              disabled={!data.hasDisk || !data.disk.data}
              icon="arrow-circle-down"
              mb="0"
              onClick={() =>
                act('bufferOption', {
                  option: 'loadDisk',
                  id: id,
                })
              }
            >
              From Disk
            </Button>
          </LabeledList.Item>
          {!!buffer.data && (
            <>
              <LabeledList.Item label="Subject">
                {buffer.owner || <Box color="average">Unknown</Box>}
              </LabeledList.Item>
              <LabeledList.Item label="Data Type">
                {buffer.type === 'ui'
                  ? 'Unique Identifiers'
                  : 'Structural Enzymes'}
                {!!buffer.ue && ' and Unique Enzymes'}
              </LabeledList.Item>
              <LabeledList.Item label="Transfer to">
                <Button
                  disabled={!isInjectorReady || !buffer.owner}
                  icon={isInjectorReady ? 'syringe' : 'spinner'}
                  iconSpin={!isInjectorReady}
                  mb="0"
                  onClick={() =>
                    act('bufferOption', {
                      option: 'createInjector',
                      id: id,
                    })
                  }
                >
                  Injector
                </Button>
                <Button
                  disabled={!isInjectorReady || !buffer.owner}
                  icon={isInjectorReady ? 'syringe' : 'spinner'}
                  iconSpin={!isInjectorReady}
                  mb="0"
                  onClick={() =>
                    act('bufferOption', {
                      option: 'createInjector',
                      id: id,
                      block: 1,
                    })
                  }
                >
                  Block Injector
                </Button>
                <Button
                  disabled={
                    !hasOccupant || !buffer.owner || !occupant.isViableSubject
                  }
                  icon="user"
                  mb="0"
                  onClick={() =>
                    act('bufferOption', {
                      option: 'transfer',
                      id: id,
                    })
                  }
                >
                  Subject
                </Button>
              </LabeledList.Item>
            </>
          )}
        </LabeledList>
        {!buffer.data && (
          <Box color="label" mt="0.5rem">
            This buffer is empty.
          </Box>
        )}
      </Box>
    </Section>
  );
};

const DNAModifierMainBuffersDisk = (props) => {
  const { act, data } = useBackend<Data>();
  const { hasDisk, disk } = data;
  return (
    <Section
      fill
      title="Data Disk"
      buttons={
        <>
          <Button.Confirm
            disabled={!hasDisk || !disk.data}
            icon="trash"
            onClick={() => act('wipeDisk')}
          >
            Wipe
          </Button.Confirm>
          <Button
            disabled={!hasDisk}
            icon="eject"
            onClick={() => act('ejectDisk')}
          >
            Eject
          </Button>
        </>
      }
    >
      {hasDisk ? (
        disk.data ? (
          <LabeledList>
            <LabeledList.Item label="Label">
              {disk.label ? disk.label : 'No label'}
            </LabeledList.Item>
            <LabeledList.Item label="Subject">
              {disk.owner ? disk.owner : <Box color="average">Unknown</Box>}
            </LabeledList.Item>
            <LabeledList.Item label="Data Type">
              {disk.type === 'ui' ? 'Unique Identifiers' : 'Structural Enzymes'}
              {!!disk.ue && ' and Unique Enzymes'}
            </LabeledList.Item>
          </LabeledList>
        ) : (
          <Box color="label">Disk is blank.</Box>
        )
      ) : (
        <Box color="label" textAlign="center" my="1rem">
          <Icon name="save-o" size={4} />
          <br />
          No disk inserted.
        </Box>
      )}
    </Section>
  );
};
