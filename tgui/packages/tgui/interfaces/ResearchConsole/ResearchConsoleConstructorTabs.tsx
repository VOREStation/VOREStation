import { BooleanLike } from 'common/react';
import { toTitleCase } from 'common/string';

import { useBackend } from '../../backend';
import { Box, Button, LabeledList, NumberInput } from '../../components';
import { ResearchConsoleBuildMenu } from './ResearchConsoleBuildMenu';
import { Data, design, mat, modularDevice, reagent } from './types';

export const ResearchConsoleConstructorMenue = (props: {
  name: string;
  linked: modularDevice;
  designs: design[];
}) => {
  const { name, linked, designs } = props;

  return (
    <ResearchConsoleBuildMenu
      target={linked}
      designs={designs}
      buildName={name === 'Protolathe' ? 'build' : 'imprint'}
      buildFiveName={name === 'Protolathe' ? 'buildfive' : null}
    />
  );
};

export const ResearchConsoleConstructorQueue = (props: {
  name: string;
  busy: BooleanLike;
  queue: { name: string; index: number }[];
}) => {
  const { act } = useBackend<Data>();

  const { queue, name, busy } = props;

  const removeQueueAction: string =
    name === 'Protolathe' ? 'removeP' : 'removeI';
  return (
    <LabeledList>
      {(queue.length &&
        queue.map((item, index) => {
          if (item.index === 1) {
            return (
              <LabeledList.Item key={index} label={item.name} labelColor="bad">
                {!busy ? (
                  <Box>
                    (Awaiting Materials)
                    <Button
                      ml={1}
                      icon="trash"
                      onClick={() =>
                        act(removeQueueAction, {
                          [removeQueueAction]: item.index,
                        })
                      }
                    >
                      Remove
                    </Button>
                  </Box>
                ) : (
                  <Button disabled icon="trash">
                    Remove
                  </Button>
                )}
              </LabeledList.Item>
            );
          }
          return (
            <LabeledList.Item label={item.name} key={item.name}>
              <Button
                icon="trash"
                onClick={() =>
                  act(removeQueueAction, {
                    [removeQueueAction]: item.index,
                  })
                }
              >
                Remove
              </Button>
            </LabeledList.Item>
          );
        })) || <Box m={1}>Queue Empty.</Box>}
    </LabeledList>
  );
};

export const ResearchConsoleConstructorMats = (props: {
  name: string;
  mats: mat[];
  matsStates: mat[];
  onMatsState: Function;
}) => {
  const { act } = useBackend<Data>();

  const { name, mats } = props;

  const ejectSheetAction: string =
    name === 'Protolathe' ? 'lathe_ejectsheet' : 'imprinter_ejectsheet';

  return (
    <LabeledList>
      {mats.map((mat) => {
        return (
          <LabeledList.Item
            label={toTitleCase(mat.name)}
            key={mat.name}
            buttons={
              <>
                <NumberInput
                  step={1}
                  minValue={0}
                  width="100px"
                  value={props.matsStates[mat.name] || 0}
                  maxValue={mat.sheets}
                  onDrag={(val: number) =>
                    props.onMatsState({
                      ...props.matsStates,
                      [mat.name]: val,
                    })
                  }
                />
                <Button
                  icon="eject"
                  disabled={!mat.removable}
                  onClick={() => {
                    props.onMatsState({
                      ...props.matsStates,
                      [mat.name]: 0,
                    });
                    act(ejectSheetAction, {
                      [ejectSheetAction]: mat.name,
                      amount: props.matsStates[mat.name] || 0,
                    });
                  }}
                >
                  Num
                </Button>
                <Button
                  icon="eject"
                  disabled={!mat.removable}
                  onClick={() =>
                    act(ejectSheetAction, {
                      [ejectSheetAction]: mat.name,
                      amount: 50,
                    })
                  }
                >
                  All
                </Button>
              </>
            }
          >
            {mat.amount} cm&sup3;
          </LabeledList.Item>
        );
      })}
    </LabeledList>
  );
};

export const ResearchConsoleConstructorChems = (props: {
  name: string;
  reagents: reagent[];
}) => {
  const { act } = useBackend<Data>();

  const { name, reagents } = props;

  const ejectChemAction: string =
    name === 'Protolathe' ? 'disposeP' : 'disposeI';
  const ejectAllChemAction: string =
    name === 'Protolathe' ? 'disposeallP' : 'disposeallI';
  return (
    <Box>
      <LabeledList>
        {(reagents.length &&
          reagents.map((chem) => (
            <LabeledList.Item label={chem.name} key={chem.name}>
              {chem.volume}u
              <Button
                ml={1}
                icon="eject"
                onClick={() => act(ejectChemAction, { dispose: chem.id })}
              >
                Purge
              </Button>
            </LabeledList.Item>
          ))) || (
          <LabeledList.Item label="Empty">No chems detected</LabeledList.Item>
        )}
      </LabeledList>
      <Button.Confirm
        mt={1}
        icon="trash"
        confirmContent="Confirm Disposal Of All Chemicals?"
        confirmIcon="trash"
        onClick={() => act(ejectAllChemAction)}
      >
        Disposal All Chemicals In Storage
      </Button.Confirm>
    </Box>
  );
};
