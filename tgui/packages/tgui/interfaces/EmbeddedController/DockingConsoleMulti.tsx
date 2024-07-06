import { useBackend } from '../../backend';
import { Flex, Icon, LabeledList, Section } from '../../components';
import { DockStatus } from './EmbeddedControllerHelpers';
import { DockingConsoleMultiData } from './types';

/**
 * Shockingly, the multi docking console is the simplest docking console.
 * It has no functionality except to display the status of multiple airlocks,
 * for bigger shuttles.
 * Replaces multi_docking_console.tmpl
 */
export const DockingConsoleMulti = (props) => {
  const { data } = useBackend<DockingConsoleMultiData>();

  const { docking_status } = data;

  return (
    <>
      <Section title="Docking Status">
        <DockStatus docking_status={docking_status} override_enabled={false} />
      </Section>
      <Section title="Airlocks">
        {data.airlocks.length ? (
          <LabeledList>
            {data.airlocks.map((airlock) => (
              <LabeledList.Item
                color={airlock.override_enabled ? 'bad' : 'good'}
                key={airlock.name}
                label={airlock.name}
              >
                {airlock.override_enabled ? 'OVERRIDE ENABLED' : 'STATUS OK'}
              </LabeledList.Item>
            ))}
          </LabeledList>
        ) : (
          <Flex height="100%" mt="0.5em">
            <Flex.Item grow="1" align="center" textAlign="center" color="bad">
              <Icon name="door-closed" mb="0.5rem" size={5} />
              <br />
              No airlocks found.
            </Flex.Item>
          </Flex>
        )}
      </Section>
    </>
  );
};
