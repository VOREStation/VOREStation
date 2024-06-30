import { useBackend } from '../../backend';
import { Box, Button, Icon, LabeledList, Section } from '../../components';
import { buffData, Data } from './types';

export const DNAModifierMainBuffers = (props) => {
  const { data } = useBackend<Data>();

  const { buffers } = data;

  let bufferElements = buffers.map((buffer, i) => (
    <DNAModifierMainBuffersElement
      key={i}
      id={i + 1}
      name={'Buffer ' + (i + 1)}
      buffer={buffer}
    />
  ));
  return (
    <>
      <Section title="Buffers">{bufferElements}</Section>
      <DNAModifierMainBuffersDisk />
    </>
  );
};

const DNAModifierMainBuffersElement = (props: {
  id: number;
  name: string;
  buffer: buffData;
}) => {
  const { act, data } = useBackend<Data>();
  const { id, name, buffer } = props;
  const { isInjectorReady } = data;
  const realName: string = name + (buffer.data ? ' - ' + buffer.label : '');
  return (
    <Box backgroundColor="rgba(0, 0, 0, 0.33)" mb="0.5rem">
      <Section
        title={realName}
        mx="0"
        lineHeight="18px"
        buttons={
          <>
            <Button.Confirm
              disabled={!buffer.data}
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
              disabled={!buffer.data}
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
              disabled={!buffer.data || !data.hasDisk}
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
        <LabeledList>
          <LabeledList.Item label="Write">
            <Button
              icon="arrow-circle-down"
              mb="0"
              onClick={() =>
                act('bufferOption', {
                  option: 'saveUI',
                  id: id,
                })
              }
            >
              Subject U.I
            </Button>
            <Button
              icon="arrow-circle-down"
              mb="0"
              onClick={() =>
                act('bufferOption', {
                  option: 'saveUIAndUE',
                  id: id,
                })
              }
            >
              Subject U.I and U.E.
            </Button>
            <Button
              icon="arrow-circle-down"
              mb="0"
              onClick={() =>
                act('bufferOption', {
                  option: 'saveSE',
                  id: id,
                })
              }
            >
              Subject S.E.
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
                  disabled={!isInjectorReady}
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
                  disabled={!isInjectorReady}
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
      </Section>
    </Box>
  );
};

const DNAModifierMainBuffersDisk = (props) => {
  const { act, data } = useBackend<Data>();
  const { hasDisk, disk } = data;
  return (
    <Section
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
