import { BooleanLike } from 'common/react';

import { useBackend } from '../../backend';
import {
  Box,
  Button,
  LabeledList,
  ProgressBar,
  Section,
} from '../../components';
import { Data } from './types';

export const SleeperDialysisPump = (props: {
  active: BooleanLike;
  actToDo: string;
  title: string;
}) => {
  const { act, data } = useBackend<Data>();

  const { active, actToDo, title } = props;

  const { isBeakerLoaded, beakerMaxSpace, beakerFreeSpace } = data;

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
            onClick={() => act(actToDo)}
          >
            {canDialysis ? 'Active' : 'Inactive'}
          </Button>
          <Button
            disabled={!isBeakerLoaded}
            icon="eject"
            onClick={() => act('removebeaker')}
          >
            Eject
          </Button>
        </>
      }
    >
      {isBeakerLoaded ? (
        <LabeledList>
          <LabeledList.Item label="Remaining Space">
            <ProgressBar
              minValue={0}
              maxValue={1}
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
