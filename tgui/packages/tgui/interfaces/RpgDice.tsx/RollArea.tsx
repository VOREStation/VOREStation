import { Fragment, type RefObject, useEffect, useRef } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Section, Stack } from 'tgui-core/components';
import { stateToColor } from './constants';
import type { Data, Result } from './types';

export const RollArea = (props) => {
  const { act, data } = useBackend<Data>();

  const { last_rolls } = data;

  const messagesEndRef: RefObject<HTMLDivElement | null> = useRef(null);

  useEffect(() => {
    const scroll = messagesEndRef.current;
    if (!scroll) return;

    const isAtBottom =
      Math.abs(scroll.scrollHeight - scroll.scrollTop - scroll.offsetHeight) <
      48;

    if (isAtBottom) {
      scroll.scrollTop = scroll.scrollHeight;
    }
  }, [last_rolls]);

  return (
    <Section
      title="Roll history"
      ref={messagesEndRef}
      scrollable
      fill
      buttons={
        <Button.Confirm onBlur={() => act('clear_history')} icon="trash" />
      }
    >
      <Stack vertical fill>
        {last_rolls.map((roll, index) => (
          <Stack.Item key={index}>
            <Box inline color="label">
              {roll.player}:
            </Box>
            <Box inline bold>
              {roll.count}
            </Box>
            {!!roll.size && (
              <Box inline bold>
                d{roll.size}
              </Box>
            )}
            {!!roll.mod && (
              <Box bold inline>
                +{roll.mod}
              </Box>
            )}
            <Box inline preserveWhitespace>
              {`: `}
            </Box>
            {!!roll.results && (
              <DetailedResults
                results={roll.results}
                mod={roll.mod || 0}
                applyToAll={!!roll.apply_to_all}
              />
            )}
            {(!roll.results || roll.results.length > 1 || !!roll.mod) && (
              <Box inline bold>
                {roll.sum}
              </Box>
            )}
          </Stack.Item>
        ))}
      </Stack>
    </Section>
  );
};

export const DetailedResults = (props: {
  results: Result[];
  mod: number;
  applyToAll: boolean;
}) => {
  const { results, mod, applyToAll } = props;

  const moreThanOne = results.length > 1;

  return (
    <>
      {!!mod && !applyToAll && moreThanOne && <Box inline>{`(`}</Box>}
      {results.map((result, index) => (
        <Fragment key={index}>
          {!!mod && applyToAll && moreThanOne && <Box inline>{`(`}</Box>}
          <Box
            inline
            color={stateToColor[result.state]}
            bold={!!stateToColor[result.state] || !moreThanOne}
          >
            {result.result}
          </Box>
          <Box inline preserveWhitespace>
            {!!mod && applyToAll && ` + ${mod}`}
            {!!mod && applyToAll && !!moreThanOne && `)`}
          </Box>
          {(moreThanOne || !!mod) &&
            (index < results.length - 1 ? (
              <Box inline preserveWhitespace>{` + `}</Box>
            ) : (
              <Box inline preserveWhitespace>
                {!!mod && !applyToAll && !!moreThanOne && `)`}
                {!!mod && !applyToAll && ` + ${mod}`}
                {` = `}
              </Box>
            ))}
        </Fragment>
      ))}
    </>
  );
};
