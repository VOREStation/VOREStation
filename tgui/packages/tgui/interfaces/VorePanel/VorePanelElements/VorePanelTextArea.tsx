import { type ReactNode, useEffect, useRef, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Stack, TextArea } from 'tgui-core/components';

import { SYNTAX_COLOR, SYNTAX_REGEX } from '../constants';

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
  maxEntries: number;
}) => {
  const { entry, limit, action, maxEntries } = props;

  const filledArray = [
    ...entry,
    ...new Array(maxEntries - entry.length).fill(''),
  ];

  function performAction(value: string, index: number) {
    const newEntry = [...entry];
    newEntry[index] = value;
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
  editMode: boolean;
  tooltip?: string;
  limit: number;
  entry: string | string[];
  action: string;
  listAction?: string;
  subAction: string;
  maxEntries?: number;
}) => {
  const { act } = useBackend();

  const {
    entry,
    editMode,
    tooltip,
    limit,
    action,
    listAction,
    subAction,
    maxEntries = 10,
  } = props;

  function doAct(value: string | string[]) {
    if (Array.isArray(value)) {
      act(action, { attribute: listAction, msgtype: subAction, val: value });
      return;
    }
    act(action, { attribute: subAction, val: value });
  }

  return editMode ? (
    <Stack fill vertical>
      {!!tooltip && (
        <Stack.Item>
          <Box color="label">{tooltip}</Box>
        </Stack.Item>
      )}
      {Array.isArray(entry) ? (
        <AreaMapper
          limit={limit}
          entry={entry}
          action={doAct}
          maxEntries={maxEntries}
        />
      ) : (
        <CountedTextElement limit={limit} entry={entry} action={doAct} />
      )}
    </Stack>
  ) : Array.isArray(entry) ? (
    <Stack vertical g={2}>
      {entry.map((singleEntry, index) => (
        <Stack.Item key={index}>
          <DescriptionSyntaxHighlighting desc={singleEntry} />
        </Stack.Item>
      ))}
    </Stack>
  ) : (
    <DescriptionSyntaxHighlighting desc={entry} />
  );
};
