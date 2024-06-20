import { useBackend } from '../backend';
import {
  Box,
  Button,
  Dimmer,
  Flex,
  Icon,
  Knob,
  LabeledList,
  ProgressBar,
  Section,
  Tabs,
} from '../components';
import { Window } from '../layouts';
import { ComplexModal } from './common/ComplexModal';

const stats = [
  ['good', 'Alive'],
  ['average', 'Unconscious'],
  ['bad', 'DEAD'],
];

const operations = [
  ['ui', 'Modify U.I.', 'dna'],
  ['se', 'Modify S.E.', 'dna'],
  ['buffer', 'Transfer Buffers', 'syringe'],
  ['rejuvenators', 'Rejuvenators', 'flask'],
];

const rejuvenatorsDoses = [5, 10, 20, 30, 50];

export const DNAModifier = (props) => {
  const { act, data } = useBackend();
  const { irradiating, dnaBlockSize, occupant } = data;
  const isDNAInvalid =
    !occupant.isViableSubject ||
    !occupant.uniqueIdentity ||
    !occupant.structuralEnzymes;
  let radiatingModal;
  if (irradiating) {
    radiatingModal = <DNAModifierIrradiating duration={irradiating} />;
  }
  return (
    <Window width={660} height={870}>
      <ComplexModal />
      {radiatingModal}
      <Window.Content className="Layout__content--flexColumn">
        <DNAModifierOccupant isDNAInvalid={isDNAInvalid} />
        <DNAModifierMain isDNAInvalid={isDNAInvalid} />
      </Window.Content>
    </Window>
  );
};

const DNAModifierOccupant = (props) => {
  const { act, data } = useBackend();
  const { locked, hasOccupant, occupant } = data;
  return (
    <Section
      title="Occupant"
      buttons={
        <>
          <Box color="label" inline mr="0.5rem">
            Door Lock:
          </Box>
          <Button
            disabled={!hasOccupant}
            selected={locked}
            icon={locked ? 'toggle-on' : 'toggle-off'}
            onClick={() => act('toggleLock')}
          >
            {locked ? 'Engaged' : 'Disengaged'}
          </Button>
          <Button
            disabled={!hasOccupant || locked}
            icon="user-slash"
            onClick={() => act('ejectOccupant')}
          >
            Eject
          </Button>
        </>
      }
    >
      {hasOccupant ? (
        <>
          <Box>
            <LabeledList>
              <LabeledList.Item label="Name">{occupant.name}</LabeledList.Item>
              <LabeledList.Item label="Health">
                <ProgressBar
                  min={occupant.minHealth}
                  max={occupant.maxHealth}
                  value={occupant.health / occupant.maxHealth}
                  ranges={{
                    good: [0.5, Infinity],
                    average: [0, 0.5],
                    bad: [-Infinity, 0],
                  }}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Status" color={stats[occupant.stat][0]}>
                {stats[occupant.stat][1]}
              </LabeledList.Item>
              <LabeledList.Divider />
            </LabeledList>
          </Box>
          {props.isDNAInvalid ? (
            <Box color="bad">
              <Icon name="exclamation-circle" />
              &nbsp; The occupant&apos;s DNA structure is ruined beyond
              recognition, please insert a subject with an intact DNA structure.
            </Box>
          ) : (
            <LabeledList>
              <LabeledList.Item label="Radiation">
                <ProgressBar
                  min="0"
                  max="100"
                  value={occupant.radiationLevel / 100}
                  color="average"
                />
              </LabeledList.Item>
              <LabeledList.Item label="Unique Enzymes">
                {data.occupant.uniqueEnzymes ? (
                  data.occupant.uniqueEnzymes
                ) : (
                  <Box color="bad">
                    <Icon name="exclamation-circle" />
                    &nbsp; Unknown
                  </Box>
                )}
              </LabeledList.Item>
            </LabeledList>
          )}
        </>
      ) : (
        <Box color="label">Cell unoccupied.</Box>
      )}
    </Section>
  );
};

