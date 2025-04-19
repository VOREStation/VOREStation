import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  ColorBox,
  Dimmer,
  Input,
  LabeledList,
  Section,
  Stack,
  Tabs,
} from 'tgui-core/components';
import { type BooleanLike } from 'tgui-core/react';
import { capitalize } from 'tgui-core/string';

import {
  ColorizedImage,
  ColorizedImageButton,
  getImage,
} from '../../helper_components';
import {
  type GeneralData,
  type GeneralDataConstant,
  type GeneralDataStatic,
  type MarkingStyle,
} from '../data';
import { BodyPopup } from '../SubtabBody';

const BP_TO_NAME = {
  r_hand: 'right hand',
  l_hand: 'left hand',
  l_arm: 'left arm',
  r_arm: 'right arm',
  l_leg: 'left leg',
  r_leg: 'right leg',
  l_foot: 'left foot',
  r_foot: 'right foot',
};

export const MarkingsPopup = (props: {
  data: GeneralData;
  staticData: GeneralDataStatic;
  serverData: GeneralDataConstant;
  setShow: React.Dispatch<React.SetStateAction<BodyPopup>>;
}) => {
  const { act } = useBackend();
  const { data, staticData, serverData, setShow } = props;

  const { body_markings } = data;
  const { body_markings: available_body_markings } = serverData;

  const markings = Object.entries(body_markings);

  const [showAddMenu, setShowAddMenu] = useState(false);
  const [showExtra, setShowExtra] = useState('');
  const [showHuman, setShowHuman] = useState(true);

  return (
    <Section
      title="Markings"
      fill
      scrollable
      mt={1}
      buttons={
        <>
          <Button.Checkbox
            checked={showHuman}
            selected={showHuman}
            onClick={() => setShowHuman((x) => !x)}
          >
            Show Human
          </Button.Checkbox>
          <Button
            icon={showAddMenu ? 'minus' : 'plus'}
            color={showAddMenu ? 'bad' : 'good'}
            onClick={() => setShowAddMenu(!showAddMenu)}
          >
            Add Marking
          </Button>
          <Button onClick={() => setShow(BodyPopup.None)} color="bad">
            Close
          </Button>
        </>
      }
    >
      {markings.length === 0 && <Box>No Markings Selected.</Box>}
      {markings.map(([name, data]) => (
        <Stack key={name} align="center">
          <Stack.Item>
            <Button
              color="transparent"
              icon="arrow-up"
              onClick={() => act('marking_up', { marking: name })}
            />
            <Button
              color="transparent"
              icon="arrow-down"
              onClick={() => act('marking_down', { marking: name })}
            />
          </Stack.Item>
          <Stack.Item grow>
            <Button
              fluid
              onClick={() => {
                setShowExtra(name);
              }}
            >
              <Stack align="center" justify="space-between" pl={10} pr={10}>
                <Stack.Item>{name}</Stack.Item>
                <Stack.Item>
                  <ColorizedImage
                    iconRef={available_body_markings[name].icon}
                    iconState={available_body_markings[name].icon_state}
                    color={data.color}
                    postRender={async (ctx) => {
                      if (showHuman) {
                        ctx.globalCompositeOperation = 'destination-over';
                        const background = await getImage(
                          Byond.iconRefMap['icons/mob/human.dmi'] +
                            '?state=body_m_s&dir=2',
                        );
                        ctx.drawImage(background, 0, 0, 64, 64);
                      }
                    }}
                  />
                </Stack.Item>
              </Stack>
            </Button>
          </Stack.Item>
        </Stack>
      ))}
      {!!showExtra && (
        <ExtraWindow
          data={data}
          staticData={staticData}
          serverData={serverData}
          name={showExtra}
          setShow={setShowExtra}
        />
      )}
      {showAddMenu && (
        <AddMarkingWindow
          data={data}
          staticData={staticData}
          serverData={serverData}
          setShow={setShowAddMenu}
        />
      )}
    </Section>
  );
};

