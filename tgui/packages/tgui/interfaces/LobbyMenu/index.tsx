import { storage } from 'common/storage';
import {
  createContext,
  type ReactNode,
  useContext,
  useEffect,
  useRef,
  useState,
} from 'react';
import { resolveAsset } from 'tgui/assets';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Box,
  Button as NativeButton,
  Modal,
  Section,
  Stack,
} from 'tgui-core/components';
import { type BooleanLike, classes } from 'tgui-core/react';

type LobbyData = {
  display_loading: BooleanLike;
  map: string;
  station_time: string;
  round_start: BooleanLike;
  round_time: string;
  ready: BooleanLike;
  new_news: BooleanLike;
  can_submit_feedback: BooleanLike;
  show_station_news: BooleanLike;
  new_station_news: BooleanLike;
  new_changelog: BooleanLike;
};

type LobbyContextType = {
  animationsDisabled: boolean;
  animationsFinished: boolean;
  setModal?: (_: ReactNode | false) => void;
};

const LobbyContext = createContext<LobbyContextType>({
  animationsDisabled: false,
  animationsFinished: false,
});

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
            <Button
              icon="cog"
              onClick={() => {
                setModal(
                  <Section
                    p={5}
                    title="Lobby Settings"
                    buttons={
                      <Button icon="xmark" onClick={() => setModal(false)} />
                    }
                  >
                    <Stack>
                      <Stack.Item>
                        <Button
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
                        </Button>
                      </Stack.Item>
                      <Stack.Item>
                        <Button
                          icon="volume-xmark"
                          onClick={() => {
                            storage.set('lobby-audio-disabled', !audioDisabled);
                            setAudioDisabled(!audioDisabled);
                            setModal(false);
                          }}
                          tooltip="Removes the loading audio"
                        >
                          {`${audioDisabled ? 'Enable' : 'Disable'} Audio`}
                        </Button>
                      </Stack.Item>
                      <Stack.Item>
                        <Button
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
                        </Button>
                      </Stack.Item>
                    </Stack>
                  </Section>,
                );
              }}
            />
          </Box>
          {hidden && (
            <Box position="absolute" top="10px" left="10px">
              <Button icon={'check'} onClick={() => setHidden(false)} />
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

const LobbyButtons = (props: {
  readonly setModal: (_) => void;
  readonly hidden: boolean;
  readonly setHidden: (_: boolean) => void;
}) => {
  const { act, data } = useBackend<LobbyData>();
  const { setModal, hidden, setHidden } = props;

  const {
    map,
    station_time,
    round_start,
    round_time,
    ready,
    new_news,
    can_submit_feedback,
    show_station_news,
    new_station_news,
    new_changelog,
  } = data;

  return (
    <Section
      p={3}
      className="sectionLoad"
      style={{ opacity: hidden ? '0' : '1' }}
    >
      <Stack vertical>
        <Stack.Item>
          <Stack align="center">
            <Stack.Item>
              <Box height="68px">
                <Box
                  className="loadEffect NanotrasenIcon"
                  style={{ cursor: 'pointer' }}
                  width="100px"
                  onClick={() => setHidden(true)}
                />
              </Box>
            </Stack.Item>
            <Stack.Item minWidth="200px">
              <Stack vertical fill>
                <Stack.Item>
                  <Box className="typeEffect">Welcome to VOREStation.</Box>
                </Stack.Item>
                <Stack.Item>
                  <Box className="typeEffect">Map: {map}</Box>
                </Stack.Item>
                <Stack.Item>
                  <Box className="typeEffect">Station Time: {station_time}</Box>
                </Stack.Item>
                <Stack.Item>
                  <Box className="typeEffect">
                    Round Duration:{' '}
                    {round_start ? 'Initializing...' : round_time}{' '}
                  </Box>
                </Stack.Item>
              </Stack>
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <TimedDivider />

        <LobbyButton
          index={1}
          onClick={() => act('character_setup')}
          icon="file-lines"
        >
          Setup Character
        </LobbyButton>

        <LobbyButton
          index={2}
          onClick={() => act('manifest')}
          icon="circle-user"
        >
          View Crew Manifest
        </LobbyButton>

        <LobbyButton index={3} onClick={() => act('shownews')} icon="newspaper">
          Show Server News {new_news ? '(NEW!)' : null}
        </LobbyButton>

        {can_submit_feedback ? (
          <LobbyButton
            index={3}
            onClick={() => act('give_feedback')}
            icon="clipboard-question"
          >
            Give Feedback
          </LobbyButton>
        ) : null}

        <LobbyButton
          index={4}
          onClick={() => act('open_changelog')}
          icon="pencil"
        >
          Show Changelog {new_changelog ? '(NEW!)' : null}
        </LobbyButton>

        {show_station_news ? (
          <LobbyButton index={5} onClick={() => act('')} icon="newspaper">
            Show Station News {new_station_news ? '(NEW!)' : null}
          </LobbyButton>
        ) : null}
        <TimedDivider />

        <LobbyButton index={5} icon="eye" onClick={() => act('observe')}>
          Observe
        </LobbyButton>

        {round_start ? (
          <LobbyButton
            index={6}
            selected={!!ready}
            onClick={() => act('ready')}
            icon={ready ? 'check' : 'xmark'}
          >
            {ready ? 'Unready' : 'Ready'}
          </LobbyButton>
        ) : (
          <LobbyButton index={6} onClick={() => act('late_join')} icon="users">
            Join Game
          </LobbyButton>
        )}
      </Stack>
    </Section>
  );
};

const TimedDivider = () => {
  const ref = useRef<HTMLDivElement>(null);

  const context = useContext(LobbyContext);
  const { animationsDisabled, animationsFinished } = context;

  useEffect(() => {
    if (!animationsFinished && !animationsDisabled) {
      setTimeout(() => {
        ref.current!.style.display = 'block';
      }, 1500);
    }
  }, [animationsFinished, animationsDisabled]);

  return (
    <Stack.Item>
      <div
        style={{
          borderStyle: 'solid',
          borderWidth: '1px',
          display: animationsFinished || animationsDisabled ? 'block' : 'none',
        }}
        className="dividerEffect"
        ref={ref}
      />
    </Stack.Item>
  );
};

type LobbyButtonProps = React.ComponentProps<typeof Box> & {
  readonly index: number;
  readonly selected?: boolean;
  readonly disabled?: boolean;
  readonly icon?: string;
  readonly tooltip?: string;
};

const LobbyButton = (props: LobbyButtonProps) => {
  const { children, index, className, ...rest } = props;

  const context = useContext<LobbyContextType>(LobbyContext);

  return (
    <Stack.Item
      className="buttonEffect"
      style={{
        animationDelay:
          context.animationsFinished || context.animationsDisabled
            ? '0s'
            : `${1.5 + index * 0.2}s`,
      }}
    >
      <Button fluid className={'distinctButton ' + className} {...rest}>
        {children}
      </Button>
    </Stack.Item>
  );
};

const Button = (props) => {
  const { act } = useBackend();

  return (
    // this works because of event propagation
    <Box onClick={() => act('keyboard')}>
      <NativeButton {...props} />
    </Box>
  );
};
