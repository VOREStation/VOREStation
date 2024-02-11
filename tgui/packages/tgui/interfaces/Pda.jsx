import { useState } from 'react';

import { useBackend } from '../backend';
import { Box, Button, Flex, Icon, LabeledList, Section } from '../components';
import { Window } from '../layouts';
/* This is all basically stolen from routes.js. */
import { routingError } from '../routes';

const requirePdaInterface = require.context('./pda', false, /\.jsx$/);

const getPdaApp = (name) => {
  let appModule;
  try {
    appModule = requirePdaInterface(`./${name}.jsx`);
  } catch (err) {
    if (err.code === 'MODULE_NOT_FOUND') {
      return routingError('notFound', name);
    }
    throw err;
  }
  const Component = appModule[name];
  if (!Component) {
    return routingError('missingExport', name);
  }
  return Component;
};

export const Pda = (props) => {
  const { act, data } = useBackend();

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

  let App = getPdaApp(app.template);

  const [settingsMode, setSettingsMode] = useState(false);

  return (
    <Window width={580} height={670} theme={useRetro ? 'pda-retro' : null}>
      <Window.Content scrollable>
        <PDAHeader
          settingsMode={settingsMode}
          setSettingsMode={setSettingsMode}
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
        <PDAFooter setSettingsMode={setSettingsMode} />
      </Window.Content>
    </Window>
  );
};

const PDAHeader = (props) => {
  const { act, data } = useBackend();

  const { settingsMode, setSettingsMode } = props;

  const { idInserted, idLink, cartridge_name, stationTime } = data;

  return (
    <Box mb={1}>
      <Flex align="center" justify="space-between">
        {!!idInserted && (
          <Flex.Item>
            <Button
              icon="eject"
              color="transparent"
              onClick={() => act('Authenticate')}
              content={idLink}
            />
          </Flex.Item>
        )}
        <Flex.Item grow={1} textAlign="center" bold>
          {stationTime}
        </Flex.Item>
        <Flex.Item>
          <Button
            selected={settingsMode}
            onClick={() => setSettingsMode(!settingsMode)}
            icon="cog"
          />
          <Button onClick={() => act('Retro')} icon="adjust" />
        </Flex.Item>
      </Flex>
    </Box>
  );
};

const PDASettings = (props) => {
  const { act, data } = useBackend();

  const { idInserted, idLink, cartridge_name, touch_silent } = data;

  return (
    <Section title="Settings">
      <LabeledList>
        <LabeledList.Item label="R.E.T.R.O Mode">
          <Button
            icon="cog"
            content={'Retro Theme'}
            onClick={() => act('Retro')}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Touch Sounds">
          <Button
            icon="cog"
            selected={!touch_silent}
            content={touch_silent ? 'Disabled' : 'Enabled'}
            onClick={() => act('TouchSounds')}
          />
        </LabeledList.Item>
        {!!cartridge_name && (
          <LabeledList.Item label="Cartridge">
            <Button
              icon="eject"
              onClick={() => act('Eject')}
              content={cartridge_name}
            />
          </LabeledList.Item>
        )}
        {!!idInserted && (
          <LabeledList.Item label="ID Card">
            <Button
              icon="eject"
              onClick={() => act('Authenticate')}
              content={idLink}
            />
          </LabeledList.Item>
        )}
      </LabeledList>
    </Section>
  );
};

const PDAFooter = (props) => {
  const { act, data } = useBackend();

  const { setSettingsMode } = props;

  const { app, useRetro } = data;

  return (
    <Box
      position="fixed"
      bottom="0%"
      left="0%"
      right="0%"
      backgroundColor={useRetro ? '#6f7961' : '#1b1b1b'}
    >
      <Flex>
        <Flex.Item basis="33%">
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
        </Flex.Item>
        <Flex.Item basis="33%">
          <Button
            fluid
            color="transparent"
            iconColor={app.is_home ? 'disabled' : 'white'}
            textAlign="center"
            icon="home"
            mb={0}
            fontSize={1.7}
            onClick={() => {
              setSettingsMode(false);
              act('Home');
            }}
          />
        </Flex.Item>
      </Flex>
    </Box>
  );
};
