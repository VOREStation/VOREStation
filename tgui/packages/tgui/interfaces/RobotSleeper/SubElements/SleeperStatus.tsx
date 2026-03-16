import { Section, Stack } from 'tgui-core/components';
import { SleeperButtons } from './SleeperStatusElements/SleeperButtons';
import { SleeperStatusPanel } from './SleeperStatusElements/SleeperStatusPanel';

export const SleeperStatus = (props: { name: string }) => {
  const { name } = props;

  return (
    <Section fill title={`${name} Status`}>
      <Stack fill vertical>
        <SleeperButtons />
        <Stack.Divider />
        <Stack.Item grow>
          <SleeperStatusPanel name={name} />
        </Stack.Item>
      </Stack>
    </Section>
  );
};
