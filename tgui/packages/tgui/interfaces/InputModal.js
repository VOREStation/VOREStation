/**
 * @file
 * @copyright 2021 Leshana
 * @license MIT
 */

import { clamp01 } from 'common/math';
import { useBackend, useLocalState } from '../backend';
import { Box, Button, Section, Input, Stack, TextArea } from '../components';
import { KEY_ESCAPE } from 'common/keycodes';
import { Window } from '../layouts';
import { createLogger } from '../logging';

const logger = createLogger('inputmodal');

export const InputModal = (props, context) => {
  const { act, data } = useBackend(context);
  const { title, message, initial, input_type, timeout } = data;

  // Current Input Value
  const [curValue, setCurValue] = useLocalState(context, 'curValue', initial);

  const handleKeyDown = e => {
    if (e.keyCode === KEY_ESCAPE) {
      e.preventDefault();
      act("cancel");
      return;
    }
  };

  let initialHeight, initialWidth;
  let modalBody;
  switch (input_type) {
    case 'text':
    case 'num':
      initialWidth = 325;
      initialHeight = Math.max(150, message.length);
      modalBody = (
        <Input
          value={initial}
          width="100%"
          autoFocus
          autoSelect
          onKeyDown={handleKeyDown}
          onChange={(_e, val) => {
            setCurValue(val);
          }}
          onEnter={(_e, val) => {
            act('choose', { choice: val });
          }}
        />
      );
      break;
    case 'message':
      initialWidth = 450;
      initialHeight = 350;
      modalBody = (
        <TextArea
          value={initial}
          width="100%"
          height="100%"
          autoFocus
          dontUseTabForIndent
          onKeyDown={handleKeyDown}
          onChange={(_e, val) => {
            setCurValue(val);
          }}
        />
      );
      break;
  }

  return (
    <Window title={title} theme="abstract" width={initialWidth} height={initialHeight}>
      {timeout !== undefined && <Loader value={timeout} />}
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item grow>
            <Section fill scrollable className="InputModal__Section" title={message} tabIndex={0}>
              {modalBody}
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Stack textAlign="center">
              <Stack.Item grow basis={0}>
                <Button
                  fluid
                  color="good"
                  lineHeight={2}
                  content="Confirm"
                  onClick={() => act('choose', { choice: curValue })}
                />
              </Stack.Item>
              <Stack.Item grow basis={0}>
                <Button fluid color="bad" lineHeight={2} content="Cancel" onClick={() => act('cancel')} />
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

export const Loader = (props) => {
  const { value } = props;
  return (
    <div className="InputModal__Loader">
      <Box
        className="InputModal__LoaderProgress"
        style={{
          width: clamp01(value) * 100 + '%',
        }}
      />
    </div>
  );
};
