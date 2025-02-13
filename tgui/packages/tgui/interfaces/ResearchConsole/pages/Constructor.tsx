import { Fragment, useState } from 'react';
import { useBackend, useSharedState } from 'tgui/backend';
import {
  Box,
  Button,
  Divider,
  Input,
  LabeledList,
  NumberInput,
  ProgressBar,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';
import { capitalizeAll } from 'tgui-core/string';

import { PaginationChevrons } from '..';
import {
  ConstructorDesign,
  ConstructorEnum,
  constructorEnumToBuild,
  constructorEnumToBuildFive,
  constructorEnumToData,
  constructorEnumToEjectAction,
  constructorEnumToEjectReagentAction,
  constructorEnumToEjectReagentAllAction,
  constructorEnumToName,
  constructorEnumToRemoveQueue,
  Data,
  LinkedConstructor,
} from '../data';

enum ConstructorTabEnum {
  Build = 0,
  Queue = 1,
  MatStorage = 2,
  ChemStorage = 3,
}

export const Constructor = (props: {
  type: ConstructorEnum;
  designs: ConstructorDesign[];
  linked_data: LinkedConstructor | null;
}) => {
  const { type, designs, linked_data } = props;
  const our_name = constructorEnumToName[type];

  if (!linked_data) {
    return <Section title={`ERROR: Cannot Find ${our_name}`} fill />;
  }

  return (
    <ConstructorPage type={type} designs={designs} linked_data={linked_data} />
  );
};

const ConstructorPage = (props: {
  type: ConstructorEnum;
  designs: ConstructorDesign[];
  linked_data: LinkedConstructor;
}) => {
  const { act, data } = useBackend<Data>();
  const { type, designs, linked_data } = props;
  const our_name = constructorEnumToName[type];

  let queueColor = 'transparent';
  let queueSpin = false;
  let queueIcon = 'layer-group';

  if (linked_data.busy) {
    queueIcon = 'hammer';
    queueColor = 'average';
    queueSpin = true;
  } else if (linked_data.queue?.length) {
    queueIcon = 'sync';
    queueColor = 'green';
    queueSpin = true;
  }

  const [tab, setTab] = useSharedState<ConstructorTabEnum>(
    `${our_name}-tab`,
    ConstructorTabEnum.Build,
  );

  let tabElement;

  switch (tab) {
    case ConstructorTabEnum.Build: {
      tabElement = <BuildTab type={type} linked_data={linked_data} />;
      break;
    }
    case ConstructorTabEnum.Queue: {
      tabElement = <QueueTab type={type} linked_data={linked_data} />;
      break;
    }
    case ConstructorTabEnum.MatStorage: {
      tabElement = <MatStorageTab type={type} linked_data={linked_data} />;
      break;
    }
    case ConstructorTabEnum.ChemStorage: {
      tabElement = <ChemStorageTab type={type} linked_data={linked_data} />;
      break;
    }
  }

  return (
    <Section title={our_name} fill>
      <MaterialBars linked_data={linked_data} />
      <Tabs>
        <Tabs.Tab
          selected={tab === ConstructorTabEnum.Build}
          onClick={() => setTab(ConstructorTabEnum.Build)}
          icon="wrench"
        >
          Build
        </Tabs.Tab>
        <Tabs.Tab
          selected={tab === ConstructorTabEnum.Queue}
          onClick={() => setTab(ConstructorTabEnum.Queue)}
          color={queueColor}
          icon={queueIcon}
          iconSpin={queueSpin}
        >
          Queue
        </Tabs.Tab>
        <Tabs.Tab
          selected={tab === ConstructorTabEnum.MatStorage}
          onClick={() => setTab(ConstructorTabEnum.MatStorage)}
          icon="cookie"
        >
          Mat Storage
        </Tabs.Tab>
        <Tabs.Tab
          selected={tab === ConstructorTabEnum.ChemStorage}
          onClick={() => setTab(ConstructorTabEnum.ChemStorage)}
          icon="flask"
        >
          Chem Storage
        </Tabs.Tab>
      </Tabs>
      {tabElement}
    </Section>
  );
};

const MaterialBars = (props: { linked_data: LinkedConstructor }) => {
  const { linked_data } = props;
  return (
    <LabeledList>
      <LabeledList.Item label="Materials">
        <ProgressBar
          value={linked_data.total_materials}
          maxValue={linked_data.max_materials}
        >
          {linked_data.total_materials} cm&sup3; / {linked_data.max_materials}{' '}
          cm&sup3;
        </ProgressBar>
      </LabeledList.Item>
      <LabeledList.Item label="Chemicals">
        <ProgressBar
          value={linked_data.total_volume}
          maxValue={linked_data.max_volume}
        >
          {linked_data.total_volume}u / {linked_data.max_volume}u
        </ProgressBar>
      </LabeledList.Item>
    </LabeledList>
  );
};

const BuildTab = (props: {
  type: ConstructorEnum;
  linked_data: LinkedConstructor;
}) => {
  const { act, data } = useBackend<Data>();
  const { type, linked_data } = props;

  const designs: ConstructorDesign[] = data[constructorEnumToData[type]];

  const buildAct = constructorEnumToBuild[type];
  const buildActFive = constructorEnumToBuildFive[type];

  return (
    <Section
      title={`Designs (Page ${data.builder_page + 1})`}
      fill
      height="85%"
      buttons={<PaginationChevrons target="builder_page" />}
      scrollable
    >
      <Input
        fluid
        updateOnPropsChange
        placeholder="Search for..."
        value={data.search}
        onInput={(e, v: string) => act('search', { search: v })}
        mb={1}
      />
      {designs?.length ? (
        designs.map((design) => (
          <Fragment key={design.id}>
            <Stack justify="space-between" align="center">
              <Stack.Item grow>{design.name}</Stack.Item>
              <Stack.Item>
                <Box inline color="label">
                  {design.mat_list.join(' ')}
                </Box>
                <Box inline color="average" ml={1}>
                  {design.chem_list.join(' ')}
                </Box>
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon="wrench"
                  onClick={() =>
                    act(buildAct, { build: design.id, imprint: design.id })
                  }
                >
                  Build
                </Button>
                {!!buildActFive && (
                  <Button
                    icon="wrench"
                    onClick={() =>
                      act(buildActFive, {
                        build: design.id,
                        imprint: design.id,
                      })
                    }
                  >
                    5
                  </Button>
                )}
              </Stack.Item>
            </Stack>
            <Divider />
          </Fragment>
        ))
      ) : (
        <Box>
          No items could be found matching the parameters (page or search).
        </Box>
      )}
    </Section>
  );
};

const QueueTab = (props: {
  type: ConstructorEnum;
  linked_data: LinkedConstructor;
}) => {
  const { act, data } = useBackend<Data>();
  const { type, linked_data } = props;

  const removeQueueAction = constructorEnumToRemoveQueue[type];

  return (
    <LabeledList>
      {linked_data.queue.length ? (
        linked_data.queue.map((item) => (
          <LabeledList.Item
            label={item.name}
            key={item.index}
            labelColor={item.index === 1 ? 'bad' : ''}
          >
            {item.index === 1 && !linked_data.busy ? (
              <Box>(Awaiting Materials)</Box>
            ) : null}
            <Button
              icon="trash"
              disabled={item.index === 1 && linked_data.busy}
              onClick={() =>
                act(removeQueueAction, {
                  [removeQueueAction]: item.index,
                })
              }
            >
              Remove
            </Button>
          </LabeledList.Item>
        ))
      ) : (
        <Box m={1}>Queue Empty.</Box>
      )}
    </LabeledList>
  );
};

const NEVER_HIDE_MATERIALS = [
  'steel',
  'glass',
  'plastic',
  'gold',
  'silver',
  'osmium',
  'lead',
  'phoron',
  'uranium',
  'diamond',
  'titanium',
];

const MatStorageTab = (props: {
  type: ConstructorEnum;
  linked_data: LinkedConstructor;
}) => {
  const { act, data } = useBackend<Data>();
  const { type, linked_data } = props;

  const ejectAction = constructorEnumToEjectAction[type];

  const [matEjectStates, setMatEjectStates] = useState<Record<string, number>>(
    {},
  );

  return (
    <LabeledList>
      {Object.entries(linked_data.materials).map(([mat, amount]) => {
        if (amount === 0 && !NEVER_HIDE_MATERIALS.includes(mat)) {
          return;
        }
        return (
          <LabeledList.Item
            key={mat}
            label={capitalizeAll(mat)}
            buttons={
              <>
                <NumberInput
                  value={matEjectStates[mat] || 0}
                  minValue={0}
                  maxValue={Math.floor(amount / data.sheet_material_amount)}
                  step={1}
                  width="100px"
                  onDrag={(val) => {
                    setMatEjectStates({
                      ...matEjectStates,
                      [mat]: val,
                    });
                  }}
                />
                <Button
                  icon="eject"
                  disabled={amount < data.sheet_material_amount}
                  onClick={() => {
                    setMatEjectStates({
                      ...matEjectStates,
                      [mat]: 0,
                    });
                    act(ejectAction, {
                      [ejectAction]: mat,
                      amount: matEjectStates[mat] || 0,
                    });
                  }}
                >
                  Num
                </Button>
                <Button
                  icon="eject"
                  disabled={amount < data.sheet_material_amount}
                  onClick={() => {
                    setMatEjectStates({
                      ...matEjectStates,
                      [mat]: 0,
                    });
                    act(ejectAction, { [ejectAction]: mat, amount: 50 });
                  }}
                >
                  All
                </Button>
              </>
            }
          >
            {amount} cm&sup3;
          </LabeledList.Item>
        );
      })}
    </LabeledList>
  );
};

const ChemStorageTab = (props: {
  type: ConstructorEnum;
  linked_data: LinkedConstructor;
}) => {
  const { act, data } = useBackend<Data>();
  const { type, linked_data } = props;

  const ejectChemAction = constructorEnumToEjectReagentAction[type];
  const ejectAllChemAction = constructorEnumToEjectReagentAllAction[type];

  return (
    <Box>
      <LabeledList>
        {linked_data.reagents?.length ? (
          linked_data.reagents.map((chem) => (
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
          ))
        ) : (
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
        Dispose of All Chemicals In Storage
      </Button.Confirm>
    </Box>
  );
};
