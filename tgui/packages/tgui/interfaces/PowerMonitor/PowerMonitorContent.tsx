import { useBackend } from '../../backend';
import { Box, Button, Section, Table } from '../../components';
import { PowerMonitorFocus } from './PowerMonitorFocus';
import { Data } from './types';

export const PowerMonitorContent = (props) => {
  const { act, data } = useBackend<Data>();

  const { all_sensors, focus } = data;

  if (focus) {
    return <PowerMonitorFocus focus={focus} />;
  }

  let body: React.JSX.Element = <Box color="bad">No sensors detected</Box>;

  if (all_sensors) {
    body = (
      <Table>
        {all_sensors.map((sensor) => (
          <Table.Row key={sensor.name}>
            <Table.Cell>
              <Button
                icon={sensor.alarm ? 'bell' : 'sign-in-alt'}
                onClick={() => act('setsensor', { id: sensor.name })}
              >
                {sensor.name}
              </Button>
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    );
  }

  return (
    <Section
      title="No active sensor. Listing all."
      buttons={
        <Button icon="undo" onClick={() => act('refresh')}>
          Scan For Sensors
        </Button>
      }
    >
      {body}
    </Section>
  );
};
