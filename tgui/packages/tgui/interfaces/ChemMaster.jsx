import { classes } from '../.././common/react';
import { useBackend } from '../backend';
import { Box, Button, Flex, Icon, LabeledList, Section } from '../components';
import { Window } from '../layouts';
import { BeakerContents } from './common/BeakerContents';
import {
  ComplexModal,
  modalOpen,
  modalRegisterBodyOverride,
} from './common/ComplexModal';

const transferAmounts = [1, 5, 10, 30, 60];
const bottleStyles = [
  'bottle.png',
  'small_bottle.png',
  'wide_bottle.png',
  'round_bottle.png',
  'reagent_bottle.png',
];

const analyzeModalBodyOverride = (modal) => {
  const { act, data } = useBackend();
  const result = modal.args.analysis;
  return (
    <Section
      level={2}
      m="-1rem"
      pb="1rem"
      title={data.condi ? 'Condiment Analysis' : 'Reagent Analysis'}
    >
      <Box mx="0.5rem">
        <LabeledList>
          <LabeledList.Item label="Name">{result.name}</LabeledList.Item>
          <LabeledList.Item label="Description">
            {(result.desc || '').length > 0 ? result.desc : 'N/A'}
          </LabeledList.Item>
          {result.blood_type && (
            <>
              <LabeledList.Item label="Blood type">
                {result.blood_type}
              </LabeledList.Item>
              <LabeledList.Item
                label="Blood DNA"
                className="LabeledList__breakContents"
              >
                {result.blood_dna}
              </LabeledList.Item>
            </>
          )}
          {!data.condi && (
            <Button
              icon={data.printing ? 'spinner' : 'print'}
              disabled={data.printing}
              iconSpin={!!data.printing}
              ml="0.5rem"
              onClick={() =>
                act('print', {
                  idx: result.idx,
                  beaker: modal.args.beaker,
                })
              }
            >
              Print
            </Button>
          )}
        </LabeledList>
      </Box>
    </Section>
  );
};

export const ChemMaster = (props) => {
  const { data } = useBackend();
  const {
    condi,
    beaker,
    beaker_reagents = [],
    buffer_reagents = [],
    mode,
  } = data;
  return (
    <Window width={575} height={500}>
      <ComplexModal />
      <Window.Content scrollable className="Layout__content--flexColumn">
        <ChemMasterBeaker
          beaker={beaker}
          beakerReagents={beaker_reagents}
          bufferNonEmpty={buffer_reagents.length > 0}
        />
        <ChemMasterBuffer mode={mode} bufferReagents={buffer_reagents} />
        <ChemMasterProduction
          isCondiment={condi}
          bufferNonEmpty={buffer_reagents.length > 0}
        />
        {/* <ChemMasterCustomization /> */}
      </Window.Content>
    </Window>
  );
};

const ChemMasterBeaker = (props) => {
  const { act, data } = useBackend();
  const { beaker, beakerReagents, bufferNonEmpty } = props;

  let headerButton = bufferNonEmpty ? (
    <Button.Confirm
      icon="eject"
      disabled={!beaker}
      onClick={() => act('eject')}
    >
      Eject and Clear Buffer
    </Button.Confirm>
  ) : (
    <Button icon="eject" disabled={!beaker} onClick={() => act('eject')}>
      Eject and Clear Buffer
    </Button>
  );

  return (
    <Section title="Beaker" buttons={headerButton}>
      {beaker ? (
        <BeakerContents
          beakerLoaded
          beakerContents={beakerReagents}
          buttons={(chemical, i) => (
            <Box mb={i < beakerReagents.length - 1 && '2px'}>
              <Button
                mb="0"
                onClick={() =>
                  modalOpen('analyze', {
                    idx: i + 1,
                    beaker: 1,
                  })
                }
              >
                Analyze
              </Button>
              {transferAmounts.map((am, j) => (
                <Button
                  key={j}
                  mb="0"
                  onClick={() =>
                    act('add', {
                      id: chemical.id,
                      amount: am,
                    })
                  }
                >
                  {am}
                </Button>
              ))}
              <Button
                mb="0"
                onClick={() =>
                  act('add', {
                    id: chemical.id,
                    amount: chemical.volume,
                  })
                }
              >
                All
              </Button>
              <Button
                mb="0"
                onClick={() =>
                  modalOpen('addcustom', {
                    id: chemical.id,
                  })
                }
              >
                Custom..
              </Button>
            </Box>
          )}
        />
      ) : (
        <Box color="label">No beaker loaded.</Box>
      )}
    </Section>
  );
};

