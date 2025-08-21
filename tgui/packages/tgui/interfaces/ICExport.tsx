import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, Section, Stack, TextArea } from 'tgui-core/components';

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
  const { data, act } = useBackend<Data>();
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
                width="100%"
                value={export_data || 'No data available'}
              />
            </Stack.Item>
            <Stack.Item>
              <Stack>
                <Stack.Item>
                  <Button
                    icon="download"
                    content="Download as File"
                    onClick={handleDownload}
                    tooltip="Download circuit data as a JSON file"
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon="copy"
                    content="Copy to Clipboard"
                    onClick={() => {
                      if (navigator.clipboard) {
                        navigator.clipboard.writeText(export_data);
                      }
                      act('copy_export_data');
                    }}
                    tooltip="Copy circuit data to clipboard"
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon="times"
                    content="Close"
                    onClick={() => act('close_export')}
                  />
                </Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item>
              Note: You can download the circuit as a file or copy to clipboard.
              Use the circuit printer&apos;s import function to load the
              circuit.
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
