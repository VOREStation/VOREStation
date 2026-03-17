import { KeyboardEvent, RefObject } from 'react';

import 'tgui/styles/themes/NtosBytecrawl.scss';

import type { Line } from './types';

type HeaderSlot = {
  text: string;
  color?: string;
};

type TerminalProps = {
  // Output lines rendered in the scrollable area
  lines: Line[];
  outputRef: RefObject<HTMLDivElement>;

  // Current input value
  input: string;
  onInput: (value: string) => void;
  onKeyDown: (e: KeyboardEvent<HTMLInputElement>) => void;
  inputRef: RefObject<HTMLInputElement>;

  // Prompt shown before the input field (e.g. "ghost@bytecrawl:~$")
  prompt: string;

  // Header bar slots — rendered left to right
  headerSlots: HeaderSlot[];

  // Setup screen: render a plain output block instead of lines + header
  setupContent?: string;
};

export function Terminal(props: TerminalProps) {
  const {
    lines,
    outputRef,
    input,
    onInput,
    onKeyDown,
    inputRef,
    prompt,
    headerSlots,
    setupContent,
  } = props;

  const inputRow = (
    <div className="bc-input-row">
      <span className="bc-prompt">{prompt + ' '}</span>
      <input
        ref={inputRef}
        className="bc-input"
        value={input}
        onChange={(e) => onInput(e.target.value)}
        onKeyDown={onKeyDown}
        autoFocus
        spellCheck={false}
      />
    </div>
  );

  return (
    <div className="bc-container">
      {/* CRT overlay effects */}
      <div className="bc-scanlines" />
      <div className="bc-vignette" />

      <div className="bc-inner">
        {setupContent !== undefined ? (
          // ── Setup screen ────────────────────────────────────────────────────
          <>
            <div className="bc-output">
              <div className="bc-line" style={{ color: '#33ff33', textShadow: '0 0 8px rgba(51,255,51,0.9)' }}>
                {setupContent}
              </div>
            </div>
            {inputRow}
          </>
        ) : (
          // ── Main game screen ─────────────────────────────────────────────────
          <>
            <div className="bc-header">
              {headerSlots.map((slot, i) => (
                <span key={i} style={slot.color ? { color: slot.color } : undefined}>
                  {slot.text}
                </span>
              ))}
            </div>
            <div ref={outputRef} className="bc-output">
              {lines.map((l, i) => (
                <div
                  key={i}
                  className="bc-line"
                  style={{
                    color: l.color || '#33ff33',
                    textShadow: `0 0 5px ${l.color || 'rgba(51,255,51,0.6)'}`,
                  }}
                >
                  {l.text}
                </div>
              ))}
            </div>
            {inputRow}
          </>
        )}
      </div>
    </div>
  );
}
