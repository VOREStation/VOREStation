import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, Section, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

type Data = {
  unlocked: BooleanLike;
  buttons: Record<string, string>;
};

export const LockdownButton = (props) => {
  const { act, data } = useBackend<Data>();
  const { unlocked, buttons } = data;

  return (
    <Window width={500} height={260}>
      <Window.Content>
        <Section fill title="Lockdown Control Console">
          {!unlocked ? (
            <Box>Swipe ID card to unlock.</Box>
          ) : (
            <Stack wrap="wrap">
              {Object.entries(buttons).map(([button, tooltip]) => (
                <Stack.Item basis="49%" key={button}>
                  <Button
                    tooltip={tooltip}
                    onClick={() =>
                      act('triggerevent', { triggerevent: button })
                    }
                  >
                    {button}
                  </Button>
                </Stack.Item>
              ))}
            </Stack>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
