import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button,
  Collapsible,
  Divider,
  Input,
  LabeledList,
  NumberInput,
  ProgressBar,
  Section,
  Slider,
  Stack,
} from 'tgui-core/components';
import { formatTime } from 'tgui-core/format';
import { round, toFixed } from 'tgui-core/math';
import type { BooleanLike } from 'tgui-core/react';
import { capitalize } from 'tgui-core/string';

type Data = {
  playing: BooleanLike;
  loop_mode: number;
  volume: number;
  current_track_ref: string | null;
  current_track: track | null;
  current_genre: string | null;
  percent: number;
  tracks: track[];
  admin: BooleanLike;
};

type track = {
  ref: string;
  title: string;
  artist: string;
  genre: string;
  duration: number;
};

export const Jukebox = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    playing,
    loop_mode,
    volume,
    current_track_ref,
    current_track,
    current_genre,
    percent,
    tracks,
    admin,
  } = data;

  const genre_songs =
    tracks.length &&
    tracks.reduce((acc, obj) => {
      const key = obj.genre || 'Uncategorized';
      if (!acc[key]) {
        acc[key] = [];
      }
      acc[key].push(obj);
      return acc;
    }, {});

  const true_genre = playing && (current_genre || 'Uncategorized');

  const [newTitle, setNewTitle] = useState<string>('Unknown');
  const [newUrl, setNewUrl] = useState<string>('');
  const [newDuration, setNewDuration] = useState<number>(0);
  const [newArtist, setNewArtist] = useState<string>('Unknown');
  const [newGenre, setNewGenre] = useState<string>('Admin');
  const [newSecret, setNewSecret] = useState<boolean>(false);
  const [newLobby, setNewLobby] = useState<boolean>(false);
  const [unlockGenre, setUnlockGenre] = useState<boolean>(false);

  function handleUnlockGenre() {
    if (unlockGenre) {
      setNewGenre('Admin');
    }
    setUnlockGenre(!unlockGenre);
  }

  return (
    <Window width={450} height={600}>
      <Window.Content scrollable>
        <Section title="Currently Playing">
          <LabeledList>
            <LabeledList.Item label="Title">
              {(playing && current_track && (
                <Box>
                  {current_track.title} by {current_track.artist || 'Unkown'}
                </Box>
              )) || <Box>Stopped</Box>}
            </LabeledList.Item>
            <LabeledList.Item label="Controls">
              <Button
                icon="play"
                disabled={playing}
                onClick={() => act('play')}
              >
                Play
              </Button>
              <Button
                icon="stop"
                disabled={!playing}
                onClick={() => act('stop')}
              >
                Stop
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Loop Mode">
              <Button
                icon="play"
                onClick={() => act('loopmode', { loopmode: 1 })}
                selected={loop_mode === 1}
              >
                Next
              </Button>
              <Button
                icon="random"
                onClick={() => act('loopmode', { loopmode: 2 })}
                selected={loop_mode === 2}
              >
                Shuffle
              </Button>
              <Button
                icon="redo"
                onClick={() => act('loopmode', { loopmode: 3 })}
                selected={loop_mode === 3}
              >
                Repeat
              </Button>
              <Button
                icon="step-forward"
                onClick={() => act('loopmode', { loopmode: 4 })}
                selected={loop_mode === 4}
              >
                Once
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Progress">
              <ProgressBar value={percent} maxValue={1} color="good" />
            </LabeledList.Item>
            <LabeledList.Item label="Volume">
              <Slider
                minValue={0}
                step={1}
                value={volume * 100}
                maxValue={100}
                ranges={{
                  good: [75, Infinity],
                  average: [25, 75],
                  bad: [0, 25],
                }}
                format={(val) => toFixed(val, 1) + '%'}
                onChange={(e, val) =>
                  act('volume', { val: round(val / 100, 2) })
                }
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Available Tracks">
          {(tracks.length &&
            Object.keys(genre_songs)
              .sort()
              .map(
                (genre) =>
                  capitalize(genre) !== 'Admin' && (
                    <Collapsible
                      title={genre}
                      key={genre}
                      color={true_genre === genre ? 'green' : 'default'}
                      child_mt={0}
                    >
                      <div style={{ marginLeft: '1em' }}>
                        {genre_songs[genre].map((track) => (
                          <Button
                            fluid
                            icon="play"
                            key={track.ref}
                            selected={current_track_ref === track.ref}
                            onClick={() =>
                              act('change_track', { change_track: track.ref })
                            }
                          >
                            {track.title}
                          </Button>
                        ))}
                      </div>
                    </Collapsible>
                  ),
              )) || <Box color="bad">Error: No songs loaded.</Box>}
        </Section>
        {admin && (
          <>
            <Section title="Admin Tracks">
              {(tracks.length &&
                Object.keys(genre_songs)
                  .sort()
                  .map(
                    (genre) =>
                      capitalize(genre) === 'Admin' && (
                        <Collapsible
                          title={genre}
                          key={genre}
                          color={true_genre === genre ? 'green' : 'default'}
                          child_mt={0}
                        >
                          <div style={{ marginLeft: '1em' }}>
                            {genre_songs[genre].map((track) => (
                              <Stack key={track.ref}>
                                <Stack.Item grow>
                                  <Button
                                    fluid
                                    icon="play"
                                    key={track.ref}
                                    selected={current_track_ref === track.ref}
                                    onClick={() =>
                                      act('change_track', {
                                        change_track: track.ref,
                                      })
                                    }
                                  >
                                    {track.title}
                                  </Button>
                                </Stack.Item>
                                <Stack.Item>
                                  <Button.Confirm
                                    icon="trash"
                                    onClick={() =>
                                      act('remove_new_track', {
                                        ref: track.ref,
                                      })
                                    }
                                  />
                                </Stack.Item>
                              </Stack>
                            ))}
                          </div>
                        </Collapsible>
                      ),
                  )) || <Box color="bad">Error: No songs added.</Box>}
            </Section>
            <Section title="Admin Options">
              <Collapsible title="Add Track">
                <LabeledList>
                  <LabeledList.Item label="Title">
                    <Input
                      width="100%"
                      value={newTitle}
                      onChange={(e, val: string) => setNewTitle(val)}
                    />
                  </LabeledList.Item>
                  <LabeledList.Item label="URL">
                    <Input
                      width="100%"
                      value={newUrl}
                      onChange={(e, val: string) => setNewUrl(val)}
                    />
                  </LabeledList.Item>
                  <LabeledList.Item label="Playtime">
                    <NumberInput
                      step={1}
                      value={newDuration}
                      minValue={0}
                      maxValue={3600}
                      onChange={(val: number) => setNewDuration(val)}
                      format={(val) => formatTime(round(val * 10, 0))}
                    />
                  </LabeledList.Item>
                  <LabeledList.Item label="Artist">
                    <Input
                      width="100%"
                      value={newArtist}
                      onChange={(e, val: string) => setNewArtist(val)}
                    />
                  </LabeledList.Item>
                  <LabeledList.Item label="Genre">
                    <Stack>
                      <Stack.Item grow>
                        {unlockGenre ? (
                          <Input
                            width="100%"
                            value={newGenre}
                            onChange={(e, val: string) => setNewGenre(val)}
                          />
                        ) : (
                          <Box>{newGenre}</Box>
                        )}
                      </Stack.Item>
                      <Stack.Item>
                        <Button.Checkbox
                          icon={unlockGenre ? 'lock-open' : 'lock'}
                          color={unlockGenre ? 'good' : 'bad'}
                          onClick={() => handleUnlockGenre()}
                        />
                      </Stack.Item>
                    </Stack>
                  </LabeledList.Item>
                  <LabeledList.Item label="Secret">
                    <Button.Checkbox
                      checked={newSecret}
                      onClick={() => setNewSecret(!newSecret)}
                    />
                  </LabeledList.Item>
                  <LabeledList.Item label="Lobby">
                    <Button.Checkbox
                      checked={newLobby}
                      onClick={() => setNewLobby(!newLobby)}
                    />
                  </LabeledList.Item>
                </LabeledList>
                <Divider />
                <Button
                  disabled={
                    !(
                      !!newTitle &&
                      !!newUrl &&
                      !!newDuration &&
                      !!newArtist &&
                      !!newGenre
                    )
                  }
                  onClick={() =>
                    act('add_new_track', {
                      title: newTitle,
                      url: newUrl,
                      duration: newDuration,
                      artist: newArtist,
                      genre: newGenre,
                      secret: newSecret,
                      lobby: newLobby,
                    })
                  }
                >
                  Add new Track
                </Button>
              </Collapsible>
            </Section>
          </>
        )}
      </Window.Content>
    </Window>
  );
};
