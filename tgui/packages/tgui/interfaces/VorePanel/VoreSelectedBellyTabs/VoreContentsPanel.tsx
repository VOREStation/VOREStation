import { useBackend } from 'tgui/backend';
import {
  Button,
  Dropdown,
  Image,
  LabeledList,
  Stack,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import { stats } from '../constants';
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

  function bellyValueToName(value: string) {
    const bellyName = bellyDropdownNames
      ?.map((entry) => {
        if (entry.value === value) {
          return entry.displayText;
        }
      })
      .filter((value) => value !== undefined);
    if (Array.isArray(bellyName) && bellyName.length) {
      return bellyName[0];
    }
    return '';
  }

  return (
    <>
      {!!outside && (
        <Stack>
          <Stack.Item grow>
            <Button.Confirm
              textAlign="center"
              confirmContent="Confirm Eject All?"
              fluid
              mb={1}
              onClick={() =>
                act('pick_from_outside', { pickall: true, intent: 'eject_all' })
              }
            >
              Eject All
            </Button.Confirm>
          </Stack.Item>
          <Stack.Item grow>
            <Button.Confirm
              textAlign="center"
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
            <Stack.Item>
              <Dropdown
                onSelected={(value) => onTargetBely(value)}
                options={bellyDropdownNames!}
                selected={bellyValueToName(targetBelly)}
              />
            </Stack.Item>
          )}
        </Stack>
      )}
      {(show_pictures && !icon_overflow && (
        <Stack wrap="wrap" justify="center" align="center">
          {contents?.map((thing) => (
            <Stack.Item key={thing.ref} basis="32%">
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
                <Image
                  src={'data:image/jpeg;base64, ' + thing.icon}
                  width="64px"
                  height="64px"
                  style={{
                    marginLeft: '-5px',
                  }}
                />
              </Button>
              {thing.name}
            </Stack.Item>
          ))}
        </Stack>
      )) || (
        <LabeledList>
          {contents?.map((thing) => (
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
