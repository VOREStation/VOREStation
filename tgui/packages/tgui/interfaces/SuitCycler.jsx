import { useState } from 'react';

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
  const { active, locked, uv_active, species, departments } = data;

  const [selectedDepartment, setSelectedDepartment] = useState(
    (!!departments && departments[0]) || null,
  );

  const [selectedSpecies, setSelectedSpecies] = useState(
    (!!species && species[0]) || null,
  );

  function handleSelectedDepartment(value) {
    setSelectedDepartment(value);
  }

  function handleSelectedSpecies(value) {
    setSelectedSpecies(value);
  }

  let subTemplate = (
    <SuitCyclerContent
      selectedDepartment={selectedDepartment}
      selectedSpecies={selectedSpecies}
      onSelectedDepartment={handleSelectedDepartment}
      onSelectedSpecies={handleSelectedSpecies}
    />
  );

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
          <Button icon="lock" onClick={() => act('lock')}>
            Lock
          </Button>
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
              onClick={() => act('eject_guy')}
            >
              Eject Entity
            </Button>
          </NoticeBox>
        )}
        <LabeledList>
          <LabeledList.Item label="Helmet">
            <Button
              icon={helmet ? 'square' : 'square-o'}
              disabled={!helmet}
              onClick={() =>
                act('dispense', {
                  item: 'helmet',
                })
              }
            >
              {helmet || 'Empty'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Suit">
            <Button
              icon={suit ? 'square' : 'square-o'}
              disabled={!suit}
              onClick={() =>
                act('dispense', {
                  item: 'suit',
                })
              }
            >
              {suit || 'Empty'}
            </Button>
          </LabeledList.Item>
          {can_repair && damage ? (
            <LabeledList.Item label="Suit Damage">
              {damage}
              <Button icon="wrench" onClick={() => act('repair_suit')}>
                Repair
              </Button>
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
              selected={props.selectedDepartment}
              onSelected={(val) => {
                props.onSelectedDepartment(val);
                act('department', { department: val });
              }}
            />
          </LabeledList.Item>
          <LabeledList.Item label="Target Species">
            <Dropdown
              width="150px"
              maxHeight="160px"
              options={species}
              selected={props.selectedSpecies}
              onSelected={(val) => {
                props.onSelectedSpecies(val);
                act('species', { species: val });
              }}
            />
          </LabeledList.Item>
        </LabeledList>
        <Button mt={1} fluid onClick={() => act('apply_paintjob')}>
          Customize
        </Button>
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
          disabled={!userHasAccess}
          onClick={() => act('lock')}
        >
          [Unlock]
        </Button>
      </Box>
    </Section>
  );
};

const SuitCyclerActive = (props) => {
  return (
    <NoticeBox>Contents are currently being painted. Please wait.</NoticeBox>
  );
};
