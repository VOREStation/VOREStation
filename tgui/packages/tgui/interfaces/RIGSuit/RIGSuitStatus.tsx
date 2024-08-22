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

  const SealButton = (
    <Button
      icon={sealing ? 'redo' : sealed ? 'power-off' : 'lock-open'}
      iconSpin={sealing}
      disabled={sealing}
      selected={sealed}
      onClick={() => act('toggle_seals')}
    >
      {'Suit ' +
        (sealing ? 'seals working...' : sealed ? 'is Active' : 'is Inactive')}
    </Button>
  );

  const CoolingButton = (
    <Button
      icon={'power-off'}
      selected={cooling}
      onClick={() => act('toggle_cooling')}
    >
      {'Suit Cooling ' + (cooling ? 'is Active' : 'is Inactive')}
    </Button>
  );

  const AIButton = (
    <Button
      selected={aioverride}
      icon="robot"
      onClick={() => act('toggle_ai_control')}
    >
      {'AI Control ' + (aioverride ? 'Enabled' : 'Disabled')}
    </Button>
  );

  return (
    <Section
      title="Status"
      buttons={
        <>
          {SealButton}
          {AIButton}
          {CoolingButton}
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
