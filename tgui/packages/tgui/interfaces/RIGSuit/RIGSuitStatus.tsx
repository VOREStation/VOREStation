import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  LabeledList,
  ProgressBar,
  Section,
} from 'tgui-core/components';

import type { Data } from './types';

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
    <Section title="Status">
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
