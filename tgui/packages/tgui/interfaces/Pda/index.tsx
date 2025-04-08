import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
/* This is all basically stolen from routes.js. */
import { routingError } from 'tgui/routes';
import {
  Box,
  Button,
  Icon,
  LabeledList,
  Section,
  Stack,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

type Data = {
  owner: string;
  ownjob: string;
  idInserted: BooleanLike;
  idLink: string;
  useRetro: BooleanLike;
  touch_silent: BooleanLike;
  cartridge_name: string;
  stationTime: string;
  app: {
    name: string;
    icon: string;
    template: string;
    has_back: BooleanLike;
    is_home: string | undefined;
  };
};

const requirePdaInterface = require.context('./pda_screens', false, /\.tsx$/);

function getPdaApp(name: string) {
  let appModule: __WebpackModuleApi.RequireContext;
  try {
    appModule = requirePdaInterface(`./${name}.tsx`);
  } catch (err) {
    if (err.code === 'MODULE_NOT_FOUND') {
      return routingError('notFound', name);
    }
    throw err;
  }
  const Component: () => React.JSX.Element = appModule[name];
  if (!Component) {
    return routingError('missingExport', name);
  }
  return Component;
}

export const Pda = (props) => {
  const { data } = useBackend<Data>();

  const { app, owner, useRetro } = data;

  if (!owner) {
    return (
      <Window>
        <Window.Content>
          <Section stretchContents>
            Warning: No ID information found! Please swipe ID!
          </Section>
        </Window.Content>
      </Window>
    );
  }

  const App = getPdaApp(app.template);

  const [settingsMode, setSettingsMode] = useState<BooleanLike>(false);

  function handleSettingsMode(value: BooleanLike) {
    setSettingsMode(value);
  }

  return (
    <Window width={580} height={670} theme={useRetro ? 'pda-retro' : undefined}>
      <Window.Content scrollable>
        <PDAHeader
          settingsMode={settingsMode}
          onSettingsMode={handleSettingsMode}
        />
        {(settingsMode && <PDASettings />) || (
          <Section
            title={
              <Box>
                <Icon name={app.icon} mr={1} />
                {app.name}
              </Box>
            }
            p={1}
          >
            <App />
          </Section>
        )}
        <Box mb={8} />
        <PDAFooter onSettingsMode={handleSettingsMode} />
      </Window.Content>
    </Window>
  );
};

const PDAHeader = (props: {
  settingsMode: BooleanLike;
  onSettingsMode: Function;
}) => {
  const { act, data } = useBackend<Data>();

  const { idInserted, idLink, stationTime } = data;

  return (
    <Box mb={1}>
      <Stack align="center" justify="space-between">
        {!!idInserted && (
          <Stack.Item>
            <Button
              icon="eject"
              color="transparent"
              onClick={() => act('Authenticate')}
            >
              {idLink}
            </Button>
          </Stack.Item>
        )}
        <Stack.Item grow textAlign="center" bold>
          {stationTime}
        </Stack.Item>
        <Stack.Item>
          <Button
            selected={props.settingsMode}
            onClick={() => props.onSettingsMode(!props.settingsMode)}
            icon="cog"
          />
          <Button onClick={() => act('Retro')} icon="adjust" />
        </Stack.Item>
      </Stack>
    </Box>
  );
};

const PDASettings = (props) => {
  const { act, data } = useBackend<Data>();

  const { idInserted, idLink, cartridge_name, touch_silent } = data;

  return (
    <Section title="Settings">
      <LabeledList>
        <LabeledList.Item label="R.E.T.R.O Mode">
          <Button icon="cog" onClick={() => act('Retro')}>
            Retro Theme
          </Button>
        </LabeledList.Item>
        <LabeledList.Item label="Touch Sounds">
          <Button
            icon="cog"
            selected={!touch_silent}
            onClick={() => act('TouchSounds')}
          >
            {touch_silent ? 'Disabled' : 'Enabled'}
          </Button>
        </LabeledList.Item>
        {!!cartridge_name && (
          <LabeledList.Item label="Cartridge">
            <Button icon="eject" onClick={() => act('Eject')}>
              {cartridge_name}
            </Button>
          </LabeledList.Item>
        )}
        {!!idInserted && (
          <LabeledList.Item label="ID Card">
            <Button icon="eject" onClick={() => act('Authenticate')}>
              {idLink}
            </Button>
          </LabeledList.Item>
        )}
      </LabeledList>
    </Section>
  );
};

const PDAFooter = (props: { onSettingsMode: Function }) => {
  const { act, data } = useBackend<Data>();

  const { app, useRetro } = data;

  return (
    <Box
      position="fixed"
      bottom="0%"
      left="0%"
      right="0%"
      backgroundColor={useRetro ? '#6f7961' : '#1b1b1b'}
    >
      <Stack>
        <Stack.Item basis="33%">
          <Button
            fluid
            color="transparent"
            iconColor={app.has_back ? 'white' : 'disabled'}
            textAlign="center"
            icon="undo"
            mb={0}
            fontSize={1.7}
            onClick={() => act('Back')}
          />
        </Stack.Item>
        <Stack.Item basis="33%">
          <Button
            fluid
            color="transparent"
            iconColor={app.is_home ? 'disabled' : 'white'}
            textAlign="center"
            icon="home"
            mb={0}
            fontSize={1.7}
            onClick={() => {
              props.onSettingsMode(false);
              act('Home');
            }}
          />
        </Stack.Item>
      </Stack>
    </Box>
  );
};
