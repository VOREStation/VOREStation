import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, Section, TextArea } from 'tgui-core/components';

type Data = {
  export_data: string;
  assembly_name: string;
};

const downloadCircuitFile = (data: string, filename: string) => {
  const blob = new Blob([data], {
    type: 'application/json',
  });

  // Use Byond.saveBlob if available, otherwise fall back to browser download
  if (typeof Byond !== 'undefined' && Byond.saveBlob) {
    Byond.saveBlob(blob, filename, '.json');
  } else {
    // Fallback for development/testing
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = filename + '.json';
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
  }
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
          <TextArea
            height="40vh"
            width="100%"
            value={export_data || 'No data available'}
          />
          <Box mt={2}>
            <Button
              icon="download"
              content="Download as File"
              onClick={handleDownload}
              tooltip="Download circuit data as a JSON file"
            />
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
            <Button
              icon="times"
              content="Close"
              onClick={() => act('close_export')}
            />
          </Box>
          <Box mt={1}>
            Note: You can download the circuit as a file or copy to clipboard.
            Use the circuit printer&apos;s import function to load the circuit.
          </Box>
        </Section>
      </Window.Content>
    </Window>
  );
};