export const ExtraWindow = (props: {
  data: GeneralData;
  staticData: GeneralDataStatic;
  serverData: GeneralDataConstant;
  name: string;
  setShow: React.Dispatch<React.SetStateAction<string>>;
}) => {
  const { act } = useBackend();
  const { data, staticData, serverData, name, setShow } = props;
  const { body_markings } = data;
  const { body_markings: available_body_markings } = serverData;

  const our_marking = body_markings[name];
  const our_marking_server = available_body_markings[name];

  if (!our_marking) {
    setShow('');
    return <Dimmer>Error: Invalid marking {name}</Dimmer>;
  }

  return (
    <Dimmer
      style={{
        display: 'block',
        overflowY: 'auto',
        textIndent: 0,
        textAlign: 'center',
        zIndex: 100,
      }}
      height="100%"
      p={1}
    >
      <Section
        fill
        title={name + ' Options'}
        buttons={
          <Button icon="times" color="bad" onClick={() => setShow('')}>
            Close
          </Button>
        }
      >
        <Button
          onClick={() =>
            act('toggle_all_marking_selection', { marking: name, toggle: 1 })
          }
        >
          Enable All
        </Button>
        <Button
          onClick={() =>
            act('toggle_all_marking_selection', { marking: name, toggle: 0 })
          }
        >
          Disable All
        </Button>
        <Button
          onClick={() => act('color_all_marking_selection', { marking: name })}
        >
          Change Color Of All
        </Button>
        <Button
          onClick={() => {
            act('marking_remove', { marking: name });
            setShow('');
          }}
          color="bad"
          icon="trash"
        >
          Delete Marking
        </Button>
        <LabeledList>
          <LabeledList.Item label="Color">
            <Button onClick={() => act('marking_color', { marking: name })}>
              {our_marking.color}
              <ColorBox color={our_marking.color} ml={1} />
            </Button>
          </LabeledList.Item>
          {Object.entries(our_marking)
            .filter(([zone, value]) => {
              return value && typeof value === 'object';
            })
            .map(
              ([zone, value]: [string, { on: BooleanLike; color: string }]) => (
                <LabeledList.Item
                  label={capitalize(BP_TO_NAME[zone] || zone)}
                  key={zone}
                >
                  <Button
                    onClick={() =>
                      act('zone_marking_color', { marking: name, zone })
                    }
                  >
                    {value.color} <ColorBox color={value.color} ml={1} />{' '}
                  </Button>
                  <Button.Checkbox
                    onClick={() =>
                      act('zone_marking_toggle', { marking: name, zone })
                    }
                    checked={value.on}
                    selected={value.on}
                    tooltip={value.on ? 'Disable Part' : 'Enable Part'}
                  />
                </LabeledList.Item>
              ),
            )}
        </LabeledList>
      </Section>
    </Dimmer>
  );
};

const MARKINGS_PER_PAGE = 30;

export const AddMarkingWindow = (props: {
  data: GeneralData;
  staticData: GeneralDataStatic;
  serverData: GeneralDataConstant;
  setShow: React.Dispatch<React.SetStateAction<boolean>>;
}) => {
  const { act } = useBackend();
  const { data, staticData, serverData, setShow } = props;
  const { body_markings } = serverData;
  const [showList, setShowList] = useState(false);
  const [showHuman, setShowHuman] = useState(true);
  const [search, setSearch] = useState('');
  const [tabIndex, setTabIndex] = useState(0);

  const body_markings_list = Object.entries(body_markings);
  body_markings_list.sort((a, b) => a[0].localeCompare(b[0]));

  const filteredStyles = body_markings_list.filter(([name, data]) => {
    if (!search) {
      return true;
    }
    return name.toLowerCase().includes(search.toLowerCase());
  });

  const styleTabCount = Math.ceil(filteredStyles.length / MARKINGS_PER_PAGE);
  const shownStyles: [string, MarkingStyle][][] = [];

  for (let i = 0; i < styleTabCount; i++) {
    shownStyles[i] = filteredStyles.slice(
      i * MARKINGS_PER_PAGE,
      i * MARKINGS_PER_PAGE + MARKINGS_PER_PAGE,
    );
  }

  return (
    <Dimmer
      style={{
        display: 'block',
        overflowY: 'auto',
        textIndent: 0,
        textAlign: 'center',
        zIndex: 100,
      }}
      height="100%"
      p={1}
    >
      <Stack vertical>
        <Stack.Item>
          <Stack>
            <Stack.Item grow>
              <Input
                fluid
                expensive
                onChange={(val) => setSearch(val)}
                value={search}
              />
            </Stack.Item>
            <Stack.Item>
              <Button.Checkbox
                checked={showHuman}
                selected={showHuman}
                onClick={() => setShowHuman(!showHuman)}
              >
                Show Human
              </Button.Checkbox>
            </Stack.Item>
          </Stack>
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
          {shownStyles[tabIndex]?.map(([name, data]) => (
            <ColorizedImageButton
              key={name}
              onClick={() => {
                act('add_marking', { new_marking: name });
                setShow(false);
              }}
              iconRef={data.icon}
              iconState={data.icon_state}
              tooltip={name}
              color="#ffffff"
              postRender={async (ctx) => {
                if (showHuman) {
                  ctx.save();
                  ctx.globalCompositeOperation = 'destination-over';
                  const background = await getImage(
                    Byond.iconRefMap['icons/mob/human.dmi'] +
                      '?state=body_m_s&dir=2',
                  );
                  ctx.drawImage(background, 0, 0, 64, 64);
                  ctx.restore();
                }
              }}
            >
              {name}
            </ColorizedImageButton>
          ))}
        </Stack.Item>
      </Stack>
    </Dimmer>
  );
};
