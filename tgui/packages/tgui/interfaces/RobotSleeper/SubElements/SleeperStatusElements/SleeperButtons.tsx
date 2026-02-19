import { useBackend } from 'tgui/backend';
import { Box, Button, Dropdown, Stack } from 'tgui-core/components';
import { EJECTION_OPTIONS } from '../../constants';
import type { Data } from '../../types';

export const SleeperButtons = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    eject_port,
    cleaning,
    medsensor,
    name,
    has_destructive_analyzer,
    techweb_name,
  } = data;

  return (
    <>
      {has_destructive_analyzer && (
        <Stack.Item>
          <Box color="label">Tech Web: {techweb_name}</Box>
        </Stack.Item>
      )}
      <Stack.Item>
        <Stack align="center">
          <Stack.Item>
            <Box color="label">Eject Port:</Box>
          </Stack.Item>
          <Stack.Item>
            <Dropdown
              onSelected={(value: string) => act('port', { value: value })}
              options={EJECTION_OPTIONS}
              selected={eject_port}
            />
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <Stack>
          <Stack.Item>
            <Button.Confirm
              onClick={() => act('eject')}
              tooltip="Eject all your sleeper contents."
            >
              Eject All
            </Button.Confirm>
          </Stack.Item>
          <Stack.Item>
            <Button.Confirm
              onClick={() => act('ingest')}
              tooltip="Moves all your sleepr contents into your currently selected vorebelly."
            >
              Vore All
            </Button.Confirm>
          </Stack.Item>
          <Stack.Item>
            <Button.Confirm
              onClick={() => act('clean')}
              disabled={cleaning}
              color={cleaning ? 'red' : undefined}
              tooltip={`Self-Cleaning mode will fill your ${name} with causic enzymes to remove any objects or biomatter, and convert them into energy.`}
            >
              Self-Clean
            </Button.Confirm>
          </Stack.Item>
          {!!medsensor && (
            <Stack.Item>
              <Button
                onClick={() => act('analyze')}
                tooltip="Scan patient for detailed information."
              >
                Analyze Patient
              </Button>
            </Stack.Item>
          )}
        </Stack>
      </Stack.Item>
    </>
  );
};
