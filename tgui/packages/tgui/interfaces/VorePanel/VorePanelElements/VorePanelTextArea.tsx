import { type ReactNode, useEffect, useRef, useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Divider,
  Floating,
  Icon,
  Stack,
  TextArea,
} from 'tgui-core/components';

import { SYNTAX_COLOR, SYNTAX_REGEX } from '../constants';
import { calcLineHeight } from '../functions';

const DescriptionSyntaxHighlighting = (props: { desc: string }) => {
  const { desc } = props;
  const [htmlDesc, setHtmlDesc] = useState<ReactNode[]>([]);

  useEffect(() => {
    if (!desc || desc.length === 0) {
      setHtmlDesc([]);
      return;
    }

    const elements: ReactNode[] = [];

    const regexCopy = new RegExp(SYNTAX_REGEX);

    let lastIndex = 0;
    let result;
    while ((result = regexCopy.exec(desc)) !== null) {
      elements.push(<>{desc.substring(lastIndex, result.index)}</>);
      elements.push(
        <Box inline color={SYNTAX_COLOR[result[0]] || 'purple'}>
          {result[0]}
        </Box>,
      );
      lastIndex = result.index + result[0].length;
    }

    elements.push(<>{desc.substring(lastIndex)}</>);

    setHtmlDesc(elements);
  }, [desc]);

  return <Box preserveWhitespace>{htmlDesc}</Box>;
};

const CountedTextElement = (props: {
  limit: number;
  entry: string;
  action: Function;
  index?: number;
}) => {
  const { entry, limit, action, index } = props;

  const ref = useRef<HTMLTextAreaElement | null>(null);

  const currentCount = ref.current?.value.length || 0;
  return (
    <>
      <Stack.Item grow>
        <TextArea
          height="100%"
          minHeight={calcLineHeight(limit, 16)}
          fluid
          ref={ref}
          maxLength={limit}
          value={entry}
          onBlur={(value) => {
            if (value !== entry) {
              action(value, index);
            }
          }}
        />
      </Stack.Item>
      <Stack.Item>
        <Stack>
          <Stack.Item grow />
          <Stack.Item>
            <Box color="label">{currentCount + ' / ' + limit}</Box>
          </Stack.Item>
          <Stack.Item grow />
        </Stack>
      </Stack.Item>
    </>
  );
};

const AreaMapper = (props: {
  limit: number;
  entry: string[];
  action: Function;
  exactLength: boolean;
  maxEntries: number;
}) => {
  const { entry, limit, action, exactLength, maxEntries } = props;

  const filledArray = [
    ...entry,
    ...new Array(maxEntries - entry.length).fill(''),
  ];

  function performAction(value: string, index: number) {
    const newEntry = [...filledArray];
    newEntry[index] = value;
    if (exactLength) {
      action(newEntry);
      return;
    }
    const filtered = newEntry.filter(Boolean);
    action(filtered);
  }

  return filledArray.map((singleEntry, index) => (
    <CountedTextElement
      key={index}
      limit={limit}
      entry={singleEntry}
      action={performAction}
      index={index}
    />
  ));
};

export const VorePanelEditTextArea = (props: {
  /** Switch between Element editing and display */
  editMode: boolean;
  /** Our backend action on text area blur */
  action: string;
  /** Our secondary backend action on text area blur */
  subAction?: string;
  /** Our secondary backend action if we used a list as input on text area blur */
  listAction?: string;
  /** Our displayed tooltip displayed above all texts */
  tooltip?: string;
  /** The maximum length of each message */
  limit: number;
  /** The current displayed message or message array */
  entry: string | string[];
  /** Do we force the input to always send the maxEntries as list length to byond */
  exactLength?: boolean;
  /** The amount of possible list entries. By default 10 */
  maxEntries?: number;
  /** Should we disbale the copy paste legacy field for text to list inputs */
  disableLegacyInput?: boolean;
  /** Disable our special highlighting used on belly messages */
  noHighlight?: boolean;
}) => {
  const { act } = useBackend();

  const {
    entry,
    editMode,
    tooltip,
    limit,
    action,
    exactLength = false,
    listAction,
    subAction = '',
    maxEntries = 10,
    disableLegacyInput = false,
    noHighlight,
  } = props;

  function doAct(value: string | string[]) {
    if (Array.isArray(value)) {
      act(action, { attribute: listAction, msgtype: subAction, val: value });
      return;
    }
    act(action, { attribute: subAction, val: value });
  }

  function applyPaste(value: string) {
    Array.isArray(entry) ? doAct(value.split('\n\n')) : doAct(value);
  }

  return editMode ? (
    <Stack fill vertical>
      {!!tooltip && (
        <Stack.Item>
          <Box color="label">{tooltip}</Box>
        </Stack.Item>
      )}
      {!disableLegacyInput && Array.isArray(entry) && (
        <Stack.Item>
          <Floating
            placement="bottom-start"
            contentClasses="VorePanel__pasteArea"
            content={
              <Stack fill vertical>
                <Stack.Item>
                  <Box color="label">
                    {
                      'Copy paste the fields as legacy block text. Use "Enter" to apply. "Shift + Enter" for new lines.'
                    }
                  </Box>
                </Stack.Item>
                <Stack.Item grow>
                  <TextArea
                    height="100%"
                    fluid
                    value={Array.isArray(entry) ? entry.join('\n\n') : entry}
                    onEnter={(value) => applyPaste(value)}
                  />
                </Stack.Item>
              </Stack>
            }
          >
            <Box className="VorePanel__floatingButton">
              <Icon name="paste" />
            </Box>
          </Floating>
        </Stack.Item>
      )}
      <Stack.Item>
        {Array.isArray(entry) ? (
          <AreaMapper
            limit={limit}
            entry={entry}
            exactLength={exactLength}
            action={doAct}
            maxEntries={maxEntries}
          />
        ) : (
          <CountedTextElement limit={limit} entry={entry} action={doAct} />
        )}
      </Stack.Item>
    </Stack>
  ) : Array.isArray(entry) ? (
    <Stack vertical g={1}>
      {entry.map((singleEntry, index) => (
        <Stack.Item key={index}>
          <Divider />
          {noHighlight ? (
            <Box preserveWhitespace>{singleEntry}</Box>
          ) : (
            <DescriptionSyntaxHighlighting desc={singleEntry} />
          )}
        </Stack.Item>
      ))}
    </Stack>
  ) : !noHighlight ? (
    <Box preserveWhitespace>{entry}</Box>
  ) : (
    <DescriptionSyntaxHighlighting desc={entry} />
  );
};
