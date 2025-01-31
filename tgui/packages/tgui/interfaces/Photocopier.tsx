import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  NumberInput,
  ProgressBar,
  Section,
  Stack,
} from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

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
  const { data } = useBackend<Data>();
  const { isAI, has_toner, has_item } = data;

  return (
    <Window title="Photocopier" width={240} height={isAI ? 309 : 234}>
      <Window.Content>
        {has_toner ? (
          <Toner />
        ) : (
          <Section title="Toner">
            <Box color="average">No inserted toner cartridge.</Box>
          </Section>
        )}
        {has_item ? (
          <Options />
        ) : (
          <Section title="Options">
            <Box color="average">No inserted item.</Box>
          </Section>
        )}
        {!!isAI && <AIOptions />}
      </Window.Content>
    </Window>
  );
};

const Toner = (props) => {
  const { data } = useBackend<Data>();
  const { max_toner, current_toner } = data;

  const average_toner: number = max_toner * 0.66;
  const bad_toner: number = max_toner * 0.33;

  return (
    <Section title="Toner">
      <ProgressBar
        ranges={{
          good: [average_toner, max_toner],
          average: [bad_toner, average_toner],
          bad: [0, bad_toner],
        }}
        value={current_toner}
        minValue={0}
        maxValue={max_toner}
      />
    </Section>
  );
};

const Options = (props) => {
  const { act, data } = useBackend<Data>();
  const { num_copies } = data;

  return (
    <Section title="Options">
      <Stack>
        <Stack.Item mt={0.4} width={11} color="label">
          Make copies:
        </Stack.Item>
        <Stack.Item>
          <NumberInput
            animated
            width="2.6em"
            height="1.65"
            step={1}
            stepPixelSize={8}
            minValue={1}
            maxValue={10}
            value={num_copies}
            onDrag={(value) =>
              act('set_copies', {
                num_copies: value,
              })
            }
          />
        </Stack.Item>
        <Stack.Item>
          <Button
            ml={0.2}
            icon="copy"
            textAlign="center"
            onClick={() => act('make_copy')}
          >
            Copy
          </Button>
        </Stack.Item>
      </Stack>
      <Button
        mt={0.5}
        textAlign="center"
        icon="reply"
        fluid
        onClick={() => act('remove')}
      >
        Remove item
      </Button>
    </Section>
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
