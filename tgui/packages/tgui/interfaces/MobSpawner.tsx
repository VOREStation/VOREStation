import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Button,
  Divider,
  Input,
  Knob,
  LabeledList,
  NumberInput,
  Section,
  Stack,
  Tabs,
  TextArea,
} from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

type Data = {
  path: string;

  path_name: string;
  desc: string;
  flavor_text: string;

  use_custom_ai: BooleanLike;
  ai_type: string;
  faction: string;
  intent: string;

  max_health: number;
  health: number;
  melee_damage_lower: number;
  melee_damage_upper: number;

  default_speak_emotes: string[];

  loc_lock: BooleanLike;
  loc_x: number;
  loc_y: number;
  loc_z: number;

  initial_x: number;
  initial_y: number;
  initial_z: number;
};

export const MobSpawner = (props) => {
  const { data } = useBackend<Data>();

  const [tabIndex, setTabIndex] = useState<number>(0);
  const [radius, setRadius] = useState<number>(0);
  const [forceUpdate, renderData] = useState<any>();
  const [x, setX] = useState<number>(data.initial_x);
  const [y, setY] = useState<number>(data.initial_y);
  const [z, setZ] = useState<number>(data.initial_z);
  const [sizeMultiplier, setSizeMultiplier] = useState<number>(100);
  const [amount, setAmount] = useState<number>(1);

  function handleHealth(value: number) {
    data.health = value;
    renderData(value);
  }

  function handleMaxHealth(value: number) {
    data.max_health = value;
    renderData(value);
  }

  function handleMeleeDamageLower(value: number) {
    data.melee_damage_lower = value;
    renderData(value);
  }

  function handleMeleeDamageupper(value: number) {
    data.melee_damage_upper = value;
    renderData(value);
  }

  function handleName(value: string) {
    data.path_name = value;
    renderData(value);
  }

  function handleDesc(value: string) {
    data.desc = value;
    renderData(value);
  }

  function handleFlavor(value: string) {
    data.flavor_text = value;
    renderData(value);
  }

  function handleRadius(value: number) {
    setRadius(value);
  }

  function handleX(value: number) {
    setX(value);
  }

  function handleY(value: number) {
    setY(value);
  }

  function handleZ(value: number) {
    setZ(value);
  }

  function handleSizeMultiplier(value: number) {
    setSizeMultiplier(value);
  }

  function handleAmount(value: number) {
    setAmount(value);
  }

  const tabs: React.JSX.Element[] = [];

  tabs[0] = (
    <GeneralMobSettings
      radius={radius}
      x={x}
      y={y}
      z={z}
      sizeMultiplier={sizeMultiplier}
      amount={amount}
      onRadius={handleRadius}
      onHealth={handleHealth}
      onMaxHealth={handleMaxHealth}
      onMeleeDamageLower={handleMeleeDamageLower}
      onMeleeDamageUpper={handleMeleeDamageupper}
      onName={handleName}
      onDesc={handleDesc}
      onFlavor={handleFlavor}
      onX={handleX}
      onY={handleY}
      onZ={handleZ}
      onSizeMultiplier={handleSizeMultiplier}
      onAmount={handleAmount}
    />
  );
  tabs[1] = <VoreMobSettings />;

  return (
    <Window width={890} height={880} theme="abstract">
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

const GeneralMobSettings = (props: {
  radius: number;
  x: number;
  y: number;
  z: number;
  sizeMultiplier: number;
  amount: number;
  onRadius: Function;
  onHealth: Function;
  onMaxHealth: Function;
  onMeleeDamageLower: Function;
  onMeleeDamageUpper: Function;
  onName: Function;
  onDesc: Function;
  onFlavor: Function;
  onX: Function;
  onY: Function;
  onZ: Function;
  onSizeMultiplier: Function;
  onAmount: Function;
}) => {
  const { act, data } = useBackend<Data>();
  return (
    <>
      <Section title="General">
        <LabeledList>
          <LabeledList.Item label="Mob Name">
            <Input
              fluid
              value={data.path_name}
              onChange={(e, val: string) => props.onName(val)}
            />
          </LabeledList.Item>
          <LabeledList.Item label="Mob Path">
            <Button fluid onClick={(val) => act('select_path')}>
              {data.path || 'Select Path'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Spawn Amount">
            <NumberInput
              step={1}
              value={props.amount}
              minValue={0}
              maxValue={256}
              onChange={(val: number) => props.onAmount(val)}
            />
          </LabeledList.Item>
          <LabeledList.Item label={'Size (' + props.sizeMultiplier + '%)'}>
            <Knob
              value={props.sizeMultiplier}
              minValue={50}
              maxValue={200}
              unit="%"
              onChange={(e, val: number) => props.onSizeMultiplier(val)}
            />
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section title="General Settings">
        <Stack>
          <Stack.Item grow>
            <Section title="Positional Settings">
              <LabeledList>
                <LabeledList.Item label="Spawn (X/Y/Z) Coords">
                  <NumberInput
                    step={1}
                    value={data.loc_lock ? data.loc_x : props.x}
                    minValue={0}
                    maxValue={256}
                    onChange={(val: number) => props.onX(val)}
                  />
                  <NumberInput
                    step={1}
                    value={data.loc_lock ? data.loc_y : props.y}
                    minValue={0}
                    maxValue={256}
                    onChange={(val: number) => props.onY(val)}
                  />
                  <NumberInput
                    step={1}
                    value={data.loc_lock ? data.loc_z : props.z}
                    minValue={0}
                    maxValue={256}
                    onChange={(val: number) => props.onZ(val)}
                  />
                  <Button.Checkbox
                    checked={data.loc_lock}
                    onClick={() => act('loc_lock')}
                  >
                    Lock coords to self
                  </Button.Checkbox>
                </LabeledList.Item>
                <LabeledList.Item label="Spawn Radius (WIP)">
                  <NumberInput
                    step={1}
                    value={props.radius}
                    disabled
                    minValue={0}
                    maxValue={256}
                    onChange={(val: number) => props.onRadius(val)}
                  />
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Divider vertical />
          </Stack.Item>
          <Stack.Item grow>
            <Section
              title="AI settings"
              buttons={
                <Button
                  selected={data.use_custom_ai}
                  onClick={() => act('toggle_custom_ai')}
                >
                  Use Custom AI
                </Button>
              }
            >
              <LabeledList>
                <LabeledList.Item>
                  <Button fluid onClick={(val) => act('set_ai_path')}>
                    {data.ai_type || 'Choose AI Type'}
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item>
                  <Button fluid onClick={(val) => act('set_faction')}>
                    {data.faction || 'Set Faction'}
                  </Button>
                </LabeledList.Item>
                <LabeledList.Item>
                  <Button fluid onClick={(val) => act('set_intent')}>
                    {data.intent || 'Set Intent'}
                  </Button>
                </LabeledList.Item>
              </LabeledList>
            </Section>
            <Section title="Health & Damage">
              <LabeledList>
                {(data.max_health && (
                  <>
                    <LabeledList.Item label="Max Health">
                      <NumberInput
                        step={1}
                        minValue={-Infinity}
                        maxValue={+Infinity}
                        value={data.max_health}
                        onChange={(val: number) => props.onMaxHealth(val)}
                      />
                    </LabeledList.Item>
                    <LabeledList.Item label="Health">
                      <NumberInput
                        step={1}
                        minValue={-Infinity}
                        maxValue={+Infinity}
                        value={data.health}
                        onChange={(val: number) => props.onHealth(val)}
                      />
                    </LabeledList.Item>
                    <br />
                  </>
                )) ||
                  "Note: Only available for '/mob/living'"}
                {(data.melee_damage_lower && (
                  <>
                    <LabeledList.Item label="Melee Damage (Lower)">
                      <NumberInput
                        step={1}
                        minValue={-Infinity}
                        maxValue={+Infinity}
                        value={data.melee_damage_lower}
                        onChange={(val: number) =>
                          props.onMeleeDamageLower(val)
                        }
                      />
                    </LabeledList.Item>
                    <LabeledList.Item label="Melee Damage (Upper)">
                      <NumberInput
                        step={1}
                        minValue={-Infinity}
                        maxValue={+Infinity}
                        value={data.melee_damage_upper}
                        onChange={(val: number) =>
                          props.onMeleeDamageUpper(val)
                        }
                      />
                    </LabeledList.Item>
                  </>
                )) ||
                  "Note: Only available for '/mob/living/simple_mob'"}
              </LabeledList>
            </Section>
          </Stack.Item>
        </Stack>
      </Section>
      <Section title="Descriptions">
        <Stack>
          <Stack.Item width="50%">
            Description:
            <br />
            <TextArea
              height={'18rem'}
              onChange={(e, val: string) => props.onDesc(val)}
              value={data.desc}
            />
          </Stack.Item>
          <Stack.Item width="50%">
            Flavor Text:
            <br />
            <TextArea
              height={'18rem'}
              value={data.flavor_text}
              onChange={(e, val: string) => props.onFlavor(val)}
            />
          </Stack.Item>
        </Stack>
      </Section>
      <Button
        color="teal"
        onClick={() =>
          act('start_spawn', {
            amount: props.amount,
            name: data.path_name,
            desc: data.desc,
            max_health: data.max_health,
            health: data.health,
            melee_damage_lower: data.melee_damage_lower,
            melee_damage_upper: data.melee_damage_upper,
            flavor_text: data.flavor_text,
            size_multiplier: props.sizeMultiplier * 0.01,
            x: data.loc_lock ? data.loc_x : props.x,
            y: data.loc_lock ? data.loc_y : props.y,
            z: data.loc_lock ? data.loc_z : props.z,
            radius: props.radius,
          })
        }
      >
        Spawn
      </Button>
    </>
  );
};

const VoreMobSettings = (props) => {
  return (
    <Section title="WIP">
      This Tab is still under construction!
      <br />
      Functionality will be added in later updates.
    </Section>
  );
};
