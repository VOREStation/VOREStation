import { useBackend } from '../../backend';
import { Box, Button, Dropdown, Flex, Input, Modal } from '../../components';

let bodyOverrides = {};

/**
 * Sends a call to BYOND to open a modal
 * @param {string} id The identifier of the modal
 * @param {object=} args The arguments to pass to the modal
 */
export const modalOpen = (id, args) => {
  const { act, data } = useBackend();
  const newArgs = Object.assign(data.modal ? data.modal.args : {}, args || {});

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
export const modalRegisterBodyOverride = (id, bodyOverride) => {
  bodyOverrides[id] = bodyOverride;
};

const modalAnswer = (id, answer, args) => {
  const { act, data } = useBackend();
  if (!data.modal) {
    return;
  }

  const newArgs = Object.assign(data.modal.args || {}, args || {});
  act('modal_answer', {
    id: id,
    answer: answer,
    arguments: JSON.stringify(newArgs),
  });
};

const modalClose = (id) => {
  const { act } = useBackend();
  act('modal_close', {
    id: id,
  });
};

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
  const { data } = useBackend();
  if (!data.modal) {
    return;
  }

  const { id, text, type } = data.modal;

  let modalOnEnter;
  let modalBody;
  let modalFooter = (
    <Button icon="arrow-left" color="grey" onClick={() => modalClose()}>
      Cancel
    </Button>
  );

  // Different contents depending on the type
  if (bodyOverrides[id]) {
    modalBody = bodyOverrides[id](data.modal);
  } else if (type === 'input') {
    let curValue = data.modal.value;
    modalOnEnter = (e) => modalAnswer(id, curValue);
    modalBody = (
      <Input
        value={data.modal.value}
        placeholder="ENTER to submit"
        width="100%"
        my="0.5rem"
        autoFocus
        autoSelect
        onChange={(_e, val) => {
          curValue = val;
        }}
      />
    );
    modalFooter = (
      <Box mt="0.5rem">
        <Button icon="arrow-left" color="grey" onClick={() => modalClose()}>
          Cancel
        </Button>
        <Button
          icon="check"
          color="good"
          float="right"
          m="0"
          onClick={() => modalAnswer(id, curValue)}
        >
          Confirm
        </Button>
        <Box clear="both" />
      </Box>
    );
  } else if (type === 'choice') {
    const realChoices =
      typeof data.modal.choices === 'object'
        ? Object.values(data.modal.choices)
        : data.modal.choices;
    modalBody = (
      <Dropdown
        options={realChoices}
        selected={data.modal.value}
        width="100%"
        my="0.5rem"
        onSelected={(val) => modalAnswer(id, val)}
      />
    );
  } else if (type === 'bento') {
    modalBody = (
      <Flex spacingPrecise="1" wrap="wrap" my="0.5rem" maxHeight="1%">
        {data.modal.choices.map((c, i) => (
          <Flex.Item key={i} flex="1 1 auto">
            <Button
              selected={i + 1 === parseInt(data.modal.value, 10)}
              onClick={() => modalAnswer(id, i + 1)}
            >
              <img src={c} />
            </Button>
          </Flex.Item>
        ))}
      </Flex>
    );
  } else if (type === 'bentospritesheet') {
    modalBody = (
      <Flex spacingPrecise="1" wrap="wrap" my="0.5rem" maxHeight="1%">
        {data.modal.choices.map((c, i) => (
          <Flex.Item key={i} flex="1 1 auto">
            <Button
              selected={i + 1 === parseInt(data.modal.value, 10)}
              onClick={() => modalAnswer(id, i + 1)}
            >
              <Box className={c} />
            </Button>
          </Flex.Item>
        ))}
      </Flex>
    );
  } else if (type === 'boolean') {
    modalFooter = (
      <Box mt="0.5rem">
        <Button
          icon="times"
          color="bad"
          float="left"
          mb="0"
          onClick={() => modalAnswer(id, 0)}
        >
          {data.modal.no_text}
        </Button>
        <Button
          icon="check"
          color="good"
          float="right"
          m="0"
          onClick={() => modalAnswer(id, 1)}
        >
          {data.modal.yes_text}
        </Button>
        <Box clear="both" />
      </Box>
    );
  }

  return (
    <Modal
      maxWidth={props.maxWidth || window.innerWidth / 2 + 'px'}
      maxHeight={props.maxHeight || window.innerHeight / 2 + 'px'}
      onEnter={modalOnEnter}
      mx="auto"
    >
      <Box inline>{text}</Box>
      {modalBody}
      {modalFooter}
    </Modal>
  );
};
