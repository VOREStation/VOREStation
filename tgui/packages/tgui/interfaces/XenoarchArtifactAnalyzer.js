import { useBackend } from '../backend';
import { Window } from '../layouts';
import { Box, Button, Section } from '../components';

export const XenoarchArtifactAnalyzer = (props, context) => {
  return (
    <Window width={250} height={140}>
      <Window.Content>
        <XenoarchArtifactAnalyzerContent />
      </Window.Content>
    </Window>
  );
};

const XenoarchArtifactAnalyzerContent = (props, context) => {
  const { act, data } = useBackend(context);

  const { owned_scanner, scan_in_progress } = data;

  if (!owned_scanner) {
    return (
      <Section title="No Scanner Detected">
        <Box color="bad">Warning: No scanner was detected. This machine requires a scanner to operate.</Box>
      </Section>
    );
  }

  if (scan_in_progress) {
    return (
      <Section title="Scan In Progress">
        Scanning...
        <Button mt={1} fluid icon="stop" onClick={() => act('scan')}>
          Cancel Scan
        </Button>
      </Section>
    );
  }

  return (
    <Section title="Artifact Analyzer">
      <Button fluid icon="search" onClick={() => act('scan')}>
        Begin Scan
      </Button>
    </Section>
  );
};
