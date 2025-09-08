import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Button, Section, Stack, TextArea } from 'tgui-core/components';

type Data = {
  export_data: string;
  assembly_name: string;
};

const downloadCircuitFile = (data: string, filename: string) => {
  const blob = new Blob([data], {
    type: 'application/json',
  });

  Byond.saveBlob(blob, filename, '.json');
};

export const ICExport = (props) => {
  const { data } = useBackend<Data>();
  const { export_data, assembly_name } = data;

  const handleDownload = () => {
    const filename = assembly_name
      ? `circuit_${assembly_name}`
      : 'circuit_export';
    downloadCircuitFile(export_data, filename);
  };

  return (
    <Window width={600} height={350}>
      <Window.Content>
        <Section title="Circuit Export Data">
          <Stack vertical>
            <Stack.Item>
              <TextArea
                height="40vh"
                fluid
                value={export_data || 'No data available'}
              />
            </Stack.Item>
            <Stack.Item>
              <Stack>
                <Stack.Item>
                  <Button
                    icon="download"
                    onClick={handleDownload}
                    tooltip="Download circuit data as a JSON file"
                  >
                    Download as File
                  </Button>
                </Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item>
              Note: You can download the circuit as a file or copy to clipboard.
              Use the circuit printer's import function to load the circuit.
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
