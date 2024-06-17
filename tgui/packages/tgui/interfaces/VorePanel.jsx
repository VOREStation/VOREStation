import { classes } from 'common/react';
import { capitalize } from 'common/string';
import { useState } from 'react';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  Collapsible,
  Divider,
  Flex,
  Icon,
  LabeledList,
  NoticeBox,
  Section,
  Tabs,
} from '../components';
import { Window } from '../layouts';

const stats = [null, 'average', 'bad'];

const digestModeToColor = {
  Hold: null,
  Digest: 'red',
  Absorb: 'purple',
  Unabsorb: 'purple',
  Drain: 'orange',
  Selective: 'orange',
  Shrink: 'teal',
  Grow: 'teal',
  'Size Steal': 'teal',
  Heal: 'green',
  'Encase In Egg': 'blue',
};

const digestModeToPreyMode = {
  Hold: 'being held.',
  Digest: 'being digested.',
  Absorb: 'being absorbed.',
  Unabsorb: 'being unabsorbed.',
  Drain: 'being drained.',
  Selective: 'being processed.',
  Shrink: 'being shrunken.',
  Grow: 'being grown.',
  'Size Steal': 'having your size stolen.',
  Heal: 'being healed.',
  'Encase In Egg': 'being encased in an egg.',
};

/**
 * There are three main sections to this UI.
 *  - The Inside Panel, where all relevant data for interacting with a belly you're in is located.
 *  - The Belly Selection Panel, where you can select what belly people will go into and customize the active one.
 *  - User Preferences, where you can adjust all of your vore preferences on the fly.
 */
export const VorePanel = (props) => {
  const { act, data } = useBackend();

  const [tabIndex, setTabIndex] = useState(0);

  const tabs = [];

  tabs[0] = <VoreBellySelectionAndCustomization />;

  tabs[1] = <VoreUserPreferences />;

  return (
    <Window width={890} height={660} theme="abstract">
      <Window.Content scrollable>
        {(data.unsaved_changes && (
          <NoticeBox danger>
            <Flex>
              <Flex.Item basis="90%">Warning: Unsaved Changes!</Flex.Item>
              <Flex.Item>
                <Button icon="save" onClick={() => act('saveprefs')}>
                  Save Prefs
                </Button>
              </Flex.Item>
              <Flex.Item>
                <Button
                  icon="download"
                  onClick={() => {
                    act('saveprefs');
                    act('exportpanel');
                  }}
                >
                  Save Prefs & Export Selected Belly
                </Button>
              </Flex.Item>
            </Flex>
          </NoticeBox>
        )) ||
          null}
        <VoreInsidePanel />
        <Tabs>
          <Tabs.Tab selected={tabIndex === 0} onClick={() => setTabIndex(0)}>
            Bellies
            <Icon name="list" ml={0.5} />
          </Tabs.Tab>
          <Tabs.Tab selected={tabIndex === 1} onClick={() => setTabIndex(1)}>
            Preferences
            <Icon name="user-cog" ml={0.5} />
          </Tabs.Tab>
        </Tabs>
        {tabs[tabIndex] || 'Error'}
      </Window.Content>
    </Window>
  );
};

const VoreInsidePanel = (props) => {
  const { act, data } = useBackend();

  const { absorbed, belly_name, belly_mode, desc, pred, contents, ref } =
    data.inside;

  if (!belly_name) {
    return <Section title="Inside">You aren&apos;t inside anyone.</Section>;
  }

  return (
    <Section title="Inside">
      <Box color="green" inline>
        You are currently {absorbed ? 'absorbed into' : 'inside'}
      </Box>
      &nbsp;
      <Box color="yellow" inline>
        {pred}&apos;s
      </Box>
      &nbsp;
      <Box color="red" inline>
        {belly_name}
      </Box>
      &nbsp;
      <Box color="yellow" inline>
        and you are
      </Box>
      &nbsp;
      <Box color={digestModeToColor[belly_mode]} inline>
        {digestModeToPreyMode[belly_mode]}
      </Box>
      &nbsp;
      <Box color="label">{desc}</Box>
      {(contents.length && (
        <Collapsible title="Belly Contents">
          <VoreContentsPanel contents={contents} belly={ref} />
        </Collapsible>
      )) ||
        'There is nothing else around you.'}
    </Section>
  );
};

const VoreBellySelectionAndCustomization = (props) => {
  const { act, data } = useBackend();

  const { our_bellies, selected } = data;

  return (
    <Flex>
      <Flex.Item shrink>
        <Section title="My Bellies" scollable>
          <Tabs vertical>
            <Tabs.Tab onClick={() => act('newbelly')}>
              New
              <Icon name="plus" ml={0.5} />
            </Tabs.Tab>
            <Tabs.Tab onClick={() => act('exportpanel')}>
              Export
              <Icon name="file-export" ml={0.5} />
            </Tabs.Tab>
            <Divider />
            {our_bellies.map((belly) => (
              <Tabs.Tab
                key={belly.name}
                selected={belly.selected}
                textColor={digestModeToColor[belly.digest_mode]}
                onClick={() => act('bellypick', { bellypick: belly.ref })}
              >
                <Box
                  inline
                  textColor={
                    (belly.selected && digestModeToColor[belly.digest_mode]) ||
                    null
                  }
                >
                  {belly.name} ({belly.contents})
                </Box>
              </Tabs.Tab>
            ))}
          </Tabs>
        </Section>
      </Flex.Item>
      <Flex.Item grow>
        {selected && (
          <Section title={selected.belly_name}>
            <VoreSelectedBelly belly={selected} />
          </Section>
        )}
      </Flex.Item>
    </Flex>
  );
};

/**
 * Subtemplate of VoreBellySelectionAndCustomization
 */
const VoreSelectedBelly = (props) => {
  const { act } = useBackend();

  const { belly } = props;
  const { contents } = belly;

  const [tabIndex, setTabIndex] = useState(0);

  const tabs = [];

  tabs[0] = <VoreSelectedBellyControls belly={belly} />;

  tabs[1] = <VoreSelectedBellyDescriptions belly={belly} />;

  tabs[2] = <VoreSelectedBellyOptions belly={belly} />;

  tabs[3] = <VoreSelectedBellySounds belly={belly} />;

  tabs[4] = <VoreSelectedBellyVisuals belly={belly} />;

  tabs[5] = <VoreSelectedBellyInteractions belly={belly} />;

  tabs[6] = <VoreContentsPanel outside contents={contents} />;

  return (
    <>
      <Tabs>
        <Tabs.Tab selected={tabIndex === 0} onClick={() => setTabIndex(0)}>
          Controls
        </Tabs.Tab>
        <Tabs.Tab selected={tabIndex === 1} onClick={() => setTabIndex(1)}>
          Descriptions
        </Tabs.Tab>
        <Tabs.Tab selected={tabIndex === 2} onClick={() => setTabIndex(2)}>
          Options
        </Tabs.Tab>
        <Tabs.Tab selected={tabIndex === 3} onClick={() => setTabIndex(3)}>
          Sounds
        </Tabs.Tab>
        <Tabs.Tab selected={tabIndex === 4} onClick={() => setTabIndex(4)}>
          Visuals
        </Tabs.Tab>
        <Tabs.Tab selected={tabIndex === 5} onClick={() => setTabIndex(5)}>
          Interactions
        </Tabs.Tab>
        <Tabs.Tab selected={tabIndex === 6} onClick={() => setTabIndex(6)}>
          Contents ({contents.length})
        </Tabs.Tab>
      </Tabs>
      {tabs[tabIndex] || 'Error'}
    </>
  );
};

