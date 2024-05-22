/* eslint react/no-danger: "off" */
import { sortBy } from 'common/collections';

import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const GuestPass = (props) => {
  const { act, data } = useBackend();

  const { access, area, giver, giveName, reason, duration, mode, log, uid } =
    data;

  return (
    <Window width={500} height={520}>
      <Window.Content scrollable>
        {(mode === 1 && (
          <Section
            title="Activity Log"
            buttons={
              <Button
                icon="scroll"
                selected
                onClick={() => act('mode', { mode: 0 })}
              >
                Activity Log
              </Button>
            }
          >
            <Button icon="print" onClick={() => act('print')} fluid mb={1}>
              Print
            </Button>
            <Section level={2} title="Logs">
              {/* These are internally generated only. */}
              {(log.length &&
                log.map((l) => (
                  <div key={l} dangerouslySetInnerHTML={{ __html: l }} />
                ))) || <Box>No logs.</Box>}
            </Section>
          </Section>
        )) || (
          <Section
            title={'Guest pass terminal #' + uid}
            buttons={
              <Button icon="scroll" onClick={() => act('mode', { mode: 1 })}>
                Activity Log
              </Button>
            }
          >
            <LabeledList>
              <LabeledList.Item label="Issuing ID">
                <Button onClick={() => act('id')}>
                  {giver || 'Insert ID'}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="Issued To">
                <Button onClick={() => act('giv_name')}>{giveName}</Button>
              </LabeledList.Item>
              <LabeledList.Item label="Reason">
                <Button onClick={() => act('reason')}>{reason}</Button>
              </LabeledList.Item>
              <LabeledList.Item label="Duration (minutes)">
                <Button onClick={() => act('duration')}>{duration}</Button>
              </LabeledList.Item>
            </LabeledList>
            <Button.Confirm icon="check" fluid onClick={() => act('issue')}>
              Issue Pass
            </Button.Confirm>
            <Section title="Access" level={2}>
              {sortBy((a) => a.area_name)(area).map((a) => (
                <Button.Checkbox
                  checked={a.on}
                  key={a.area}
                  onClick={() => act('access', { access: a.area })}
                >
                  {a.area_name}
                </Button.Checkbox>
              ))}
            </Section>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};
