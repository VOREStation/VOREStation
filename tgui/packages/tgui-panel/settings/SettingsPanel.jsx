/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { toFixed } from 'common/math';
import { useState } from 'react';
import { useDispatch, useSelector } from 'tgui/backend';
import {
  Box,
  Button,
  Collapsible,
  ColorBox,
  Divider,
  Dropdown,
  Flex,
  Input,
  LabeledList,
  NumberInput,
  Section,
  Stack,
  Tabs,
  TextArea,
} from 'tgui/components';

import { ChatPageSettings } from '../chat';
import {
  purgeChatMessageArchive,
  rebuildChat,
  saveChatToDisk,
} from '../chat/actions';
import { MESSAGE_TYPES } from '../chat/constants';
import { useGame } from '../game';
import { THEMES } from '../themes';
import {
  addHighlightSetting,
  changeSettingsTab,
  removeHighlightSetting,
  updateHighlightSetting,
  updateSettings,
  updateToggle,
} from './actions';
import { FONTS, MAX_HIGHLIGHT_SETTINGS, SETTINGS_TABS } from './constants';
import {
  selectActiveTab,
  selectHighlightSettingById,
  selectHighlightSettings,
  selectSettings,
} from './selectors';

export const SettingsPanel = (props) => {
  const activeTab = useSelector(selectActiveTab);
  const dispatch = useDispatch();
  return (
    <Stack fill>
      <Stack.Item>
        <Section fitted fill minHeight="8em">
          <Tabs vertical>
            {SETTINGS_TABS.map((tab) => (
              <Tabs.Tab
                key={tab.id}
                selected={tab.id === activeTab}
                onClick={() =>
                  dispatch(
                    changeSettingsTab({
                      tabId: tab.id,
                    }),
                  )
                }
              >
                {tab.name}
              </Tabs.Tab>
            ))}
          </Tabs>
        </Section>
      </Stack.Item>
      <Stack.Item grow={1} basis={0}>
        {activeTab === 'general' && <SettingsGeneral />}
        {activeTab === 'limits' && <MessageLimits />}
        {activeTab === 'export' && <ExportTab />}
        {activeTab === 'chatPage' && <ChatPageSettings />}
        {activeTab === 'textHighlight' && <TextHighlightSettings />}
        {activeTab === 'adminSettings' && <AdminSettings />}
      </Stack.Item>
    </Stack>
  );
};

