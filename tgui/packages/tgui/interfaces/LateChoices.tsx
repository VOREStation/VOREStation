import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, NoticeBox, Section, Stack } from 'tgui-core/components';

enum Evac {
  Gone = 'Gone',
  Emergency = 'Emergency',
  CrewTransfer = 'Crew Transfer',
  None = 'None',
}

enum Department {
  Command = 'Command',
  Security = 'Security',
  Engineering = 'Engineering',
  Medical = 'Medical',
  Research = 'Research',
  Supply = 'Supply',
  Service = 'Service',
  Expedition = 'Expedition',
  Silicon = 'Silicon',
  Offmap = 'Offmap',
  Unknown = 'Unknown',
}

type Job = {
  title: string;
  priority: number;
  departments: Department[];
  current_positions: number;
  active: number;
  offmap: boolean;
};

type Data = {
  name: string;
  duration: number;
  evac: Evac;
  jobs: Job[];
};

const splitJobs = (
  jobs: Job[],
): { favorites: Job[]; departments: { [key: string]: Job[] } } => {
  const favorites: Job[] = [];
  const departments: { [key: string]: Job[] } = {};

  for (const job of jobs) {
    if (job.priority !== 0) {
      favorites.push(job);
    } else {
      for (const department of job.departments) {
        if (department in departments) {
          departments[department].push(job);
        } else {
          departments[department] = [job];
        }
      }
    }
  }

  favorites.sort((a, b) => a.priority - b.priority);

  return {
    favorites,
    departments,
  };
};

export const LateChoices = (props) => {
  const { act, data } = useBackend<Data>();

  const { name, duration, evac, jobs } = data;

  const { favorites, departments } = splitJobs(jobs);

  return (
    <Window width={300} height={660}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Section title="Late Join">
              <Box fontSize={1.4} textAlign="center">
                Welcome, {name}
              </Box>
              <Box fontSize={1.2} textAlign="center">
                Round Duration: {duration}
              </Box>
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Section title="Choose a position" fill scrollable>
              {favorites.length ? (
                <Section title={<DepartmentTitle department="Favorites" />}>
                  {favorites.map((job) => (
                    <JobButton key={job.title} job={job} />
                  ))}
                </Section>
              ) : null}
              {Object.entries(departments)
                .sort((a, b) => a[0].localeCompare(b[0]))
                .map(([dept, jobs]) => (
                  <Section
                    title={<DepartmentTitle department={dept} />}
                    key={dept}
                  >
                    {jobs.map((job) => (
                      <JobButton key={job.title} job={job} />
                    ))}
                  </Section>
                ))}
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const Evacuation = (props: { evac: Evac }) => {
  const { evac } = props;

  switch (evac) {
    case Evac.None:
      return null;
    case Evac.CrewTransfer:
      return (
        <NoticeBox warning>
          The vessel is currently undergoing crew transfer procedures.
        </NoticeBox>
      );
    case Evac.Emergency:
      return (
        <NoticeBox danger>
          The vessel is currently undergoing evacuation procedures.
        </NoticeBox>
      );
    case Evac.Gone:
      return <NoticeBox danger>The vessel has been evacuated.</NoticeBox>;
    default:
      return null;
  }
};

const priorityToColor = (priority: number): string => {
  switch (priority) {
    case 1:
      return 'good';
    case 2:
      return 'average';
    case 3:
      return 'bad';
    default:
      return '';
  }
};

const JobButton = (props: { job: Job }) => {
  const { act } = useBackend();
  const { job } = props;
  return (
    <Button
      fluid
      color={priorityToColor(job.priority)}
      onClick={() => act('join', { job: job.title })}
    >
      <Stack>
        <Stack.Item grow>{job.title}</Stack.Item>
        <Stack.Item>
          ({job.current_positions}) (Active: {job.active})
        </Stack.Item>
      </Stack>
    </Button>
  );
};

const DepartmentTitle = (props: { department: string }) => {
  const { department } = props;

  switch (department) {
    case 'Favorites':
      return (
        <Box backgroundColor="#4d9121" p={1} m={-1}>
          {department}
        </Box>
      );
    case Department.Command:
      return (
        <Box backgroundColor="#2f2f7f" p={1} m={-1}>
          {department}
        </Box>
      );
    case Department.Security:
      return (
        <Box backgroundColor="#8e2929" p={1} m={-1}>
          {department}
        </Box>
      );
    case Department.Engineering:
      return (
        <Box backgroundColor="#7f6e2c" p={1} m={-1}>
          {department}
        </Box>
      );
    case Department.Medical:
      return (
        <Box backgroundColor="#026865" p={1} m={-1}>
          {department}
        </Box>
      );
    case Department.Research:
      return (
        <Box backgroundColor="#ad6bad" p={1} m={-1}>
          {department}
        </Box>
      );
    case Department.Supply:
      return (
        <Box backgroundColor="#9b633e" p={1} m={-1}>
          {department}
        </Box>
      );
    case Department.Service:
      return (
        <Box backgroundColor="#515151" p={1} m={-1}>
          {department}
        </Box>
      );
    case Department.Expedition:
      return (
        <Box backgroundColor="#515151" p={1} m={-1}>
          {department}
        </Box>
      );
    case Department.Silicon:
      return (
        <Box backgroundColor="#3f823f" p={1} m={-1}>
          {department}
        </Box>
      );
    case Department.Offmap:
      return (
        <Box p={1} m={-1}>
          {department}
        </Box>
      );
    case Department.Unknown:
      return (
        <Box p={1} m={-1}>
          {department}
        </Box>
      );
    default:
      return department;
  }
};
