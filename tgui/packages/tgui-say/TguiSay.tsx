import './styles/main.scss';

import { FormEvent, KeyboardEvent, useEffect, useRef, useState } from 'react';
import { dragStartHandler } from 'tgui/drag';
import { isEscape, KEY } from 'tgui-core/keys';
import { clamp } from 'tgui-core/math';
import { type BooleanLike, classes } from 'tgui-core/react';

import { Channel, ChannelIterator } from './ChannelIterator';
import { ChatHistory } from './ChatHistory';
import { LineLength, RADIO_PREFIXES, WindowSize } from './constants';
import {
  getMarkupString,
  getPrefix,
  windowClose,
  windowOpen,
  windowSet,
} from './helpers';
import { byondMessages } from './timers';

type ByondOpen = {
  channel: Channel;
};

type ByondProps = {
  maxLength: number;
  minimumHeight: number;
  minimumWidth: number;
  lightMode: BooleanLike;
};

const ROWS: Record<keyof typeof WindowSize, number> = {
  Small: 1,
  Medium: 2,
  Large: 3,
  Max: 20,
  Width: 360,
  MaxWidth: 800,
} as const;

export function TguiSay() {
  const innerRef = useRef<HTMLTextAreaElement>(null);
  const channelIterator = useRef(new ChannelIterator());
  const chatHistory = useRef(new ChatHistory());
  const messages = useRef(byondMessages);

  // I initially wanted to make these an object or a reducer, but it's not really worth it.
  // You lose the granulatity and add a lot of boilerplate.
  const [buttonContent, setButtonContent] = useState('');
  const [currentPrefix, setCurrentPrefix] = useState<
    keyof typeof RADIO_PREFIXES | null
  >(null);
  const [size, setSize] = useState(WindowSize.Small);
  const [maxLength, setMaxLength] = useState(1024);
  const [minimumHeight, setMinimumHeight] = useState(WindowSize.Small);
  const [minimumWidth, setMinimumWidth] = useState(WindowSize.Width);
  const [lightMode, setLightMode] = useState(false);
  const [position, setPosition] = useState([window.screenX, window.screenY]);
  const [value, setValue] = useState('');

  function handleArrowKeys(direction: KEY.PageUp | KEY.PageDown): void {
    const chat = chatHistory.current;
    const iterator = channelIterator.current;

    if (direction === KEY.PageUp) {
      if (chat.isAtLatest() && value) {
        // Save current message to temp history if at the most recent message
        chat.saveTemp(value);
      }
      // Try to get the previous message, fall back to the current value if none
      const prevMessage = chat.getOlderMessage();

      if (prevMessage) {
        setButtonContent(chat.getIndex().toString());
        setValue(prevMessage);
      }
    } else {
      const nextMessage = chat.getNewerMessage() || chat.getTemp() || '';

      const newContent = chat.isAtLatest()
        ? iterator.current()
        : chat.getIndex().toString();

      setButtonContent(newContent);
      setValue(nextMessage);
    }
  }

  function handleBackspaceDelete(): void {
    const chat = chatHistory.current;
    const iterator = channelIterator.current;

    // User is on a chat history message
    if (!chat.isAtLatest()) {
      chat.reset();
      setButtonContent(currentPrefix ?? iterator.current());

      // Empty input, resets the channel
    } else if (currentPrefix && iterator.isSay() && value?.length === 0) {
      setCurrentPrefix(null);
      setButtonContent(iterator.current());
    }
  }

  function handleClose(): void {
    innerRef.current?.blur();
    windowClose();

    setTimeout(() => {
      chatHistory.current.reset();
      channelIterator.current.reset();
      unloadChat();
    }, 25);
  }

  function handleEnter(): void {
    const iterator = channelIterator.current;
    const prefix = currentPrefix ?? '';

    if (value?.length && value.length < maxLength) {
      chatHistory.current.add(value);
      Byond.sendMessage('entry', {
        channel: iterator.current(),
        entry: iterator.isSay() ? prefix + value : value,
      });
    }

    handleClose();
  }

  function handleForceSay(): void {
    const iterator = channelIterator.current;

    // Only force say if we're on a visible channel and have typed something
    if (!value || iterator.isVisible()) return;

    const prefix = currentPrefix ?? '';
    const grunt = iterator.isSay() ? prefix + value : value;

    messages.current.forceSayMsg(grunt);
    unloadChat();
  }

  function handleIncrementChannel(): void {
    const xPos = window.screenX;
    const yPos = window.screenY;
    if (JSON.stringify(position) !== JSON.stringify([xPos, yPos])) return;
    const iterator = channelIterator.current;

    iterator.next();
    setButtonContent(iterator.current());
    setCurrentPrefix(null);
    messages.current.channelIncrementMsg(
      iterator.isVisible(),
      iterator.current(),
    );
  }

  function handleDecrementChannel() {
    const iterator = channelIterator.current;

    iterator.prev();
    setButtonContent(iterator.current());
    setCurrentPrefix(null);
    messages.current.channelIncrementMsg(
      iterator.isVisible(),
      iterator.current(),
    );
  }

  function handleInput(event: FormEvent<HTMLTextAreaElement>): void {
    const iterator = channelIterator.current;
    let newValue = event.currentTarget.value;

    let newPrefix = getPrefix(newValue) || currentPrefix;
    // Handles switching prefixes
    if (newPrefix && newPrefix !== currentPrefix) {
      setButtonContent(RADIO_PREFIXES[newPrefix]);
      setCurrentPrefix(newPrefix);
      newValue = newValue.slice(3);
      iterator.set('Say');

      if (newPrefix === ',b ') {
        Byond.sendMessage('thinking', { visible: false });
      }
    }

    // Handles typing indicators
    if (channelIterator.current.isVisible() && newPrefix !== ',b ') {
      messages.current.typingMsg(iterator.current());
    }

    setValue(newValue);
  }

  function handleKeyDown(event: KeyboardEvent<HTMLTextAreaElement>): void {
    if (event.getModifierState('AltGraph')) return;

    switch (event.key) {
      case 'u': // replace with tgui core 1.8.x
        if (event.ctrlKey || event.metaKey) {
          event.preventDefault();
          const { value, selectionStart, selectionEnd } = event.currentTarget;
          event.currentTarget.value = getMarkupString(
            value,
            '_',
            selectionStart,
            selectionEnd,
          );
          event.currentTarget.selectionEnd = selectionEnd + 2;
        }
        break;
      case 'i': // replace with tgui core 1.8.x
        if (event.ctrlKey || event.metaKey) {
          event.preventDefault();
          const { value, selectionStart, selectionEnd } = event.currentTarget;
          event.currentTarget.value = getMarkupString(
            value,
            '|',
            selectionStart,
            selectionEnd,
          );
          event.currentTarget.selectionEnd = selectionEnd + 2;
        }
        break;
      case 'b': // replace with tgui core 1.8.x
        if (event.ctrlKey || event.metaKey) {
          event.preventDefault();
          const { value, selectionStart, selectionEnd } = event.currentTarget;
          event.currentTarget.value = getMarkupString(
            value,
            '+',
            selectionStart,
            selectionEnd,
          );
          event.currentTarget.selectionEnd = selectionEnd + 2;
        }
        break;
      case KEY.PageUp:
      case KEY.PageDown:
        event.preventDefault();
        handleArrowKeys(event.key);
        break;

      case KEY.Delete:
      case KEY.Backspace:
        handleBackspaceDelete();
        break;

      case KEY.Enter:
        if (!event.shiftKey) {
          event.preventDefault();
          handleEnter();
        }
        break;

      case KEY.Tab:
        event.preventDefault();
        if (event.shiftKey) {
          handleDecrementChannel();
          break;
        }
        handleIncrementChannel();
        break;

      default:
        if (isEscape(event.key)) {
          handleClose();
        }
    }
  }

  function handleButtonDrag(e: React.MouseEvent<Element, MouseEvent>): void {
    const xPos = window.screenX;
    const yPos = window.screenY;
    setPosition([xPos, yPos]);
    dragStartHandler(e);
  }

  function handleOpen(data: ByondOpen): void {
    setTimeout(() => {
      innerRef.current?.focus();
      windowSet(WindowSize.Width, WindowSize.Small);
      setSize(WindowSize.Width);
    }, 1);

    const { channel } = data;
    const iterator = channelIterator.current;
    // Catches the case where the modal is already open
    if (iterator.isSay()) {
      iterator.set(channel);
    }

    setButtonContent(iterator.current());
    windowOpen(iterator.current());
  }

  function handleProps(data: ByondProps): void {
    setMaxLength(data.maxLength);
    setMinimumHeight(data.minimumHeight);
    const minWidth = clamp(
      data.minimumWidth,
      WindowSize.Width,
      WindowSize.MaxWidth,
    );
    setMinimumWidth(minWidth);
    setLightMode(!!data.lightMode);
  }

  function unloadChat(): void {
    setCurrentPrefix(null);
    setButtonContent(channelIterator.current.current());
    setValue('');
  }

  /** Subscribe to Byond messages */
  useEffect(() => {
    Byond.subscribeTo('props', handleProps);
    Byond.subscribeTo('force', handleForceSay);
    Byond.subscribeTo('open', handleOpen);
  }, []);

  /** Value has changed, we need to check if the size of the window is ok */
  useEffect(() => {
    const len = value?.length || 0;

    let newSize: WindowSize;
    if (len > LineLength.Medium) {
      newSize = WindowSize.Large;
    } else if (len <= LineLength.Medium && len > LineLength.Small) {
      newSize = WindowSize.Medium;
    } else {
      newSize = WindowSize.Small;
    }
    newSize = clamp(newSize, minimumHeight * 20 + 10, WindowSize.Max);

    if (size !== newSize) {
      setSize(newSize);
      windowSet(minimumWidth, newSize);
    }
  }, [value]);

  const theme =
    (lightMode && 'lightMode') ||
    (currentPrefix && RADIO_PREFIXES[currentPrefix]) ||
    channelIterator.current.current();

  return (
    <>
      <div
        className={`window window-${theme} window-${size}`}
        onMouseDown={dragStartHandler}
      >
        {!lightMode && <div className={`shine shine-${theme}`} />}
      </div>
      <div className={classes(['content', lightMode && 'content-lightMode'])}>
        <button
          className={`button button-${theme}`}
          onClick={handleIncrementChannel}
          onMouseDown={handleButtonDrag}
          type="button"
        >
          {buttonContent}
        </button>
        <textarea
          autoCorrect="off"
          className={`textarea textarea-${theme}`}
          maxLength={maxLength}
          onInput={handleInput}
          onKeyDown={handleKeyDown}
          ref={innerRef}
          spellCheck={false}
          rows={ROWS[size] || 1}
          value={value}
        />
      </div>
    </>
  );
}
