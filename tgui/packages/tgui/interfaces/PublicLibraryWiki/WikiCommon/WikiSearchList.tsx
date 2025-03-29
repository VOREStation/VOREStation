import { type Dispatch, type SetStateAction } from 'react';
import { useBackend } from 'tgui/backend';
import { Button, Divider, Input, Section, Stack } from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';

export const WikiSearchList = (props: {
  title: string;
  searchText: string;
  onSearchText: Dispatch<SetStateAction<string>>;
  listEntries: string[];
  basis: string;
  activeEntry: string;
  onActiveEntry?: Dispatch<SetStateAction<string>>;
  action?: string;
  button?: React.JSX.Element;
}) => {
  const { act } = useBackend();

  const {
    title,
    searchText,
    onSearchText,
    onActiveEntry,
    listEntries,
    activeEntry,
    basis,
    action,
    button,
  } = props;

  return (
    <Stack.Item basis={basis}>
      <Section fill title={title} buttons={button}>
        <Stack vertical fill>
          <Stack.Item>
            <Input
              mr="10px"
              fluid
              value={searchText}
              placeholder={'Search for ' + title + '...'}
              onInput={(e, value: string) => onSearchText(value)}
            />
          </Stack.Item>
          <Divider />
          <Stack.Item grow>
            <Section fill scrollable>
              <Stack vertical fill>
                {listEntries
                  .sort((a, b) => a.localeCompare(b))
                  .map((entry) => (
                    <Stack.Item key={entry}>
                      <Button
                        selected={entry === activeEntry}
                        fluid
                        ellipsis
                        onClick={() => {
                          if (action) {
                            act(action, { data: entry });
                          }
                          if (onActiveEntry) {
                            onActiveEntry(entry);
                          }
                        }}
                      >
                        {capitalize(entry)}
                      </Button>
                    </Stack.Item>
                  ))}
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Section>
    </Stack.Item>
  );
};
