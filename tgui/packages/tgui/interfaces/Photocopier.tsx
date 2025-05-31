import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  AnimatedNumber,
  Box,
  Button,
  Section,
  Stack,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

type Data = {
  has_item: BooleanLike;
  isAI: BooleanLike;
  can_AI_print: BooleanLike;
  has_toner: BooleanLike;
  current_toner: number;
  max_toner: number;
  num_copies: number;
  max_copies: number;
};

export const Photocopier = (props) => {
  const { act, data } = useBackend<Data>();
  const { has_item, num_copies, can_AI_print, isAI } = data;

  return (
    <Window title="Photocopier" width={200} height={isAI ? 230 : 210}>
      <Window.Content>
        {/* VFD */}
        <Stack vertical>
          <Stack.Item>
            <Box
              className="font-grand9k_pixel"
              backgroundColor="#002200"
              textColor="#0fffb8"
              pl={1}
              pr={1}
              style={{ border: '4px solid #181817', borderRadius: '4px' }}
            >
              <Stack vertical>
                <Stack.Item>
                  <Stack>
                    <Stack.Item>TONER LEVEL:</Stack.Item>
                    <Stack.Item>
                      <Toner />
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
                <Stack.Item>
                  <Stack>
                    <Stack.Item>COPIES:</Stack.Item>
                    <Stack.Item>{num_copies}</Stack.Item>
                  </Stack>
                </Stack.Item>
                <Stack.Item color={has_item ? 'good' : 'bad'}>
                  {has_item ? 'SCANNER READY' : 'NO ITEM LOADED'}
                </Stack.Item>
                {isAI ? (
                  <Stack.Item>
                    <Stack>
                      <Stack.Item color="hsl(332, 60%, 60%)">AI:</Stack.Item>
                      <Stack.Item>
                        <Button
                          color="transparent"
                          disabled={!can_AI_print}
                          onClick={() => act('ai_photo')}
                        >
                          UPLOAD PHOTO
                        </Button>
                      </Stack.Item>
                    </Stack>
                  </Stack.Item>
                ) : null}
              </Stack>
            </Box>
          </Stack.Item>
          <Stack.Item>
            <Buttons />
          </Stack.Item>
          {has_item ? (
            <Stack.Item>
              <Button
                fluid
                backgroundColor="#3a3a3a"
                style={{ boxShadow: '2px 2px #1a1a1a' }}
                icon="eject"
                onClick={() => act('remove')}
              >
                Remove Item
              </Button>
            </Stack.Item>
          ) : null}
        </Stack>
      </Window.Content>
    </Window>
  );
};

const Toner = (props) => {
  const { data } = useBackend<Data>();
  const { max_toner, current_toner, has_toner } = data;

  if (!has_toner) {
    return <Box color="bad">ERR</Box>;
  }

  const average_toner: number = max_toner * 0.66;
  const bad_toner: number = max_toner * 0.33;

  let color;
  if (current_toner < bad_toner) {
    color = 'bad';
  } else if (current_toner < average_toner) {
    color = 'average';
  } else {
    color = 'good';
  }

  return (
    <Box color={color}>
      <AnimatedNumber value={current_toner} format={(f) => f + '%'} />
    </Box>
  );
};

const Buttons = (props) => {
  const { act, data } = useBackend<Data>();
  const { num_copies } = data;
  return (
    <Stack justify="center">
      <Stack.Item>
        <Button
          icon="minus"
          backgroundColor="#3a3a3a"
          fontSize={2.5}
          style={{ boxShadow: '2px 2px #1a1a1a' }}
          onClick={() =>
            act('set_copies', {
              num_copies: num_copies - 1,
            })
          }
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          icon="play"
          backgroundColor="#3a3a3a"
          fontSize={2.5}
          style={{ boxShadow: '2px 2px #1a1a1a' }}
          onClick={() => act('make_copy')}
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          icon="plus"
          backgroundColor="#3a3a3a"
          fontSize={2.5}
          style={{ boxShadow: '2px 2px #1a1a1a' }}
          onClick={() =>
            act('set_copies', {
              num_copies: num_copies + 1,
            })
          }
        />
      </Stack.Item>
    </Stack>
  );
};

const AIOptions = (props) => {
  const { act, data } = useBackend<Data>();
  const { can_AI_print } = data;

  return (
    <Section title="AI Options">
      <Box>
        <Button
          fluid
          icon="images"
          textAlign="center"
          disabled={!can_AI_print}
          onClick={() => act('ai_photo')}
        >
          Print photo from database
        </Button>
      </Box>
    </Section>
  );
};
