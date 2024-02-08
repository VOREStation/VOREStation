import { BooleanLike } from 'common/react';
import { Fragment } from 'react';

import { useBackend } from '../backend';
import { Box, Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

type Data = {
  notices: {
    name: string;
    isphoto: BooleanLike;
    ispaper: BooleanLike;
    ref: string;
  }[];
};

export const NoticeBoard = (props) => {
  const { act, data } = useBackend<Data>();

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
                    <Button
                      icon="image"
                      content="Look"
                      onClick={() => act('look', { ref: notice.ref })}
                    />
                  )) ||
                    (notice.ispaper && (
                      <>
                        <Button
                          icon="sticky-note"
                          content="Read"
                          onClick={() => act('read', { ref: notice.ref })}
                        />
                        <Button
                          icon="pen"
                          content="Write"
                          onClick={() => act('write', { ref: notice.ref })}
                        />
                      </>
                    )) ||
                    'Unknown Entity'}
                  <Button
                    icon="minus-circle"
                    content="Remove"
                    onClick={() => act('remove', { ref: notice.ref })}
                  />
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
