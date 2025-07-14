import 'tgui/styles/interfaces/CommandlineTerminal.scss';

import { Box } from 'tgui-core/components';

const stringToColor = (str: string): string => {
  let hash = 0;
  for (let i = 0; i < str.length; i++) {
    hash = str.charCodeAt(i) + ((hash << 5) - hash);
  }
  const hue = Math.abs(hash) % 360;
  return `hsl(${hue}, 70%, 80%)`; // pastel prince background
};

export const LogEntry = (props: {
  command: string;
  owner: string;
  warning: boolean;
  entry: string;
  timestamp: string;
  source: string;
}) => {
  const { command, warning, entry, timestamp, owner, source } = props;

  return (
    <Box className="commandline_logentry-border" id={owner}>
      <Box className="commandline_logentry" id="commandline_logentry">
        <Box className="commandline_logentry-header">
          <Box
            className="commandline_logentry-timestamp"
            style={{ backgroundColor: stringToColor(source) }}
          >
            {timestamp}
          </Box>
          <Box className="commandline_logentry-command">{command}</Box>
          {warning && <Box className="commandline_logentry-warning">[!!]</Box>}
        </Box>
        <Box className="commandline_logentry-content">{entry}</Box>
      </Box>
    </Box>
  );
};
