import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  ColorBox,
  Dropdown,
  ImageButton,
  Input,
  LabeledList,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';
import { createSearch } from 'tgui-core/string';

import { MARKINGS_PER_PAGE } from './constants';
import { bodyStyle, Data, SPRITE_ACCESSORY_COLOR_CHANNEL_NAMES } from './types';

export const AppearanceChangerColors = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    change_eye_color,
    change_skin_tone,
    change_skin_color,
    change_hair_color,
    change_facial_hair_color,
    eye_color,
    skin_color,
    hair_color,
    hair_grad,
    hair_color_grad,
    facial_hair_color,
    ears_color,
    ears2_color,
    tail_color,
    tail2_color,
    tail3_color,
    wing_color,
    wing2_color,
    wing3_color,
    ear_secondary_colors,
    hair_grads,
  } = data;

  return (
    <Section title="Colors" fill scrollable>
      {change_eye_color ? (
        <Box>
          <ColorBox color={eye_color} mr={1} />
          <Button onClick={() => act('eye_color')}>Change Eye Color</Button>
        </Box>
      ) : (
        ''
      )}
      {change_skin_tone ? (
        <Box>
          <Button onClick={() => act('skin_tone')}>Change Skin Tone</Button>
        </Box>
      ) : (
        ''
      )}
      {change_skin_color ? (
        <Box>
          <ColorBox color={skin_color} mr={1} />
          <Button onClick={() => act('skin_color')}>Change Skin Color</Button>
        </Box>
      ) : (
        ''
      )}
      {change_hair_color ? (
        <>
          <Box>
            <ColorBox color={hair_color} mr={1} />
            <Button onClick={() => act('hair_color')}>Change Hair Color</Button>
          </Box>
          <Box>
            <ColorBox color={hair_color_grad} mr={1} />
            <Button onClick={() => act('hair_color_grad')}>
              Change Hair gradiant Color
            </Button>
            <Dropdown
              autoScroll={false}
              width="30%"
              selected={hair_grad || 'None'}
              options={hair_grads.map((key: string) => {
                return {
                  displayText: key,
                  value: key,
                };
              })}
              onSelected={(val: string) => act('hair_grad', { picked: val })}
            />
          </Box>
          <Box>
            <ColorBox color={ears_color} mr={1} />
            <Button onClick={() => act('ears_color')}>
              Change Ears Color (Primary)
            </Button>
          </Box>
          <Box>
            <ColorBox color={ears2_color} mr={1} />
            <Button onClick={() => act('ears2_color')}>
              Change Ears Color (Secondary)
            </Button>
          </Box>
          {ear_secondary_colors.map((color, index) => (
            <Box key={index}>
              <ColorBox color={color} mr={1} />
              <Button
                onClick={() =>
                  act('ears_secondary_color', { channel: index + 1 })
                }
              >
                Change Secondary Ears Color (
                {SPRITE_ACCESSORY_COLOR_CHANNEL_NAMES[index]})
              </Button>
            </Box>
          ))}
          <Box>
            <ColorBox color={tail_color} mr={1} />
            <Button onClick={() => act('tail_color')}>Change Tail Color</Button>
          </Box>
          <Box>
            <ColorBox color={tail2_color} mr={1} />
            <Button onClick={() => act('tail2_color')}>
              Change Secondary Tail Color
            </Button>
          </Box>
          <Box>
            <ColorBox color={tail3_color} mr={1} />
            <Button onClick={() => act('tail3_color')}>
              Change Tertiary Tail Color
            </Button>
          </Box>
          <Box>
            <ColorBox color={wing_color} mr={1} />
            <Button onClick={() => act('wing_color')}>Change Wing Color</Button>
          </Box>
          <Box>
            <ColorBox color={wing2_color} mr={1} />
            <Button onClick={() => act('wing2_color')}>
              Change Secondary Wing Color
            </Button>
          </Box>
          <Box>
            <ColorBox color={wing3_color} mr={1} />
            <Button onClick={() => act('wing3_color')}>
              Change Tertiary Wing Color
            </Button>
          </Box>
        </>
      ) : null}
      {change_facial_hair_color ? (
        <Box>
          <ColorBox color={facial_hair_color} mr={1} />
          <Button onClick={() => act('facial_hair_color')}>
            Change Facial Hair Color
          </Button>
        </Box>
      ) : null}
    </Section>
  );
};

export const AppearanceChangerMarkings = (props) => {
  const { act, data } = useBackend<Data>();

  const { markings, marking_styles } = data;

  const [searchText, setSearchText] = useState<string>('');
  const [tabIndex, setTabIndex] = useState(0);

  const searcher = createSearch(searchText, (style: bodyStyle) => {
    return style.name;
  });

  const filteredStyles = marking_styles.filter(searcher);

  filteredStyles.sort((a, b) =>
    a.name.toLowerCase().localeCompare(b.name.toLowerCase()),
  );
  const styleTabCount = Math.ceil(filteredStyles.length / MARKINGS_PER_PAGE);

  const shownStyles: bodyStyle[][] = [];

  for (let i = 0; i < styleTabCount; i++) {
    shownStyles[i] = filteredStyles.slice(
      i * MARKINGS_PER_PAGE,
      i * MARKINGS_PER_PAGE + MARKINGS_PER_PAGE,
    );
  }

  return (
    <Section title="Markings" fill scrollable>
      <Stack vertical>
        <Stack.Item>
          <LabeledList>
            {markings.map((m) => (
              <LabeledList.Item key={m.marking_name} label={m.marking_name}>
                <Stack>
                  <Stack.Item grow />
                  <Stack.Item>
                    <ColorBox color={m.marking_color} mr={1} />
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      onClick={() =>
                        act('marking', { todo: 4, name: m.marking_name })
                      }
                    >
                      Change Color
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      onClick={() =>
                        act('marking', { todo: 0, name: m.marking_name })
                      }
                    >
                      -
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      onClick={() =>
                        act('marking', { todo: 3, name: m.marking_name })
                      }
                    >
                      Move down
                    </Button>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      onClick={() =>
                        act('marking', { todo: 2, name: m.marking_name })
                      }
                    >
                      Move up
                    </Button>
                  </Stack.Item>
                </Stack>
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Stack.Item>
        <Stack.Item>
          <Input
            fluid
            placeholder={'Search for markings...'}
            value={searchText}
            onInput={(e, val) => setSearchText(val)}
          />
        </Stack.Item>
        <Stack.Item>
          <Tabs>
            <Stack wrap="wrap" justify="center">
              {shownStyles.map((_, i) => (
                <Stack.Item key={i}>
                  <Tabs.Tab
                    selected={tabIndex === i}
                    onClick={() => setTabIndex(i)}
                  >
                    Page {i + 1}
                  </Tabs.Tab>
                </Stack.Item>
              ))}
            </Stack>
          </Tabs>
        </Stack.Item>
        <Stack.Item>
          {shownStyles[tabIndex]?.map((style) => (
            <ImageButton
              key={style.name}
              tooltip={style.name}
              dmIcon={style.icon}
              dmIconState={style.icon_state}
              onClick={() => {
                act('marking', { todo: 1, name: style.name });
              }}
            >
              {style.name}
            </ImageButton>
          ))}
        </Stack.Item>
      </Stack>
    </Section>
  );
};
