/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { useAtomValue } from 'jotai';
import {
  Button,
  Collapsible,
  Knob,
  Section,
  Stack,
} from 'tgui-core/components';

import { useSettings } from '../settings/use-settings';
import { metaAtom, playingAtom } from './atoms';
import { player } from './handlers';

export function NowPlayingWidget(props) {
  const { settings, updateSettings } = useSettings();
  const meta = useAtomValue(metaAtom);
  const {
    album = 'Unknown Album',
    artist = 'Unknown Artist',
    duration,
    link,
    title,
    upload_date = 'Unknown Data',
  } = meta || {};

  const playing = useAtomValue(playingAtom);

  const date = !Number.isNaN(upload_date)
    ? upload_date?.substring(0, 4) +
      '-' +
      upload_date?.substring(4, 6) +
      '-' +
      upload_date?.substring(6, 8)
    : upload_date;

  return (
    <Stack align="center">
      {playing ? (
        <Stack.Item
          mx={0.5}
          grow
          style={{
            whiteSpace: 'nowrap',
            overflow: 'hidden',
            textOverflow: 'ellipsis',
          }}
        >
          {
            <Collapsible title={title || 'Unknown Track'} color="blue">
              <Section>
                {link !== 'Song Link Hidden' && (
                  <Stack.Item grow color="label">
                    URL: <a href={link}>{link}</a>
                  </Stack.Item>
                )}
                <Stack.Item grow color="label">
                  Duration: {duration}
                </Stack.Item>
                {artist !== 'Song Artist Hidden' &&
                  artist !== 'Unknown Artist' && (
                    <Stack.Item grow color="label">
                      Artist: {artist}
                    </Stack.Item>
                  )}
                {album !== 'Song Album Hidden' && album !== 'Unknown Album' && (
                  <Stack.Item grow color="label">
                    Album: {album}
                  </Stack.Item>
                )}
                {upload_date !== 'Song Upload Date Hidden' &&
                  upload_date !== 'Unknown Date' && (
                    <Stack.Item grow color="label">
                      Uploaded: {date}
                    </Stack.Item>
                  )}
              </Section>
            </Collapsible>
          }
        </Stack.Item>
      ) : (
        <Stack.Item grow color="label">
          Nothing to play.
        </Stack.Item>
      )}
      {playing && (
        <Stack.Item mx={0.5} fontSize="0.9em">
          <Button tooltip="Stop" icon="stop" onClick={() => player.stop()} />
        </Stack.Item>
      )}
      <Stack.Item mx={0.5} fontSize="0.9em">
        <Knob
          tickWhileDragging
          minValue={0}
          maxValue={1}
          value={settings.adminMusicVolume}
          step={0.0025}
          stepPixelSize={1}
          format={(value) => `${(value * 100).toFixed()}%`}
          onChange={(e, value) => {
            updateSettings({
              adminMusicVolume: value,
            });
            player.setVolume(value);
          }}
        />
      </Stack.Item>
    </Stack>
  );
}
