import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Button, Section, Stack } from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

type Data = {
  doors_open: BooleanLike;
  fire_mode: BooleanLike;
  floors: floor[];
};

type floor = {
  id: number;
  ref: string;
  queued: BooleanLike;
  target: BooleanLike;
  current: BooleanLike;
  label: string;
  name: string;
};

export const Turbolift = (props) => {
  const { act, data } = useBackend<Data>();

  const { floors, doors_open, fire_mode } = data;

  return (
    <Window width={480} height={fire_mode ? 285 : 260}>
      <Window.Content>
        <Section
          title="Floor Selection"
          className={fire_mode ? 'Section--elevator--fire' : null}
          buttons={
            <>
              <Button
                icon={doors_open ? 'door-open' : 'door-closed'}
                selected={doors_open && !fire_mode}
                color={fire_mode ? 'red' : null}
                onClick={() => act('toggle_doors')}
              >
                {doors_open
                  ? fire_mode
                    ? 'Close Doors (SAFETY OFF)'
                    : 'Doors Open'
                  : 'Doors Closed'}
              </Button>
              <Button
                icon="exclamation-triangle"
                color="bad"
                onClick={() => act('emergency_stop')}
              >
                Emergency Stop
              </Button>
            </>
          }
        >
          {!fire_mode || (
            <Section
              className="Section--elevator--fire"
              textAlign="center"
              title="FIREFIGHTER MODE ENGAGED"
            />
          )}
          <Stack wrap="wrap">
            {floors.map((floor) => (
              <Stack.Item basis="100%" key={floor.id}>
                <Stack align="center" justify="space-around">
                  <Stack.Item basis="22%" textAlign="right" mr="3px">
                    {floor.label || 'Floor #' + floor.id}
                  </Stack.Item>
                  <Stack.Item basis="8%" textAlign="left">
                    <Button
                      icon="circle"
                      color={
                        floor.current
                          ? 'red'
                          : floor.target
                            ? 'green'
                            : floor.queued
                              ? 'yellow'
                              : null
                      }
                      onClick={() => act('move_to_floor', { ref: floor.ref })}
                    />
                  </Stack.Item>
                  <Stack.Item basis="50%" grow>
                    {floor.name}
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            ))}
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
