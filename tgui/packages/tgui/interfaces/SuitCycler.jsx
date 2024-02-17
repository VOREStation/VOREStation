import { useBackend } from '../backend';
import {
  Box,
  Button,
  Dropdown,
  LabeledList,
  NoticeBox,
  NumberInput,
  Section,
} from '../components';
import { Window } from '../layouts';

export const SuitCycler = (props) => {
  const { act, data } = useBackend();
  const { active, locked, uv_active } = data;

  let subTemplate = <SuitCyclerContent />;

  if (uv_active) {
    subTemplate = <SuitCyclerUV />;
  } else if (locked) {
    subTemplate = <SuitCyclerLocked />;
  } else if (active) {
    subTemplate = <SuitCyclerActive />;
  }

  return (
    <Window width={320} height={400}>
      <Window.Content>{subTemplate}</Window.Content>
    </Window>
  );
};

const SuitCyclerContent = (props) => {
  const { act, data } = useBackend();
  const {
    safeties,
    occupied,
    suit,
    helmet,
    departments,
    species,
    uv_level,
    max_uv_level,
    can_repair,
    damage,
  } = data;

  return (
    <>
      <Section
        title="Storage"
        buttons={
          <Button icon="lock" content="Lock" onClick={() => act('lock')} />
        }
      >
        {!!(occupied && safeties) && (
          <NoticeBox>
            Biological entity detected in suit chamber. Please remove before
            continuing with operation.
            <Button
              fluid
              icon="eject"
              color="red"
              content="Eject Entity"
              onClick={() => act('eject_guy')}
            />
          </NoticeBox>
        )}
        <LabeledList>
          <LabeledList.Item label="Helmet">
            <Button
              icon={helmet ? 'square' : 'square-o'}
              content={helmet || 'Empty'}
              disabled={!helmet}
              onClick={() =>
                act('dispense', {
                  item: 'helmet',
                })
              }
            />
          </LabeledList.Item>
          <LabeledList.Item label="Suit">
            <Button
              icon={suit ? 'square' : 'square-o'}
              content={suit || 'Empty'}
              disabled={!suit}
              onClick={() =>
                act('dispense', {
                  item: 'suit',
                })
              }
            />
          </LabeledList.Item>
          {can_repair && damage ? (
            <LabeledList.Item label="Suit Damage">
              {damage}
              <Button
                icon="wrench"
                content="Repair"
                onClick={() => act('repair_suit')}
              />
            </LabeledList.Item>
          ) : null}
        </LabeledList>
      </Section>
      <Section title="Customization">
        <LabeledList>
          <LabeledList.Item label="Target Paintjob">
            <Dropdown
              noscroll
              width="150px"
              options={departments}
              selected={departments[0]}
              onSelected={(val) => act('department', { department: val })}
            />
          </LabeledList.Item>
          <LabeledList.Item label="Target Species">
            <Dropdown
              width="150px"
              maxHeight="160px"
              options={species}
              selected={species[0]}
              onSelected={(val) => act('species', { species: val })}
            />
          </LabeledList.Item>
        </LabeledList>
        <Button
          mt={1}
          fluid
          content="Customize"
          onClick={() => act('apply_paintjob')}
        />
      </Section>
      <Section title="UV Decontamination">
        <LabeledList>
          <LabeledList.Item label="Radiation Level">
            <NumberInput
              width="50px"
              value={uv_level}
              minValue={1}
              maxValue={max_uv_level}
              stepPixelSize={30}
              onChange={(e, val) => act('radlevel', { radlevel: val })}
            />
          </LabeledList.Item>
          <LabeledList.Item label="Decontaminate">
            <Button
              fluid
              icon="recycle"
              disabled={occupied && safeties}
              textAlign="center"
              onClick={() => act('uv')}
            />
          </LabeledList.Item>
        </LabeledList>
      </Section>
    </>
  );
};

const SuitCyclerUV = (props) => {
  return (
    <NoticeBox>
      Contents are currently being decontaminated. Please wait.
    </NoticeBox>
  );
};

const SuitCyclerLocked = (props) => {
  const { act, data } = useBackend();

  const { model_text, userHasAccess } = data;

  return (
    <Section title="Locked" textAlign="center">
      <Box color="bad" bold>
        The {model_text} suit cycler is currently locked. Please contact your
        system administrator.
      </Box>
      <Box>
        <Button
          icon="unlock"
          content="[Unlock]"
          disabled={!userHasAccess}
          onClick={() => act('lock')}
        />
      </Box>
    </Section>
  );
};

const SuitCyclerActive = (props) => {
  return (
    <NoticeBox>Contents are currently being painted. Please wait.</NoticeBox>
  );
};
