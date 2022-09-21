import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

export const NoticeBoard = (props, context) => {
  const { act, data } = useBackend(context);

  const { notices } = data;

  return (
    <Window width={330} height={300}>
      <Window.Content>
        <Section>
          {notices.length ? (
            <LabeledList>
              {notices.map((notice, i) => (
                <LabeledList.Item key={i} label={notice.name}>
                  {(notice.isphoto && (
                    <Button icon="image" content="Look" onClick={() => act('look', { ref: notice.ref })} />
                  )) ||
                    (notice.ispaper && (
                      <Fragment>
                        <Button icon="sticky-note" content="Read" onClick={() => act('read', { ref: notice.ref })} />
                        <Button icon="pen" content="Write" onClick={() => act('write', { ref: notice.ref })} />
                      </Fragment>
                    )) ||
                    'Unknown Entity'}
                  <Button icon="minus-circle" content="Remove" onClick={() => act('remove', { ref: notice.ref })} />
                </LabeledList.Item>
              ))}
            </LabeledList>
          ) : (
            <Box color="average">No notices posted here.</Box>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