const ChemMasterBuffer = (props) => {
  const { act } = useBackend();
  const { mode, bufferReagents = [] } = props;
  return (
    <Section
      title="Buffer"
      buttons={
        <Box color="label">
          Transferring to&nbsp;
          <Button
            icon={mode ? 'flask' : 'trash'}
            color={!mode && 'bad'}
            onClick={() => act('toggle')}
          >
            {mode ? 'Beaker' : 'Disposal'}
          </Button>
        </Box>
      }
    >
      {bufferReagents.length > 0 ? (
        <BeakerContents
          beakerLoaded
          beakerContents={bufferReagents}
          buttons={(chemical, i) => (
            <Box mb={i < bufferReagents.length - 1 && '2px'}>
              <Button
                mb="0"
                onClick={() =>
                  modalOpen('analyze', {
                    idx: i + 1,
                    beaker: 0,
                  })
                }
              >
                Analyze
              </Button>
              {transferAmounts.map((am, i) => (
                <Button
                  key={i}
                  mb="0"
                  onClick={() =>
                    act('remove', {
                      id: chemical.id,
                      amount: am,
                    })
                  }
                >
                  {am}
                </Button>
              ))}
              <Button
                mb="0"
                onClick={() =>
                  act('remove', {
                    id: chemical.id,
                    amount: chemical.volume,
                  })
                }
              >
                All
              </Button>
              <Button
                mb="0"
                onClick={() =>
                  modalOpen('removecustom', {
                    id: chemical.id,
                  })
                }
              >
                Custom..
              </Button>
            </Box>
          )}
        />
      ) : (
        <Box color="label">Buffer is empty.</Box>
      )}
    </Section>
  );
};

const ChemMasterProduction = (props) => {
  const { act, data } = useBackend();
  if (!props.bufferNonEmpty) {
    return (
      <Section
        title="Production"
        flexGrow="1"
        buttons={
          <Button
            disabled={!data.loaded_pill_bottle}
            icon="eject"
            mb="0.5rem"
            onClick={() => act('ejectp')}
          >
            {data.loaded_pill_bottle
              ? data.loaded_pill_bottle_name +
                ' (' +
                data.loaded_pill_bottle_contents_len +
                '/' +
                data.loaded_pill_bottle_storage_slots +
                ')'
              : 'No pill bottle loaded'}
          </Button>
        }
      >
        <Flex height="100%">
          <Flex.Item grow="1" align="center" textAlign="center" color="label">
            <Icon name="tint-slash" mt="0.5rem" mb="0.5rem" size="5" />
            <br />
            Buffer is empty.
          </Flex.Item>
        </Flex>
      </Section>
    );
  }

  return (
    <Section
      title="Production"
      flexGrow="1"
      buttons={
        <Button
          disabled={!data.loaded_pill_bottle}
          icon="eject"
          mb="0.5rem"
          onClick={() => act('ejectp')}
        >
          {data.loaded_pill_bottle
            ? data.loaded_pill_bottle_name +
              ' (' +
              data.loaded_pill_bottle_contents_len +
              '/' +
              data.loaded_pill_bottle_storage_slots +
              ')'
            : 'No pill bottle loaded'}
        </Button>
      }
    >
      {!props.isCondiment ? (
        <ChemMasterProductionChemical />
      ) : (
        <ChemMasterProductionCondiment />
      )}
    </Section>
  );
};

