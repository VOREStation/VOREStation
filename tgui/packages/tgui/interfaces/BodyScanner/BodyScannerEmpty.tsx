import { Flex, Icon, Section } from '../../components';

export const BodyScannerEmpty = () => {
  return (
    <Section textAlign="center" flexGrow>
      <Flex height="100%">
        <Flex.Item grow="1" align="center" color="label">
          <Icon name="user-slash" mb="0.5rem" size={5} />
          <br />
          No occupant detected.
        </Flex.Item>
      </Flex>
    </Section>
  );
};
