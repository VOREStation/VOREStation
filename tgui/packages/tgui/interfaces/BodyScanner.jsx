import { round } from 'common/math';
import { Fragment } from 'react';
import { useBackend } from '../backend';
import { AnimatedNumber, Box, Button, Flex, Icon, LabeledList, ProgressBar, Section, Table, Tooltip } from '../components';
import { Window } from '../layouts';

const stats = [
  ['good', 'Alive'],
  ['average', 'Unconscious'],
  ['bad', 'DEAD'],
];

const abnormalities = [
  [
    'hasBorer',
    'bad',
    (occupant) =>
      'Large growth detected in frontal lobe,' +
      ' possibly cancerous. Surgical removal is recommended.',
  ],
  ['hasVirus', 'bad', (occupant) => 'Viral pathogen detected in blood stream.'],
  ['blind', 'average', (occupant) => 'Cataracts detected.'],
  [
    'colourblind',
    'average',
    (occupant) => 'Photoreceptor abnormalities detected.',
  ],
  ['nearsighted', 'average', (occupant) => 'Retinal misalignment detected.'],
  /* VOREStation Add */
  [
    'humanPrey',
    'average',
    (occupant) => {
      return 'Foreign Humanoid(s) detected: ' + occupant.humanPrey;
    },
  ],
  [
    'livingPrey',
    'average',
    (occupant) => {
      return 'Foreign Creature(s) detected: ' + occupant.livingPrey;
    },
  ],
  [
    'objectPrey',
    'average',
    (occupant) => {
      return 'Foreign Object(s) detected: ' + occupant.objectPrey;
    },
  ],
  /* VOREStation Add End */
];

const damages = [
  ['Respiratory', 'oxyLoss'],
  ['Brain', 'brainLoss'],
  ['Toxin', 'toxLoss'],
  ['Radiation', 'radLoss'],
  ['Brute', 'bruteLoss'],
  ['Genetic', 'cloneLoss'],
  ['Burn', 'fireLoss'],
  ['Paralysis', 'paralysis'],
];

const damageRange = {
  average: [0.25, 0.5],
  bad: [0.5, Infinity],
};

const mapTwoByTwo = (a, c) => {
  let result = [];
  for (let i = 0; i < a.length; i += 2) {
    result.push(c(a[i], a[i + 1], i));
  }
  return result;
};

const reduceOrganStatus = (A) => {
  return A.length > 0
    ? A.reduce((a, s) =>
      a === null ? (
        s
      ) : (
        <>
          {a}
          {!!s && <Box>{s}</Box>}
        </>
      )
    )
    : null;
};

const germStatus = (i) => {
  if (i > 100) {
    if (i < 300) {
      return 'mild infection';
    }
    if (i < 400) {
      return 'mild infection+';
    }
    if (i < 500) {
      return 'mild infection++';
    }
    if (i < 700) {
      return 'acute infection';
    }
    if (i < 800) {
      return 'acute infection+';
    }
    if (i < 900) {
      return 'acute infection++';
    }
    if (i >= 900) {
      return 'septic';
    }
  }

  return '';
};

export const BodyScanner = (props) => {
  const { data } = useBackend();
  const { occupied, occupant = {} } = data;
  const body = occupied ? (
    <BodyScannerMain occupant={occupant} />
  ) : (
    <BodyScannerEmpty />
  );
  return (
    <Window width={690} height={600}>
      <Window.Content scrollable className="Layout__content--flexColumn">
        {body}
      </Window.Content>
    </Window>
  );
};

const BodyScannerMain = (props) => {
  const { occupant } = props;
  return (
    <Box>
      <BodyScannerMainOccupant occupant={occupant} />
      <BodyScannerMainReagents occupant={occupant} />
      <BodyScannerMainAbnormalities occupant={occupant} />
      <BodyScannerMainDamage occupant={occupant} />
      <BodyScannerMainOrgansExternal organs={occupant.extOrgan} />
      <BodyScannerMainOrgansInternal organs={occupant.intOrgan} />
    </Box>
  );
};

