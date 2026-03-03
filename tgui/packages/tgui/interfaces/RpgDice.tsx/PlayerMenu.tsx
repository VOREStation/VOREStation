import { type RefObject, useRef, useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Button,
  LabeledList,
  NumberInput,
  Section,
  Stack,
} from 'tgui-core/components';
import { KEY } from 'tgui-core/keys';
import { classes } from 'tgui-core/react';
import { VorePanelTooltip } from '../VorePanel/VorePanelElements/VorePanelTooltip';
import { gameTooltip, MAX_HISTORY, presetDice } from './constants';
import type { Data } from './types';

export const PlayerMenu = (props) => {
  const { act } = useBackend<Data>();
  const [diceSize, setDiceSize] = useState(6);
  const [diceCount, setDiceCount] = useState(1);
  const [modifier, setModifier] = useState(0);
  const [applyToAll, setApplyToAll] = useState(false);
  const [customInput, setCustomInput] = useState('');

  const [history, setHistory] = useState<string[]>([]);
  const [historyIndex, setHistoryIndex] = useState<number>(-1);

  const inputRef: RefObject<HTMLInputElement | null> = useRef(null);

  function updateHistory(newEntry: string) {
    if (newEntry === history[historyIndex]) return;

    const newHistory = [...history, newEntry];

    if (newHistory.length > MAX_HISTORY) {
      newHistory.shift();
    }

    setHistory(newHistory);
    setHistoryIndex(newHistory.length);
  }

  function handleKeyDown(event: React.KeyboardEvent<HTMLInputElement>): void {
    if (event.getModifierState('AltGraph')) return;

    switch (event.key) {
      case KEY.PageUp:
        event.preventDefault();
        inputRef.current?.blur();
        handleUndo();
        requestAnimationFrame(() => inputRef.current?.focus());
        break;
      case KEY.PageDown:
        event.preventDefault();
        inputRef.current?.blur();
        handleRedo();
        requestAnimationFrame(() => inputRef.current?.focus());
        break;
    }
  }

  function handleUndo() {
    if (historyIndex > 0) {
      const prevState = history[historyIndex - 1];
      setCustomInput(prevState);
      setHistoryIndex(historyIndex - 1);
    }
    requestAnimationFrame(() => inputRef.current?.focus());
  }

  function handleRedo() {
    if (historyIndex < history.length) {
      const nextState = history[historyIndex + 1];
      setCustomInput(nextState);
      setHistoryIndex(historyIndex + 1);
    } else if (historyIndex === history.length) {
      setCustomInput('');
    }
    requestAnimationFrame(() => inputRef.current?.focus());
  }

  const firstHalf = presetDice.slice(0, 4);
  const secondHalf = presetDice.slice(4);
  return (
    <Section
      title="Dice Selection"
      fill
      buttons={
        <Stack>
          <Stack.Item>
            <Button onClick={() => act('invite_player')}>Invite Player</Button>
          </Stack.Item>
          <Stack.Item>
            <VorePanelTooltip tooltip={gameTooltip} displayText="?" />
          </Stack.Item>
        </Stack>
      }
    >
      <Stack vertical fill>
        <Stack.Item>
          <Stack>
            {firstHalf.map((dice, index) => (
              <Stack.Item grow key={index}>
                <Button
                  onClick={() => act('roll_dice', { dice_size: dice })}
                  className={classes(['RpgDice__dice', `d${dice}`, 'side'])}
                >
                  {dice}
                </Button>
              </Stack.Item>
            ))}
          </Stack>
        </Stack.Item>
        <Stack.Item>
          <Stack textAlign="center">
            {secondHalf.map((dice, index) => (
              <Stack.Item grow key={index}>
                <Button
                  onClick={() => act('roll_dice', { dice_size: dice })}
                  className={classes(['RpgDice__dice', `d${dice}`, 'side'])}
                >
                  {dice}
                </Button>
              </Stack.Item>
            ))}
          </Stack>
        </Stack.Item>
        <Stack.Divider />
        <Stack.Item>
          <Stack>
            <Stack.Item grow>
              <LabeledList>
                <LabeledList.Item label="Size">
                  <NumberInput
                    width="50px"
                    minValue={1}
                    maxValue={10000}
                    value={diceSize}
                    onChange={setDiceSize}
                  />
                </LabeledList.Item>
                <LabeledList.Item label="Count">
                  <NumberInput
                    width="50px"
                    stepPixelSize={40}
                    minValue={1}
                    maxValue={10}
                    value={diceCount}
                    onChange={setDiceCount}
                  />
                </LabeledList.Item>
                <LabeledList.Item label="Modifier">
                  <Stack>
                    <Stack.Item>
                      <NumberInput
                        width="50px"
                        value={modifier}
                        onChange={setModifier}
                      />
                      <Stack.Item inline>
                        <Button.Checkbox
                          checked={applyToAll}
                          onClick={() => setApplyToAll(!applyToAll)}
                        >
                          Apply to all
                        </Button.Checkbox>
                      </Stack.Item>
                    </Stack.Item>
                  </Stack>
                </LabeledList.Item>
              </LabeledList>
            </Stack.Item>
            <Stack.Item>
              <Button
                onClick={() =>
                  act('roll_dice', {
                    dice_size: diceSize,
                    dice_count: diceCount,
                    dice_mod: modifier,
                    mod_all: applyToAll,
                  })
                }
                icon="dice"
                iconSize={2}
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
        {/** Requires rust g dice
        <Stack.Divider />
        <Stack.Item>
          <Stack>
            <Stack.Item>
              <Button
                disabled
                onClick={handleUndo}
                icon="rotate-left"
                iconSize={2}
              />
            </Stack.Item>
            <Stack.Item grow>
              <Button
                disabled
                onClick={handleRedo}
                icon="rotate-right"
                iconSize={2}
              />
            </Stack.Item>
            <Stack.Item>
              <Button
                disabled
                onClick={() => {
                  updateHistory(customInput);
                  act('custom_roll', { custom: customInput });
                  setCustomInput('');
                  requestAnimationFrame(() => inputRef.current?.focus());
                }}
                iconSize={2}
                icon="paper-plane"
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item>
          <Stack fill>
            <Stack.Item grow>
              <Input
                disabled
                fluid
                ref={inputRef}
                onEnter={(value) => {
                  updateHistory(value);
                  act('custom_roll', { custom: value });
                  setCustomInput('');
                  requestAnimationFrame(() => inputRef.current?.focus());
                }}
                maxLength={200}
                value={customInput}
                onChange={setCustomInput}
                onKeyDown={handleKeyDown}
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
        */}
      </Stack>
    </Section>
  );
};
