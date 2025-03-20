import { useBackend } from 'tgui/backend';
import { Button, Image, LabeledList, Stack } from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

import { stats } from './constants';
import { contentData } from './types';

export const VoreContentsPanel = (props: {
  contents: contentData[];
  belly?: string;
  outside?: BooleanLike;
  show_pictures: BooleanLike;
  icon_overflow: BooleanLike;
}) => {
  const { act } = useBackend();

  const {
    contents,
    belly,
    outside = false,
    show_pictures,
    icon_overflow,
  } = props;

  return (
    <>
      {outside ? (
        <Button
          textAlign="center"
          fluid
          mb={1}
          onClick={() => act('pick_from_outside', { pickall: true })}
        >
          All
        </Button>
      ) : (
        ''
      )}
      {(show_pictures && !icon_overflow && (
        <Stack wrap="wrap" justify="center" align="center">
          {contents.map((thing) => (
            <Stack.Item key={thing.name} basis="32%">
              <Button
                width="64px"
                color={thing.absorbed ? 'purple' : stats[thing.stat]}
                style={{
                  verticalAlign: 'middle',
                  marginRight: '5px',
                  borderRadius: '20px',
                }}
                onClick={() =>
                  act(
                    thing.outside ? 'pick_from_outside' : 'pick_from_inside',
                    {
                      pick: thing.ref,
                      belly: belly,
                    },
                  )
                }
              >
                <Image
                  src={'data:image/jpeg;base64, ' + thing.icon}
                  width="64px"
                  height="64px"
                  style={{
                    marginLeft: '-5px',
                  }}
                />
              </Button>
              {thing.name}
            </Stack.Item>
          ))}
        </Stack>
      )) || (
        <LabeledList>
          {contents.map((thing, i) => (
            <LabeledList.Item key={i} label={thing.name}>
              <Button
                fluid
                mt={-1}
                mb={-1}
                color={thing.absorbed ? 'purple' : stats[thing.stat]}
                onClick={() =>
                  act(
                    thing.outside ? 'pick_from_outside' : 'pick_from_inside',
                    {
                      pick: thing.ref,
                      belly: belly,
                    },
                  )
                }
              >
                Interact
              </Button>
            </LabeledList.Item>
          ))}
        </LabeledList>
      )}
    </>
  );
};
