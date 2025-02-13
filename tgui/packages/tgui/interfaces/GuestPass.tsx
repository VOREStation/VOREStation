/* eslint react/no-danger: "off" */
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, LabeledList, Section } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

type Data = {
  access: number[] | null;
  area: area[];
  giver: string | null;
  giveName: string;
  reason: String;
  duration: number;
  mode: BooleanLike;
  log: string[];
  uid: number;
};

type area = { area: string; area_name: string; on: BooleanLike };

export const GuestPass = (props) => {
  const { act, data } = useBackend<Data>();

  const { area, giver, giveName, reason, duration, mode, log, uid } = data;

  area.sort((a, b) => a.area_name.localeCompare(b.area_name));

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
            <Section title="Logs">
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
            <Section title="Access">
              {area.map((a) => (
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
