import { useState } from 'react';
import {
  Button,
  Collapsible,
  Input,
  NoticeBox,
  Section,
  Stack,
} from 'tgui-core/components';
import { useBackend } from '../../backend';
import { validateRegExp } from './functions';
import type { CategoryViewerProps } from './types';

export const CategoryViewer = (props: CategoryViewerProps) => {
  const { act } = useBackend();
  const [search, setSearch] = useState('');
  const [searchRegex, setSearchRegex] = useState(false);
  const [caseSensitive, setCaseSensitive] = useState(false);
  if (!search && searchRegex) {
    setSearchRegex(false);
  }
  let regexValidation: boolean | SyntaxError = true;
  if (searchRegex) {
    regexValidation = validateRegExp(search);
  }

  return (
    <Section
      fill
      title={`Category Viewer${
        props.activeCategory
          ? ` - ${props.activeCategory}[${props.data?.entry_count}]`
          : ' - Select a category'
      }`}
      buttons={
        <Stack>
          <Stack.Item>
            <Button
              icon="sync"
              onClick={() => act('refresh')}
              tooltip="Refresh Logs"
            />
          </Stack.Item>
          <Stack.Item>
            <Input placeholder="Search" value={search} onChange={setSearch} />
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="code"
              tooltip="RegEx Search"
              selected={searchRegex}
              onClick={() => setSearchRegex(!searchRegex)}
            />
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="font"
              selected={caseSensitive}
              tooltip="Case Sensitive"
              onClick={() => setCaseSensitive(!caseSensitive)}
            />
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="trash"
              tooltip="Clear Search"
              color="bad"
              onClick={() => {
                setSearch('');
                setSearchRegex(false);
              }}
            />
          </Stack.Item>
        </Stack>
      }
    >
      <Section fill scrollable>
        <Stack g={0} fill vertical overflowX="hidden">
          {!searchRegex || regexValidation === true ? (
            props.data?.entries.map((entry) => {
              if (search) {
                if (searchRegex) {
                  const regex = new RegExp(search, caseSensitive ? 'g' : 'gi');
                  if (!regex.test(entry.message)) {
                    return null;
                  }
                } else {
                  if (caseSensitive) {
                    if (!entry.message.includes(search)) {
                      return null;
                    }
                  } else {
                    if (
                      !entry.message
                        .toLowerCase()
                        .includes(search.toLowerCase())
                    ) {
                      return null;
                    }
                  }
                }
              }

              return (
                <Stack.Item key={entry.id}>
                  <Collapsible title={`[${entry.id}] - ${entry.message}`}>
                    <Stack vertical fill>
                      <Stack.Item>
                        <p font-family="Courier">{entry.message}</p>
                      </Stack.Item>
                      <Stack.Item>
                        {entry.semver && (
                          <Stack.Item>
                            <JsonViewer data={entry.semver} title="Semver" />
                          </Stack.Item>
                        )}
                      </Stack.Item>
                      {entry.data && (
                        <Stack.Item>
                          <JsonViewer data={entry.data} title="Data" />
                        </Stack.Item>
                      )}
                    </Stack>
                  </Collapsible>
                </Stack.Item>
              );
            })
          ) : (
            <NoticeBox danger>
              Invalid RegEx: {(regexValidation as SyntaxError).message}
            </NoticeBox>
          )}
        </Stack>
      </Section>
    </Section>
  );
};

const JsonViewer = (props: { data: any; title: string }) => {
  return (
    <Collapsible title={props.title}>
      <pre>{JSON.stringify(props.data, null, 2)}</pre>
    </Collapsible>
  );
};
