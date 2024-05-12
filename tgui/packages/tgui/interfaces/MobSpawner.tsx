import { useState } from 'react';

import { BooleanLike } from '../../common/react';
import { useBackend } from '../backend';
import {
  Button,
  Divider,
  Flex,
  Input,
  Knob,
  LabeledList,
  NumberInput,
  Section,
  Tabs,
  TextArea,
} from '../components';
import { Window } from '../layouts';

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
  const { act, data } = useBackend<Data>();

  const [tabIndex, setTabIndex] = useState(0);
  const [radius, setRadius] = useState(0);
  const [forceUpdate, renderData] = useState();
  const [x, setX] = useState(data.initial_x);
  const [y, setY] = useState(data.initial_y);
  const [z, setZ] = useState(data.initial_z);
  const [sizeMultiplier, setSizeMultiplier] = useState(100);
  const [amount, setAmount] = useState(1);

  function handleHealth(value) {
    data.health = value;
    renderData(value);
  }

  function handleMaxHealth(value) {
    data.max_health = value;
    renderData(value);
  }

  function handleMeleeDamageLower(value) {
    data.melee_damage_lower = value;
    renderData(value);
  }

  function handleMeleeDamageupper(value) {
    data.melee_damage_upper = value;
    renderData(value);
  }

  function handleName(value) {
    data.path_name = value;
    renderData(value);
  }

  function handleDesc(value) {
    data.desc = value;
    renderData(value);
  }

  function handleFlavor(value) {
    data.flavor_text = value;
    renderData(value);
  }

  function handleRadius(value) {
    setRadius(value);
  }

  function handleX(value) {
    setX(value);
  }

  function handleY(value) {
    setY(value);
  }

  function handleZ(value) {
    setZ(value);
  }

  function handleSizeMultiplier(value) {
    setSizeMultiplier(value);
  }

  function handleAmount(value) {
    setAmount(value);
  }

  const tabs: any = [];

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
      onMeleeDamageupper={handleMeleeDamageupper}
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

const GeneralMobSettings = (props) => {
  const { act, data } = useBackend<Data>();
  return (
    <>
      <Section title="General">
        <LabeledList>
          <LabeledList.Item label="Mob Name">
            <Input
              fluid
              value={data.path_name}
              onChange={(e, val) => props.onName(val)}
            />
          </LabeledList.Item>
          <LabeledList.Item label="Mob Path">
            <Button fluid onClick={(val) => act('select_path')}>
              {data.path || 'Select Path'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Spawn Amount">
            <NumberInput
              value={props.amount}
              minValue={0}
              maxValue={256}
              onChange={(e, val) => props.onAmount(val)}
            />
          </LabeledList.Item>
          <LabeledList.Item label={'Size (' + props.sizeMultiplier + '%)'}>
            <Knob
              value={props.sizeMultiplier}
              minValue={50}
              maxValue={200}
              unit="%"
              onChange={(e, val) => props.onSizeMultiplier(val)}
            />
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section title="General Settings">
        <Flex horizontal>
          <Flex.Item FlexGrow>
            <Section title="Positional Settings">
              <LabeledList>
                <LabeledList.Item label="Spawn (X/Y/Z) Coords">
                  <NumberInput
                    value={data.loc_lock ? data.loc_x : props.x}
                    minValue={0}
                    maxValue={256}
                    onChange={(e, val) => props.onX(val)}
                  />
                  <NumberInput
                    value={data.loc_lock ? data.loc_y : props.y}
                    minValue={0}
                    maxValue={256}
                    onChange={(e, val) => props.onY(val)}
                  />
                  <NumberInput
                    value={data.loc_lock ? data.loc_z : props.z}
                    minValue={0}
                    maxValue={256}
                    onChange={(e, val) => props.onZ(val)}
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
                    value={props.radius}
                    disabled
                    minValue={0}
                    maxValue={256}
                    onChange={(e, val) => props.onRadius(val)}
                  />
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Flex.Item>
          <Flex.Item>
            <Divider vertical />
          </Flex.Item>
          <Flex.Item FlexGrow>
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
                        value={data.max_health}
                        onChange={(e, val) => props.onMaxHealth(val)}
                      />
                    </LabeledList.Item>
                    <LabeledList.Item label="Health">
                      <NumberInput
                        value={data.health}
                        onChange={(e, val) => props.onHealth(val)}
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
                        value={data.melee_damage_lower}
                        onChange={(e, val) => props.onMeleeDamageLower(val)}
                      />
                    </LabeledList.Item>
                    <LabeledList.Item label="Melee Damage (Upper)">
                      <NumberInput
                        value={data.melee_damage_upper}
                        onChange={(e, val) => props.onMeleeDamageUpper(val)}
                      />
                    </LabeledList.Item>
                  </>
                )) ||
                  "Note: Only available for '/mob/living/simple_mob'"}
              </LabeledList>
            </Section>
          </Flex.Item>
        </Flex>
      </Section>
      <Section title="Descriptions">
        <Flex>
          <Flex.Item width="50%">
            Description:
            <br />
            <TextArea
              height={'18rem'}
              onChange={(e, val) => props.onDesc(val)}
              value={data.desc}
            />
          </Flex.Item>
          <Flex.Item width="50%">
            Flavor Text:
            <br />
            <TextArea
              height={'18rem'}
              value={data.flavor_text}
              onChange={(e, val) => props.onFlavor(val)}
            />
          </Flex.Item>
        </Flex>
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
  const { act, data } = useBackend<Data>();

  return (
    <Section title="WIP">
      This Tab is still under construction!
      <br />
      Functionality will be added in later updates.
    </Section>
  );
};