const VoreSelectedBellyControls = (props) => {
  const { act } = useBackend();

  const { belly } = props;
  const { belly_name, mode, item_mode, addons } = belly;

  return (
    <LabeledList>
      <LabeledList.Item
        label="Name"
        buttons={
          <>
            <Button
              icon="arrow-up"
              tooltipPosition="left"
              tooltip="Move this belly tab up."
              onClick={() => act('move_belly', { dir: -1 })}
            />
            <Button
              icon="arrow-down"
              tooltipPosition="left"
              tooltip="Move this belly tab down."
              onClick={() => act('move_belly', { dir: 1 })}
            />
          </>
        }
      >
        <Button onClick={() => act('set_attribute', { attribute: 'b_name' })}>
          {belly_name}
        </Button>
      </LabeledList.Item>
      <LabeledList.Item label="Mode">
        <Button
          color={digestModeToColor[mode]}
          onClick={() => act('set_attribute', { attribute: 'b_mode' })}
        >
          {mode}
        </Button>
      </LabeledList.Item>
      <LabeledList.Item label="Mode Addons">
        {(addons.length && addons.join(', ')) || 'None'}
        <Button
          onClick={() => act('set_attribute', { attribute: 'b_addons' })}
          ml={1}
          icon="plus"
        />
      </LabeledList.Item>
      <LabeledList.Item label="Item Mode">
        <Button
          onClick={() => act('set_attribute', { attribute: 'b_item_mode' })}
        >
          {item_mode}
        </Button>
      </LabeledList.Item>
      <LabeledList.Item basis="100%" mt={1}>
        <Button.Confirm
          fluid
          icon="exclamation-triangle"
          confirmIcon="trash"
          color="red"
          confirmContent="This is irreversable!"
          onClick={() => act('set_attribute', { attribute: 'b_del' })}
        >
          Delete Belly
        </Button.Confirm>
      </LabeledList.Item>
    </LabeledList>
  );
};

const VoreSelectedBellyDescriptions = (props) => {
  const { act } = useBackend();

  const { belly } = props;
  const {
    verb,
    release_verb,
    desc,
    absorbed_desc,
    mode,
    message_mode,
    escapable,
    interacts,
    emote_active,
  } = belly;

  return (
    <LabeledList>
      <LabeledList.Item
        label="Description"
        buttons={
          <Button
            onClick={() => act('set_attribute', { attribute: 'b_desc' })}
            icon="pen"
          />
        }
      >
        {desc}
      </LabeledList.Item>
      <LabeledList.Item
        label="Description (Absorbed)"
        buttons={
          <Button
            onClick={() =>
              act('set_attribute', { attribute: 'b_absorbed_desc' })
            }
            icon="pen"
          />
        }
      >
        {absorbed_desc}
      </LabeledList.Item>
      <LabeledList.Item label="Vore Verb">
        <Button onClick={() => act('set_attribute', { attribute: 'b_verb' })}>
          {verb}
        </Button>
      </LabeledList.Item>
      <LabeledList.Item label="Release Verb">
        <Button
          onClick={() => act('set_attribute', { attribute: 'b_release_verb' })}
        >
          {release_verb}
        </Button>
      </LabeledList.Item>
      <LabeledList.Item label="Show All Messages">
        <Button
          onClick={() =>
            act('set_attribute', {
              attribute: 'b_message_mode',
            })
          }
          icon={message_mode ? 'toggle-on' : 'toggle-off'}
          selected={message_mode}
        >
          {message_mode ? 'True' : 'False'}
        </Button>
      </LabeledList.Item>
      <LabeledList.Item label="Examine Messages">
        <Button
          onClick={() =>
            act('set_attribute', { attribute: 'b_msgs', msgtype: 'em' })
          }
        >
          Examine Message (when full)
        </Button>
        <Button
          onClick={() =>
            act('set_attribute', { attribute: 'b_msgs', msgtype: 'ema' })
          }
        >
          Examine Message (with absorbed victims)
        </Button>
      </LabeledList.Item>
      {message_mode || escapable ? (
        <>
          <VoreSelectedBellyDescriptionsStruggle />
          <VoreSelectedBellyDescriptionsEscape
            message_mode={message_mode}
            interacts={interacts}
          />
          {(message_mode ||
            !!interacts.transferlocation ||
            !!interacts.transferlocation_secondary) && (
            <VoreSelectedBellyDescriptionsTransfer
              message_mode={message_mode}
              interacts={interacts}
            />
          )}
          {(message_mode ||
            interacts.digestchance > 0 ||
            interacts.absorbchance > 0) && (
            <VoreSelectedBellyDescriptionsInteractionChance
              message_mode={message_mode}
              interacts={interacts}
            />
          )}
        </>
      ) : (
        ''
      )}
      {(message_mode ||
        mode === 'Digest' ||
        mode === 'Selective' ||
        mode === 'Absorb' ||
        mode === 'Unabsorb') && (
        <VoreSelectedBellyDescriptionsBellymode
          message_mode={message_mode}
          mode={mode}
        />
      )}
      {emote_active ? (
        <VoreSelectedBellyDescriptionsIdle
          message_mode={message_mode}
          mode={mode}
        />
      ) : (
        ''
      )}
      <LabeledList.Item label="Reset Messages">
        <Button
          color="red"
          onClick={() =>
            act('set_attribute', { attribute: 'b_msgs', msgtype: 'reset' })
          }
        >
          Reset Messages
        </Button>
      </LabeledList.Item>
    </LabeledList>
  );
};

const VoreSelectedBellyDescriptionsStruggle = (props) => {
  const { act } = useBackend();

  return (
    <LabeledList.Item label="Struggle Messages">
      <Button
        onClick={() =>
          act('set_attribute', { attribute: 'b_msgs', msgtype: 'smo' })
        }
      >
        Struggle Message (outside)
      </Button>
      <Button
        onClick={() =>
          act('set_attribute', { attribute: 'b_msgs', msgtype: 'smi' })
        }
      >
        Struggle Message (inside)
      </Button>
      <Button
        onClick={() =>
          act('set_attribute', { attribute: 'b_msgs', msgtype: 'asmo' })
        }
      >
        Absorbed Struggle Message (outside)
      </Button>
      <Button
        onClick={() =>
          act('set_attribute', { attribute: 'b_msgs', msgtype: 'asmi' })
        }
      >
        Absorbed Struggle Message (inside)
      </Button>
    </LabeledList.Item>
  );
};

const VoreSelectedBellyDescriptionsEscape = (props) => {
  const { act } = useBackend();

  const { message_mode, interacts } = props;

  return (
    <LabeledList.Item label="Escape Messages">
      <Button
        onClick={() =>
          act('set_attribute', { attribute: 'b_msgs', msgtype: 'escap' })
        }
      >
        Escape Attempt Message (to prey)
      </Button>
      <Button
        onClick={() =>
          act('set_attribute', { attribute: 'b_msgs', msgtype: 'escao' })
        }
      >
        Escape Attempt Message (to you)
      </Button>
      {(message_mode || interacts.escapechance > 0) && (
        <>
          <Button
            onClick={() =>
              act('set_attribute', {
                attribute: 'b_msgs',
                msgtype: 'escp',
              })
            }
          >
            Escape Message (to prey)
          </Button>
          <Button
            onClick={() =>
              act('set_attribute', {
                attribute: 'b_msgs',
                msgtype: 'esco',
              })
            }
          >
            Escape Message (to you)
          </Button>
          <Button
            onClick={() =>
              act('set_attribute', {
                attribute: 'b_msgs',
                msgtype: 'escout',
              })
            }
          >
            Escape Message (outside)
          </Button>
        </>
      )}
      <Button
        onClick={() =>
          act('set_attribute', { attribute: 'b_msgs', msgtype: 'escip' })
        }
      >
        Escape Item Message (to prey)
      </Button>
      <Button
        onClick={() =>
          act('set_attribute', { attribute: 'b_msgs', msgtype: 'escio' })
        }
      >
        Escape Item Message (to you)
      </Button>
      <Button
        onClick={() =>
          act('set_attribute', {
            attribute: 'b_msgs',
            msgtype: 'esciout',
          })
        }
      >
        Escape Item Message (outside)
      </Button>
      <Button
        onClick={() =>
          act('set_attribute', { attribute: 'b_msgs', msgtype: 'escfp' })
        }
      >
        Escape Fail Message (to prey)
      </Button>
      <Button
        onClick={() =>
          act('set_attribute', { attribute: 'b_msgs', msgtype: 'escfo' })
        }
      >
        Escape Fail Message (to you)
      </Button>
      <Button
        onClick={() =>
          act('set_attribute', { attribute: 'b_msgs', msgtype: 'aescap' })
        }
      >
        Absorbed Escape Attempt Message (to prey)
      </Button>
      <Button
        onClick={() =>
          act('set_attribute', { attribute: 'b_msgs', msgtype: 'aescao' })
        }
      >
        Absorbed Escape Attempt Message (to you)
      </Button>
      {(message_mode || interacts.escapechance_absorbed > 0) && (
        <>
          <Button
            onClick={() =>
              act('set_attribute', {
                attribute: 'b_msgs',
                msgtype: 'aescp',
              })
            }
          >
            Absorbed Escape Message (to prey)
          </Button>
          <Button
            onClick={() =>
              act('set_attribute', {
                attribute: 'b_msgs',
                msgtype: 'aesco',
              })
            }
          >
            Absorbed Escape Message (to you)
          </Button>
          <Button
            onClick={() =>
              act('set_attribute', {
                attribute: 'b_msgs',
                msgtype: 'aescout',
              })
            }
          >
            Absorbed Escape Message (outside)
          </Button>
        </>
      )}
      <Button
        onClick={() =>
          act('set_attribute', { attribute: 'b_msgs', msgtype: 'aescfp' })
        }
      >
        Absorbed Escape Fail Message (to prey)
      </Button>
      <Button
        onClick={() =>
          act('set_attribute', { attribute: 'b_msgs', msgtype: 'aescfo' })
        }
      >
        Absorbed Escape Fail Message (to you)
      </Button>
    </LabeledList.Item>
  );
};

