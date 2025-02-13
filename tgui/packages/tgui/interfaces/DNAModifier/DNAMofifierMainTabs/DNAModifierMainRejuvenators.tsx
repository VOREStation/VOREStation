import { useBackend } from 'tgui/backend';
import { Box, Button, Icon, LabeledList, Section } from 'tgui-core/components';

import { rejuvenatorsDoses } from '../constants';
import type { Data } from '../types';

export const DNAModifierMainRejuvenators = (props) => {
  const { act, data } = useBackend<Data>();

  const { isBeakerLoaded, beakerVolume, beakerLabel, hasOccupant } = data;

  return (
    <Section
      fill
      title="Rejuvenators and Beaker"
      buttons={
        <Button
          disabled={!isBeakerLoaded}
          icon="eject"
          onClick={() => act('ejectBeaker')}
        >
          Eject
        </Button>
      }
    >
      {isBeakerLoaded ? (
        <LabeledList>
          <LabeledList.Item label="Inject">
            {rejuvenatorsDoses.map((a, i) => (
              <Button
                key={i}
                disabled={a > beakerVolume || !hasOccupant}
                icon="syringe"
                onClick={() =>
                  act('injectRejuvenators', {
                    amount: a,
                  })
                }
              >
                {a}
              </Button>
            ))}
            <Button
              disabled={beakerVolume <= 0 || !hasOccupant}
              icon="syringe"
              onClick={() =>
                act('injectRejuvenators', {
                  amount: beakerVolume,
                })
              }
            >
              All
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Beaker">
            <Box mb="0.5rem">{beakerLabel ? beakerLabel : 'No label'}</Box>
            {beakerVolume ? (
              <Box color="good">
                {beakerVolume} unit{beakerVolume === 1 ? '' : 's'} remaining
              </Box>
            ) : (
              <Box color="bad">Empty</Box>
            )}
          </LabeledList.Item>
        </LabeledList>
      ) : (
        <Box color="label" textAlign="center" my="25%">
          <Icon name="exclamation-triangle" size={4} />
          <br />
          No beaker loaded.
        </Box>
      )}
    </Section>
  );
};
