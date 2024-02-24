import { useBackend } from '../backend';
import { Box, LabeledList, ProgressBar, Section } from '../components';
import { Window } from '../layouts';

export const ResleevingPod = (model) => {
  const { data } = useBackend();
  const {
    occupied,
    name,
    health,
    maxHealth,
    stat,
    mindStatus,
    mindName,
    resleeveSick,
    initialSick,
  } = data;

  return (
    <Window width={300} height={350} resizeable>
      <Window.Content>
        <Section title="Occupant">
          {occupied ? (
            <>
              <LabeledList>
                <LabeledList.Item label="Name">{name}</LabeledList.Item>
                <LabeledList.Item label="Health">
                  {stat === 2 ? (
                    <Box color="bad">DEAD</Box>
                  ) : stat === 1 ? (
                    <Box color="average">Unconscious</Box>
                  ) : (
                    <ProgressBar
                      ranges={{
                        good: [0.5, Infinity],
                        average: [0.25, 0.5],
                        bad: [-Infinity, 0.25],
                      }}
                      value={health / maxHealth}
                    >
                      {health}%
                    </ProgressBar>
                  )}
                </LabeledList.Item>
                <LabeledList.Item label="Mind Status">
                  {mindStatus ? 'Present' : 'Missing'}
                </LabeledList.Item>
                {mindStatus ? (
                  <LabeledList.Item label="Mind Occupying">
                    {mindName}
                  </LabeledList.Item>
                ) : (
                  ''
                )}
              </LabeledList>
              {resleeveSick ? (
                <Box color="average" mt={3}>
                  Warning: Resleeving Sickness detected.
                  {initialSick ? (
                    <>
                      {' '}
                      Motion Sickness also detected. Please allow the newly
                      resleeved person a moment to get their bearings. This
                      warning will disappear when Motion Sickness is no longer
                      detected.
                    </>
                  ) : (
                    ''
                  )}
                </Box>
              ) : (
                ''
              )}
            </>
          ) : (
            <Box bold m={1}>
              Unoccupied.
            </Box>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
