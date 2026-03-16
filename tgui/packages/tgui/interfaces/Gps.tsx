import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  Divider,
  Icon,
  Input,
  LabeledList,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';
import { flow } from 'tgui-core/fp';
import { clamp } from 'tgui-core/math';
import type { BooleanLike } from 'tgui-core/react';
import { createSearch } from 'tgui-core/string';
import { vecLength, vecSubtract } from 'tgui-core/vector';
import { PreferenceEditColor } from './PreferencesMenu/elements/ColorInput';

const coordsToVec = (coords: string) => coords.split(', ').map(parseFloat);

type Data = {
  theme: string | null;
  currentArea: string;
  power: BooleanLike;
  tag: string;
  currentCoords: string; // "x, y, z"
  localMode: BooleanLike;
  currentZName: string;
  signals: Signal[];
  canHide: BooleanLike;
  isHidden: BooleanLike;
};

type Signal = {
  ref: string;
  gpsTag: string;
  areaName: string;
  local: BooleanLike;
  zName: string;
  trackingColor: string | null;
  trackingName: BooleanLike;
  coords?: string;
  degrees?: number;
  dist?: number;
};

function sortSignal(a: Signal, b: Signal) {
  if (a.dist === undefined && b.dist === undefined) return 0;
  if (a.dist === undefined) return 1;
  if (b.dist === undefined) return -1;
  if (a.dist < b.dist) return -1;
  if (a.dist > b.dist) return 1;
  else return a.gpsTag.localeCompare(b.gpsTag);
}

export const Gps = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    theme,
    currentArea,
    currentCoords,
    localMode,
    power,
    tag,
    canHide,
    isHidden,
    currentZName,
  } = data;

  const [search, setSearch] = useState('');
  const searchName = createSearch<Signal>(search, (gps) => gps.gpsTag);
  const signals: Signal[] = flow([
    (signals: Signal[]) =>
      signals.map((signal, index) => {
        // Calculate distance to the target. BYOND distance is capped to 127,
        // that's why we roll our own calculations here.
        const dist =
          signal.dist &&
          Math.round(
            vecLength(
              vecSubtract(
                coordsToVec(currentCoords),
                coordsToVec(signal.coords || ''),
              ),
            ),
          );
        return { ...signal, dist, index };
      }),
    (signals: Signal[]) => signals.sort((a, b) => sortSignal(a, b)),
  ])(data.signals || []);

  return (
    <Window
      title="Global Positioning System"
      width={600}
      height={700}
      theme={theme ? theme : undefined}
    >
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Section
              title="Control"
              buttons={
                <Button
                  tooltip="Power off the GPS. Unpoered devices can not be tracked."
                  icon="power-off"
                  selected={power}
                  onClick={() => act('power')}
                >
                  {power ? 'On' : 'Off'}
                </Button>
              }
            >
              <LabeledList>
                <LabeledList.Item label="Tag">
                  <Button.Input
                    fluid
                    icon="pencil-alt"
                    onCommit={(value) => act('rename', { value })}
                    value={tag}
                  />
                </LabeledList.Item>
                <LabeledList.Item label="Range">
                  <Button
                    tooltip={`Adjust the signal receiver to ${localMode ? 'BROAD' : 'NARROW'}.`}
                    icon={localMode ? 'signal' : 'tower-broadcast'}
                    selected={!localMode}
                    onClick={() => act('localMode')}
                  >
                    {localMode ? 'NARROW' : 'BROAD'}
                  </Button>
                </LabeledList.Item>
                {!!canHide && (
                  <LabeledList.Item label="Hide Signal">
                    <Button
                      tooltip={`Adjust the GPS to ${isHidden ? '' : 'not'} broadcast a signal.`}
                      icon={isHidden ? 'eye-low-vision' : 'eye'}
                      color={!isHidden && 'bad'}
                      onClick={() => act('hideSignal')}
                    >
                      {isHidden ? 'HIDDEN' : 'VISIBLE'}
                    </Button>
                  </LabeledList.Item>
                )}
              </LabeledList>
            </Section>
          </Stack.Item>
          {!!power && (
            <>
              <Stack.Item>
                <Section title="Current Location">
                  <Box fontSize="18px">
                    {currentArea} ({currentCoords} | {currentZName})
                  </Box>
                </Section>
              </Stack.Item>
              <Stack.Item grow>
                <Section
                  fill
                  title="Detected Signals"
                  scrollable
                  buttons={
                    <Input
                      placeholder="Search name..."
                      width="200px"
                      value={search}
                      onChange={(value) => setSearch(value)}
                    />
                  }
                >
                  <Table>
                    <Table.Row header>
                      <Table.Cell>Name</Table.Cell>
                      <Table.Cell collapsing>Options</Table.Cell>
                      <Table.Cell collapsing>Direction</Table.Cell>
                      <Table.Cell collapsing>Coordinates</Table.Cell>
                    </Table.Row>
                    {signals.length ? (
                      signals.filter(searchName).map((signal, index) => (
                        <Table.Row
                          key={signal.gpsTag + signal.coords + index}
                          className="candystripe"
                        >
                          <Table.Cell bold color="label">
                            {signal.gpsTag}
                          </Table.Cell>
                          <Table.Cell>
                            {signal.trackingColor ? (
                              <Stack>
                                <Stack.Item>
                                  <Button
                                    tooltip="Stop tracking this GPS."
                                    color="red"
                                    icon="circle-stop"
                                    onClick={() =>
                                      act('stopTrack', { ref: signal.ref })
                                    }
                                  />
                                </Stack.Item>
                                <Stack.Item>
                                  <PreferenceEditColor
                                    back_color={signal.trackingColor}
                                    onClose={(value) =>
                                      act('trackColor', {
                                        ref: signal.ref,
                                        color: value,
                                      })
                                    }
                                  />
                                </Stack.Item>
                                <Stack.Item>
                                  <Button
                                    selected={signal.trackingName}
                                    tooltip={`${signal.trackingName ? 'Hide' : 'Show'} this GPS label.`}
                                    icon="tag"
                                    onClick={() =>
                                      act('trackLabel', { ref: signal.ref })
                                    }
                                  />
                                </Stack.Item>
                              </Stack>
                            ) : (
                              <Button
                                onClick={() =>
                                  act('startTrack', { ref: signal.ref })
                                }
                              >
                                Track
                              </Button>
                            )}
                          </Table.Cell>
                          {signal.local ? (
                            <Table.Cell
                              collapsing
                              opacity={
                                signal.dist !== undefined &&
                                clamp(
                                  1.2 / Math.log(Math.E + signal.dist / 20),
                                  0.4,
                                  1,
                                )
                              }
                            >
                              {signal.degrees !== undefined && (
                                <Icon
                                  mr={1}
                                  size={1.2}
                                  name="arrow-up"
                                  rotation={signal.degrees}
                                />
                              )}
                              {signal.dist !== undefined && `${signal.dist}m`}
                            </Table.Cell>
                          ) : (
                            <Table.Cell collapsing>Non-local</Table.Cell>
                          )}
                          <Table.Cell collapsing>
                            {signal.coords} | {signal.zName}
                          </Table.Cell>
                        </Table.Row>
                      ))
                    ) : (
                      <>
                        <Divider />
                        <Table.Row>
                          <Table.Cell align="center" color="label" colSpan={4}>
                            No signals detetcted.
                          </Table.Cell>
                        </Table.Row>
                      </>
                    )}
                  </Table>
                </Section>
              </Stack.Item>
            </>
          )}
        </Stack>
      </Window.Content>
    </Window>
  );
};