const ChemMasterProductionChemical = (props) => {
  const { act, data } = useBackend();
  return (
    <LabeledList>
      <LabeledList.Item label="Pills">
        <Button
          icon="circle"
          mr="0.5rem"
          onClick={() => modalOpen('create_pill')}
        >
          One (60u max)
        </Button>
        <Button
          icon="plus-circle"
          mb="0.5rem"
          onClick={() => modalOpen('create_pill_multiple')}
        >
          Multiple
        </Button>
        <br />
        <Button onClick={() => modalOpen('change_pill_style')}>
          <div
            style={{
              display: 'inline-block',
              width: '16px',
              height: '16px',
              verticalAlign: 'middle',
              backgroundSize: '200%',
              backgroundPosition: 'left -10px bottom -6px',
            }}
          >
            <Box
              className={classes([
                'chem_master32x32',
                'pill' + data.pillsprite,
              ])}
              style={{
                bottom: '10px',
                right: '10px',
                position: 'relative',
              }}
            />
          </div>
          Style
        </Button>
      </LabeledList.Item>
      <LabeledList.Item label="Patches">
        <Button
          icon="square"
          mr="0.5rem"
          onClick={() => modalOpen('create_patch')}
        >
          One (60u max)
        </Button>
        <Button
          icon="plus-square"
          onClick={() => modalOpen('create_patch_multiple')}
        >
          Multiple
        </Button>
      </LabeledList.Item>
      <LabeledList.Item label="Bottle">
        <Button
          icon="wine-bottle"
          mr="0.5rem"
          mb="0.5rem"
          onClick={() => modalOpen('create_bottle')}
        >
          Create bottle (60u max)
        </Button>
        <Button
          icon="plus-square"
          onClick={() => modalOpen('create_bottle_multiple')}
        >
          Multiple
        </Button>
        <br />
        <Button mb="0.5rem" onClick={() => modalOpen('change_bottle_style')}>
          <div
            style={{
              display: 'inline-block',
              width: '16px',
              height: '16px',
              verticalAlign: 'middle',
              backgroundSize: '200%',
              backgroundPosition: 'left -10px bottom -6px',
            }}
          >
            <Box
              className={classes([
                'chem_master32x32',
                'bottle-' + data.bottlesprite,
              ])}
              style={{
                bottom: '10px',
                right: '10px',
                position: 'relative',
              }}
            />
          </div>
          Style
        </Button>
      </LabeledList.Item>
    </LabeledList>
  );
};

const ChemMasterProductionCondiment = (props) => {
  const { act } = useBackend();
  return (
    <>
      <Button
        icon="box"
        mb="0.5rem"
        onClick={() => modalOpen('create_condi_pack')}
      >
        Create condiment pack (10u max)
      </Button>
      <br />
      <Button
        icon="wine-bottle"
        mb="0"
        onClick={() => act('create_condi_bottle')}
      >
        Create bottle (60u max)
      </Button>
    </>
  );
};

// const ChemMasterCustomization = (props) => {
//   const { act, data } = useBackend();
//   if (!data.loaded_pill_bottle) {
//     return (
//       <Section title="Pill Bottle Customization">
//         <Box color="label">
//           None loaded.
//         </Box>
//       </Section>
//     );
//   }

//   return (
//     <Section title="Pill Bottle Customization">
//       <Button
//         disabled={!data.loaded_pill_bottle}
//         icon="eject"
//         mb="0.5rem"
//         onClick={() => act('ejectp')}
//        >
//        {data.loaded_pill_bottle
//         ? (
//           data.loaded_pill_bottle_name
//             + " ("
//             + data.loaded_pill_bottle_contents_len
//             + "/"
//             + data.loaded_pill_bottle_storage_slots
//             + ")"
//         )
//         : "None loaded"}
//       </Button>
//     </Section>
//   );
// };

modalRegisterBodyOverride('analyze', analyzeModalBodyOverride);
