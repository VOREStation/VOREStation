import { BooleanLike } from '../../common/react';
import { useBackend, useLocalState } from '../backend';
import { Button, Dropdown, Flex, Input, Knob, LabeledList, NumberInput, Section, Tabs, TextArea } from '../components';
import { Window } from '../layouts';

type Data = {
  path: string;

  default_path_name: string;
  default_desc: string;
  default_flavor_text: string;

  default_speak_emotes: string[];

  mob_paths: string[];

  loc_lock: BooleanLike;
  loc_x: number;
  loc_y: number;
  loc_z: number;

  initial_x: number;
  initial_y: number;
  initial_z: number;
};

export const MobSpawner = (props, context) => {
  const { act, data } = useBackend<Data>(context);

  const [tabIndex, setTabIndex] = useLocalState(context, 'panelTabIndex', 0);

  const tabs: any = [];

  tabs[0] = <GeneralMobSettings />;
  tabs[1] = <VoreMobSettings />;

  return (
    <Window width={890} height={660} theme="abstract" resizable>
      <Window.Content scrollable>
        <Tabs>
          <Tabs.Tab selected={tabIndex === 0} onClick={() => setTabIndex(0)}>
            General Settings
          </Tabs.Tab>
          <Tabs.Tab selected={tabIndex === 1} onClick={() => setTabIndex(1)}>
            Vore Settings [WIP]
          </Tabs.Tab>
        </Tabs>
        {tabs[tabIndex] || 'Error'}
      </Window.Content>
    </Window>
  );
};

const GeneralMobSettings = (props, context) => {
  const { act, data } = useBackend<Data>(context);

  const [amount, setAmount] = useLocalState(context, 'amount', 1);
  const [name, setName] = useLocalState(
    context,
    'name',
    data.default_path_name
  );
  const [desc, setDesc] = useLocalState(context, 'desc', data.default_desc);
  const [flavorText, setFlavorText] = useLocalState(
    context,
    'flavorText',
    data.default_flavor_text
  );

  const [sizeMultiplier, setSizeMultiplier] = useLocalState(
    context,
    'sizeMultiplier',
    100
  );

  const [x, setX] = useLocalState(context, 'x', data.initial_x);
  const [y, setY] = useLocalState(context, 'y', data.initial_y);
  const [z, setZ] = useLocalState(context, 'z', data.initial_z);

  const [radius, setRadius] = useLocalState(context, 'radius', 0);

  return (
    <>
      <Section title="General">
        <LabeledList>
          <LabeledList.Item label="Mob Name">
            <Input
              fluid
              value={name || data.default_path_name}
              onChange={(e, val) => setName(val)}
            />
          </LabeledList.Item>
          <LabeledList.Item label="Mob Path">
            <Dropdown
              fluid
              options={data.mob_paths}
              displayText={data.path || 'No path selected yet.'}
              onSelected={(val) => act('select_path', { path: val })}
            />
          </LabeledList.Item>
          <LabeledList.Item label="Spawn Amount">
            <NumberInput
              value={amount}
              minValue={0}
              maxValue={256}
              onChange={(e, val) => setAmount(val)}
            />
          </LabeledList.Item>
          <LabeledList.Item label={'Size (' + sizeMultiplier + '%)'}>
            <Knob
              value={sizeMultiplier}
              minValue={50}
              maxValue={200}
              unit="%"
              onChange={(e, val) => setSizeMultiplier(val)}
            />
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section title="Positional Settings">
        <LabeledList>
          <LabeledList.Item label="Spawn (X/Y/Z) Coords">
            <NumberInput
              value={data.loc_lock ? data.loc_x : x}
              minValue={0}
              maxValue={256}
              onChange={(e, val) => setX(val)}
            />
            <NumberInput
              value={data.loc_lock ? data.loc_y : y}
              minValue={0}
              maxValue={256}
              onChange={(e, val) => setY(val)}
            />
            <NumberInput
              value={data.loc_lock ? data.loc_z : z}
              minValue={0}
              maxValue={256}
              onChange={(e, val) => setZ(val)}
            />
            <Button.Checkbox
              content="Lock coords to self"
              checked={data.loc_lock}
              onClick={() => act('loc_lock')}
            />
          </LabeledList.Item>
          <LabeledList.Item label="Spawn Radius (WIP)">
            <NumberInput
              value={radius}
              disabled
              minValue={0}
              maxValue={256}
              onChange={(e, val) => setRadius(val)}
            />
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section title="Descriptions">
        <Flex>
          <Flex.Item width="50%">
            Description:
            <br />
            <TextArea
              height={'18rem'}
              onChange={(e, val) => setDesc(val)}
              value={desc || data.default_desc}
            />
          </Flex.Item>
          <Flex.Item width="50%">
            Flavor Text:
            <br />
            <TextArea
              height={'18rem'}
              value={flavorText || data.default_flavor_text}
              onChange={(e, val) => setFlavorText(val)}
            />
          </Flex.Item>
        </Flex>
      </Section>
      <Button
        color="teal"
        onCLick={() =>
          act('start_spawn', {
            amount: amount,
            name: name,
            desc: desc,
            flavor_text: flavorText,
            size_multiplier: sizeMultiplier * 0.01,
            x: data.loc_lock ? data.loc_x : x,
            y: data.loc_lock ? data.loc_y : y,
            z: data.loc_lock ? data.loc_z : z,
            radius: radius,
          })
        }>
        Spawn
      </Button>
    </>
  );
};

const VoreMobSettings = (props, context) => {
  const { act, data } = useBackend<Data>(context);

  return (
    <Section title="WIP">
      This Tab is still under construction!
      <br />
      Functionality will be added in later updates.
    </Section>
  );
};
