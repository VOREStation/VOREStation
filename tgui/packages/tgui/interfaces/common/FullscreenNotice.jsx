import { Flex, Section } from '../../components';

/**
 * Just a generic wrapper for fullscreen notices.
 */
export const FullscreenNotice = (props, context) => {
  const { children, title = 'Welcome' } = props;
  return (
    <Section title={title} height="100%" fill>
      <Flex height="100%" align="center" justify="center">
        <Flex.Item textAlign="center" mt="-2rem">
          {children}
        </Flex.Item>
      </Flex>
    </Section>
  );
};
