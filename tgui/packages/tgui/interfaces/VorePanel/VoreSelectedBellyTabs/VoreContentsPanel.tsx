import { useEffect, useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  ColorBox,
  Dropdown,
  Image,
  Input,
  LabeledList,
  Section,
  Stack,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { createSearch } from 'tgui-core/string';
import { stats } from '../constants';
import { ourTypeToOptions } from '../functions';
import type { contentData, DropdownEntry } from '../types';

export const VoreContentsPanel = (props: {
  contents?: contentData[] | null;
  targetBelly?: string;
  onTargetBely?: React.Dispatch<React.SetStateAction<string>>;
  bellyDropdownNames?: DropdownEntry[];
  belly?: string;
  outside?: BooleanLike;
  show_pictures: BooleanLike;
  icon_overflow: BooleanLike;
}) => {
  const { act } = useBackend();
  const [selectedAtom, setSelectedAtom] = useState<contentData | null>(null);
  const [contentSearchText, setContentSearchText] = useState<string>('');

  const {
    contents = [],
    targetBelly = '',
    onTargetBely,
    bellyDropdownNames,
    belly,
    outside = false,
    show_pictures,
    icon_overflow,
  } = props;

  useEffect(() => {
    if (
      selectedAtom &&
      !contents?.some((item) => item.ref === selectedAtom.ref)
    ) {
      setSelectedAtom(null);
    }
  }, [contents]);

  function bellyValueToName(value: string) {
    const bellyName = bellyDropdownNames
      ?.map((entry) => {
        if (entry.value === value) {
          return entry.displayText;
        }
        return undefined;
      })
      .filter((value) => value !== undefined);
    if (Array.isArray(bellyName) && bellyName.length) {
      return bellyName[0];
    }
    return '';
  }

  const contentSearch = createSearch(
    contentSearchText,
    (content: contentData) => content.name,
  );
  const displayedContents = contents?.filter(contentSearch);

  return (
    <Section
      fill
      title="Contents"
      buttons={
        <Stack>
          <Stack.Item>
            <Input
              width="200px"
              value={contentSearchText}
              onChange={setContentSearchText}
              placeholder="Search contents..."
            />
          </Stack.Item>
          <Stack.Item>
            <Button
              icon={show_pictures ? 'image' : 'list-check'}
              width="100px"
              selected={show_pictures}
              disabled={icon_overflow}
              tooltip={
                'Allows to toggle if belly contents are shown as icons or in list format. ' +
                (show_pictures
                  ? 'Contents shown as pictures.'
                  : 'Contents shown as lists.') +
                (show_pictures && icon_overflow
                  ? 'Temporarily disabled. Stomach contents above limits.'
                  : '')
              }
              backgroundColor={show_pictures && icon_overflow ? 'orange' : ''}
              onClick={() => act('show_pictures')}
            >
              {show_pictures ? 'Picture View' : 'List View'}
            </Button>
          </Stack.Item>
        </Stack>
      }
    >
      <Stack fill vertical>
        {!!outside && (
          <Stack.Item>
            <Stack align="baseline">
              <Stack.Item grow>
                <Button.Confirm
                  textAlign="center"
                  tooltip="Eject all contents at your current location."
                  confirmContent="Confirm Eject All?"
                  fluid
                  mb={1}
                  onClick={() =>
                    act('pick_from_outside', {
                      pickall: true,
                      intent: 'eject_all',
                    })
                  }
                >
                  Eject All
                </Button.Confirm>
              </Stack.Item>
              <Stack.Item grow>
                <Button.Confirm
                  textAlign="center"
                  tooltip="Move all contents towards the selected destination."
                  disabled={!targetBelly}
                  confirmContent="Confirm Move All?"
                  fluid
                  mb={1}
                  onClick={() =>
                    act('pick_from_outside', {
                      pickall: true,
                      intent: 'move_all',
                      val: targetBelly,
                    })
                  }
                >
                  Move All
                </Button.Confirm>
              </Stack.Item>
              {!!bellyDropdownNames && !!onTargetBely && (
                <>
                  <Stack.Item color="label">Destination:</Stack.Item>
                  <Stack.Item>
                    <Dropdown
                      onSelected={(value) => onTargetBely(value)}
                      options={bellyDropdownNames!}
                      selected={bellyValueToName(targetBelly)}
                    />
                  </Stack.Item>
                </>
              )}
            </Stack>
          </Stack.Item>
        )}
        <Stack.Item>
          {selectedAtom ? (
            <Stack>
              {ourTypeToOptions(
                selectedAtom.our_type,
                !!selectedAtom.outside,
                bellyValueToName(targetBelly),
              ).map((option) => (
                <Stack.Item key={option.name}>
                  {option.needsConfirm ? (
                    <Button.Confirm
                      color={option.color}
                      tooltip={option.tooltip}
                      disabled={option.disabled}
                      onClick={() =>
                        act(
                          selectedAtom.outside
                            ? 'pick_from_outside'
                            : 'pick_from_inside',
                          {
                            option: option.name,
                            pick: selectedAtom.ref,
                            targetBelly: targetBelly,
                            belly: belly,
                          },
                        )
                      }
                    >
                      {option.name}
                    </Button.Confirm>
                  ) : (
                    <Button
                      color={option.color}
                      tooltip={option.tooltip}
                      disabled={option.disabled}
                      onClick={() =>
                        act(
                          selectedAtom.outside
                            ? 'pick_from_outside'
                            : 'pick_from_inside',
                          {
                            option: option.name,
                            pick: selectedAtom.ref,
                            targetBelly: targetBelly,
                            belly: belly,
                          },
                        )
                      }
                    >
                      {option.name}
                    </Button>
                  )}
                </Stack.Item>
              ))}
              <Stack.Item grow />
              <Stack.Item>
                <Button
                  tooltip="Open legacy list selection which persists UI closing."
                  onClick={() =>
                    act(
                      selectedAtom.outside
                        ? 'pick_from_outside'
                        : 'pick_from_inside',
                      {
                        pick: selectedAtom.ref,
                        belly: belly,
                      },
                    )
                  }
                  disabled={!selectedAtom}
                >
                  List Window
                </Button>
              </Stack.Item>
            </Stack>
          ) : (
            <Box height="20px">Select something to interact with it.</Box>
          )}
        </Stack.Item>
        <Stack.Divider />
        <Stack.Item grow>
          <Section fill scrollable>
            {(show_pictures && !icon_overflow && (
              <Stack wrap="wrap" justify="center" align="center">
                {displayedContents?.map((thing) => (
                  <Stack.Item key={thing.ref} basis="32%">
                    <Button
                      width="64px"
                      selected={thing.ref === selectedAtom?.ref}
                      color={thing.absorbed ? 'purple' : stats[thing.stat]}
                      style={{
                        verticalAlign: 'middle',
                        marginRight: '5px',
                        borderRadius: '20px',
                      }}
                      onClick={() => {
                        if (selectedAtom?.ref === thing.ref) {
                          setSelectedAtom(null);
                        } else {
                          setSelectedAtom(thing);
                        }
                      }}
                    >
                      <Image
                        src={`data:image/jpeg;base64,${thing.icon}`}
                        width="64px"
                        height="64px"
                        style={{
                          marginLeft: '-5px',
                        }}
                      />
                    </Button>
                    {thing.ref === selectedAtom?.ref &&
                      (!!stats[thing.stat] || !!thing.absorbed) && (
                        <>
                          <ColorBox
                            color={
                              thing.absorbed ? 'purple' : stats[thing.stat]
                            }
                          />
                          <Box inline preserveWhitespace>
                            {' '}
                          </Box>
                        </>
                      )}
                    {thing.name}
                  </Stack.Item>
                ))}
              </Stack>
            )) || (
              <LabeledList>
                {displayedContents?.map((thing) => (
                  <LabeledList.Item key={thing.ref} label={thing.name}>
                    <Button
                      fluid
                      mt={-1}
                      mb={-1}
                      selected={thing.ref === selectedAtom?.ref}
                      color={thing.absorbed ? 'purple' : stats[thing.stat]}
                      onClick={() => {
                        if (selectedAtom?.ref === thing.ref) {
                          setSelectedAtom(null);
                        } else {
                          setSelectedAtom(thing);
                        }
                      }}
                    >
                      <Stack align="center">
                        <Stack.Item grow>Interact</Stack.Item>
                        {thing.ref === selectedAtom?.ref && (
                          <ColorBox
                            color={
                              thing.absorbed ? 'purple' : stats[thing.stat]
                            }
                          />
                        )}
                      </Stack>
                    </Button>
                  </LabeledList.Item>
                ))}
              </LabeledList>
            )}
          </Section>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
