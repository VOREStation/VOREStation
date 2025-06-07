import { type ReactNode } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Section, Stack } from 'tgui-core/components';

import {
  type Job,
  type OccupationData,
  type OccupationDataConstant,
  type OccupationDataStatic,
  Selected,
} from './data';

export const Occupation = (props: {
  data: OccupationData;
  staticData: OccupationDataStatic;
  serverData: OccupationDataConstant;
}) => {
  const { data, staticData, serverData } = props;

  return (
    <OccupationContent
      data={data}
      staticData={staticData}
      serverData={serverData}
    />
  );
};

export const OccupationContent = (props: {
  data: OccupationData;
  staticData: OccupationDataStatic;
  serverData: OccupationDataConstant;
}) => {
  const { data, staticData, serverData } = props;
  const { alternate_option, jobs } = data;

  const departments = Object.keys(jobs);

  const first_half: Job[] = [];
  const second_half: Job[] = [];

  for (let i = 0; i < departments.length; i++) {
    if (i <= departments.length / 2) {
      first_half.push(...jobs[departments[i]]);
    } else {
      second_half.push(...jobs[departments[i]]);
    }
  }

  return (
    <Section
      fill
      scrollable
      title={'Choose Occupation Chances'}
      mt={1}
      buttons={
        <Button
          color="transparent"
          icon="question"
          tooltip="Left click to increase priority, right click to decrease priority"
          tooltipPosition="bottom-end"
        />
      }
    >
      <Stack fill>
        <Stack.Item grow>
          {first_half.map((job) => (
            <JobBox key={job.ref} job={job} />
          ))}
        </Stack.Item>
        <Stack.Item grow>
          {second_half.map((job) => (
            <JobBox key={job.ref} job={job} />
          ))}
        </Stack.Item>
      </Stack>
    </Section>
  );
};

export const selected2text = (selected: Selected) => {
  switch (selected) {
    case Selected.Yes:
      return <Box color="good">[YES]</Box>;
    case Selected.High:
      return <Box color="good">[HIGH]</Box>;
    case Selected.Medium:
      return <Box color="average">[MEDIUM]</Box>;
    case Selected.Low:
      return <Box color="bad">[LOW]</Box>;
    case Selected.Never:
      return <Box color="black">[NEVER]</Box>;
  }
};

export const selected_next = (selected: Selected) => {
  switch (selected) {
    case Selected.Yes:
      return 4;
    case Selected.Medium:
      return 1;
    case Selected.Low:
      return 2;
    case Selected.Never:
      return 3;
  }
};

export const selected_prev = (selected: Selected) => {
  switch (selected) {
    case Selected.Yes:
      return 4; // to never
    case Selected.High:
      return 2; // to medium
    case Selected.Medium:
      return 3; // to low
    case Selected.Low:
      return 4; // to never
    case Selected.Never:
      return 4; // to never
  }
};

export const JobBox = (props: { job: Job }) => {
  const { act } = useBackend();
  const { job } = props;

  let disabledReason: ReactNode | null = null;
  if (job.banned) {
    disabledReason = <Box bold>[BANNED]</Box>;
  } else if (job.denylist_days) {
    disabledReason = <Box bold>[IN {job.available_in_days} DAYS]</Box>;
  } else if (job.denylist_playtime) {
    disabledReason = (
      <Box bold>[IN {job.available_in_hours.toFixed(1)} DEPTHOURS]</Box>
    );
  } else if (job.denylist_whitelist) {
    disabledReason = <Box bold>[WHITELIST ONLY]</Box>;
    // EVIL
  } else if (job.denylist_character_age) {
    disabledReason = (
      <Box bold>[MIN CHARACTER AGE FOR SELECTED RACE/BRAIN: {job.min_age}]</Box>
    );
  }

  return (
    <Box backgroundColor={job.selection_color} pl={0.4} pt={0.4} pb={0.4}>
      <Stack fill>
        <Stack.Item grow>
          <Button
            style={{
              border: '1px solid black',
              textDecoration: disabledReason ? 'line-through' : 'unset',
            }}
            onClick={() => act('job_info', { rank: job.title })}
          >
            {job.title}
          </Button>
        </Stack.Item>
        <Stack.Item grow>
          {disabledReason || (
            <Box>
              <Box>
                <Button
                  style={{ border: '1px solid black' }}
                  onClick={() =>
                    act('set_job', {
                      set_job: job.title,
                      level: selected_next(job.selected),
                    })
                  }
                  onContextMenu={(e: React.MouseEvent<HTMLDivElement>) => {
                    e.preventDefault();
                    act('set_job', {
                      set_job: job.title,
                      level: selected_prev(job.selected),
                    });
                  }}
                >
                  {selected2text(job.selected)}
                </Button>
              </Box>
              {job.alt_titles.length ? (
                <Box mt={0.2}>
                  <Button
                    style={{ border: '1px solid black' }}
                    onClick={() => act('select_alt_title', { job: job.ref })}
                  >
                    [{job.selected_title}]
                  </Button>
                </Box>
              ) : null}
            </Box>
          )}
        </Stack.Item>
      </Stack>
    </Box>
  );
};
