import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Autofocus, Button, Input, Section, Stack } from 'tgui-core/components';
import { isAlphabetic, isNumeric, KEY } from 'tgui-core/keys';

import { InputButtons } from './common/InputButtons';
import { Loader } from './common/Loader';

type ListInputData = {
  init_value: string;
  items: string[];
  large_buttons: boolean;
  message: string;
  timeout: number;
  title: string;
};

export const ListInputModal = (props) => {
  const { act, data } = useBackend<ListInputData>();
  const {
    items = [],
    message = '',
    init_value,
    large_buttons,
    timeout,
    title,
  } = data;
  const [selected, setSelected] = useState(items.indexOf(init_value));
  const [searchBarVisible, setSearchBarVisible] = useState(items.length > 9);
  const [searchQuery, setSearchQuery] = useState('');
  // User presses up or down on keyboard
  // Simulates clicking an item

  const onArrowKey = (key: KEY) => {
    const len = filteredItems.length - 1;
    if (key === KEY.Down) {
      if (selected === null || selected === len) {
        setSelected(0);
        document!.getElementById('0')?.scrollIntoView();
      } else {
        setSelected(selected + 1);
        document!.getElementById((selected + 1).toString())?.scrollIntoView();
      }
    } else if (key === KEY.Up) {
      if (selected === null || selected === 0) {
        setSelected(len);
        document!.getElementById(len.toString())?.scrollIntoView();
      } else {
        setSelected(selected - 1);
        document!.getElementById((selected - 1).toString())?.scrollIntoView();
      }
    }
  };
  // User selects an item with mouse
  const onClick = (index: number) => {
    if (index === selected) {
      return;
    }
    setSelected(index);
  };
  // User presses a letter key and searchbar is visible
  const onFocusSearch = () => {
    setSearchBarVisible(false);
    setTimeout(() => {
      setSearchBarVisible(true);
    }, 1);
  };
  // User presses a letter key with no searchbar visible
  const onLetterSearch = (key: string) => {
    const foundItem = items.find((item) => {
      return item?.toLowerCase().startsWith(key?.toLowerCase());
    });
    if (foundItem) {
      const foundIndex = items.indexOf(foundItem);
      setSelected(foundIndex);
      document!.getElementById(foundIndex.toString())?.scrollIntoView();
    }
  };
  // User types into search bar
  const onSearch = (query: string) => {
    if (query === searchQuery) {
      return;
    }
    setSearchQuery(query);
    setSelected(0);
    document!.getElementById('0')?.scrollIntoView();
  };
  // User presses the search button
  const onSearchBarToggle = () => {
    setSearchBarVisible(!searchBarVisible);
    setSearchQuery('');
  };
  const filteredItems = items.filter((item) =>
    item?.toLowerCase().includes(searchQuery.toLowerCase()),
  );
  // Dynamically changes the window height based on the message.
  const windowHeight =
    325 + Math.ceil(message.length / 3) + (large_buttons ? 5 : 0);
  // Grabs the cursor when no search bar is visible.
  if (!searchBarVisible) {
    setTimeout(() => document!.getElementById(selected.toString())?.focus(), 1);
  }

  function handleKeyDown(event: React.KeyboardEvent<HTMLDivElement>) {
    const key = event.key;
    if (key === KEY.Down || key === KEY.Up) {
      event.preventDefault();
      onArrowKey(key);
    }
    if (key === KEY.Enter) {
      event.preventDefault();
      act('submit', { entry: filteredItems[selected] });
    }
    if (!searchBarVisible && (isAlphabetic(key) || isNumeric(key))) {
      event.preventDefault();
      onLetterSearch(key);
    }
    if (key === KEY.Escape) {
      event.preventDefault();
      act('cancel');
    }
  }

  return (
    <Window title={title} width={325} height={windowHeight}>
      {timeout && <Loader value={timeout} />}
      <Window.Content
        onKeyDown={(event) => {
          handleKeyDown(event);
        }}
      >
        <Section
          buttons={
            <Button
              compact
              icon={searchBarVisible ? 'search' : 'font'}
              selected
              tooltip={
                searchBarVisible
                  ? 'Search Mode. Type to search or use arrow keys to select manually.'
                  : 'Hotkey Mode. Type a letter to jump to the first match. Enter to select.'
              }
              tooltipPosition="left"
              onClick={() => onSearchBarToggle()}
            />
          }
          className="ListInput__Section"
          fill
          title={message}
        >
          <Stack fill vertical>
            <Stack.Item grow>
              <ListDisplay
                filteredItems={filteredItems}
                onClick={onClick}
                onFocusSearch={onFocusSearch}
                searchBarVisible={searchBarVisible}
                selected={selected}
              />
            </Stack.Item>
            {searchBarVisible && (
              <Input
                autoFocus
                autoSelect
                fluid
                expensive
                onEnter={() => {
                  act('submit', { entry: filteredItems[selected] });
                }}
                onChange={onSearch}
                placeholder="Search..."
                value={searchQuery}
              />
            )}
            <Stack.Item>
              <InputButtons input={filteredItems[selected]} />
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};

/**
 * Displays the list of selectable items.
 * If a search query is provided, filters the items.
 */
const ListDisplay = (props) => {
  const { act } = useBackend<ListInputData>();
  const { filteredItems, onClick, onFocusSearch, searchBarVisible, selected } =
    props;

  function handleKeyDown(event: React.KeyboardEvent<HTMLDivElement>) {
    const key = event.key;
    if (searchBarVisible && (isAlphabetic(key) || isNumeric(key))) {
      event.preventDefault();
      onFocusSearch();
    }
  }

  return (
    <Section fill scrollable>
      <Autofocus />
      {filteredItems.map((item, index) => {
        return (
          <Button
            className="candystripe"
            color="transparent"
            fluid
            id={index}
            key={index}
            onClick={() => onClick(index)}
            onDoubleClick={(event) => {
              event.preventDefault();
              act('submit', { entry: filteredItems[selected] });
            }}
            onKeyDown={(event) => {
              handleKeyDown(event);
            }}
            selected={index === selected}
            style={{
              animation: 'none',
              transition: 'none',
            }}
          >
            {item.replace(/^\w/, (c) => c.toUpperCase())}
          </Button>
        );
      })}
    </Section>
  );
};
