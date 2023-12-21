import { useBackend } from '../backend';
import { Box, Button, LabeledList, ProgressBar, Section } from '../components';
import { Window } from '../layouts';

export const RogueZones = (props) => {
  const { act, data } = useBackend();
  const {
    timeout_percent,
    diffstep,
    difficulty,
    occupied,
    scanning,
    updated,
    debug,
    shuttle_location,
    shuttle_at_station,
    scan_ready,
    can_recall_shuttle,
  } = data;
  return (
    <Window width={360} height={250}>
      <Window.Content>
        <Section title="Current Area">
          <LabeledList>
            <LabeledList.Item label="Mineral Content">
              {difficulty}
            </LabeledList.Item>
            <LabeledList.Item
              label="Shuttle Location"
              buttons={
                (can_recall_shuttle && (
                  <Button
                    color="bad"
                    icon="rocket"
                    onClick={() => act('recall_shuttle')}>
                    Recall Shuttle
                  </Button>
                )) ||
                null
              }>
              {shuttle_location}
            </LabeledList.Item>
            {(occupied && (
              <LabeledList.Item color="bad" labelColor="bad" label="Personnel">
                WARNING: Area occupied by {occupied} personnel!
              </LabeledList.Item>
            )) || (
              <LabeledList.Item label="Personnel" color="good">
                No personnel detected.
              </LabeledList.Item>
            )}
          </LabeledList>
        </Section>
        <Section
          title="Scanner"
          buttons={
            <Button
              disabled={!scan_ready}
              fluid
              icon="search"
              onClick={() => act('scan_for_new')}>
              Scan For Asteroids
            </Button>
          }>
          <LabeledList>
            <LabeledList.Item label="Scn Ramestat Core">
              <ProgressBar
                value={timeout_percent}
                maxValue={100}
                ranges={{
                  good: [100, Infinity],
                  average: [75, 100],
                  bad: [-Infinity, 75],
                }}
              />
            </LabeledList.Item>
            {(scanning && (
              <LabeledList.Item label="Scanning">In progress.</LabeledList.Item>
            )) ||
              null}
            {(updated && !scanning && (
              <LabeledList.Item label="Info">
                Updated shuttle destination!
              </LabeledList.Item>
            )) ||
              null}
            {(debug && (
              <LabeledList.Item label="Debug" labelColor="bad">
                <Box>Timeout Percent: {timeout_percent}</Box>
                <Box>Diffstep: {diffstep}</Box>
                <Box>Difficulty: {difficulty}</Box>
                <Box>Occupied: {occupied}</Box>
                <Box>Debug: {debug}</Box>
                <Box>Shuttle Location: {shuttle_location}</Box>
                <Box>Shuttle at station: {shuttle_at_station}</Box>
                <Box>Scan Ready: {scan_ready}</Box>
              </LabeledList.Item>
            )) ||
              null}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
