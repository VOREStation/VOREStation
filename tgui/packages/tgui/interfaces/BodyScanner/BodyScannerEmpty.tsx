import { Icon, Section, Stack } from 'tgui-core/components';

export const BodyScannerEmpty = () => {
  return (
    <Section textAlign="center" flexGrow>
      <Stack height="100%">
        <Stack.Item grow align="center" color="label">
          <Icon name="user-slash" mb="0.5rem" size={5} />
          <br />
          No occupant detected.
        </Stack.Item>
      </Stack>
    </Section>
  );
};