export const SettingsGeneral = (props) => {
  const {
    theme,
    fontFamily,
    fontSize,
    lineHeight,
    showReconnectWarning,
    prependTimestamps,
    interleave,
    interleaveColor,
  } = useSelector(selectSettings);
  const dispatch = useDispatch();
  const [freeFont, setFreeFont] = useState(false);
  return (
    <Section>
      <LabeledList>
        <LabeledList.Item label="Theme">
          <Dropdown
            width="175px"
            selected={theme}
            options={THEMES}
            onSelected={(value) =>
              dispatch(
                updateSettings({
                  theme: value,
                }),
              )
            }
          />
        </LabeledList.Item>
        <LabeledList.Item label="Font style">
          <Stack inline align="baseline">
            <Stack.Item>
              {(!freeFont && (
                <Dropdown
                  width="175px"
                  selected={fontFamily}
                  options={FONTS}
                  onSelected={(value) =>
                    dispatch(
                      updateSettings({
                        fontFamily: value,
                      }),
                    )
                  }
                />
              )) || (
                <Input
                  value={fontFamily}
                  onChange={(e, value) =>
                    dispatch(
                      updateSettings({
                        fontFamily: value,
                      }),
                    )
                  }
                />
              )}
            </Stack.Item>
            <Stack.Item>
              <Button
                icon={freeFont ? 'lock-open' : 'lock'}
                color={freeFont ? 'good' : 'bad'}
                ml={1}
                onClick={() => {
                  setFreeFont(!freeFont);
                }}
              >
                Custom font
              </Button>
            </Stack.Item>
          </Stack>
        </LabeledList.Item>
        <LabeledList.Item label="Font size">
          <NumberInput
            width="4em"
            step={1}
            stepPixelSize={10}
            minValue={8}
            maxValue={32}
            value={fontSize}
            unit="px"
            format={(value) => toFixed(value)}
            onChange={(e, value) =>
              dispatch(
                updateSettings({
                  fontSize: value,
                }),
              )
            }
          />
        </LabeledList.Item>
        <LabeledList.Item label="Line height">
          <NumberInput
            width="4em"
            step={0.01}
            stepPixelSize={2}
            minValue={0.8}
            maxValue={5}
            value={lineHeight}
            format={(value) => toFixed(value, 2)}
            onDrag={(e, value) =>
              dispatch(
                updateSettings({
                  lineHeight: value,
                }),
              )
            }
          />
        </LabeledList.Item>
        <LabeledList.Item label="Enable disconnection/afk warning">
          <Button.Checkbox
            checked={showReconnectWarning}
            tooltip="Unchecking this will disable the red afk/reconnection warning bar at the bottom of the chat."
            mr="5px"
            onClick={() =>
              dispatch(
                updateSettings({
                  showReconnectWarning: !showReconnectWarning,
                }),
              )
            }
          />
        </LabeledList.Item>
        <LabeledList.Item label="Interleave messages">
          <Button.Checkbox
            checked={interleave}
            tooltip="Enabling this will interleave messages."
            mr="5px"
            onClick={() =>
              dispatch(
                updateSettings({
                  interleave: !interleave,
                }),
              )
            }
          />
          <Box inline>
            <ColorBox mr={1} color={interleaveColor} />
            <Input
              width="5em"
              monospace
              placeholder="#ffffff"
              value={interleaveColor}
              onInput={(e, value) =>
                dispatch(
                  updateSettings({
                    interleaveColor: value,
                  }),
                )
              }
            />
          </Box>
        </LabeledList.Item>
        <LabeledList.Item label="Enable chat timestamps">
          <Button.Checkbox
            checked={prependTimestamps}
            tooltip="Enabling this will prepend timestamps to all messages."
            mr="5px"
            onClick={() =>
              dispatch(
                updateSettings({
                  prependTimestamps: !prependTimestamps,
                }),
              )
            }
          />
          <Box inline>
            <Button icon="check" onClick={() => dispatch(rebuildChat())}>
              Apply now
            </Button>
            <Box inline fontSize="0.9em" ml={1} color="label">
              Can freeze the chat for a while.
            </Box>
          </Box>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

export const MessageLimits = (props) => {
  const dispatch = useDispatch();
  const {
    visibleMessageLimit,
    persistentMessageLimit,
    combineMessageLimit,
    combineIntervalLimit,
    saveInterval,
  } = useSelector(selectSettings);
  return (
    <Section>
      <LabeledList>
        <LabeledList.Item label="Amount of lines to display 500-10000 (Default: 2500)">
          <NumberInput
            width="5em"
            step={100}
            stepPixelSize={2}
            minValue={500}
            maxValue={10000}
            value={visibleMessageLimit}
            format={(value) => toFixed(value)}
            onDrag={(e, value) =>
              dispatch(
                updateSettings({
                  visibleMessageLimit: value,
                }),
              )
            }
          />
          &nbsp;
          {visibleMessageLimit >= 5000 ? (
            <Box inline fontSize="0.9em" color="red">
              Impacts performance!
            </Box>
          ) : (
            ''
          )}
        </LabeledList.Item>
        <LabeledList.Item label="Amount of visually persistent lines 0-10000 (Default: 1000)">
          <NumberInput
            width="5em"
            step={100}
            stepPixelSize={2}
            minValue={0}
            maxValue={10000}
            value={persistentMessageLimit}
            format={(value) => toFixed(value)}
            onDrag={(e, value) =>
              dispatch(
                updateSettings({
                  persistentMessageLimit: value,
                }),
              )
            }
          />
          &nbsp;
          {persistentMessageLimit >= 2500 ? (
            <Box inline fontSize="0.9em" color="red">
              Delays initialization!
            </Box>
          ) : (
            ''
          )}
        </LabeledList.Item>
        <LabeledList.Item label="Amount of different lines in-between to combine 0-10 (Default: 5)">
          <NumberInput
            width="5em"
            step={1}
            stepPixelSize={10}
            minValue={0}
            maxValue={10}
            value={combineMessageLimit}
            format={(value) => toFixed(value)}
            onDrag={(e, value) =>
              dispatch(
                updateSettings({
                  combineMessageLimit: value,
                }),
              )
            }
          />
        </LabeledList.Item>
        <LabeledList.Item label="Time to combine messages 0-10 (Default: 5 Seconds)">
          <NumberInput
            width="5em"
            step={1}
            stepPixelSize={10}
            minValue={0}
            maxValue={10}
            value={combineIntervalLimit}
            unit="s"
            format={(value) => toFixed(value)}
            onDrag={(e, value) =>
              dispatch(
                updateSettings({
                  combineIntervalLimit: value,
                }),
              )
            }
          />
        </LabeledList.Item>
        <LabeledList.Item label="Message store interval 1-10 (Default: 10 Seconds) [Requires restart]">
          <NumberInput
            width="5em"
            step={1}
            stepPixelSize={5}
            minValue={1}
            maxValue={10}
            value={saveInterval}
            unit="s"
            format={(value) => toFixed(value)}
            onDrag={(e, value) =>
              dispatch(
                updateSettings({
                  saveInterval: value,
                }),
              )
            }
          />
          &nbsp;
          {saveInterval <= 3 ? (
            <Box inline fontSize="0.9em" color="red">
              Warning, experimental! Might crash!
            </Box>
          ) : (
            ''
          )}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

export const ExportTab = (props) => {
  const dispatch = useDispatch();
  const game = useGame();
  const {
    storedRounds,
    exportStart,
    exportEnd,
    logRetainRounds,
    logEnable,
    logLineCount,
    logLimit,
    totalStoredMessages,
    storedTypes,
  } = useSelector(selectSettings);
  const [purgeConfirm, setPurgeConfirm] = useState(0);
  const [logConfirm, setLogConfirm] = useState(0);
  return (
    <Section>
      <Flex align="baseline">
        {logEnable ? (
          logConfirm ? (
            <Button
              icon="ban"
              color="red"
              onClick={() => {
                dispatch(
                  updateSettings({
                    logEnable: false,
                  }),
                );
                setLogConfirm(false);
              }}
            >
              Disable?
            </Button>
          ) : (
            <Button
              icon="ban"
              color="red"
              onClick={() => {
                setLogConfirm(true);
                setTimeout(() => {
                  setLogConfirm(false);
                }, 5000);
              }}
            >
              Disable logging
            </Button>
          )
        ) : (
          <Button
            icon="download"
            color="green"
            onClick={() => {
              dispatch(
                updateSettings({
                  logEnable: true,
                }),
              );
            }}
          >
            Enable logging
          </Button>
        )}
        <Flex.Item grow={1} />
        <Flex.Item color="label">Round ID:&nbsp;</Flex.Item>
        <Flex.Item color={game.roundId ? '' : 'red'}>
          {game.roundId ? game.roundId : 'ERROR'}
        </Flex.Item>
      </Flex>
      {logEnable ? (
        <>
          <LabeledList>
            <LabeledList.Item label="Amount of rounds to log (1 to 8)">
              <NumberInput
                width="5em"
                step={1}
                stepPixelSize={10}
                minValue={1}
                maxValue={8}
                value={logRetainRounds}
                format={(value) => toFixed(value)}
                onDrag={(e, value) =>
                  dispatch(
                    updateSettings({
                      logRetainRounds: value,
                    }),
                  )
                }
              />
              &nbsp;
              {logRetainRounds > 3 ? (
                <Box inline fontSize="0.9em" color="red">
                  Warning, might crash!
                </Box>
              ) : (
                ''
              )}
            </LabeledList.Item>
            <LabeledList.Item label="Hardlimit for the log archive (0 = inf. to 50000)">
              <NumberInput
                width="5em"
                step={500}
                stepPixelSize={10}
                minValue={0}
                maxValue={50000}
                value={logLimit}
                format={(value) => toFixed(value)}
                onDrag={(e, value) =>
                  dispatch(
                    updateSettings({
                      logLimit: value,
                    }),
                  )
                }
              />
              &nbsp;
              {logLimit > 0 ? (
                <Box
                  inline
                  fontSize="0.9em"
                  color={logLimit > 10000 ? 'red' : 'label'}
                >
                  {logLimit > 15000
                    ? 'Warning, might crash! Takes priority above round retention.'
                    : 'Takes priority above round retention.'}
                </Box>
              ) : (
                ''
              )}
            </LabeledList.Item>
          </LabeledList>
          <Section>
            <Collapsible mt={1} color="transparent" title="Messages to log">
              {MESSAGE_TYPES.map((typeDef) => (
                <Button.Checkbox
                  key={typeDef.type}
                  checked={storedTypes[typeDef.type]}
                  onClick={() =>
                    dispatch(
                      updateToggle({
                        type: typeDef.type,
                      }),
                    )
                  }
                >
                  {typeDef.name}
                </Button.Checkbox>
              ))}
            </Collapsible>
          </Section>
        </>
      ) : (
        ''
      )}
      <LabeledList>
        <LabeledList.Item label="Export round start (0 = curr.) / end (0 = dis.)">
          <NumberInput
            width="5em"
            step={1}
            stepPixelSize={10}
            minValue={0}
            maxValue={exportEnd === 0 ? 0 : exportEnd - 1}
            value={exportStart}
            format={(value) => toFixed(value)}
            onDrag={(e, value) =>
              dispatch(
                updateSettings({
                  exportStart: value,
                }),
              )
            }
          />
          <NumberInput
            width="5em"
            step={1}
            stepPixelSize={10}
            minValue={exportStart === 0 ? 0 : exportStart + 1}
            maxValue={storedRounds}
            value={exportEnd}
            format={(value) => toFixed(value)}
            onDrag={(e, value) =>
              dispatch(
                updateSettings({
                  exportEnd: value,
                }),
              )
            }
          />
          &nbsp;
          <Box inline fontSize="0.9em" color="label">
            Stored Rounds:&nbsp;
          </Box>
          <Box inline>{storedRounds}</Box>
        </LabeledList.Item>
        <LabeledList.Item label="Amount of lines to export (0 = inf.)">
          <NumberInput
            width="5em"
            step={100}
            stepPixelSize={10}
            minValue={0}
            maxValue={50000}
            value={logLineCount}
            format={(value) => toFixed(value)}
            onDrag={(e, value) =>
              dispatch(
                updateSettings({
                  logLineCount: value,
                }),
              )
            }
          />
        </LabeledList.Item>
        <LabeledList.Item label="Totally stored messages">
          <Box>{totalStoredMessages}</Box>
        </LabeledList.Item>
      </LabeledList>
      <Divider />
      <Button icon="save" onClick={() => dispatch(saveChatToDisk())}>
        Save chat log
      </Button>
      {purgeConfirm > 0 ? (
        <Button
          icon="trash"
          color="red"
          onClick={() => {
            dispatch(purgeChatMessageArchive());
            setPurgeConfirm(2);
          }}
        >
          {purgeConfirm > 1 ? 'Purged!' : 'Are you sure?'}
        </Button>
      ) : (
        <Button
          icon="trash"
          color="red"
          onClick={() => {
            setPurgeConfirm(1);
            setTimeout(() => {
              setPurgeConfirm(false);
            }, 5000);
          }}
        >
          Purge message archive
        </Button>
      )}
    </Section>
  );
};

const TextHighlightSettings = (props) => {
  const highlightSettings = useSelector(selectHighlightSettings);
  const dispatch = useDispatch();
  return (
    <Section fill scrollable height="235px">
      <Section p={0}>
        <Flex direction="column">
          {highlightSettings.map((id, i) => (
            <TextHighlightSetting
              key={i}
              id={id}
              mb={i + 1 === highlightSettings.length ? 0 : '10px'}
            />
          ))}
          {highlightSettings.length < MAX_HIGHLIGHT_SETTINGS && (
            <Flex.Item>
              <Button
                color="transparent"
                icon="plus"
                onClick={() => {
                  dispatch(addHighlightSetting());
                }}
              >
                Add Highlight Setting
              </Button>
            </Flex.Item>
          )}
        </Flex>
      </Section>
      <Divider />
      <Box>
        <Button icon="check" onClick={() => dispatch(rebuildChat())}>
          Apply now
        </Button>
        <Box inline fontSize="0.9em" ml={1} color="label">
          Can freeze the chat for a while.
        </Box>
      </Box>
    </Section>
  );
};

const TextHighlightSetting = (props) => {
  const { id, ...rest } = props;
  const highlightSettingById = useSelector(selectHighlightSettingById);
  const dispatch = useDispatch();
  const {
    highlightColor,
    highlightText,
    blacklistText,
    highlightWholeMessage,
    highlightBlacklist,
    matchWord,
    matchCase,
  } = highlightSettingById[id];
  return (
    <Flex.Item {...rest}>
      <Flex mb={1} color="label" align="baseline">
        <Flex.Item grow>
          <Button
            color="transparent"
            icon="times"
            onClick={() =>
              dispatch(
                removeHighlightSetting({
                  id: id,
                }),
              )
            }
          >
            Delete
          </Button>
        </Flex.Item>
        <Flex.Item>
          <Button.Checkbox
            checked={highlightBlacklist}
            tooltip="If this option is selected, you can blacklist senders not to highlight their messages."
            mr="5px"
            onClick={() =>
              dispatch(
                updateHighlightSetting({
                  id: id,
                  highlightBlacklist: !highlightBlacklist,
                }),
              )
            }
          >
            Highlight Blacklist
          </Button.Checkbox>
        </Flex.Item>
        <Flex.Item>
          <Button.Checkbox
            checked={highlightWholeMessage}
            tooltip="If this option is selected, the entire message will be highlighted in yellow."
            mr="5px"
            onClick={() =>
              dispatch(
                updateHighlightSetting({
                  id: id,
                  highlightWholeMessage: !highlightWholeMessage,
                }),
              )
            }
          >
            Whole Message
          </Button.Checkbox>
        </Flex.Item>
        <Flex.Item>
          <Button.Checkbox
            checked={matchWord}
            tooltipPosition="bottom-start"
            tooltip="If this option is selected, only exact matches (no extra letters before or after) will trigger. Not compatible with punctuation. Overriden if regex is used."
            onClick={() =>
              dispatch(
                updateHighlightSetting({
                  id: id,
                  matchWord: !matchWord,
                }),
              )
            }
          >
            Exact
          </Button.Checkbox>
        </Flex.Item>
        <Flex.Item>
          <Button.Checkbox
            tooltip="If this option is selected, the highlight will be case-sensitive."
            checked={matchCase}
            onClick={() =>
              dispatch(
                updateHighlightSetting({
                  id: id,
                  matchCase: !matchCase,
                }),
              )
            }
          >
            Case
          </Button.Checkbox>
        </Flex.Item>
        <Flex.Item shrink={0}>
          <ColorBox mr={1} color={highlightColor} />
          <Input
            width="5em"
            monospace
            placeholder="#ffffff"
            value={highlightColor}
            onInput={(e, value) =>
              dispatch(
                updateHighlightSetting({
                  id: id,
                  highlightColor: value,
                }),
              )
            }
          />
        </Flex.Item>
      </Flex>
      <TextArea
        height="3em"
        value={highlightText}
        placeholder="Put words to highlight here. Separate terms with commas, i.e. (term1, term2, term3)"
        onChange={(e, value) =>
          dispatch(
            updateHighlightSetting({
              id: id,
              highlightText: value,
            }),
          )
        }
      />
      {highlightBlacklist ? (
        <TextArea
          height="3em"
          value={blacklistText}
          placeholder="Put names of senders you don't want highlighted here. Separate names with commas, i.e. (name1, name2, name3)"
          onChange={(e, value) =>
            dispatch(
              updateHighlightSetting({
                id: id,
                blacklistText: value,
              }),
            )
          }
        />
      ) : (
        ''
      )}
    </Flex.Item>
  );
};

export const AdminSettings = (props) => {
  const dispatch = useDispatch();
  const { hideImportantInAdminTab } = useSelector(selectSettings);
  return (
    <Section>
      <LabeledList>
        <LabeledList.Item label="Hide Important messages in admin only tabs">
          <Button.Checkbox
            checked={hideImportantInAdminTab}
            tooltip="Enabling this will hide all important messages in admin filter exclusive tabs."
            mr="5px"
            onClick={() =>
              dispatch(
                updateSettings({
                  hideImportantInAdminTab: !hideImportantInAdminTab,
                }),
              )
            }
          />
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
