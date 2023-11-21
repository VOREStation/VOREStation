import { toFixed, round } from 'common/math';
import { useBackend } from '../backend';
import { Box, Button, LabeledList, NumberInput, Section } from '../components';
import { RADIO_CHANNELS } from '../constants';
import { Window } from '../layouts';

export const Radio = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    rawfreq,
    minFrequency,
    maxFrequency,
    listening,
    broadcasting,
    subspace,
    subspaceSwitchable,
    chan_list,
    loudspeaker,
    mic_cut,
    spk_cut,
    useSyndMode,
  } = data;

  const tunedChannel = RADIO_CHANNELS.find(
    (channel) => channel.freq === Number(rawfreq)
  );

  // Calculate window height
  let height = 156;
  if (chan_list && chan_list.length > 0) {
    height += chan_list.length * 28 + 6;
  } else {
    height += 24;
  }
  if (subspaceSwitchable) {
    height += 38;
  }
  return (
    <Window
      width={310}
      height={height}
      resizable
      theme={useSyndMode ? 'syndicate' : ''}>
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Frequency">
              <NumberInput
                animated
                unit="kHz"
                step={0.2}
                stepPixelSize={10}
                minValue={minFrequency / 10}
                maxValue={maxFrequency / 10}
                value={rawfreq / 10}
                format={(value) => toFixed(value, 1)}
                onDrag={(e, value) =>
                  act('setFrequency', {
                    freq: round(value * 10),
                  })
                }
              />
              {tunedChannel && (
                <Box inline color={tunedChannel.color} ml={2}>
                  [{tunedChannel.name}]
                </Box>
              )}
            </LabeledList.Item>
            <LabeledList.Item label="Audio">
              <Button
                textAlign="center"
                width="37px"
                icon={listening ? 'volume-up' : 'volume-mute'}
                selected={listening}
                disabled={spk_cut}
                onClick={() => act('listen')}
              />
              <Button
                textAlign="center"
                width="37px"
                icon={broadcasting ? 'microphone' : 'microphone-slash'}
                selected={broadcasting}
                disabled={mic_cut}
                onClick={() => act('broadcast')}
              />
              {!!subspaceSwitchable && (
                <Box>
                  <Button
                    icon="bullhorn"
                    selected={subspace}
                    content={`Subspace Tx ${subspace ? 'ON' : 'OFF'}`}
                    onClick={() => act('subspace')}
                  />
                </Box>
              )}
              {!!subspaceSwitchable && (
                <Box>
                  <Button
                    icon={loudspeaker ? 'volume-up' : 'volume-mute'}
                    selected={loudspeaker}
                    content="Loudspeaker"
                    onClick={() => act('toggleLoudspeaker')}
                  />
                </Box>
              )}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Channels">
          {(!chan_list || chan_list.length === 0) && (
            <Box inline color="bad">
              No channels detected.
            </Box>
          )}
          <LabeledList>
            {!chan_list
              ? null
              : chan_list.map((channel) => {
                const channeldata = RADIO_CHANNELS.find(
                  (c) => c.freq === Number(channel.freq)
                );
                let color = 'default';
                if (channeldata) {
                  color = channeldata.color;
                }
                return (
                  <LabeledList.Item
                    key={channel.chan}
                    label={channel.display_name}
                    labelColor={color}
                    textAlign="right">
                    {channel.secure_channel && subspace ? (
                      <Button
                        icon={
                          !channel.sec_channel_listen
                            ? 'check-square-o'
                            : 'square-o'
                        }
                        selected={!channel.sec_channel_listen}
                        content={!channel.sec_channel_listen ? 'On' : 'Off'}
                        onClick={() =>
                          act('channel', {
                            channel: channel.chan,
                          })
                        }
                      />
                    ) : (
                      <Button
                        content="Switch"
                        selected={channel.chan === rawfreq}
                        onClick={() =>
                          act('specFreq', {
                            channel: channel.chan,
                          })
                        }
                      />
                    )}
                  </LabeledList.Item>
                );
              })}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
