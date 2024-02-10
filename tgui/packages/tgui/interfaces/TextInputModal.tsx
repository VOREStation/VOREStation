import { useState } from 'react';

import { useBackend } from '../backend';
import { Box, Section, Stack, TextArea } from '../components';
import { Window } from '../layouts';
import { InputButtons } from './common/InputButtons';
import { Loader } from './common/Loader';

type TextInputData = {
  large_buttons: boolean;
  max_length: number;
  message: string;
  multiline: boolean;
  placeholder: string;
  timeout: number;
  title: string;
  prevent_enter: boolean;
};

export const TextInputModal = (props) => {
  const { act, data } = useBackend<TextInputData>();
  const {
    large_buttons,
    max_length,
    message = '',
    multiline,
    placeholder = '',
    timeout,
    title,
    prevent_enter,
  } = data;
  const [input, setInput] = useState(placeholder || '');
  const onType = (value: string) => {
    if (value === input) {
      return;
    }
    setInput(value);
  };
  // Dynamically changes the window height based on the message.
  const windowHeight =
    135 +
    (message.length > 30 ? Math.ceil(message.length / 4) : 0) +
    (multiline || input.length >= 30 ? 75 : 0) +
    (message.length && large_buttons ? 5 : 0);

  return (
    <Window title={title} width={325} height={windowHeight}>
      {timeout && <Loader value={timeout} />}
      <Window.Content
        onEscape={() => act('cancel')}
        onEnter={(event) => {
          if (!prevent_enter) {
            act('submit', { entry: input });
            event.preventDefault();
          }
        }}
      >
        <Section fill>
          <Stack fill vertical>
            <Stack.Item>
              <Box color="label">{message}</Box>
            </Stack.Item>
            <Stack.Item grow>
              <InputArea input={input} onType={onType} />
            </Stack.Item>
            <Stack.Item>
              <InputButtons
                input={input}
                message={`${input.length}/${max_length}`}
              />
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};

/** Gets the user input and invalidates if there's a constraint. */
const InputArea = (props: {
  input: string;
  onType: (value: string) => void;
}) => {
  const { act, data } = useBackend<TextInputData>();
  const { max_length, multiline, prevent_enter } = data;
  const { input, onType } = props;

  return (
    <TextArea
      autoFocus
      autoSelect
      height={multiline || input.length >= 30 ? '100%' : '1.8rem'}
      maxLength={max_length}
      onEscape={() => act('cancel')}
      onEnter={(event) => {
        if (!prevent_enter) {
          act('submit', { entry: input });
          event.preventDefault();
        }
      }}
      onInput={(_, value) => onType(value)}
      placeholder="Type something..."
      value={input}
    />
  );
};
