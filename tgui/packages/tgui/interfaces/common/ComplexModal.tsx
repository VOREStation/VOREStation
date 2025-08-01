import { type KeyboardEvent, useRef, useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Dropdown,
  Image,
  Input,
  Modal,
  Stack,
} from 'tgui-core/components';

// biome-ignore lint/complexity/noBannedTypes: In this case, we got any type of Object
type Data = { modal: { id: string; args: {}; text: string; type: string } };
const bodyOverrides = {};

/**
 * Sends a call to BYOND to open a modal
 * @param {string} id The identifier of the modal
 * @param {object=} args The arguments to pass to the modal
 */
export const modalOpen = (id, args = {}) => {
  const { act, data } = useBackend<Data>();

  const { modal } = data;

  const newArgs = Object.assign(modal ? modal.args : {}, args || {});

  act('modal_open', {
    id: id,
    arguments: JSON.stringify(newArgs),
  });
};

/**
 * Registers an override for any modal with the given id
 * @param {string} id The identifier of the modal
 * @param {function} bodyOverride The override function that returns the
 *    modal contents
 */
export const modalRegisterBodyOverride = (
  id: string,
  bodyOverride: (modal: {
    id: string;
    text: string;
    // biome-ignore lint/complexity/noBannedTypes: In this case, we got any type of Object
    args: {};
    type: string;
  }) => React.JSX.Element,
) => {
  bodyOverrides[id] = bodyOverride;
};

// biome-ignore lint/complexity/noBannedTypes: In this case, we got any type of Object
const modalAnswer = (id: string, answer: string, args: {}) => {
  const { act, data } = useBackend<Data>();

  const { modal } = data;

  if (!modal) {
    return;
  }

  const newArgs = Object.assign(modal.args || {}, args || {});
  act('modal_answer', {
    id: id,
    answer: answer,
    arguments: JSON.stringify(newArgs),
  });
};

const modalClose = (id: string | null) => {
  const { act } = useBackend();
  act('modal_close', {
    id: id,
  });
};

type complexData = Data &
  Partial<{
    modal: {
      value: string;
      choices: string[];
      no_text: string;
      yes_text: string;
    };
  }>;

/**
 * Displays a modal and its actions. Passed data must have a valid modal field
 *
 * **A valid modal field contains:**
 *
 * `id` — The identifier of the modal.
 * Used for server-client communication and overriding
 *
 * `text` — The text of the modal
 *
 * `type` — The type of the modal:
 * `message`, `input`, `choice`, `bento` and `boolean`.
 * Overriden by a body override registered to the identifier if applicable.
 * Defaults to `message` if not found
 * @param {object} props
 */
export const ComplexModal = (props) => {
  const { data } = useBackend<complexData>();

  const { modal } = data;

  if (!modal) {
    return;
  }

  const { id, text, type } = modal;

  const modalOnEscape:
    | ((e: KeyboardEvent<HTMLDivElement>) => void)
    | undefined = (e) => modalClose(id);
  let modalOnEnter: ((e: KeyboardEvent<HTMLDivElement>) => void) | undefined;
  let modalBody: React.JSX.Element | undefined;
  let modalFooter: React.JSX.Element = (
    <Button icon="arrow-left" color="grey" onClick={() => modalClose(null)}>
      Cancel
    </Button>
  );

  // Different contents depending on the type
  if (bodyOverrides[id]) {
    modalBody = bodyOverrides[id](modal);
  } else if (type === 'input') {
    const lastValue = useRef(modal.value);
    const [curValue, setCurValue] = useState(modal.value);

    if (lastValue.current !== modal.value) {
      lastValue.current = modal.value;
      setCurValue(modal.value);
    }

    modalOnEnter = (e) => modalAnswer(id, curValue, {});
    modalBody = (
      <Input
        key={id}
        value={curValue}
        placeholder="ENTER to submit"
        width="100%"
        my="0.5rem"
        autoFocus
        autoSelect
        onChange={(val) => {
          setCurValue(val);
        }}
      />
    );
    modalFooter = (
      <Box mt="0.5rem">
        <Button icon="arrow-left" color="grey" onClick={() => modalClose(null)}>
          Cancel
        </Button>
        <Button
          icon="check"
          color="good"
          style={{
            float: 'right',
          }}
          m="0"
          onClick={() => modalAnswer(id, curValue, {})}
        >
          Confirm
        </Button>
        <Box
          style={{
            clear: 'both',
          }}
        />
      </Box>
    );
  } else if (type === 'choice') {
    const realChoices =
      typeof modal.choices === 'object'
        ? Object.values(modal.choices)
        : modal.choices;
    modalBody = (
      <Dropdown
        autoScroll={false}
        options={realChoices}
        selected={modal.value}
        width="100%"
        my="0.5rem"
        onSelected={(val) => modalAnswer(id, val, {})}
      />
    );
  } else if (type === 'bento') {
    modalBody = (
      <Stack wrap="wrap" my="0.5rem" maxHeight="1%">
        {modal.choices.map((c, i) => (
          <Stack.Item key={i}>
            <Button
              selected={i + 1 === parseInt(modal.value, 10)}
              onClick={() => modalAnswer(id, (i + 1).toString(), {})}
            >
              <Image src={c} />
            </Button>
          </Stack.Item>
        ))}
      </Stack>
    );
  } else if (type === 'bentospritesheet') {
    modalBody = (
      <Stack wrap="wrap" my="0.5rem" maxHeight="1%">
        {modal.choices.map((c, i) => (
          <Stack.Item key={i}>
            <Button
              selected={i + 1 === parseInt(modal.value, 10)}
              onClick={() => modalAnswer(id, (i + 1).toString(), {})}
            >
              <Box className={c} />
            </Button>
          </Stack.Item>
        ))}
      </Stack>
    );
  } else if (type === 'boolean') {
    modalFooter = (
      <Box mt="0.5rem">
        <Button
          icon="times"
          color="bad"
          style={{
            float: 'left',
          }}
          mb="0"
          onClick={() => modalAnswer(id, '0', {})}
        >
          {modal.no_text}
        </Button>
        <Button
          icon="check"
          color="good"
          style={{
            float: 'right',
          }}
          m="0"
          onClick={() => modalAnswer(id, '1', {})}
        >
          {modal.yes_text}
        </Button>
        <Box
          style={{
            clear: 'both',
          }}
        />
      </Box>
    );
  }

  return (
    <Modal
      maxWidth={props.maxWidth || `${window.innerWidth / 2}px`}
      maxHeight={props.maxHeight || `${window.innerHeight / 2}px`}
      onEnter={modalOnEnter}
      onEscape={modalOnEscape}
      mx="auto"
    >
      <Box inline>{text}</Box>
      {modalBody}
      {modalFooter}
    </Modal>
  );
};
