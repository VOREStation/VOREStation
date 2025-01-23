import { Icon, Stack } from 'tgui-core/components';

export const OperatingComputerUnoccupied = (props) => {
  return (
    <Stack textAlign="center" height="100%">
      <Stack.Item grow align="center" color="label">
        <Icon name="user-slash" mb="0.5rem" size={5} />
        <br />
        No patient detected.
      </Stack.Item>
    </Stack>
  );
};