const VoreSelectedBellyDescriptionsTransfer = (props) => {
  const { act } = useBackend();

  const { message_mode, interacts } = props;

  return (
    <LabeledList.Item label="Transfer Messages">
      {(message_mode || !!interacts.transferlocation) && (
        <>
          <Button
            onClick={() =>
              act('set_attribute', {
                attribute: 'b_msgs',
                msgtype: 'trnspp',
              })
            }
          >
            Primary Transfer Message (to prey)
          </Button>
          <Button
            onClick={() =>
              act('set_attribute', {
                attribute: 'b_msgs',
                msgtype: 'trnspo',
              })
            }
          >
            Primary Transfer Message (to you)
          </Button>
        </>
      )}
      {(message_mode || !!interacts.transferlocation_secondary) && (
        <>
          <Button
            onClick={() =>
              act('set_attribute', {
                attribute: 'b_msgs',
                msgtype: 'trnssp',
              })
            }
          >
            Secondary Transfer Message (to prey)
          </Button>
          <Button
            onClick={() =>
              act('set_attribute', {
                attribute: 'b_msgs',
                msgtype: 'trnsso',
              })
            }
          >
            Secondary Transfer Message (to you)
          </Button>
        </>
      )}
    </LabeledList.Item>
  );
};

const VoreSelectedBellyDescriptionsInteractionChance = (props) => {
  const { act } = useBackend();

  const { message_mode, interacts } = props;

  return (
    <LabeledList.Item label="Interaction Chance Messages">
      {(message_mode || interacts.digestchance > 0) && (
        <>
          <Button
            onClick={() =>
              act('set_attribute', {
                attribute: 'b_msgs',
                msgtype: 'stmodp',
              })
            }
          >
            Interaction Chance Digest Message (to prey)
          </Button>
          <Button
            onClick={() =>
              act('set_attribute', {
                attribute: 'b_msgs',
                msgtype: 'stmodo',
              })
            }
          >
            Interaction Chance Digest Message (to you)
          </Button>
        </>
      )}
      {(message_mode || interacts.absorbchance > 0) && (
        <>
          <Button
            onClick={() =>
              act('set_attribute', {
                attribute: 'b_msgs',
                msgtype: 'stmoap',
              })
            }
          >
            Interaction Chance Absorb Message (to prey)
          </Button>
          <Button
            onClick={() =>
              act('set_attribute', {
                attribute: 'b_msgs',
                msgtype: 'stmoao',
              })
            }
          >
            Interaction Chance Absorb Message (to you)
          </Button>
        </>
      )}
    </LabeledList.Item>
  );
};

const VoreSelectedBellyDescriptionsBellymode = (props) => {
  const { act } = useBackend();

  const { message_mode, mode } = props;

  return (
    <LabeledList.Item label="Bellymode Messages">
      {(message_mode || mode === 'Digest' || mode === 'Selective') && (
        <>
          <Button
            onClick={() =>
              act('set_attribute', { attribute: 'b_msgs', msgtype: 'dmp' })
            }
          >
            Digest Message (to prey)
          </Button>
          <Button
            onClick={() =>
              act('set_attribute', { attribute: 'b_msgs', msgtype: 'dmo' })
            }
          >
            Digest Message (to you)
          </Button>
        </>
      )}
      {(message_mode || mode === 'Absorb' || mode === 'Selective') && (
        <>
          <Button
            onClick={() =>
              act('set_attribute', { attribute: 'b_msgs', msgtype: 'amp' })
            }
          >
            Absorb Message (to prey)
          </Button>
          <Button
            onClick={() =>
              act('set_attribute', { attribute: 'b_msgs', msgtype: 'amo' })
            }
          >
            Absorb Message (to you)
          </Button>
        </>
      )}
      {(message_mode || mode === 'Unabsorb') && (
        <>
          <Button
            onClick={() =>
              act('set_attribute', { attribute: 'b_msgs', msgtype: 'uamp' })
            }
          >
            Unabsorb Message (to prey)
          </Button>
          <Button
            onClick={() =>
              act('set_attribute', { attribute: 'b_msgs', msgtype: 'uamo' })
            }
          >
            Unabsorb Message (to you)
          </Button>
        </>
      )}
    </LabeledList.Item>
  );
};

const VoreSelectedBellyDescriptionsIdle = (props) => {
  const { act } = useBackend();

  const { message_mode, mode } = props;

  return (
    <LabeledList.Item label="Idle Messages">
      {(message_mode || mode === 'Hold' || mode === 'Selective') && (
        <>
          <Button
            onClick={() =>
              act('set_attribute', {
                attribute: 'b_msgs',
                msgtype: 'im_hold',
              })
            }
          >
            Idle Messages (Hold)
          </Button>
          <Button
            onClick={() =>
              act('set_attribute', {
                attribute: 'b_msgs',
                msgtype: 'im_holdabsorbed',
              })
            }
          >
            Idle Messages (Hold Absorbed)
          </Button>
        </>
      )}
      {(message_mode || mode === 'Digest' || mode === 'Selective') && (
        <Button
          onClick={() =>
            act('set_attribute', {
              attribute: 'b_msgs',
              msgtype: 'im_digest',
            })
          }
        >
          Idle Messages (Digest)
        </Button>
      )}
      {(message_mode || mode === 'Absorb' || mode === 'Selective') && (
        <Button
          onClick={() =>
            act('set_attribute', {
              attribute: 'b_msgs',
              msgtype: 'im_absorb',
            })
          }
        >
          Idle Messages (Absorb)
        </Button>
      )}
      {(message_mode || mode === 'Unabsorb') && (
        <Button
          onClick={() =>
            act('set_attribute', {
              attribute: 'b_msgs',
              msgtype: 'im_unabsorb',
            })
          }
        >
          Idle Messages (Unabsorb)
        </Button>
      )}
      {(message_mode || mode === 'Drain' || mode === 'Selective') && (
        <Button
          onClick={() =>
            act('set_attribute', { attribute: 'b_msgs', msgtype: 'im_drain' })
          }
        >
          Idle Messages (Drain)
        </Button>
      )}
      {(message_mode || mode === 'Heal') && (
        <Button
          onClick={() =>
            act('set_attribute', { attribute: 'b_msgs', msgtype: 'im_heal' })
          }
        >
          Idle Messages (Heal)
        </Button>
      )}
      {(message_mode || mode === 'Size Steal') && (
        <Button
          onClick={() =>
            act('set_attribute', { attribute: 'b_msgs', msgtype: 'im_steal' })
          }
        >
          Idle Messages (Size Steal)
        </Button>
      )}
      {(message_mode || mode === 'Shrink') && (
        <Button
          onClick={() =>
            act('set_attribute', {
              attribute: 'b_msgs',
              msgtype: 'im_shrink',
            })
          }
        >
          Idle Messages (Shrink)
        </Button>
      )}
      {(message_mode || mode === 'Grow') && (
        <Button
          onClick={() =>
            act('set_attribute', { attribute: 'b_msgs', msgtype: 'im_grow' })
          }
        >
          Idle Messages (Grow)
        </Button>
      )}
      {(message_mode || mode === 'Encase In Egg') && (
        <Button
          onClick={() =>
            act('set_attribute', { attribute: 'b_msgs', msgtype: 'im_egg' })
          }
        >
          Idle Messages (Encase In Egg)
        </Button>
      )}
    </LabeledList.Item>
  );
};