const BodyScannerMainOccupant = (props) => {
  const { act, data } = useBackend();
  const { occupant } = data;
  return (
    <Section
      title="Occupant"
      buttons={
        <>
          <Button icon="user-slash" onClick={() => act('ejectify')}>
            Eject
          </Button>
          <Button icon="print" onClick={() => act('print_p')}>
            Print Report
          </Button>
        </>
      }>
      <LabeledList>
        <LabeledList.Item label="Name">{occupant.name}</LabeledList.Item>
        <LabeledList.Item label="Health">
          <ProgressBar
            min="0"
            max={occupant.maxHealth}
            value={occupant.health / occupant.maxHealth}
            ranges={{
              good: [0.5, Infinity],
              average: [0, 0.5],
              bad: [-Infinity, 0],
            }}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Status" color={stats[occupant.stat][0]}>
          {stats[occupant.stat][1]}
        </LabeledList.Item>
        <LabeledList.Item label="Temperature">
          <AnimatedNumber value={round(occupant.bodyTempC, 0)} />
          &deg;C,&nbsp;
          <AnimatedNumber value={round(occupant.bodyTempF, 0)} />
          &deg;F
        </LabeledList.Item>
        <LabeledList.Item label="Blood Volume">
          <AnimatedNumber value={round(occupant.blood.volume, 0)} />{' '}
          units&nbsp;(
          <AnimatedNumber value={round(occupant.blood.percent, 0)} />
          %)
        </LabeledList.Item>
        {/* VOREStation Add */}
        <LabeledList.Item label="Weight">
          {round(data.occupant.weight) +
            'lbs, ' +
            round(data.occupant.weight / 2.20463) +
            'kgs'}
        </LabeledList.Item>
        {/* VOREStation Add End */}
      </LabeledList>
    </Section>
  );
};

