import { storage } from 'common/storage';
import { type ReactNode, useEffect, useRef, useState } from 'react';
import { resolveAsset } from 'tgui/assets';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Modal, Section, Stack } from 'tgui-core/components';
import { classes } from 'tgui-core/react';

import { LobbyContext } from './constants';
import { LobbyButtons } from './LobbyButtons';
import { CustomButton } from './LobbyElements';
import type { LobbyData } from './types';

export const LobbyMenu = (props) => {
  const { act, data } = useBackend<LobbyData>();

  const onLoadPlayer = useRef<HTMLAudioElement>(null);

  const [modal, setModal] = useState<ReactNode | false>(false);

  const [filterDisabled, setFilterDisabled] = useState(false);
  const [animationsDisabled, setAnimationsDisabled] = useState(false);
  const [audioDisabled, setAudioDisabled] = useState(false);
  const [animationsFinished, setAnimationsFinished] = useState(false);

  useEffect(() => {
    storage
      .get('lobby-filter-disabled')
      .then((val) => setFilterDisabled(!!val));
    storage
      .get('lobby-animations-disabled')
      .then((val) => setAnimationsDisabled(!!val));
    storage.get('lobby-audio-disabled').then((val) => setAudioDisabled(!!val));

    setTimeout(() => {
      if (onLoadPlayer.current) {
        onLoadPlayer.current!.play();
      }
    }, 250);

    setTimeout(() => {
      setAnimationsFinished(true);
    }, 10000);
  }, []);

  const [hidden, setHidden] = useState<boolean>(false);

  return (
    <Window fitted scrollbars={false} theme="ntos">
      {!audioDisabled && (
        <audio src={resolveAsset('load.ogg')} ref={onLoadPlayer} />
      )}
      <Window.Content
        className={classes([
          'LobbyScreen',
          animationsDisabled ? null : 'animationsEnabled',
          filterDisabled ? null : 'filterEnabled',
        ])}
        fitted
      >
        <LobbyContext.Provider
          value={{
            animationsDisabled: animationsDisabled,
            animationsFinished: animationsFinished,
            setModal: setModal,
          }}
        >
          {!!modal && <Modal>{modal}</Modal>}
          <Box
            height="100%"
            width="100%"
            style={{
              backgroundImage: data.display_loading
                ? `url(${resolveAsset('lobby_loading.gif')})`
                : `url(${resolveAsset('lobby_bg.gif')})`,
            }}
            className="bgLoad bgBackground"
          />
          <Box height="100%" width="100%" position="absolute" className="crt" />
          <Box position="absolute" top="10px" right="10px">
            <CustomButton
              icon="cog"
              onClick={() => {
                setModal(
                  <Section
                    p={5}
                    title="Lobby Settings"
                    buttons={
                      <CustomButton
                        icon="xmark"
                        onClick={() => setModal(false)}
                      />
                    }
                  >
                    <Stack>
                      <Stack.Item>
                        <CustomButton
                          icon="tv"
                          onClick={() => {
                            storage.set(
                              'lobby-filter-disabled',
                              !filterDisabled,
                            );
                            setFilterDisabled(!filterDisabled);
                            setModal(false);
                          }}
                          tooltip="Removes the CRT filter background"
                        >
                          {`${filterDisabled ? 'Enable' : 'Disable'} Scanlines`}
                        </CustomButton>
                      </Stack.Item>
                      <Stack.Item>
                        <CustomButton
                          icon="volume-xmark"
                          onClick={() => {
                            storage.set('lobby-audio-disabled', !audioDisabled);
                            setAudioDisabled(!audioDisabled);
                            setModal(false);
                          }}
                          tooltip="Removes the loading audio"
                        >
                          {`${audioDisabled ? 'Enable' : 'Disable'} Audio`}
                        </CustomButton>
                      </Stack.Item>
                      <Stack.Item>
                        <CustomButton
                          icon="bolt"
                          onClick={() => {
                            storage.set(
                              'lobby-animations-disabled',
                              !animationsDisabled,
                            );
                            setAnimationsDisabled(!animationsDisabled);
                            setModal(false);
                          }}
                          tooltip="Disables animations."
                        >
                          {`${animationsDisabled ? 'Enable' : 'Disable'} Animations`}
                        </CustomButton>
                      </Stack.Item>
                    </Stack>
                  </Section>,
                );
              }}
            />
          </Box>
          {hidden && (
            <Box position="absolute" top="10px" left="10px">
              <CustomButton icon={'check'} onClick={() => setHidden(false)} />
            </Box>
          )}
          <Stack vertical height="100%" justify="space-around" align="center">
            <Stack.Item>
              <LobbyButtons
                setModal={setModal}
                hidden={hidden}
                setHidden={setHidden}
              />
            </Stack.Item>
          </Stack>
        </LobbyContext.Provider>
      </Window.Content>
    </Window>
  );
};