const DNAModifierMain = (props) => {
  const { act, data } = useBackend();
  const { selectedMenuKey, hasOccupant, occupant } = data;
  if (!hasOccupant) {
    return (
      <Section flexGrow="1">
        <Flex height="100%">
          <Flex.Item grow="1" align="center" textAlign="center" color="label">
            <Icon name="user-slash" mb="0.5rem" size="5" />
            <br />
            No occupant in DNA modifier.
          </Flex.Item>
        </Flex>
      </Section>
    );
  } else if (props.isDNAInvalid) {
    return (
      <Section flexGrow="1">
        <Flex height="100%">
          <Flex.Item grow="1" align="center" textAlign="center" color="label">
            <Icon name="user-slash" mb="0.5rem" size="5" />
            <br />
            No operation possible on this subject.
          </Flex.Item>
        </Flex>
      </Section>
    );
  }
  let body;
  if (selectedMenuKey === 'ui') {
    body = (
      <>
        <DNAModifierMainUI />
        <DNAModifierMainRadiationEmitter />
      </>
    );
  } else if (selectedMenuKey === 'se') {
    body = (
      <>
        <DNAModifierMainSE />
        <DNAModifierMainRadiationEmitter />
      </>
    );
  } else if (selectedMenuKey === 'buffer') {
    body = <DNAModifierMainBuffers />;
  } else if (selectedMenuKey === 'rejuvenators') {
    body = <DNAModifierMainRejuvenators />;
  }
  return (
    <Section flexGrow="1">
      <Tabs>
        {operations.map((op, i) => (
          <Tabs.Tab
            key={i}
            selected={selectedMenuKey === op[0]}
            onClick={() => act('selectMenuKey', { key: op[0] })}
          >
            <Icon name={op[2]} />
            {op[1]}
          </Tabs.Tab>
        ))}
      </Tabs>
      {body}
    </Section>
  );
};

const DNAModifierMainUI = (props) => {
  const { act, data } = useBackend();
  const {
    selectedUIBlock,
    selectedUISubBlock,
    selectedUITarget,
    dnaBlockSize,
    occupant,
  } = data;
  return (
    <Section title="Modify Unique Identifier" level="2">
      <DNAModifierBlocks
        dnaString={occupant.uniqueIdentity}
        selectedBlock={selectedUIBlock}
        selectedSubblock={selectedUISubBlock}
        blockSize={dnaBlockSize}
        action="selectUIBlock"
      />
      <LabeledList>
        <LabeledList.Item label="Target">
          <Knob
            minValue="1"
            maxValue="15"
            stepPixelSize="20"
            value={selectedUITarget}
            format={(value) => value.toString(16).toUpperCase()}
            ml="0"
            onChange={(e, val) => act('changeUITarget', { value: val })}
          />
        </LabeledList.Item>
      </LabeledList>
      <Button
        icon="radiation"
        mt="0.5rem"
        onClick={() => act('pulseUIRadiation')}
      >
        Irradiate Block
      </Button>
    </Section>
  );
};

const DNAModifierMainSE = (props) => {
  const { act, data } = useBackend();
  const { selectedSEBlock, selectedSESubBlock, dnaBlockSize, occupant } = data;
  return (
    <Section title="Modify Structural Enzymes" level="2">
      <DNAModifierBlocks
        dnaString={occupant.structuralEnzymes}
        selectedBlock={selectedSEBlock}
        selectedSubblock={selectedSESubBlock}
        blockSize={dnaBlockSize}
        action="selectSEBlock"
      />
      <Button icon="radiation" onClick={() => act('pulseSERadiation')}>
        Irradiate Block
      </Button>
    </Section>
  );
};

const DNAModifierMainRadiationEmitter = (props) => {
  const { act, data } = useBackend();
  const { radiationIntensity, radiationDuration } = data;
  return (
    <Section title="Radiation Emitter" level="2">
      <LabeledList>
        <LabeledList.Item label="Intensity">
          <Knob
            minValue="1"
            maxValue="10"
            stepPixelSize="20"
            value={radiationIntensity}
            popUpPosition="right"
            ml="0"
            onChange={(e, val) => act('radiationIntensity', { value: val })}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Duration">
          <Knob
            minValue="1"
            maxValue="20"
            stepPixelSize="10"
            unit="s"
            value={radiationDuration}
            popUpPosition="right"
            ml="0"
            onChange={(e, val) => act('radiationDuration', { value: val })}
          />
        </LabeledList.Item>
      </LabeledList>
      <Button
        icon="radiation"
        tooltip="Mutates a random block of either the occupant's UI or SE."
        tooltipPosition="top"
        mt="0.5rem"
        onClick={() => act('pulseRadiation')}
      >
        Pulse Radiation
      </Button>
    </Section>
  );
};

