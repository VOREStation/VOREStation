import { useBackend } from '../backend';
import { AnimatedNumber, Box, Button, LabeledList, ProgressBar, Section } from '../components';
import { Window } from '../layouts';

export const pAIDoorjack = (props) => {
  const { act, data } = useBackend();

  const { cable, machine, inprogress, progress_a, progress_b, aborted } = data;

  return (
    <Window width={300} height={150}>
      <Window.Content scrollable>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Cable">
              {(machine && <Box color="good">Connected</Box>) ||
                (cable && <Box color="average">Extended</Box>) || (
                  <Box>
                    <Button
                      icon="ethernet"
                      content="Retracted"
                      onClick={() => act('cable')}
                    />
                  </Box>
                )}
            </LabeledList.Item>
            {(!!machine && (
              <LabeledList.Item label="Hack">
                {(inprogress && (
                  <Box>
                    <ProgressBar
                      value={progress_a}
                      maxValue={100}
                      ranges={{
                        good: [67, Infinity],
                        average: [33, 67],
                        bad: [-Infinity, 33],
                      }}>
                      <AnimatedNumber value={progress_a} />.
                      <AnimatedNumber value={progress_b} />%
                    </ProgressBar>
                    <Button
                      icon="ban"
                      color="bad"
                      onClick={() => act('cancel')}
                    />
                  </Box>
                )) || (
                  <Button
                    icon="virus"
                    content="Start"
                    onClick={() => act('jack')}
                  />
                )}
              </LabeledList.Item>
            )) ||
              (!!aborted && (
                <LabeledList.Item color="bad" mt={1}>
                  Hack aborted.
                </LabeledList.Item>
              ))}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
