import { Button, Stack } from 'tgui-core/components';

let url: string | null = null;

setInterval(() => {
  Byond.winget('', 'url').then((currentUrl) => {
    // Sometimes, for whatever reason, BYOND will give an IP with a :0 port.
    if (currentUrl && !currentUrl.match(/:0$/)) {
      url = currentUrl;
    }
  });
}, 5000);

export function ReconnectButton(props: {
  onDismissedWarning: React.Dispatch<React.SetStateAction<boolean>>;
}) {
  if (!url) {
    return null;
  }
  const { onDismissedWarning } = props;

  return (
    <Stack>
      <Stack.Item>
        <Button
          color="white"
          onClick={() => {
            Byond.command('.reconnect');
          }}
        >
          Reconnect
        </Button>
      </Stack.Item>
      <Stack.Item>
        <Button
          color="white"
          icon="power-off"
          tooltip="Relaunch game"
          tooltipPosition="bottom-end"
          onClick={() => {
            location.href = `byond://${url}`;
            Byond.command('.quit');
          }}
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          color="white"
          onClick={() => {
            onDismissedWarning(true);
          }}
        >
          Dismiss
        </Button>
      </Stack.Item>
    </Stack>
  );
}
