import { Flex, Icon } from '../../components';

export const OperatingComputerUnoccupied = (props) => {
  return (
    <Flex textAlign="center" height="100%">
      <Flex.Item grow="1" align="center" color="label">
        <Icon name="user-slash" mb="0.5rem" size={5} />
        <br />
        No patient detected.
      </Flex.Item>
    </Flex>
  );
};
