import { useBackend } from 'tgui/backend';
import { NtosWindow } from 'tgui/layouts';
import {
  Box,
  Button,
  Icon,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
  Stack,
} from 'tgui-core/components';
import { toFixed } from 'tgui-core/math';
import type { BooleanLike } from 'tgui-core/react';

type Data = {
  PC_device_theme: string;
  downloading: BooleanLike;
  error: string | BooleanLike;
  downloadname: string | undefined;
  downloaddesc: string | undefined;
  downloadsize: number | undefined;
  downloadspeed: number | undefined;
  downloadcompletion: number | undefined;
  disk_size: number;
  disk_used: number;
  hackedavailable: BooleanLike;
  hacked_programs: program[];
  downloadable_programs: program[];
  downloads_queue: string[];
};

type program = {
  filename: string;
  filedesc: string;
  fileinfo: string;
  compatibility: string;
  size: number;
  icon: string;
};

export const NtosNetDownloader = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    PC_device_theme,
    disk_size,
    disk_used,
    downloadable_programs = [],
    error,
    hacked_programs = [],
    hackedavailable,
  } = data;
  return (
    <NtosWindow theme={PC_device_theme} width={480} height={735}>
      <NtosWindow.Content scrollable>
        {!!error && (
          <NoticeBox>
            <Box mb={1}>{error}</Box>
            <Button onClick={() => act('PRG_reseterror')}>Reset</Button>
          </NoticeBox>
        )}
        <Section>
          <LabeledList>
            <LabeledList.Item label="Disk usage">
              <ProgressBar value={disk_used} minValue={0} maxValue={disk_size}>
                {`${disk_used} GQ / ${disk_size} GQ`}
              </ProgressBar>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section>
          {downloadable_programs.map((program) => (
            <Program key={program.filename} program={program} />
          ))}
        </Section>
        {!!hackedavailable && (
          <Section title="UNKNOWN Software Repository">
            <NoticeBox mb={1}>
              Please note that Nanotrasen does not recommend download of
              software from non-official servers.
            </NoticeBox>
            {hacked_programs.map((program) => (
              <Program key={program.filename} program={program} />
            ))}
          </Section>
        )}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

const Program = (props: { program: program }) => {
  const { program } = props;
  const { act, data } = useBackend<Data>();
  const {
    disk_size,
    disk_used,
    downloadcompletion,
    downloadname,
    downloadsize,
    downloadspeed,
    downloads_queue,
  } = data;
  const disk_free = disk_size - disk_used;
  return (
    <Box mb={3}>
      <Stack align="baseline">
        <Stack.Item bold grow>
          {program.filedesc}
        </Stack.Item>
        <Stack.Item color="label" nowrap>
          {program.size} GQ
        </Stack.Item>
        <Stack.Item ml={2} width="110px" textAlign="center">
          {(program.filename === downloadname && (
            <ProgressBar
              color="green"
              minValue={0}
              maxValue={downloadsize}
              value={downloadcompletion!}
            >
              {toFixed((downloadcompletion! / downloadsize!) * 100, 1)}%&nbsp;
              {'(' + downloadspeed + 'GQ/s)'}
            </ProgressBar>
          )) ||
            (downloads_queue.indexOf(program.filename) !== -1 && (
              <Button
                icon="ban"
                color="bad"
                onClick={() =>
                  act('PRG_removequeued', {
                    filename: program.filename,
                  })
                }
              >
                Queued...
              </Button>
            )) || (
              <Button
                fluid
                icon="download"
                disabled={program.size > disk_free}
                onClick={() =>
                  act('PRG_downloadfile', {
                    filename: program.filename,
                  })
                }
              >
                Download
              </Button>
            )}
        </Stack.Item>
      </Stack>
      {program.compatibility !== 'Compatible' && (
        <Box mt={1} italic fontSize="12px" position="relative">
          <Icon mx={1} color="red" name="times" />
          Incompatible!
        </Box>
      )}
      {program.size > disk_free && (
        <Box mt={1} italic fontSize="12px" position="relative">
          <Icon mx={1} color="red" name="times" />
          Not enough disk space!
        </Box>
      )}
      <Box mt={1} italic color="label" fontSize="12px">
        {program.fileinfo}
      </Box>
    </Box>
  );
};