const VoreSelectedBellyOptions = (props) => {
  const { act, data } = useBackend();

  const { host_mobtype } = data;
  const { is_cyborg, is_vore_simple_mob } = host_mobtype;
  const { belly } = props;
  const {
    can_taste,
    nutrition_percent,
    digest_brute,
    digest_burn,
    digest_oxy,
    digest_tox,
    digest_clone,
    bulge_size,
    display_absorbed_examine,
    shrink_grow_size,
    emote_time,
    emote_active,
    contaminates,
    contaminate_flavor,
    contaminate_color,
    egg_type,
    selective_preference,
    save_digest_mode,
    eating_privacy_local,
    silicon_belly_overlay_preference,
    belly_mob_mult,
    belly_item_mult,
    belly_overall_mult,
    drainmode,
  } = belly;

  return (
    <Flex wrap="wrap">
      <Flex.Item basis="49%" grow={1}>
        <LabeledList>
          <LabeledList.Item label="Can Taste">
            <Button
              onClick={() => act('set_attribute', { attribute: 'b_tastes' })}
              icon={can_taste ? 'toggle-on' : 'toggle-off'}
              selected={can_taste}
            >
              {can_taste ? 'Yes' : 'No'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Contaminates">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_contaminate' })
              }
              icon={contaminates ? 'toggle-on' : 'toggle-off'}
              selected={contaminates}
            >
              {contaminates ? 'Yes' : 'No'}
            </Button>
          </LabeledList.Item>
          {(contaminates && (
            <>
              <LabeledList.Item label="Contamination Flavor">
                <Button
                  onClick={() =>
                    act('set_attribute', {
                      attribute: 'b_contamination_flavor',
                    })
                  }
                  icon="pen"
                >
                  {contaminate_flavor}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="Contamination Color">
                <Button
                  onClick={() =>
                    act('set_attribute', { attribute: 'b_contamination_color' })
                  }
                  icon="pen"
                >
                  {capitalize(contaminate_color)}
                </Button>
              </LabeledList.Item>
            </>
          )) ||
            null}
          <LabeledList.Item label="Nutritional Gain">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_nutritionpercent' })
              }
            >
              {nutrition_percent + '%'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Required Examine Size">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_bulge_size' })
              }
            >
              {bulge_size * 100 + '%'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Display Absorbed Examines">
            <Button
              onClick={() =>
                act('set_attribute', {
                  attribute: 'b_display_absorbed_examine',
                })
              }
              icon={display_absorbed_examine ? 'toggle-on' : 'toggle-off'}
              selected={display_absorbed_examine}
            >
              {display_absorbed_examine ? 'True' : 'False'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Toggle Vore Privacy">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_eating_privacy' })
              }
            >
              {capitalize(eating_privacy_local)}
            </Button>
          </LabeledList.Item>

          <LabeledList.Item label="Save Digest Mode">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_save_digest_mode' })
              }
              icon={save_digest_mode ? 'toggle-on' : 'toggle-off'}
              selected={save_digest_mode}
            >
              {save_digest_mode ? 'True' : 'False'}
            </Button>
          </LabeledList.Item>
        </LabeledList>
        <VoreSelectedMobTypeBellyButtons belly={belly} />
      </Flex.Item>
      <Flex.Item basis="49%" grow={1}>
        <LabeledList>
          <LabeledList.Item label="Idle Emotes">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_emoteactive' })
              }
              icon={emote_active ? 'toggle-on' : 'toggle-off'}
              selected={emote_active}
            >
              {emote_active ? 'Active' : 'Inactive'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Idle Emote Delay">
            <Button
              onClick={() => act('set_attribute', { attribute: 'b_emotetime' })}
            >
              {emote_time + ' seconds'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Digest Brute Damage">
            <Button
              onClick={() => act('set_attribute', { attribute: 'b_brute_dmg' })}
            >
              {digest_brute}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Digest Burn Damage">
            <Button
              onClick={() => act('set_attribute', { attribute: 'b_burn_dmg' })}
            >
              {digest_burn}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Digest Suffocation Damage">
            <Button
              onClick={() => act('set_attribute', { attribute: 'b_oxy_dmg' })}
            >
              {digest_oxy}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Digest Toxins Damage">
            <Button
              onClick={() => act('set_attribute', { attribute: 'b_tox_dmg' })}
            >
              {digest_tox}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Digest Clone Damage">
            <Button
              onClick={() => act('set_attribute', { attribute: 'b_clone_dmg' })}
            >
              {digest_clone}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Drain Finishing Mode">
            <Button
              onClick={() => act('set_attribute', { attribute: 'b_drainmode' })}
            >
              {drainmode}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Shrink/Grow Size">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_grow_shrink' })
              }
            >
              {shrink_grow_size * 100 + '%'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Egg Type">
            <Button
              onClick={() => act('set_attribute', { attribute: 'b_egg_type' })}
              icon="pen"
            >
              {capitalize(egg_type)}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Selective Mode Preference">
            <Button
              onClick={() =>
                act('set_attribute', {
                  attribute: 'b_selective_mode_pref_toggle',
                })
              }
            >
              {capitalize(selective_preference)}
            </Button>
          </LabeledList.Item>
        </LabeledList>
      </Flex.Item>
    </Flex>
  );
};

const VoreSelectedMobTypeBellyButtons = (props) => {
  const { act, data } = useBackend();
  const { host_mobtype } = data;
  const { is_cyborg, is_vore_simple_mob } = host_mobtype;
  const { belly } = props;
  const {
    silicon_belly_overlay_preference,
    belly_mob_mult,
    belly_item_mult,
    belly_overall_mult,
  } = belly;

  if (is_cyborg) {
    return (
      <Section title={'Cyborg Controls'} width={'80%'}>
        <LabeledList>
          <LabeledList.Item label="Toggle Belly Overlay Mode">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_silicon_belly' })
              }
            >
              {capitalize(silicon_belly_overlay_preference)}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Mob Vorebelly Size Mult">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_belly_mob_mult' })
              }
            >
              {belly_mob_mult}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Item Vorebelly Size Mult">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_belly_item_mult' })
              }
            >
              {belly_item_mult}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Belly Size Multiplier">
            <Button
              onClick={() =>
                act('set_attribute', {
                  attribute: 'b_belly_overall_mult',
                })
              }
            >
              {belly_overall_mult}
            </Button>
          </LabeledList.Item>
        </LabeledList>
      </Section>
    );
  } else if (is_vore_simple_mob) {
    return (
      // For now, we're only returning empty. TODO: Simple mob belly controls
      <LabeledList>
        <LabeledList.Item />
      </LabeledList>
    );
  } else {
    return (
      // Returning Empty element
      <LabeledList>
        <LabeledList.Item />
      </LabeledList>
    );
  }
};

