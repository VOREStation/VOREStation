import { Fragment, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { ImageButton, Input, Section, Stack } from 'tgui-core/components';
import { createSearch } from 'tgui-core/string';

import { bodyStyle, Data, styles } from './types';

export const AppearanceChangerParts = (props: {
  sectionNames: string[];
  possibleStyles: styles[][];
  currentStyle: string[];
  actions: string[];
  canClear?: boolean;
}) => {
  const { act } = useBackend<Data>();
  const { sectionNames, possibleStyles, currentStyle, actions, canClear } =
    props;
  const [searchText, setSearchText] = useState<string>('');

  const selectableStyles = possibleStyles.map((styles: styles[]) => {
    const searcher = createSearch(searchText, (style: styles) => {
      return style.name;
    });

    const filteredStyles = styles.filter(searcher);

    return filteredStyles.sort((a, b) =>
      a.name.toLowerCase().localeCompare(b.name.toLowerCase()),
    );
  });

  return (
    <Stack vertical fill>
      {sectionNames.map((section, i) => (
        <Fragment key={section}>
          <Stack.Item>
            {i === 0 && (
              <Input
                fluid
                placeholder={'Search for ' + section.toLowerCase() + '...'}
                value={searchText}
                onInput={(e, val) => setSearchText(val)}
              />
            )}
          </Stack.Item>
          <Stack.Item grow>
            <Section title={section} fill scrollable>
              {canClear && (
                <ImageButton
                  tooltip="-- Not Set --"
                  onClick={() => act(actions[i], { clear: true })}
                  selected={currentStyle[i] === null}
                >
                  -- Not Set --
                </ImageButton>
              )}
              {selectableStyles[i].map((style) => (
                <ImageButton
                  tooltip={style.name}
                  dmIcon={style.icon}
                  dmIconState={style.icon_state}
                  key={style.name}
                  onClick={() => {
                    act(actions[i], { ref: style.instance });
                  }}
                  selected={style.name === currentStyle[i]}
                >
                  {style.name}
                </ImageButton>
              ))}
            </Section>
          </Stack.Item>
        </Fragment>
      ))}
    </Stack>
  );
};

export const AppearanceChangerHair = (props: {
  sectionNames: string[];
  possibleStyles: bodyStyle[][];
  currentStyle: string[];
  actions: string[];
}) => {
  const { act } = useBackend<Data>();
  const { sectionNames, possibleStyles, currentStyle, actions } = props;
  const [searchText, setSearchText] = useState<string>('');

  const selectableStyles = possibleStyles.map((styles: bodyStyle[]) => {
    const searcher = createSearch(searchText, (style: styles) => {
      return style.name;
    });

    const filteredStyles = styles.filter(searcher);

    return filteredStyles.sort((a, b) =>
      a.name.toLowerCase().localeCompare(b.name.toLowerCase()),
    );
  });

  return (
    <Stack vertical fill>
      {sectionNames.map((section, i) => (
        <Fragment key={section}>
          <Stack.Item key={section}>
            <Input
              fluid
              placeholder={'Search for ' + section.toLowerCase() + '...'}
              value={searchText}
              onInput={(e, val) => setSearchText(val)}
            />
          </Stack.Item>
          <Stack.Item grow>
            <Section title={section} fill scrollable>
              {selectableStyles[i].map((style) => (
                <ImageButton
                  tooltip={style.name}
                  dmIcon={style.icon}
                  dmIconState={style.icon_state}
                  key={style.name}
                  onClick={() => {
                    act(actions[i], { name: style.name });
                  }}
                  selected={style.name === currentStyle[i]}
                >
                  {style.name}
                </ImageButton>
              ))}
            </Section>
          </Stack.Item>
        </Fragment>
      ))}
    </Stack>
  );
};
