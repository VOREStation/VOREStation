import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  DmIcon,
  Icon,
  Section,
  Stack,
  Tooltip,
} from 'tgui-core/components';

import { Data, DDisk, TDisk } from '../data';

export const Misc = (props) => {
  const { act, data } = useBackend<Data>();

  return (
    <Section title="Misc" fill textAlign="center">
      <Stack fill>
        <Stack.Item grow mr={2}>
          <Settings />
          <DiskOptions />
        </Stack.Item>
        <Stack.Item grow>
          <Machines />
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const Settings = (props) => {
  const { act, data } = useBackend<Data>();

  return (
    <Section title="Settings">
      <SyncSettings is_public={!!data.is_public} sync={!!data.sync} />
      <Button fluid icon="lock" onClick={() => act('lock')}>
        Lock Console
      </Button>
      <Button fluid color="bad" icon="trash" onClick={() => act('reset')}>
        Reset R&D Database
      </Button>
    </Section>
  );
};

const SyncSettings = (props: { is_public: boolean; sync: boolean }) => {
  const { act } = useBackend();
  const { is_public, sync } = props;

  if (is_public) {
    return null;
  }

  return sync ? (
    <>
      <Button fluid icon="sync" onClick={() => act('sync')}>
        Sync Database with Network
      </Button>
      <Button fluid icon="unlink" onClick={() => act('togglesync')}>
        Disconnect from Research Network
      </Button>
    </>
  ) : (
    <Button fluid icon="link" onClick={() => act('togglesync')}>
      Connect to Research Network
    </Button>
  );
};

const DiskOptions = (props) => {
  const { act, data } = useBackend<Data>();

  return (
    <Section fill title="Disk Operations">
      {!!data.t_disk && <TechDiskOptions data={data.t_disk} />}
      {!!data.d_disk && <DataDiskOptions data={data.d_disk} />}
      {!(data.t_disk || data.d_disk) && (
        <Box color="average">No Disk Inserted</Box>
      )}
    </Section>
  );
};

const TechDiskOptions = (props: { data: TDisk }) => {
  const { data } = props;
  const { act } = useBackend<Data>();

  return (
    <Stack align="space-around" fontSize={2}>
      <Stack.Item>
        <Icon name="hdd" size={2} textAlign="left" />
      </Stack.Item>
      <Stack.Item textAlign="right" grow>
        <Stack vertical>
          <Stack.Item>
            <Box bold>Technology Disk</Box>
          </Stack.Item>
          <Stack.Item>
            {data.stored ? (
              <Box mt={1}>
                <Tooltip content={data.stored.desc}>
                  <Box>{data.stored.name}</Box>
                </Tooltip>
                <Box>Level {data.stored.level}</Box>
              </Box>
            ) : (
              <Box color="average">Disk is empty.</Box>
            )}
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <Box>
          <Button
            icon="eject"
            fontSize={2}
            tooltip="Eject"
            tooltipPosition="right"
            onClick={() => act('eject_tech')}
          />
        </Box>
        {data.stored && (
          <>
            <Box>
              <Button
                mt={1}
                icon="upload"
                fontSize={2}
                tooltip="Upload Contents"
                tooltipPosition="right"
                onClick={() => act('updt_tech')}
              />
            </Box>
            <Box>
              <Button
                mt={1}
                icon="eraser"
                fontSize={2}
                tooltip="Erase Contents"
                tooltipPosition="right"
                onClick={() => act('clear_tech')}
              />
            </Box>
          </>
        )}
      </Stack.Item>
    </Stack>
  );
};

const DataDiskOptions = (props: { data: DDisk }) => {
  const { data } = props;
  const { act } = useBackend<Data>();

  return (
    <Stack align="space-around" fontSize={2}>
      <Stack.Item>
        <Icon name="hdd" size={2} textAlign="left" />
      </Stack.Item>
      <Stack.Item textAlign="right" grow>
        <Stack vertical>
          <Stack.Item>
            <Box bold>Data Disk</Box>
          </Stack.Item>
          <Stack.Item>
            {data.stored ? (
              <Box mt={1}>
                <Box>{data.stored.name}</Box>
                <Box>
                  {Object.keys(data.stored.materials).map((mat) => (
                    <Box key={mat}>
                      {mat} x {data.stored?.materials[mat]}
                    </Box>
                  ))}
                </Box>
              </Box>
            ) : (
              <Box color="average">Disk is empty.</Box>
            )}
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <Box>
          <Button
            icon="eject"
            fontSize={2}
            tooltip="Eject"
            tooltipPosition="right"
            onClick={() => act('eject_design')}
          />
        </Box>
        {data.stored && (
          <>
            <Box>
              <Button
                mt={1}
                icon="upload"
                fontSize={2}
                tooltip="Upload Contents"
                tooltipPosition="right"
                onClick={() => act('updt_design')}
              />
            </Box>
            <Box>
              <Button
                mt={1}
                icon="eraser"
                fontSize={2}
                tooltip="Erase Contents"
                tooltipPosition="right"
                onClick={() => act('clear_design')}
              />
            </Box>
          </>
        )}
      </Stack.Item>
    </Stack>
  );
};

const Machines = (props) => {
  const { act, data } = useBackend<Data>();
  return (
    <Section fill title="Machines">
      <Button fluid icon="sync" onClick={() => act('find_device')}>
        Re-sync with Nearby Devices
      </Button>
      <Stack fill vertical justify="space-around">
        <Stack.Item>
          <Machine exists={!!data.linked_lathe} type={MachineType.Protolathe} />
        </Stack.Item>
        <Stack.Item>
          <Machine
            exists={!!data.linked_imprinter}
            type={MachineType.CircuitImprinter}
          />
        </Stack.Item>
        <Stack.Item>
          <Machine
            exists={!!data.linked_destroy}
            type={MachineType.DestructiveAnalyzer}
          />
        </Stack.Item>
      </Stack>
    </Section>
  );
};

enum MachineType {
  Protolathe,
  CircuitImprinter,
  DestructiveAnalyzer,
}

const machineTypeToState = {
  [MachineType.Protolathe]: 'protolathe',
  [MachineType.CircuitImprinter]: 'circuit_imprinter',
  [MachineType.DestructiveAnalyzer]: 'd_analyzer',
};

const machineTypeToName = {
  [MachineType.Protolathe]: 'Protolathe',
  [MachineType.CircuitImprinter]: 'Circuit Imprinter',
  [MachineType.DestructiveAnalyzer]: 'Destructive Analyzer',
};

const machineTypeToLink = {
  [MachineType.Protolathe]: 'lathe',
  [MachineType.CircuitImprinter]: 'imprinter',
  [MachineType.DestructiveAnalyzer]: 'destroy',
};

const Machine = (props: { type: MachineType; exists: boolean }) => {
  const { act } = useBackend();
  const { type, exists } = props;
  return (
    <Stack align="center" p={1}>
      <Stack.Item grow>
        <DmIcon
          icon="icons/obj/machines/research.dmi"
          icon_state={machineTypeToState[type]}
          width={8}
          height={8}
        />
      </Stack.Item>
      <Stack.Item grow>
        <Stack vertical>
          <Stack.Item>
            <Box bold>{machineTypeToName[type]}</Box>
          </Stack.Item>
          <Stack.Item>
            <Box bold color={exists ? 'good' : 'bad'}>
              {exists ? 'Connected' : 'Not Connected'}
            </Box>
          </Stack.Item>
          {!!exists && (
            <Stack.Item>
              <Button
                fluid
                icon="unlink"
                mt={1}
                onClick={() =>
                  act('disconnect', { disconnect: machineTypeToLink[type] })
                }
              >
                Unlink
              </Button>
            </Stack.Item>
          )}
        </Stack>
      </Stack.Item>
    </Stack>
  );
};
