import { round } from 'common/math';
import { Fragment } from 'inferno';
import { useBackend } from "../backend";
import { Box, Button, Flex, Icon, LabeledList, ProgressBar, Section } from "../components";
import { Window } from "../layouts";

/* This is all basically stolen from routes.js. */
import { routingError } from "../routes";

const requirePdaInterface = require.context('./pda', false, /\.js$/);

const getPdaApp = name => {
  let appModule;
  try {
    appModule = requirePdaInterface(`./${name}.js`);
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

export const Pda = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    app,
    owner,
    useRetro,
  } = data;

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

  return (
    <Window width={580} height={670} theme={useRetro ? "pda-retro" : null} resizable>
      <Window.Content scrollable>
        <PDAHeader />
        <Section
          title={
            <Box>
              <Icon name={app.icon} mr={1} />
              {app.name}
            </Box>
          }
          p={1}>
          <App />
        </Section>
        <Box mb={8} />
        <PDAFooter />
      </Window.Content>
    </Window>
  );
};

const PDAHeader = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    idInserted,
    idLink,
    cartridge_name,
    stationTime,
  } = data;

  return (
    <Box mb={1}>
      <Flex align="center" justify="space-between" pl={1} pr={1}>
        {!!idInserted && (
          <Flex.Item>
            <Button
              color="transparent"
              icon="eject"
              onClick={() => act("authenticate")}
              content={idLink} />
          </Flex.Item>
        )}
        {!!cartridge_name && (
          <Flex.Item>
            <Button
              color="transparent"
              icon="eject"
              onClick={() => act("eject")}
              content={cartridge_name} />
          </Flex.Item>
        )}
        <Flex.Item>
          <Button
            icon="cog"
            color="transparent"
            content="Toggle R.E.T.R.O. Mode"
            onClick={() => act("Retro")} />
        </Flex.Item>
        <Flex.Item>
          <Box bold>
            {stationTime}
          </Box>
        </Flex.Item>
      </Flex>
    </Box>
  );
};

const PDAFooter = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    app,
  } = data;

  return (
    <Box position="fixed" bottom="0%" left="0%" right="0%">
      <Flex>
        <Flex.Item basis="33%">
          <Button
            fluid
            color="transparent"
            iconColor={app.has_back ? "white" : "disabled"}
            textAlign="center"
            icon="undo"
            mb={0}
            fontSize={1.7}
            onClick={() => act("Back")} />
        </Flex.Item>
        <Flex.Item basis="33%">
          <Button
            fluid
            color="transparent"
            iconColor={app.is_home ? "disabled" : "white"}
            textAlign="center"
            icon="home"
            mb={0}
            fontSize={1.7}
            onClick={() => act("Home")} />
        </Flex.Item>
      </Flex>
    </Box>
  );
};