const VoreSelectedBellySounds = (props) => {
  const { act } = useBackend();

  const { belly } = props;
  const { is_wet, wet_loop, fancy, sound, release_sound } = belly;

  return (
    <Flex wrap="wrap">
      <Flex.Item basis="49%" grow={1}>
        <LabeledList>
          <LabeledList.Item label="Fleshy Belly">
            <Button
              onClick={() => act('set_attribute', { attribute: 'b_wetness' })}
              icon={is_wet ? 'toggle-on' : 'toggle-off'}
              selected={is_wet}
            >
              {is_wet ? 'Yes' : 'No'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Internal Loop">
            <Button
              onClick={() => act('set_attribute', { attribute: 'b_wetloop' })}
              icon={wet_loop ? 'toggle-on' : 'toggle-off'}
              selected={wet_loop}
            >
              {wet_loop ? 'Yes' : 'No'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Use Fancy Sounds">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_fancy_sound' })
              }
              icon={fancy ? 'toggle-on' : 'toggle-off'}
              selected={fancy}
            >
              {fancy ? 'Yes' : 'No'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Vore Sound">
            <Button
              onClick={() => act('set_attribute', { attribute: 'b_sound' })}
            >
              {sound}
            </Button>
            <Button
              onClick={() => act('set_attribute', { attribute: 'b_soundtest' })}
              icon="volume-up"
            />
          </LabeledList.Item>
          <LabeledList.Item label="Release Sound">
            <Button
              onClick={() => act('set_attribute', { attribute: 'b_release' })}
            >
              {release_sound}
            </Button>
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_releasesoundtest' })
              }
              icon="volume-up"
            />
          </LabeledList.Item>
        </LabeledList>
      </Flex.Item>
    </Flex>
  );
};

const VoreSelectedBellyVisuals = (props) => {
  const { act } = useBackend();

  const { belly } = props;
  const {
    belly_fullscreen,
    possible_fullscreens,
    disable_hud,
    belly_fullscreen_color,
    belly_fullscreen_color_secondary,
    belly_fullscreen_color_trinary,
    mapRef,
    colorization_enabled,
    vore_sprite_flags,
    affects_voresprite,
    absorbed_voresprite,
    absorbed_multiplier,
    item_voresprite,
    item_multiplier,
    health_voresprite,
    resist_animation,
    voresprite_size_factor,
    belly_sprite_option_shown,
    belly_sprite_to_affect,
    undergarment_chosen,
    undergarment_if_none,
    undergarment_color,
    tail_option_shown,
    tail_to_change_to,
    tail_colouration,
    tail_extra_overlay,
    tail_extra_overlay2,
  } = belly;

  return (
    <>
      <Section title="Vore Sprites">
        <Flex direction="row">
          <LabeledList>
            <LabeledList.Item label="Affect Vore Sprites">
              <Button
                onClick={() =>
                  act('set_attribute', { attribute: 'b_affects_vore_sprites' })
                }
                icon={affects_voresprite ? 'toggle-on' : 'toggle-off'}
                selected={affects_voresprite}
                content={affects_voresprite ? 'Yes' : 'No'}
              />
            </LabeledList.Item>
            {affects_voresprite ? (
              <span>
                <LabeledList.Item label="Vore Sprite Mode">
                  {(vore_sprite_flags.length && vore_sprite_flags.join(', ')) ||
                    'None'}
                  <Button
                    onClick={() =>
                      act('set_attribute', { attribute: 'b_vore_sprite_flags' })
                    }
                    ml={1}
                    icon="plus"
                  />
                </LabeledList.Item>
                <LabeledList.Item label="Count Absorbed prey for vore sprites">
                  <Button
                    onClick={() =>
                      act('set_attribute', {
                        attribute: 'b_count_absorbed_prey_for_sprites',
                      })
                    }
                    icon={absorbed_voresprite ? 'toggle-on' : 'toggle-off'}
                    selected={absorbed_voresprite}
                    content={absorbed_voresprite ? 'Yes' : 'No'}
                  />
                </LabeledList.Item>
                <LabeledList.Item label="Absorbed Multiplier">
                  <Button
                    onClick={() =>
                      act('set_attribute', {
                        attribute: 'b_absorbed_multiplier',
                      })
                    }
                    content={absorbed_multiplier}
                  />
                </LabeledList.Item>
                <LabeledList.Item label="Count items for vore sprites">
                  <Button
                    onClick={() =>
                      act('set_attribute', {
                        attribute: 'b_count_items_for_sprites',
                      })
                    }
                    icon={item_voresprite ? 'toggle-on' : 'toggle-off'}
                    selected={item_voresprite}
                    content={item_voresprite ? 'Yes' : 'No'}
                  />
                </LabeledList.Item>
                <LabeledList.Item label="Items Multiplier">
                  <Button
                    onClick={() =>
                      act('set_attribute', { attribute: 'b_item_multiplier' })
                    }
                    content={item_multiplier}
                  />
                </LabeledList.Item>
                <LabeledList.Item label="Prey health affects vore sprites">
                  <Button
                    onClick={() =>
                      act('set_attribute', {
                        attribute: 'b_health_impacts_size',
                      })
                    }
                    icon={health_voresprite ? 'toggle-on' : 'toggle-off'}
                    selected={health_voresprite}
                    content={health_voresprite ? 'Yes' : 'No'}
                  />
                </LabeledList.Item>
                <LabeledList.Item label="Animation when prey resist">
                  <Button
                    onClick={() =>
                      act('set_attribute', { attribute: 'b_resist_animation' })
                    }
                    icon={resist_animation ? 'toggle-on' : 'toggle-off'}
                    selected={resist_animation}
                    content={resist_animation ? 'Yes' : 'No'}
                  />
                </LabeledList.Item>
                <LabeledList.Item label="Vore Sprite Size Factor">
                  <Button
                    onClick={() =>
                      act('set_attribute', {
                        attribute: 'b_size_factor_sprites',
                      })
                    }
                    content={voresprite_size_factor}
                  />
                </LabeledList.Item>
                {belly_sprite_option_shown ? (
                  <LabeledList.Item label="Belly Sprite to affect">
                    <Button
                      onClick={() =>
                        act('set_attribute', {
                          attribute: 'b_belly_sprite_to_affect',
                        })
                      }
                      content={belly_sprite_to_affect}
                    />
                  </LabeledList.Item>
                ) : (
                  ''
                )}
                {tail_option_shown &&
                vore_sprite_flags.includes('Undergarment addition') ? (
                  <div>
                    <LabeledList.Item label="Undergarment type to affect">
                      <Button
                        onClick={() =>
                          act('set_attribute', {
                            attribute: 'b_undergarment_choice',
                          })
                        }
                        content={undergarment_chosen}
                      />
                    </LabeledList.Item>
                    <LabeledList.Item label="Undergarment if none equipped">
                      <Button
                        onClick={() =>
                          act('set_attribute', {
                            attribute: 'b_undergarment_if_none',
                          })
                        }
                        content={undergarment_if_none}
                      />
                    </LabeledList.Item>
                  </div>
                ) : (
                  ''
                )}
                {tail_option_shown &&
                vore_sprite_flags.includes('Tail adjustment') ? (
                  <LabeledList.Item label="Tail to change to">
                    <Button
                      onClick={() =>
                        act('set_attribute', {
                          attribute: 'b_tail_to_change_to',
                        })
                      }
                      content={tail_to_change_to}
                    />
                  </LabeledList.Item>
                ) : (
                  ''
                )}
              </span>
            ) : (
              ''
            )}
          </LabeledList>
        </Flex>
      </Section>
      <Section title="Belly Fullscreens Preview and Coloring">
        <Flex direction="row">
          <Box
            backgroundColor={belly_fullscreen_color}
            width="20px"
            height="20px"
          />
          <Button
            icon="eye-dropper"
            onClick={() =>
              act('set_attribute', {
                attribute: 'b_fullscreen_color',
                val: null,
              })
            }
          >
            Select Primary Color
          </Button>
          <Box
            backgroundColor={belly_fullscreen_color_secondary}
            width="20px"
            height="20px"
          />
          <Button
            icon="eye-dropper"
            onClick={() =>
              act('set_attribute', {
                attribute: 'b_fullscreen_color_secondary',
                val: null,
              })
            }
          >
            Select Secondary Color
          </Button>
          <Box
            backgroundColor={belly_fullscreen_color_trinary}
            width="20px"
            height="20px"
          />
          <Button
            icon="eye-dropper"
            onClick={() =>
              act('set_attribute', {
                attribute: 'b_fullscreen_color_trinary',
                val: null,
              })
            }
          >
            Select Trinary Color
          </Button>
          <LabeledList.Item label="Enable Coloration">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_colorization_enabled' })
              }
              icon={colorization_enabled ? 'toggle-on' : 'toggle-off'}
              selected={colorization_enabled}
            >
              {colorization_enabled ? 'Yes' : 'No'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Preview Belly">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_preview_belly' })
              }
            >
              Preview
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Clear Preview">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_clear_preview' })
              }
            >
              Clear
            </Button>
          </LabeledList.Item>
        </Flex>
      </Section>
      <Section>
        <Section title="Vore FX">
          <LabeledList>
            <LabeledList.Item label="Disable Prey HUD">
              <Button
                onClick={() =>
                  act('set_attribute', { attribute: 'b_disable_hud' })
                }
                icon={disable_hud ? 'toggle-on' : 'toggle-off'}
                selected={disable_hud}
              >
                {disable_hud ? 'Yes' : 'No'}
              </Button>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Belly Fullscreens Styles" width="800px">
          Belly styles:
          <Button
            fluid
            selected={belly_fullscreen === '' || belly_fullscreen === null}
            onClick={() =>
              act('set_attribute', { attribute: 'b_fullscreen', val: null })
            }
          >
            Disabled
          </Button>
          {Object.keys(possible_fullscreens).map((key, index) => (
            <span key={index} style={{ width: '256px' }}>
              <Button
                key={key}
                width="256px"
                height="256px"
                selected={key === belly_fullscreen}
                onClick={() =>
                  act('set_attribute', { attribute: 'b_fullscreen', val: key })
                }
              >
                <Box
                  className={classes(['vore240x240', key])}
                  style={{
                    transform: 'translate(0%, 4%)',
                  }}
                />
              </Button>
            </span>
          ))}
        </Section>
      </Section>
    </>
  );
};