const BodyScannerMainReagents = (props) => {
  const { occupant } = props;

  return (
    <>
      <Section title="Blood Reagents">
        {occupant.reagents ? (
          <Table>
            <Table.Row header>
              <Table.Cell>Reagent</Table.Cell>
              <Table.Cell textAlign="right">Amount</Table.Cell>
            </Table.Row>
            {occupant.reagents.map((reagent) => (
              <Table.Row key={reagent.name}>
                <Table.Cell>{reagent.name}</Table.Cell>
                <Table.Cell textAlign="right">
                  {reagent.amount} Units{' '}
                  {reagent.overdose ? <Box color="bad">OVERDOSING</Box> : null}
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        ) : (
          <Box color="good">No Blood Reagents Detected</Box>
        )}
      </Section>
      <Section title="Stomach Reagents">
        {occupant.ingested ? (
          <Table>
            <Table.Row header>
              <Table.Cell>Reagent</Table.Cell>
              <Table.Cell textAlign="right">Amount</Table.Cell>
            </Table.Row>
            {occupant.ingested.map((reagent) => (
              <Table.Row key={reagent.name}>
                <Table.Cell>{reagent.name}</Table.Cell>
                <Table.Cell textAlign="right">
                  {reagent.amount} Units{' '}
                  {reagent.overdose ? <Box color="bad">OVERDOSING</Box> : null}
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        ) : (
          <Box color="good">No Stomach Reagents Detected</Box>
        )}
      </Section>
    </>
  );
};

const BodyScannerMainAbnormalities = (props) => {
  const { occupant } = props;

  let hasAbnormalities =
    occupant.hasBorer ||
    occupant.blind ||
    occupant.colourblind ||
    occupant.nearsighted ||
    occupant.hasVirus;

  /* VOREStation Add */
  hasAbnormalities =
    hasAbnormalities ||
    occupant.humanPrey ||
    occupant.livingPrey ||
    occupant.objectPrey;
  /* VOREStation Add End */

  if (!hasAbnormalities) {
    return (
      <Section title="Abnormalities">
        <Box color="label">No abnormalities found.</Box>
      </Section>
    );
  }

  return (
    <Section title="Abnormalities">
      {abnormalities.map((a, i) => {
        if (occupant[a[0]]) {
          return (
            <Box color={a[1]} bold={a[1] === 'bad'}>
              {a[2](occupant)}
            </Box>
          );
        }
      })}
    </Section>
  );
};

const BodyScannerMainDamage = (props) => {
  const { occupant } = props;
  return (
    <Section title="Damage">
      <Table>
        {mapTwoByTwo(damages, (d1, d2, i) => (
          <>
            <Table.Row color="label">
              <Table.Cell>{d1[0]}:</Table.Cell>
              <Table.Cell>{!!d2 && d2[0] + ':'}</Table.Cell>
            </Table.Row>
            <Table.Row>
              <Table.Cell>
                <BodyScannerMainDamageBar
                  value={occupant[d1[1]]}
                  marginBottom={i < damages.length - 2}
                />
              </Table.Cell>
              <Table.Cell>
                {!!d2 && <BodyScannerMainDamageBar value={occupant[d2[1]]} />}
              </Table.Cell>
            </Table.Row>
          </>
        ))}
      </Table>
    </Section>
  );
};

const BodyScannerMainDamageBar = (props) => {
  return (
    <ProgressBar
      min="0"
      max="100"
      value={props.value / 100}
      mt="0.5rem"
      mb={!!props.marginBottom && '0.5rem'}
      ranges={damageRange}>
      {round(props.value, 0)}
    </ProgressBar>
  );
};

const BodyScannerMainOrgansExternal = (props) => {
  if (props.organs.length === 0) {
    return (
      <Section title="External Organs">
        <Box color="label">N/A</Box>
      </Section>
    );
  }

  return (
    <Section title="External Organs">
      <Table>
        <Table.Row header>
          <Table.Cell>Name</Table.Cell>
          <Table.Cell textAlign="center">Damage</Table.Cell>
          <Table.Cell textAlign="right">Injuries</Table.Cell>
        </Table.Row>
        {props.organs.map((o, i) => (
          <Table.Row key={i} textTransform="capitalize">
            <Table.Cell width="33%">{o.name}</Table.Cell>
            <Table.Cell textAlign="center" q>
              <ProgressBar
                min="0"
                max={o.maxHealth}
                mt={i > 0 && '0.5rem'}
                value={o.totalLoss / 100}
                ranges={damageRange}>
                <Box float="left" inline>
                  {!!o.bruteLoss && (
                    <Box inline position="relative">
                      <Icon name="bone" />
                      {round(o.bruteLoss, 0)}&nbsp;
                      <Tooltip position="top" content="Brute damage" />
                    </Box>
                  )}
                  {!!o.fireLoss && (
                    <Box inline position="relative">
                      <Icon name="fire" />
                      {round(o.fireLoss, 0)}
                      <Tooltip position="top" content="Burn damage" />
                    </Box>
                  )}
                </Box>
                <Box inline>{round(o.totalLoss, 0)}</Box>
              </ProgressBar>
            </Table.Cell>
            <Table.Cell textAlign="right" width="33%">
              <Box color="average" inline>
                {reduceOrganStatus([
                  o.internalBleeding && 'Internal bleeding',
                  !!o.status.bleeding && 'External bleeding',
                  o.lungRuptured && 'Ruptured lung',
                  o.destroyed && 'Destroyed',
                  !!o.status.broken && o.status.broken,
                  germStatus(o.germ_level),
                  !!o.open && 'Open incision',
                ])}
              </Box>
              <Box inline>
                {reduceOrganStatus([
                  !!o.status.splinted && 'Splinted',
                  !!o.status.robotic && 'Robotic',
                  !!o.status.dead && <Box color="bad">DEAD</Box>,
                ])}
                {reduceOrganStatus(
                  o.implants.map((s) => (s.known ? s.name : 'Unknown object'))
                )}
              </Box>
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};

const BodyScannerMainOrgansInternal = (props) => {
  if (props.organs.length === 0) {
    return (
      <Section title="Internal Organs">
        <Box color="label">N/A</Box>
      </Section>
    );
  }

  return (
    <Section title="Internal Organs">
      <Table>
        <Table.Row header>
          <Table.Cell>Name</Table.Cell>
          <Table.Cell textAlign="center">Damage</Table.Cell>
          <Table.Cell textAlign="right">Injuries</Table.Cell>
        </Table.Row>
        {props.organs.map((o, i) => (
          <Table.Row key={i} textTransform="capitalize">
            <Table.Cell width="33%">{o.name}</Table.Cell>
            <Table.Cell textAlign="center">
              <ProgressBar
                min="0"
                max={o.maxHealth}
                value={o.damage / 100}
                mt={i > 0 && '0.5rem'}
                ranges={damageRange}>
                {round(o.damage, 0)}
              </ProgressBar>
            </Table.Cell>
            <Table.Cell textAlign="right" width="33%">
              <Box color="average" inline>
                {reduceOrganStatus([
                  germStatus(o.germ_level),
                  !!o.inflamed && 'Appendicitis detected.',
                ])}
              </Box>
              <Box inline>
                {reduceOrganStatus([
                  o.robotic === 1 && 'Robotic',
                  o.robotic === 2 && 'Assisted',
                  !!o.dead && <Box color="bad">DEAD</Box>,
                ])}
              </Box>
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    </Section>
  );
};

const BodyScannerEmpty = () => {
  return (
    <Section textAlign="center" flexGrow="1">
      <Flex height="100%">
        <Flex.Item grow="1" align="center" color="label">
          <Icon name="user-slash" mb="0.5rem" size="5" />
          <br />
          No occupant detected.
        </Flex.Item>
      </Flex>
    </Section>
  );
};
