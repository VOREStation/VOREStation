import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, LabeledList, Section } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

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
                      onClick={() => act('look', { ref: notice.ref })}
                    >
                      Look
                    </Button>
                  )) ||
                    (notice.ispaper && (
                      <>
                        <Button
                          icon="sticky-note"
                          onClick={() => act('read', { ref: notice.ref })}
                        >
                          Read
                        </Button>
                        <Button
                          icon="pen"
                          onClick={() => act('write', { ref: notice.ref })}
                        >
                          Write
                        </Button>
                      </>
                    )) ||
                    'Unknown Entity'}
                  <Button
                    icon="minus-circle"
                    onClick={() => act('remove', { ref: notice.ref })}
                  >
                    Remove
                  </Button>
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
