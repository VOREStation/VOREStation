import { Section, Stack } from 'tgui-core/components';

/**
 * Just a generic wrapper for fullscreen notices.
 */
export const FullscreenNotice = (props: {
  children?: React.ReactNode | undefined;
  title?: string;
}) => {
  const { children, title = 'Welcome' } = props;
  return (
    <Section title={title} height="100%" fill>
      <Stack height="100%" align="center" justify="center">
        <Stack.Item textAlign="center" mt="-2rem">
          {children}
        </Stack.Item>
      </Stack>
    </Section>
  );
};
