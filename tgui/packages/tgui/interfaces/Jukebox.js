import { round } from 'common/math';
import { sortBy } from 'common/collections';
import { useBackend } from "../backend";
import { Box, Button, LabeledList, ProgressBar, Section, Slider } from "../components";
import { Window } from "../layouts";

export const Jukebox = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    playing,
    loop_mode,
    volume,
    current_track_ref,
    current_track,
    percent,
    tracks,
  } = data;

  return (
    <Window width={450} height={600} resizable>
      <Window.Content scrollable>
        <Section title="Currently Playing">
          <LabeledList>
            <LabeledList.Item label="Title">
              {playing && current_track && (
                <Box>
                  {current_track.title} by {current_track.artist || "Unkown"}
                </Box>
              ) || (
                <Box>
                  Stopped
                </Box>
              )}
            </LabeledList.Item>
            <LabeledList.Item label="Controls">
              <Button
                icon="play"
                disabled={playing}
                onClick={() => act("play")}>
                Play
              </Button>
              <Button
                icon="stop"
                disabled={!playing}
                onClick={() => act("stop")}>
                Stop
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Loop Mode">
              <Button
                icon="play"
                onClick={() => act("loopmode", { loopmode: 1 })}
                selected={loop_mode === 1}>
                Next
              </Button>
              <Button
                icon="random"
                onClick={() => act("loopmode", { loopmode: 2 })}
                selected={loop_mode === 2}>
                Shuffle
              </Button>
              <Button
                icon="redo"
                onClick={() => act("loopmode", { loopmode: 3 })}
                selected={loop_mode === 3}>
                Repeat
              </Button>
              <Button
                icon="step-forward"
                onClick={() => act("loopmode", { loopmode: 4 })}
                selected={loop_mode === 4}>
                Once
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Progress">
              <ProgressBar
                value={percent}
                maxValue={1}
                color="good" />
            </LabeledList.Item>
            <LabeledList.Item label="Volume">
              <Slider
                minValue={0}
                step={0.01}
                value={volume}
                maxValue={1}
                ranges={{
                  good: [.75, Infinity],
                  average: [.25, .75],
                  bad: [0, .25],
                }}
                format={val => round(val * 100, 1) + "%"}
                onChange={(e, val) => act("volume", { val: round(val, 2) })} />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Available Tracks">
          {tracks.length && sortBy(a => a.title)(tracks).map(track => (
            <Button
              fluid
              icon="play"
              key={track.ref}
              selected={current_track_ref === track.ref}
              onClick={() => act("change_track", { change_track: track.ref })}>
              {track.title}
            </Button>
          )) || (
            <Box color="bad">
              Error: No songs loaded.
            </Box>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};