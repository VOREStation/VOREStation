import { useBackend } from '../../backend';
import { Button, Flex, Section } from '../../components';
import { Data } from './types';

export const ShuttleControlSharedShuttleControls = (props) => {
  const { act, data } = useBackend<Data>();

  const { can_launch, can_cancel, can_force } = data;

  return (
    <Section title="Controls">
      <Flex spacing={1}>
        <Flex.Item grow={1}>
          <Button
            onClick={() => act('move')}
            disabled={!can_launch}
            icon="rocket"
            fluid
          >
            Launch Shuttle
          </Button>
        </Flex.Item>
        <Flex.Item grow={1}>
          <Button
            onClick={() => act('cancel')}
            disabled={!can_cancel}
            icon="ban"
            fluid
          >
            Cancel Launch
          </Button>
        </Flex.Item>
        <Flex.Item grow={1}>
          <Button
            onClick={() => act('force')}
            color="bad"
            disabled={!can_force}
            icon="exclamation-triangle"
            fluid
          >
            Force Launch
          </Button>
        </Flex.Item>
      </Flex>
    </Section>
  );
};
