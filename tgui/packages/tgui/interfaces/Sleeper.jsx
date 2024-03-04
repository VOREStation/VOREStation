import { round } from 'common/math';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  Flex,
  Icon,
  LabeledList,
  ProgressBar,
  Section,
} from '../components';
import { Window } from '../layouts';

const stats = [
  ['good', 'Alive'],
  ['average', 'Unconscious'],
  ['bad', 'DEAD'],
];

const damages = [
  ['Resp', 'oxyLoss'],
  ['Toxin', 'toxLoss'],
  ['Brute', 'bruteLoss'],
  ['Burn', 'fireLoss'],
];

const damageRange = {
  average: [0.25, 0.5],
  bad: [0.5, Infinity],
};

const tempColors = [
  'bad',
  'average',
  'average',
  'good',
  'average',
  'average',
  'bad',
];

export const Sleeper = (props) => {
  const { act, data } = useBackend();
  const { hasOccupant } = data;
  const body = hasOccupant ? <SleeperMain /> : <SleeperEmpty />;
  return (
    <Window width={550} height={760}>
      <Window.Content className="Layout__content--flexColumn">
        {body}
      </Window.Content>
    </Window>
  );
};

const SleeperMain = (props) => {
  const { act, data } = useBackend();
  const { occupant, dialysis, stomachpumping } = data;
  return (
    <>
      <SleeperOccupant />
      <SleeperDamage />
      <SleeperDialysisPump
        title="Dialysis"
        active={dialysis}
        actToDo="togglefilter"
      />
      <SleeperDialysisPump
        title="Stomach Pump"
        active={stomachpumping}
        actToDo="togglepump"
      />
      <SleeperChemicals />
    </>
  );
};

const SleeperOccupant = (props) => {
  const { act, data } = useBackend();
  const { occupant, auto_eject_dead, stasis } = data;
  return (
    <Section
      title="Occupant"
      buttons={
        <>
          <Box color="label" inline>
            Auto-eject if dead:&nbsp;
          </Box>
          <Button
            icon={auto_eject_dead ? 'toggle-on' : 'toggle-off'}
            selected={auto_eject_dead}
            content={auto_eject_dead ? 'On' : 'Off'}
            onClick={() =>
              act('auto_eject_dead_' + (auto_eject_dead ? 'off' : 'on'))
            }
          />
          <Button
            icon="user-slash"
            content="Eject"
            onClick={() => act('ejectify')}
          />
          <Button content={stasis} onClick={() => act('changestasis')} />
        </>
      }
    >
      <LabeledList>
        <LabeledList.Item label="Name">{occupant.name}</LabeledList.Item>
        <LabeledList.Item label="Health">
          <ProgressBar
            min={0}
            max={occupant.maxHealth}
            value={occupant.health / occupant.maxHealth}
            ranges={{
              good: [0.5, Infinity],
              average: [0, 0.5],
              bad: [-Infinity, 0],
            }}
          >
            {round(occupant.health, 0)}
          </ProgressBar>
        </LabeledList.Item>
        <LabeledList.Item label="Status" color={stats[occupant.stat][0]}>
          {stats[occupant.stat][1]}
        </LabeledList.Item>
        <LabeledList.Item label="Temperature">
          <ProgressBar
            min="0"
            max={occupant.maxTemp}
            value={occupant.bodyTemperature / occupant.maxTemp}
            color={tempColors[occupant.temperatureSuitability + 3]}
          >
            {round(occupant.btCelsius, 0)}&deg;C,
            {round(occupant.btFaren, 0)}&deg;F
          </ProgressBar>
        </LabeledList.Item>
        {!!occupant.hasBlood && (
          <>
            <LabeledList.Item label="Blood Level">
              <ProgressBar
                min="0"
                max={occupant.bloodMax}
                value={occupant.bloodLevel / occupant.bloodMax}
                ranges={{
                  bad: [-Infinity, 0.6],
                  average: [0.6, 0.9],
                  good: [0.6, Infinity],
                }}
              >
                {occupant.bloodPercent}%, {occupant.bloodLevel}cl
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="Pulse" verticalAlign="middle">
              {occupant.pulse} BPM
            </LabeledList.Item>
          </>
        )}
      </LabeledList>
    </Section>
  );
};

