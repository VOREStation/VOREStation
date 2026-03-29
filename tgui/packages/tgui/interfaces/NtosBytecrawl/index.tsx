import { type KeyboardEvent, useEffect, useRef, useState } from 'react';

import { storage } from 'common/storage';
import { useBackend } from 'tgui/backend';
import { NtosWindow } from 'tgui/layouts';
import { Box } from 'tgui-core/components';

import { doAutocomplete, execCommand } from './commands';
import type { CommandContext } from './commands';
import { STORAGE_KEY } from './store';
import type { GState, Line, ScanEntry } from './types';
import { useGameLoop } from './hooks';
import { defaultState, getMaxSlots, getTraceStatus } from './utils';
import { Terminal } from './Terminal';

const W = 720;
const H = 540;

export const NtosBytecrawl = (_props: unknown) => {
  const { act } = useBackend();

  // ── Terminal output lines ──────────────────────────────────────────────────
  const [lines, setLines] = useState<Line[]>([]);
  const outputRef = useRef<HTMLDivElement>(null);

  // Auto-scroll output to bottom on new lines
  useEffect(() => {
    if (outputRef.current) {
      outputRef.current.scrollTop = outputRef.current.scrollHeight;
    }
  }, [lines]);

  // ── Game state ─────────────────────────────────────────────────────────────
  // Persisted via common/storage — load on mount, save on every change.
  const [g, setG] = useState<GState>(defaultState());
  const gRef = useRef<GState>(g);
  useEffect(() => {
    gRef.current = g;
  }, [g]);

  // Load persisted save on mount
  useEffect(() => {
    const load = async () => {
      const saved = await storage.get(STORAGE_KEY);
      if (saved) setG(saved as GState);
    };
    load();
  }, []);

  // Persist on every state change
  useEffect(() => {
    storage.set(STORAGE_KEY, g);
  }, [g]);

  // ── Scan pool (client-side, regenerated per scan command) ──────────────────
  const scanPool = useRef<ScanEntry[]>([]);

  // ── Command input state ────────────────────────────────────────────────────
  const [input, setInput] = useState('');
  const [cmdHistory, setCmdHistory] = useState<string[]>([]);
  const [histIdx, setHistIdx] = useState(-1);
  const inputRef = useRef<HTMLInputElement>(null);

  // ── Setup screen input ─────────────────────────────────────────────────────
  const [setupInput, setSetupInput] = useState('');

  // ── Game loop (tick + market tick intervals) ───────────────────────────────
  useGameLoop(g.phase, gRef, setG, setLines, act);

  // ── Helpers ────────────────────────────────────────────────────────────────
  const print = (text: string, color?: string) =>
    setLines((prev) => [...prev, { text, color }]);

  const clearLines = () => setLines([]);

  // ── Command context ────────────────────────────────────────────────────────
  const ctx: CommandContext = {
    gRef,
    setG,
    print,
    clearLines,
    act,
    scanPool,
  };

  // ── Keyboard handler (main terminal) ──────────────────────────────────────
  const handleKey = (e: KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'Enter') {
      const raw = input;
      setInput('');
      setHistIdx(-1);
      if (raw.trim()) {
        setCmdHistory((h) => [raw.trim(), ...h.slice(0, 49)]);
      }
      execCommand(raw, ctx);
    } else if (e.key === 'ArrowUp') {
      e.preventDefault();
      setHistIdx((i) => {
        const ni = Math.min(i + 1, cmdHistory.length - 1);
        if (cmdHistory[ni]) setInput(cmdHistory[ni]);
        return ni;
      });
    } else if (e.key === 'ArrowDown') {
      e.preventDefault();
      setHistIdx((i) => {
        const ni = Math.max(i - 1, -1);
        if (ni === -1) setInput('');
        else if (cmdHistory[ni]) setInput(cmdHistory[ni]);
        return ni;
      });
    } else if (e.key === 'ArrowRight') {
      const el = inputRef.current;
      if (el && el.selectionStart === input.length) {
        const completed = doAutocomplete(input, gRef, scanPool);
        if (completed !== input) {
          e.preventDefault();
          setInput(completed);
        }
      }
    }
  };

  // ── Keyboard handler (setup screen) ───────────────────────────────────────
  const handleSetupKey = (e: KeyboardEvent<HTMLInputElement>) => {
    if (e.key !== 'Enter') return;
    const name = setupInput.trim() || 'ghost';
    setG((prev) => ({ ...prev, handle: name, phase: 'playing' }));
    act('init', { handle: name });
    print(`Identity locked: ${name}`, '#33ff33');
    print('');
    print('BYTECRAWL v1.0 ready. Type help for commands.');
    print('Start with: scan');
    print('');
  };

  // ── Header data ────────────────────────────────────────────────────────────
  const { label: traceLabel, color: traceColor } = getTraceStatus(g.trace);
  const activeSlots = g.jobs.filter((j) => j.state === 'cracking').length;
  const maxSlots = getMaxSlots(g);
  const headerSlots = [
    { text: `BYTECRAWL v1.0 // ${g.handle}${g.ascCount > 0 ? ` [ASC-${g.ascCount}]` : ''}` },
    { text: `TRACE: ${g.trace.toFixed(1)}% [${traceLabel}]`, color: traceColor },
    { text: `WALLET: $${Math.floor(g.wallet)}` },
    { text: `SLOTS: ${activeSlots}/${maxSlots}` },
  ];

  // ── Render ─────────────────────────────────────────────────────────────────
  return (
    <NtosWindow width={W + 40} height={H + 60}>
      <NtosWindow.Content>
        <Box onClick={() => inputRef.current?.focus()}>
          {g.phase === 'setup' ? (
            <Terminal
              lines={[]}
              outputRef={outputRef}
              input={setupInput}
              onInput={setSetupInput}
              onKeyDown={handleSetupKey}
              inputRef={inputRef}
              prompt=">"
              headerSlots={[]}
              setupContent={
                'BYTECRAWL v1.0\nCLI HACKING TERMINAL\n========================\n\nConnecting to darknet...\nAnonymising route...\nRoute established.\n\nEnter handle (operator alias):'
              }
            />
          ) : (
            <Terminal
              lines={lines}
              outputRef={outputRef}
              input={input}
              onInput={setInput}
              onKeyDown={handleKey}
              inputRef={inputRef}
              prompt={`${g.handle}@bytecrawl:~$`}
              headerSlots={headerSlots}
            />
          )}
        </Box>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