const DNAModifierMainBuffers = (props) => {
  const { act, data } = useBackend();
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
      <Section title="Buffers" level="2">
        {bufferElements}
      </Section>
      <DNAModifierMainBuffersDisk />
    </>
  );
};

const DNAModifierMainBuffersElement = (props) => {
  const { act, data } = useBackend();
  const { id, name, buffer } = props;
  const isInjectorReady = data.isInjectorReady;
  const realName = name + (buffer.data ? ' - ' + buffer.label : '');
  return (
    <Box backgroundColor="rgba(0, 0, 0, 0.33)" mb="0.5rem">
      <Section
        title={realName}
        level="3"
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
  const { act, data } = useBackend();
  const { hasDisk, disk } = data;
  return (
    <Section
      title="Data Disk"
      level="2"
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
          <Icon name="save-o" size="4" />
          <br />
          No disk inserted.
        </Box>
      )}
    </Section>
  );
};

const DNAModifierMainRejuvenators = (props) => {
  const { act, data } = useBackend();
  const { isBeakerLoaded, beakerVolume, beakerLabel } = data;
  return (
    <Section
      title="Rejuvenators and Beaker"
      level="2"
      buttons={
        <Button
          disabled={!isBeakerLoaded}
          icon="eject"
          onClick={() => act('ejectBeaker')}
        >
          Eject
        </Button>
      }
    >
      {isBeakerLoaded ? (
        <LabeledList>
          <LabeledList.Item label="Inject">
            {rejuvenatorsDoses.map((a, i) => (
              <Button
                key={i}
                disabled={a > beakerVolume}
                icon="syringe"
                onClick={() =>
                  act('injectRejuvenators', {
                    amount: a,
                  })
                }
              >
                {a}
              </Button>
            ))}
            <Button
              disabled={beakerVolume <= 0}
              icon="syringe"
              onClick={() =>
                act('injectRejuvenators', {
                  amount: beakerVolume,
                })
              }
            >
              All
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Beaker">
            <Box mb="0.5rem">{beakerLabel ? beakerLabel : 'No label'}</Box>
            {beakerVolume ? (
              <Box color="good">
                {beakerVolume} unit{beakerVolume === 1 ? '' : 's'} remaining
              </Box>
            ) : (
              <Box color="bad">Empty</Box>
            )}
          </LabeledList.Item>
        </LabeledList>
      ) : (
        <Box color="label" textAlign="center" my="25%">
          <Icon name="exclamation-triangle" size="4" />
          <br />
          No beaker loaded.
        </Box>
      )}
    </Section>
  );
};

const DNAModifierIrradiating = (props) => {
  return (
    <Dimmer textAlign="center">
      <Icon name="spinner" size="5" spin />
      <br />
      <Box color="average">
        <h1>
          <Icon name="radiation" />
          &nbsp;Irradiating occupant&nbsp;
          <Icon name="radiation" />
        </h1>
      </Box>
      <Box color="label">
        <h3>
          For {props.duration} second{props.duration === 1 ? '' : 's'}
        </h3>
      </Box>
    </Dimmer>
  );
};

const DNAModifierBlocks = (props) => {
  const { act, data } = useBackend();
  const { dnaString, selectedBlock, selectedSubblock, blockSize, action } =
    props;

  const characters = dnaString.split('');
  let curBlock = 0;
  let dnaBlocks = [];
  for (let block = 0; block < characters.length; block += blockSize) {
    const realBlock = block / blockSize + 1;
    let subBlocks = [];
    for (let subblock = 0; subblock < blockSize; subblock++) {
      const realSubblock = subblock + 1;
      subBlocks.push(
        <Button
          selected={
            selectedBlock === realBlock && selectedSubblock === realSubblock
          }
          mb="0"
          onClick={() =>
            act(action, {
              block: realBlock,
              subblock: realSubblock,
            })
          }
        >
          {characters[block + subblock]}
        </Button>,
      );
    }
    dnaBlocks.push(
      <Flex.Item flex="0 0 16%" mb="1rem">
        <Box
          display="inline-block"
          width="20px"
          height="20px"
          mr="0.5rem"
          lineHeight="20px"
          backgroundColor="rgba(0, 0, 0, 0.33)"
          fontFamily="monospace"
          textAlign="center"
        >
          {realBlock}
        </Box>
        {subBlocks}
      </Flex.Item>,
    );
  }
  return <Flex wrap="wrap">{dnaBlocks}</Flex>;
};
