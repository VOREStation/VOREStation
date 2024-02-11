import { BooleanLike } from 'common/react';
import { Fragment } from 'react';

import { useBackend } from '../backend';
import { Box, Button, LabeledList, ProgressBar, Section } from '../components';
import { Window } from '../layouts';

type Data = {
  cell: BooleanLike;
  cellCharge: number;
  cellMaxCharge: number;
  locked: BooleanLike;
  suspension_field: BooleanLike;
};

export const XenoarchSuspension = (props) => {
  const { act, data } = useBackend<Data>();

  const { cell, cellCharge, cellMaxCharge, locked, suspension_field } = data;

  return (
    <Window width={400} height={150}>
      <Window.Content>
        <Section
          title={'Triple-phase S.F.G. MK III "Reliant"'}
          buttons={
            <Button
              icon={locked ? 'lock' : 'lock-open'}
              selected={!locked}
              onClick={() => act('lock')}
            >
              {locked ? 'Locked' : 'Unlocked'}
            </Button>
          }
        >
          {(locked && (
            <Box color="bad">
              This interface is locked. Swipe an ID card to unlock it.
            </Box>
          )) || (
            <>
              <LabeledList>
                <LabeledList.Item label="Cell Charge">
                  {(cell && (
                    <ProgressBar
                      ranges={{
                        good: [cellMaxCharge * 0.75, Infinity],
                        average: [cellMaxCharge * 0.5, cellMaxCharge * 0.75],
                        bad: [-Infinity, cellMaxCharge * 0.5],
                      }}
                      value={cellCharge}
                      maxValue={cellMaxCharge}
                    />
                  )) || <Box color="bad">No cell inserted.</Box>}
                </LabeledList.Item>
              </LabeledList>
              <Button
                fluid
                mt={1}
                icon="meteor"
                selected={suspension_field}
                onClick={() => act('toggle_field')}
              >
                {suspension_field
                  ? 'Disengage Suspension Field'
                  : 'Engage Suspension Field'}
              </Button>
            </>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
