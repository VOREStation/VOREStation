import { useBackend } from '../../backend';
import { Box, Button, Icon } from '../../components';
import { FullscreenNotice } from './FullscreenNotice';

/**
 * Displays a login screen that users can interact with
 * using an ID card in their hand.
 * Special elements can be invoked by defining machineType prop
 * possible string arguments are defined in SpecialMachineInteraction in loginScreen.js
 *
 * Required data fields:
 * * `scan` — The name of the currently inserted ID
 * * `isAI` — Whether the user is an AI. If true, shows "Login as AI"
 * * `isRobot` — Whether the user is a robot. If true, shows "Login as Cyborg"
 *
 * Clicking the main button calls the `scan` TGUI act.
 * Clicking either the AI or normal login button calls
 * the `login` TGUI act with the a `login_type` parameter with the value:
 * * 1 (LOGIN_TYPE_NORMAL) if it's an ID login
 * * 2 (LOGIN_TYPE_AI) if it's an AI login
 * * 3 (LOGIN_TYPE_ROBOT) if it's a robot login
 *
 * You will have to handle the AI login case in the same action.
 * The normal login button is only available when `scan` is not null.
 * The AI and robot login buttons are only visible if the user is one
 * @param {object} _properties
 * @param {object} context
 */
export const LoginScreen = (_properties, context) => {
  const { act, data } = useBackend(context);
  const { scan, isAI, isRobot } = data;
  const { machineType } = _properties;
  return (
    <FullscreenNotice title="Welcome">
      <Box fontSize="1.5rem" bold>
        <Icon name="user-circle" verticalAlign="middle" size={3} mr="1rem" />
        Guest
      </Box>
      <Box color="label" my="1rem">
        ID:
        <Button
          icon="id-card"
          content={scan ? scan : '----------'}
          ml="0.5rem"
          onClick={() => act('scan')}
        />
      </Box>
      <Button
        icon="sign-in-alt"
        disabled={!scan}
        content="Login"
        onClick={() =>
          act('login', {
            login_type: 1,
          })
        }
      />

      {!!isAI && (
        <Button
          icon="sign-in-alt"
          content="Login as AI"
          onClick={() =>
            act('login', {
              login_type: 2,
            })
          }
        />
      )}
      {!!isRobot && (
        <Button
          icon="sign-in-alt"
          content="Login as Cyborg"
          onClick={() =>
            act('login', {
              login_type: 3,
            })
          }
        />
      )}
      <Box>
        <SpecialMachineInteraction specialType={machineType} />
      </Box>
    </FullscreenNotice>
  );
};

/**
 * Special login screen elements that we want to appear for specific machines.
 * Props: "specialType", arguemnt: string
 * specialType definitions are defined in LoginScreen.js SpecialMachineInteraction
 * currently supported: "Fax"
 */
export const SpecialMachineInteraction = (_properties, context) => {
  const { act } = useBackend(context);
  const { specialType } = _properties;
  if (!specialType) {
    return null;
  } else if (specialType === 'Fax') {
    return (
      <Button
        position="relative"
        content="Send Automated Fax Request"
        bottom="152px"
        left="188px"
        icon="share-square"
        onClick={() => act('send_automated_staff_request')}
        tooltip={
          "Automated Fax Requests do not require staff to post on discord, but won't ping the related roles."
        }
      />
    );
  }
};
