import { useBackend } from 'tgui/backend';
import { Box, Section, Stack } from 'tgui-core/components';
import { currentLoadToColor, summarizeItems } from '../../functions';
import type { Data } from '../../types';
import { SleeperCargoStatus } from './SleeperCargoStatus';
import { SleeperPatient } from './SleeperPatient';
import { SleeperSelfClean } from './SleeperSelfClean';

export const SleeperStatusPanel = (props: { name: string }) => {
  const { data } = useBackend<Data>();
  const {
    delivery,
    compactor,
    contents,
    max_item_count,
    ore_storage,
    current_capacity,
    max_ore_storage,
  } = data;
  const { name } = props;

  return (
    <Section fill scrollable>
      <Stack fill vertical>
        {(!!delivery || !!compactor) && !!contents.length && (
          <>
            <Stack.Item>
              <Box bold inline>
                Current load:
              </Box>
              <Box
                inline
                preserveWhitespace
                color={currentLoadToColor(contents.length, max_item_count)}
              >
                {` ${contents.length} / ${max_item_count} objects.`}
              </Box>
            </Stack.Item>
            {delivery ? (
              <SleeperCargoStatus />
            ) : (
              <Stack.Item>
                <Box color="label">{summarizeItems(contents)}</Box>
              </Stack.Item>
            )}
            <Stack.Divider />
          </>
        )}
        {!!ore_storage && (
          <>
            <Stack.Item>
              <Box bold inline>
                Current ore capacity:
              </Box>
              <Box
                inline
                preserveWhitespace
                color={currentLoadToColor(current_capacity, max_ore_storage)}
              >
                {` ${current_capacity} / ${max_ore_storage} ores.`}
              </Box>
            </Stack.Item>
            <Stack.Divider />
          </>
        )}
        <SleeperSelfClean />
        <SleeperPatient name={name} />
      </Stack>
    </Section>
  );
};