const VoreSelectedBellyInteractions = (props) => {
  const { act } = useBackend();

  const { belly } = props;
  const { escapable, interacts } = belly;

  return (
    <Section
      title="Belly Interactions"
      buttons={
        <Button
          onClick={() => act('set_attribute', { attribute: 'b_escapable' })}
          icon={escapable ? 'toggle-on' : 'toggle-off'}
          selected={escapable}
        >
          {escapable ? 'Interactions On' : 'Interactions Off'}
        </Button>
      }
    >
      {escapable ? (
        <LabeledList>
          <LabeledList.Item label="Escape Chance">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_escapechance' })
              }
            >
              {interacts.escapechance + '%'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Absorbed Escape Chance">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_escapechance_absorbed' })
              }
            >
              {interacts.escapechance_absorbed + '%'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Escape Time">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_escapetime' })
              }
            >
              {interacts.escapetime / 10 + 's'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Divider />
          <LabeledList.Item label="Transfer Chance">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_transferchance' })
              }
            >
              {interacts.transferchance + '%'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Transfer Location">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_transferlocation' })
              }
            >
              {interacts.transferlocation
                ? interacts.transferlocation
                : 'Disabled'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Divider />
          <LabeledList.Item label="Secondary Transfer Chance">
            <Button
              onClick={() =>
                act('set_attribute', {
                  attribute: 'b_transferchance_secondary',
                })
              }
            >
              {interacts.transferchance_secondary + '%'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Secondary Transfer Location">
            <Button
              onClick={() =>
                act('set_attribute', {
                  attribute: 'b_transferlocation_secondary',
                })
              }
            >
              {interacts.transferlocation_secondary
                ? interacts.transferlocation_secondary
                : 'Disabled'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Divider />
          <LabeledList.Item label="Absorb Chance">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_absorbchance' })
              }
            >
              {interacts.absorbchance + '%'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Digest Chance">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_digestchance' })
              }
            >
              {interacts.digestchance + '%'}
            </Button>
          </LabeledList.Item>
        </LabeledList>
      ) : (
        'These options only display while interactions are turned on.'
      )}
    </Section>
  );
};

const VoreContentsPanel = (props) => {
  const { act, data } = useBackend();
  const { show_pictures } = data;
  const { contents, belly, outside = false } = props;

  return (
    <>
      {(outside && (
        <Button
          textAlign="center"
          fluid
          mb={1}
          onClick={() => act('pick_from_outside', { pickall: true })}
        >
          All
        </Button>
      )) ||
        null}
      {(show_pictures && (
        <Flex wrap="wrap" justify="center" align="center">
          {contents.map((thing) => (
            <Flex.Item key={thing.name} basis="33%">
              <Button
                width="64px"
                color={thing.absorbed ? 'purple' : stats[thing.stat]}
                style={{
                  verticalAlign: 'middle',
                  marginRight: '5px',
                  borderRadius: '20px',
                }}
                onClick={() =>
                  act(
                    thing.outside ? 'pick_from_outside' : 'pick_from_inside',
                    {
                      pick: thing.ref,
                      belly: belly,
                    },
                  )
                }
              >
                <img
                  src={'data:image/jpeg;base64, ' + thing.icon}
                  width="64px"
                  height="64px"
                  style={{
                    '-ms-interpolation-mode': 'nearest-neighbor',
                    'margin-left': '-5px',
                  }}
                />
              </Button>
              {thing.name}
            </Flex.Item>
          ))}
        </Flex>
      )) || (
        <LabeledList>
          {contents.map((thing) => (
            <LabeledList.Item key={thing.ref} label={thing.name}>
              <Button
                fluid
                mt={-1}
                mb={-1}
                color={thing.absorbed ? 'purple' : stats[thing.stat]}
                onClick={() =>
                  act(
                    thing.outside ? 'pick_from_outside' : 'pick_from_inside',
                    {
                      pick: thing.ref,
                      belly: belly,
                    },
                  )
                }
              >
                Interact
              </Button>
            </LabeledList.Item>
          ))}
        </LabeledList>
      )}
    </>
  );
};

const VoreUserPreferences = (props) => {
  const { act, data } = useBackend();

  const {
    digestable,
    devourable,
    resizable,
    feeding,
    absorbable,
    digest_leave_remains,
    allowmobvore,
    permit_healbelly,
    show_vore_fx,
    can_be_drop_prey,
    can_be_drop_pred,
    allow_inbelly_spawning,
    allow_spontaneous_tf,
    step_mechanics_active,
    pickup_mechanics_active,
    noisy,
    drop_vore,
    stumble_vore,
    slip_vore,
    throw_vore,
    food_vore,
    digest_pain,
    nutrition_message_visible,
    weight_message_visible,
    eating_privacy_global,
  } = data.prefs;

  const { show_pictures } = data;

  const preferences = {
    digestion: {
      action: 'toggle_digest',
      test: digestable,
      tooltip: {
        main: "This button is for those who don't like being digested. It can make you undigestable.",
        enable: 'Click here to allow digestion.',
        disable: 'Click here to prevent digestion.',
      },
      content: {
        enabled: 'Digestion Allowed',
        disabled: 'No Digestion',
      },
    },
    absorbable: {
      action: 'toggle_absorbable',
      test: absorbable,
      tooltip: {
        main: "This button allows preds to know whether you prefer or don't prefer to be absorbed.",
        enable: 'Click here to allow being absorbed.',
        disable: 'Click here to disallow being absorbed.',
      },
      content: {
        enabled: 'Absorption Allowed',
        disabled: 'No Absorption',
      },
    },
    devour: {
      action: 'toggle_devour',
      test: devourable,
      tooltip: {
        main: 'This button is to toggle your ability to be devoured by others.',
        enable: 'Click here to allow being devoured.',
        disable: 'Click here to prevent being devoured.',
      },
      content: {
        enabled: 'Devouring Allowed',
        disabled: 'No Devouring',
      },
    },
    mobvore: {
      action: 'toggle_mobvore',
      test: allowmobvore,
      tooltip: {
        main: "This button is for those who don't like being eaten by mobs.",
        enable: 'Click here to allow being eaten by mobs.',
        disable: 'Click here to prevent being eaten by mobs.',
      },
      content: {
        enabled: 'Mobs eating you allowed',
        disabled: 'No Mobs eating you',
      },
    },
    feed: {
      action: 'toggle_feed',
      test: feeding,
      tooltip: {
        main: 'This button is to toggle your ability to be fed to or by others vorishly.',
        enable: 'Click here to allow being fed to/by other people.',
        disable: 'Click here to prevent being fed to/by other people.',
      },
      content: {
        enabled: 'Feeding Allowed',
        disabled: 'No Feeding',
      },
    },
    healbelly: {
      action: 'toggle_healbelly',
      test: permit_healbelly,
      tooltip: {
        main:
          "This button is for those who don't like healbelly used on them as a mechanic." +
          ' It does not affect anything, but is displayed under mechanical prefs for ease of quick checks.',
        enable: 'Click here to allow being heal-bellied.',
        disable: 'Click here to prevent being heal-bellied.',
      },
      content: {
        enabled: 'Heal-bellies Allowed',
        disabled: 'No Heal-bellies',
      },
    },
    dropnom_prey: {
      action: 'toggle_dropnom_prey',
      test: can_be_drop_prey,
      tooltip: {
        main:
          'This toggle is for spontaneous, environment related vore' +
          ' as prey, including drop-noms, teleporters, etc.',
        enable: 'Click here to allow being spontaneous prey.',
        disable: 'Click here to prevent being spontaneous prey.',
      },
      content: {
        enabled: 'Spontaneous Prey Enabled',
        disabled: 'Spontaneous Prey Disabled',
      },
    },
    dropnom_pred: {
      action: 'toggle_dropnom_pred',
      test: can_be_drop_pred,
      tooltip: {
        main:
          'This toggle is for spontaneous, environment related vore' +
          ' as a predator, including drop-noms, teleporters, etc.',
        enable: 'Click here to allow being spontaneous pred.',
        disable: 'Click here to prevent being spontaneous pred.',
      },
      content: {
        enabled: 'Spontaneous Pred Enabled',
        disabled: 'Spontaneous Pred Disabled',
      },
    },
    toggle_drop_vore: {
      action: 'toggle_drop_vore',
      test: drop_vore,
      tooltip: {
        main:
          'Allows for dropnom spontaneous vore to occur. ' +
          'Note, you still need spontaneous vore pred and/or prey enabled.',
        enable: 'Click here to allow for dropnoms.',
        disable: 'Click here to disable dropnoms.',
      },
      content: {
        enabled: 'Drop Noms Enabled',
        disabled: 'Drop Noms Disabled',
      },
    },
    toggle_slip_vore: {
      action: 'toggle_slip_vore',
      test: slip_vore,
      tooltip: {
        main:
          'Allows for slip related spontaneous vore to occur. ' +
          'Note, you still need spontaneous vore pred and/or prey enabled.',
        enable: 'Click here to allow for slip vore.',
        disable: 'Click here to disable slip vore.',
      },
      content: {
        enabled: 'Slip Vore Enabled',
        disabled: 'Slip Vore Disabled',
      },
    },
    toggle_stumble_vore: {
      action: 'toggle_stumble_vore',
      test: stumble_vore,
      tooltip: {
        main:
          'Allows for stumble related spontaneous vore to occur. ' +
          ' Note, you still need spontaneous vore pred and/or prey enabled.',
        enable: 'Click here to allow for stumble vore.',
        disable: 'Click here to disable stumble vore.',
      },
      content: {
        enabled: 'Stumble Vore Enabled',
        disabled: 'Stumble Vore Disabled',
      },
    },
    toggle_throw_vore: {
      action: 'toggle_throw_vore',
      test: throw_vore,
      tooltip: {
        main:
          'Allows for throw related spontaneous vore to occur. ' +
          ' Note, you still need spontaneous vore pred and/or prey enabled.',
        enable: 'Click here to allow for throw vore.',
        disable: 'Click here to disable throw vore.',
      },
      content: {
        enabled: 'Throw Vore Enabled',
        disabled: 'Throw Vore Disabled',
      },
    },
    toggle_food_vore: {
      action: 'toggle_food_vore',
      test: food_vore,
      tooltip: {
        main:
          'Allows for food related spontaneous vore to occur. ' +
          ' Note, you still need spontaneous vore pred and/or prey enabled.',
        enable: 'Click here to allow for food vore.',
        disable: 'Click here to disable food vore.',
      },
      content: {
        enabled: 'Food Vore Enabled',
        disabled: 'Food Vore Disabled',
      },
    },
    toggle_digest_pain: {
      action: 'toggle_digest_pain',
      test: digest_pain,
      tooltip: {
        main:
          'Allows for pain messages to show when being digested. ' +
          ' Can be toggled off to disable pain messages.',
        enable: 'Click here to allow for digestion pain.',
        disable: 'Click here to disable digestion pain.',
      },
      content: {
        enabled: 'Digestion Pain Enabled',
        disabled: 'Digestion Pain Disabled',
      },
    },
    inbelly_spawning: {
      action: 'toggle_allow_inbelly_spawning',
      test: allow_inbelly_spawning,
      tooltip: {
        main:
          'This toggle is ghosts being able to spawn in one of your bellies.' +
          ' You will have to confirm again when they attempt to.',
        enable: 'Click here to allow prey to spawn in you.',
        disable: 'Click here to prevent prey from spawning in you.',
      },
      content: {
        enabled: 'Inbelly Spawning Allowed',
        disabled: 'Inbelly Spawning Forbidden',
      },
    },
    noisy: {
      action: 'toggle_noisy',
      test: noisy,
      tooltip: {
        main: 'Toggle audible hunger noises.',
        enable: 'Click here to turn on hunger noises.',
        disable: 'Click here to turn off hunger noises.',
      },
      content: {
        enabled: 'Hunger Noises Enabled',
        disabled: 'Hunger Noises Disabled',
      },
    },
    resize: {
      action: 'toggle_resize',
      test: resizable,
      tooltip: {
        main: 'This button is to toggle your ability to be resized by others.',
        enable: 'Click here to allow being resized.',
        disable: 'Click here to prevent being resized.',
      },
      content: {
        enabled: 'Resizing Allowed',
        disabled: 'No Resizing',
      },
    },
    steppref: {
      action: 'toggle_steppref',
      test: step_mechanics_active,
      tooltip: {
        main: '',
        enable:
          'You will not participate in step mechanics.' +
          ' Click to enable step mechanics.',
        disable:
          'This setting controls whether or not you participate in size-based step mechanics.' +
          ' Includes both stepping on others, as well as getting stepped on. Click to disable step mechanics.',
      },
      content: {
        enabled: 'Step Mechanics Enabled',
        disabled: 'Step Mechanics Disabled',
      },
    },
    vore_fx: {
      action: 'toggle_fx',
      test: show_vore_fx,
      tooltip: {
        main: '',
        enable:
          'Regardless of Predator Setting, you will not see their FX settings.' +
          ' Click this to enable showing FX.',
        disable:
          'This setting controls whether or not a pred is allowed to mess with your HUD and fullscreen overlays.' +
          ' Click to disable all FX.',
      },
      content: {
        enabled: 'Show Vore FX',
        disabled: 'Do Not Show Vore FX',
      },
    },
    remains: {
      action: 'toggle_leaveremains',
      test: digest_leave_remains,
      tooltip: {
        main: '',
        enable:
          'Regardless of Predator Setting, you will not leave remains behind.' +
          ' Click this to allow leaving remains.',
        disable:
          'Your Predator must have this setting enabled in their belly modes to allow remains to show up,' +
          ' if they do not, they will not leave your remains behind, even with this on. Click to disable remains.',
      },
      content: {
        enabled: 'Allow Leaving Remains',
        disabled: 'Do Not Allow Leaving Remains',
      },
    },
    pickuppref: {
      action: 'toggle_pickuppref',
      test: pickup_mechanics_active,
      tooltip: {
        main: '',
        enable:
          'You will not participate in pick-up mechanics.' +
          ' Click this to allow picking up/being picked up.',
        disable:
          'Allows macros to pick you up into their hands, and you to pick up micros.' +
          ' Click to disable pick-up mechanics.',
      },
      content: {
        enabled: 'Pick-up Mechanics Enabled',
        disabled: 'Pick-up Mechanics Disabled',
      },
    },
    spontaneous_tf: {
      action: 'toggle_allow_spontaneous_tf',
      test: allow_spontaneous_tf,
      tooltip: {
        main:
          'This toggle is for spontaneous or environment related transformation' +
          ' as a victim, such as via chemicals.',
        enable: 'Click here to allow being spontaneously transformed.',
        disable: 'Click here to disable being spontaneously transformed.',
      },
      content: {
        enabled: 'Spontaneous TF Enabled',
        disabled: 'Spontaneous TF Disabled',
      },
    },
    examine_nutrition: {
      action: 'toggle_nutrition_ex',
      test: nutrition_message_visible,
      tooltip: {
        main: '',
        enable: 'Click here to enable nutrition messages.',
        disable: 'Click here to disable nutrition messages.',
      },
      content: {
        enabled: 'Examine Nutrition Messages Active',
        disabled: 'Examine Nutrition Messages Inactive',
      },
    },
    examine_weight: {
      action: 'toggle_weight_ex',
      test: weight_message_visible,
      tooltip: {
        main: '',
        enable: 'Click here to enable weight messages.',
        disable: 'Click here to disable weight messages.',
      },
      content: {
        enabled: 'Examine Weight Messages Active',
        disabled: 'Examine Weight Messages Inactive',
      },
    },
    eating_privacy_global: {
      action: 'toggle_global_privacy',
      test: eating_privacy_global,
      tooltip: {
        main:
          'Sets default belly behaviour for vorebellies for announcing' +
          ' ingesting or expelling prey' +
          ' Overwritten by belly-specific preferences if set.',
        enable: ' Click here to turn your messages subtle',
        disable: ' Click here to turn your  messages loud',
      },
      content: {
        enabled: 'Global Vore Privacy: Subtle',
        disabled: 'Global Vore Privacy: Loud',
      },
    },
  };

  return (
    <Section
      title="Mechanical Preferences"
      buttons={
        <Button
          icon="eye"
          selected={show_pictures}
          onClick={() => act('show_pictures')}
        >
          Contents Preference: {show_pictures ? 'Show Pictures' : 'Show List'}
        </Button>
      }
    >
      <Flex spacing={1} wrap="wrap" justify="center">
        <Flex.Item basis="32%">
          <VoreUserPreferenceItem spec={preferences.digestion} />
        </Flex.Item>
        <Flex.Item basis="32%" grow={1}>
          <VoreUserPreferenceItem spec={preferences.absorbable} />
        </Flex.Item>
        <Flex.Item basis="32%">
          <VoreUserPreferenceItem spec={preferences.devour} />
        </Flex.Item>
        <Flex.Item basis="32%">
          <VoreUserPreferenceItem spec={preferences.mobvore} />
        </Flex.Item>
        <Flex.Item basis="32%" grow={1}>
          <VoreUserPreferenceItem spec={preferences.feed} />
        </Flex.Item>
        <Flex.Item basis="32%">
          <VoreUserPreferenceItem
            spec={preferences.healbelly}
            tooltipPosition="top"
          />
        </Flex.Item>
        <Flex.Item basis="32%">
          <VoreUserPreferenceItem spec={preferences.dropnom_prey} />
        </Flex.Item>
        <Flex.Item basis="32%" grow={1}>
          <VoreUserPreferenceItem spec={preferences.dropnom_pred} />
        </Flex.Item>
        <Flex.Item basis="32%">
          <VoreUserPreferenceItem spec={preferences.toggle_drop_vore} />
        </Flex.Item>
        <Flex.Item basis="32%">
          <VoreUserPreferenceItem spec={preferences.toggle_slip_vore} />
        </Flex.Item>
        <Flex.Item basis="32%" grow={1}>
          <VoreUserPreferenceItem spec={preferences.toggle_stumble_vore} />
        </Flex.Item>
        <Flex.Item basis="32%">
          <VoreUserPreferenceItem spec={preferences.toggle_throw_vore} />
        </Flex.Item>
        <Flex.Item basis="32%">
          <VoreUserPreferenceItem spec={preferences.toggle_food_vore} />
        </Flex.Item>
        <Flex.Item basis="32%" grow={1}>
          <VoreUserPreferenceItem spec={preferences.toggle_digest_pain} />
        </Flex.Item>
        <Flex.Item basis="32%">
          <VoreUserPreferenceItem spec={preferences.inbelly_spawning} />
        </Flex.Item>
        <Flex.Item basis="32%">
          <VoreUserPreferenceItem spec={preferences.noisy} />
        </Flex.Item>
        <Flex.Item basis="32%" grow={1}>
          <VoreUserPreferenceItem spec={preferences.resize} />
        </Flex.Item>
        <Flex.Item basis="32%">
          <VoreUserPreferenceItem
            spec={preferences.steppref}
            tooltipPosition="top"
          />
        </Flex.Item>
        <Flex.Item basis="32%">
          <VoreUserPreferenceItem
            spec={preferences.vore_fx}
            tooltipPosition="top"
          />
        </Flex.Item>
        <Flex.Item basis="32%" grow={1}>
          <VoreUserPreferenceItem
            spec={preferences.remains}
            tooltipPosition="top"
          />
        </Flex.Item>
        <Flex.Item basis="32%">
          <VoreUserPreferenceItem
            spec={preferences.pickuppref}
            tooltipPosition="top"
          />
        </Flex.Item>
        <Flex.Item basis="32%">
          <VoreUserPreferenceItem spec={preferences.spontaneous_tf} />
        </Flex.Item>
        <Flex.Item basis="32%" grow={1}>
          <Button fluid onClick={() => act('switch_selective_mode_pref')}>
            Selective Mode Preference
          </Button>
        </Flex.Item>
        <Flex.Item basis="32%" grow={3}>
          <VoreUserPreferenceItem spec={preferences.eating_privacy_global} />
        </Flex.Item>
      </Flex>
      <Section title="Aesthetic Preferences">
        <Flex spacing={1} wrap="wrap" justify="center">
          <Flex.Item basis="50%" grow={1}>
            <Button fluid icon="grin-tongue" onClick={() => act('setflavor')}>
              Set Taste
            </Button>
          </Flex.Item>
          <Flex.Item basis="50%">
            <Button fluid icon="wind" onClick={() => act('setsmell')}>
              Set Smell
            </Button>
          </Flex.Item>
          <Flex.Item basis="50%" grow={1}>
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_msgs', msgtype: 'en' })
              }
              icon="flask"
              fluid
            >
              Set Nutrition Examine Message
            </Button>
          </Flex.Item>
          <Flex.Item basis="50%">
            <Button
              onClick={() =>
                act('set_attribute', { attribute: 'b_msgs', msgtype: 'ew' })
              }
              icon="weight-hanging"
              fluid
            >
              Set Weight Examine Message
            </Button>
          </Flex.Item>
          <Flex.Item basis="50%" grow={1}>
            <VoreUserPreferenceItem spec={preferences.examine_nutrition} />
          </Flex.Item>
          <Flex.Item basis="50%">
            <VoreUserPreferenceItem spec={preferences.examine_weight} />
          </Flex.Item>
          <Flex.Item basis="50%">
            <Button
              fluid
              content="Vore Sprite Color"
              onClick={() => act('set_vs_color')}
            />
          </Flex.Item>
        </Flex>
      </Section>
      <Divider />
      <Section>
        <Flex spacing={1}>
          <Flex.Item basis="49%">
            <Button fluid icon="save" onClick={() => act('saveprefs')}>
              Save Prefs
            </Button>
          </Flex.Item>
          <Flex.Item basis="49%" grow={1}>
            <Button fluid icon="undo" onClick={() => act('reloadprefs')}>
              Reload Prefs
            </Button>
          </Flex.Item>
        </Flex>
      </Section>
    </Section>
  );
};

const VoreUserPreferenceItem = (props) => {
  const { act } = useBackend();

  const { spec, ...rest } = props;
  const { action, test, tooltip, content } = spec;

  return (
    <Button
      onClick={() => act(action)}
      icon={test ? 'toggle-on' : 'toggle-off'}
      selected={test}
      fluid
      tooltip={tooltip.main + ' ' + (test ? tooltip.disable : tooltip.enable)}
      {...rest}
    >
      {test ? content.enabled : content.disabled}
    </Button>
  );
};