const SleeperDamage = (props) => {
  const { data } = useBackend();
  const { occupant } = data;
  return (
    <Section title="Damage">
      <LabeledList>
        {damages.map((d, i) => (
          <LabeledList.Item key={i} label={d[0]}>
            <ProgressBar
              key={i}
              min="0"
              max="100"
              value={occupant[d[1]] / 100}
              ranges={damageRange}
            >
              {round(occupant[d[1]], 0)}
            </ProgressBar>
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
  );
};

const SleeperDialysisPump = (props) => {
  const { act, data } = useBackend();
  const { isBeakerLoaded, beakerMaxSpace, beakerFreeSpace } = data;
  const { active, actToDo, title } = props;
  const canDialysis = active && beakerFreeSpace > 0;
  return (
    <Section
      title={title}
      buttons={
        <>
          <Button
            disabled={!isBeakerLoaded || beakerFreeSpace <= 0}
            selected={canDialysis}
            icon={canDialysis ? 'toggle-on' : 'toggle-off'}
            content={canDialysis ? 'Active' : 'Inactive'}
            onClick={() => act(actToDo)}
          />
          <Button
            disabled={!isBeakerLoaded}
            icon="eject"
            content="Eject"
            onClick={() => act('removebeaker')}
          />
        </>
      }
    >
      {isBeakerLoaded ? (
        <LabeledList>
          <LabeledList.Item label="Remaining Space">
            <ProgressBar
              min="0"
              max={beakerMaxSpace}
              value={beakerFreeSpace / beakerMaxSpace}
              ranges={{
                good: [0.5, Infinity],
                average: [0.25, 0.5],
                bad: [-Infinity, 0.25],
              }}
            >
              {beakerFreeSpace}u
            </ProgressBar>
          </LabeledList.Item>
        </LabeledList>
      ) : (
        <Box color="label">No beaker loaded.</Box>
      )}
    </Section>
  );
};

const SleeperChemicals = (props) => {
  const { act, data } = useBackend();
  const { occupant, chemicals, maxchem, amounts } = data;
  return (
    <Section title="Chemicals" flexGrow="1">
      {chemicals.map((chem, i) => {
        let barColor = '';
        let odWarning;
        if (chem.overdosing) {
          barColor = 'bad';
          odWarning = (
            <Box color="bad">
              <Icon name="exclamation-circle" />
              &nbsp; Overdosing!
            </Box>
          );
        } else if (chem.od_warning) {
          barColor = 'average';
          odWarning = (
            <Box color="average">
              <Icon name="exclamation-triangle" />
              &nbsp; Close to overdosing
            </Box>
          );
        }
        return (
          <Box key={i} backgroundColor="rgba(0, 0, 0, 0.33)" mb="0.5rem">
            <Section
              title={chem.title}
              level="3"
              mx="0"
              lineHeight="18px"
              buttons={odWarning}
            >
              <Flex align="flex-start">
                <ProgressBar
                  min="0"
                  max={maxchem}
                  value={chem.occ_amount / maxchem}
                  color={barColor}
                  mr="0.5rem"
                >
                  {chem.pretty_amount}/{maxchem}u
                </ProgressBar>
                {amounts.map((a, i) => (
                  <Button
                    key={i}
                    disabled={
                      !chem.injectable ||
                      chem.occ_amount + a > maxchem ||
                      occupant.stat === 2
                    }
                    icon="syringe"
                    content={a}
                    mb="0"
                    height="19px"
                    onClick={() =>
                      act('chemical', {
                        chemid: chem.id,
                        amount: a,
                      })
                    }
                  />
                ))}
              </Flex>
            </Section>
          </Box>
        );
      })}
    </Section>
  );
};

const SleeperEmpty = (props) => {
  const { act, data } = useBackend();
  const { isBeakerLoaded } = data;
  return (
    <Section textAlign="center" flexGrow="1">
      <Flex height="100%">
        <Flex.Item grow="1" align="center" color="label">
          <Icon name="user-slash" mb="0.5rem" size="5" />
          <br />
          No occupant detected.
          {(isBeakerLoaded && (
            <Box>
              <Button
                icon="eject"
                content="Remove Beaker"
                onClick={() => act('removebeaker')}
              />
            </Box>
          )) ||
            null}
        </Flex.Item>
      </Flex>
    </Section>
  );
};
