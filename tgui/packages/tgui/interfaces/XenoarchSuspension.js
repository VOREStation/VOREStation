import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Box, Button, LabeledList, ProgressBar, Section } from '../components';
import { Window } from '../layouts';

export const XenoarchSuspension = (props, context) => {
  const { act, data } = useBackend(context);

  const { cell, cellCharge, cellMaxCharge, locked, suspension_field } = data;

  return (
    <Window width={400} height={150}>
      <Window.Content>
        <Section
          title={'Triple-phase S.F.G. MK III "Reliant"'}
          buttons={
            <Button icon={locked ? 'lock' : 'lock-open'} selected={!locked} onClick={() => act('lock')}>
              {locked ? 'Locked' : 'Unlocked'}
            </Button>
          }>
          {(locked && <Box color="bad">This interface is locked. Swipe an ID card to unlock it.</Box>) || (
            <Fragment>
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
              <Button fluid mt={1} icon="meteor" selected={suspension_field} onClick={() => act('toggle_field')}>
                {suspension_field ? 'Disengage Suspension Field' : 'Engage Suspension Field'}
              </Button>
            </Fragment>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
