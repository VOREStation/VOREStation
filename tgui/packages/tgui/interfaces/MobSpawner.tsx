import { BooleanLike } from '../../common/react';
import { useBackend, useLocalState } from '../backend';
import { Button, Divider, Flex, Input, Knob, LabeledList, NumberInput, Section, Tabs, TextArea } from '../components';
import { Window } from '../layouts';

type Data = {
  path: string;

  default_path_name: string;
  default_desc: string;
  default_flavor_text: string;

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

  const [tabIndex, setTabIndex] = useLocalState('panelTabIndex', 0);

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

const GeneralMobSettings = (props) => {
  const { act, data } = useBackend<Data>();

  const [amount, setAmount] = useLocalState('amount', 1);
  const [name, setName] = useLocalState('name', data.default_path_name);
  const [ai_type] = useLocalState('aiType', data.ai_type);
  const [use_custom_ai] = useLocalState('toggleCustomAi', data.use_custom_ai);
  const [faction] = useLocalState('setMobFaction', data.faction);
  const [intent] = useLocalState('setIntent', data.intent);
  const [maxHealth, setMaxHealth] = useLocalState('maxHealth', data.max_health);
  const [health, setHealth] = useLocalState('health', data.health);
  const [meleeDamageLower, setMeleeDamageLower] = useLocalState(
    'meleeDamageLower',
    data.melee_damage_lower
  );
  const [meleeDamageUpper, setMeleeDamageUpper] = useLocalState(
    'meleeDamageUpper',
    data.melee_damage_upper
  );
  const [desc, setDesc] = useLocalState('desc', data.default_desc);
  const [flavorText, setFlavorText] = useLocalState(
    'flavorText',
    data.default_flavor_text
  );

  const [sizeMultiplier, setSizeMultiplier] = useLocalState(
    'sizeMultiplier',
    100
  );

  const [x, setX] = useLocalState('x', data.initial_x);
  const [y, setY] = useLocalState('y', data.initial_y);
  const [z, setZ] = useLocalState('z', data.initial_z);

  const [radius, setRadius] = useLocalState('radius', 0);

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
            <Button
              fluid
              content={data.path || 'Select Path'}
              onClick={(val) => act('select_path')}
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
      <Section title="General Settings">
        <Flex horizontal>
          <Flex.Item FlexGrow>
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
          </Flex.Item>
          <Flex.Item>
            <Divider vertical />
          </Flex.Item>
          <Flex.Item FlexGrow>
            <Section
              title="AI settings"
              buttons={
                <Button
                  selected={use_custom_ai}
                  fill
                  content="Use Custom AI"
                  onClick={() => act('toggle_custom_ai')}
                />
              }>
              <LabeledList>
                <LabeledList.Item>
                  <Button
                    fluid
                    content={ai_type || 'Choose AI Type'}
                    onClick={(val) => act('set_ai_path')}
                  />
                </LabeledList.Item>
                <LabeledList.Item>
                  <Button
                    fluid
                    content={faction || 'Set Faction'}
                    onClick={(val) => act('set_faction')}
                  />
                </LabeledList.Item>
                <LabeledList.Item>
                  <Button
                    fluid
                    content={intent || 'Set Intent'}
                    onClick={(val) => act('set_intent')}
                  />
                </LabeledList.Item>
              </LabeledList>
            </Section>
            <Section title="Health & Damage">
              <LabeledList>
                {(maxHealth && (
                  <>
                    <LabeledList.Item label="Max Health">
                      <NumberInput
                        value={maxHealth}
                        onChange={(e, val) => setMaxHealth(val)}
                      />
                    </LabeledList.Item>
                    <LabeledList.Item label="Health">
                      <NumberInput
                        value={health}
                        onChange={(e, val) => setHealth(val)}
                      />
                    </LabeledList.Item>
                    <br />
                  </>
                )) ||
                  "Note: Only available for '/mob/living'"}
                {(meleeDamageLower && (
                  <>
                    <LabeledList.Item label="Melee Damage (Lower)">
                      <NumberInput
                        value={meleeDamageLower}
                        onChange={(e, val) => setMeleeDamageLower(val)}
                      />
                    </LabeledList.Item>
                    <LabeledList.Item label="Melee Damage (Upper)">
                      <NumberInput
                        value={meleeDamageUpper}
                        onChange={(e, val) => setMeleeDamageUpper(val)}
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
            name: name || data.default_path_name,
            desc: desc || data.default_desc,
            max_health: maxHealth || data.max_health,
            health: health || data.health,
            melee_damage_lower: meleeDamageLower || data.melee_damage_lower,
            melee_damage_upper: meleeDamageUpper || data.melee_damage_upper,
            flavor_text: flavorText || data.default_flavor_text,
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
