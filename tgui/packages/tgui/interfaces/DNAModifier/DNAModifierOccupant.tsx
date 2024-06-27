import { BooleanLike } from 'common/react';

import { useBackend } from '../../backend';
import {
  Box,
  Button,
  Icon,
  LabeledList,
  ProgressBar,
  Section,
} from '../../components';
import { stats } from './constants';
import { Data } from './types';

export const DNAModifierOccupant = (props: { isDNAInvalid: BooleanLike }) => {
  const { act, data } = useBackend<Data>();

  const { locked, hasOccupant, occupant } = data;

  return (
    <Section
      title="Occupant"
      buttons={
        <>
          <Box color="label" inline mr="0.5rem">
            Door Lock:
          </Box>
          <Button
            disabled={!hasOccupant}
            selected={locked}
            icon={locked ? 'toggle-on' : 'toggle-off'}
            onClick={() => act('toggleLock')}
          >
            {locked ? 'Engaged' : 'Disengaged'}
          </Button>
          <Button
            disabled={!hasOccupant || locked}
            icon="user-slash"
            onClick={() => act('ejectOccupant')}
          >
            Eject
          </Button>
        </>
      }
    >
      {hasOccupant ? (
        <>
          <Box>
            <LabeledList>
              <LabeledList.Item label="Name">{occupant.name}</LabeledList.Item>
              <LabeledList.Item label="Health">
                <ProgressBar
                  minValue={0}
                  maxValue={1}
                  value={occupant.health! / occupant.maxHealth!}
                  ranges={{
                    good: [0.5, Infinity],
                    average: [0, 0.5],
                    bad: [-Infinity, 0],
                  }}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Status" color={stats[occupant.stat!][0]}>
                {stats[occupant.stat!][1]}
              </LabeledList.Item>
              <LabeledList.Divider />
            </LabeledList>
          </Box>
          {props.isDNAInvalid ? (
            <Box color="bad">
              <Icon name="exclamation-circle" />
              &nbsp; The occupant&apos;s DNA structure is ruined beyond
              recognition, please insert a subject with an intact DNA structure.
            </Box>
          ) : (
            <LabeledList>
              <LabeledList.Item label="Radiation">
                <ProgressBar
                  minValue={0}
                  maxValue={1}
                  value={occupant.radiationLevel! / 100}
                  color="average"
                />
              </LabeledList.Item>
              <LabeledList.Item label="Unique Enzymes">
                {data.occupant.uniqueEnzymes ? (
                  data.occupant.uniqueEnzymes
                ) : (
                  <Box color="bad">
                    <Icon name="exclamation-circle" />
                    &nbsp; Unknown
                  </Box>
                )}
              </LabeledList.Item>
            </LabeledList>
          )}
        </>
      ) : (
        <Box color="label">Cell unoccupied.</Box>
      )}
    </Section>
  );
};
