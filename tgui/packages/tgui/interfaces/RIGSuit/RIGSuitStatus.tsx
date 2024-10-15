import { useBackend } from '../../backend';
import {
  Box,
  Button,
  LabeledList,
  ProgressBar,
  Section,
} from '../../components';
import { Data } from './types';

export const RIGSuitStatus = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    // Power Bar
    chargestatus,
    charge,
    maxcharge,
    // AI Control Toggle
    aioverride,
    // Suit Status
    sealing,
    sealed,
    cooling,
    // Cover Locks
    emagged,
    securitycheck,
    coverlock,
  } = data;

  return (
    <Section
      title="Status"
      buttons={
        <>
          <Button
            icon={sealing ? 'redo' : sealed ? 'power-off' : 'lock-open'}
            iconSpin={sealing}
            disabled={sealing}
            selected={sealed}
            onClick={() => act('toggle_seals')}
          >
            {'Suit ' +
              (sealing
                ? 'seals working...'
                : sealed
                  ? 'is Active'
                  : 'is Inactive')}
          </Button>
          <Button
            icon="robot"
            selected={aioverride}
            onClick={() => act('toggle_ai_control')}
            tooltip={'AI Control ' + (aioverride ? 'Enabled' : 'Disabled')}
            tooltipPosition="bottom-end"
          />
          <Button
            icon="wind"
            selected={cooling}
            onClick={() => act('toggle_cooling')}
            tooltip={'Suit Cooling ' + (cooling ? 'is Active' : 'is Inactive')}
            tooltipPosition="bottom-end"
          />
          <Button
            icon="lungs"
            onClick={() => act('tank_settings')}
            tooltip="Tank Settings"
            tooltipPosition="bottom-end"
          />
        </>
      }
    >
      <LabeledList>
        <LabeledList.Item label="Power Supply">
          <ProgressBar
            minValue={0}
            maxValue={50}
            value={chargestatus}
            ranges={{
              good: [35, Infinity],
              average: [15, 35],
              bad: [-Infinity, 15],
            }}
          >
            {charge} / {maxcharge}
          </ProgressBar>
        </LabeledList.Item>
        <LabeledList.Item label="Cover Status">
          {emagged || !securitycheck ? (
            <Box color="bad">Error - Maintenance Lock Control Offline</Box>
          ) : (
            <Button
              icon={coverlock ? 'lock' : 'lock-open'}
              onClick={() => act('toggle_suit_lock')}
            >
              {coverlock ? 'Locked' : 'Unlocked'}
            </Button>
          )}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
