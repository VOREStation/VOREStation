import { useBackend } from '../backend';
import { Button, Box, LabeledList, ProgressBar, Section, Icon } from '../components';
import { NtosWindow } from '../layouts';

export const NtosNetTransfer = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    error,
    downloading,
    uploading,
    upload_filelist,
  } = data;

  let body = <P2PAvailable />;

  if (error) {
    body = <P2PError />;
  } else if (downloading) {
    body = <P2PDownload />;
  } else if (uploading) {
    body = <P2PUpload />;
  } else if (upload_filelist.length) {
    body = <P2PUploadServer />;
  }

  return (
    <NtosWindow width={575} height={700} resizable>
      <NtosWindow.Content scrollable>
        {body}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

const P2PError = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    error,
  } = data;
  return (
    <Section title="An error has occured during operation." buttons={
      <Button
        icon="undo"
        onClick={() => act("PRG_reset")}>
        Reset
      </Button>
    }>
      Additional Information: {error}
    </Section>
  );
};

const P2PDownload = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    download_name,
    download_progress,
    download_size,
    download_netspeed,
  } = data;
  return (
    <Section title="Download in progress">
      <LabeledList>
        <LabeledList.Item label="Downloaded File">
          {download_name}
        </LabeledList.Item>
        <LabeledList.Item label="Progress">
          <ProgressBar
            value={download_progress}
            maxValue={download_size}>
            {download_progress} / {download_size} GQ
          </ProgressBar>
        </LabeledList.Item>
        <LabeledList.Item label="Transfer Speed">
          {download_netspeed} GQ/s
        </LabeledList.Item>
        <LabeledList.Item label="Controls">
          <Button
            icon="ban"
            onClick={() => act("PRG_reset")}>
            Cancel Download
          </Button>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const P2PUpload = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    upload_clients,
    upload_filename,
    upload_haspassword,
  } = data;
  return (
    <Section title="Server enabled">
      <LabeledList>
        <LabeledList.Item label="Clients Connected">
          {upload_clients}
        </LabeledList.Item>
        <LabeledList.Item label="Provided file">
          {upload_filename}
        </LabeledList.Item>
        <LabeledList.Item label="Server Password">
          {upload_haspassword ? "Enabled" : "Disabled"}
        </LabeledList.Item>
        <LabeledList.Item label="Commands">
          <Button
            icon="lock"
            onClick={() => act("PRG_setpassword")}>
            Set Password
          </Button>
          <Button
            icon="ban"
            onClick={() => act("PRG_reset")}>
            Cancel Upload
          </Button>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const P2PUploadServer = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    upload_filelist,
  } = data;
  return (
    <Section title="File transfer server ready." buttons={
      <Button
        icon="undo"
        onClick={() => act("PRG_reset")}>
        Cancel
      </Button>
    }>
      <Button
        fluid
        icon="lock"
        onClick={() => act("PRG_setpassword")}>
        Set Password
      </Button>
      <Section title="Pick file to serve." level={2}>
        {upload_filelist.map(file => (
          <Button
            key={file.uid}
            fluid
            icon="upload"
            onClick={() => act("PRG_uploadfile", { uid: file.uid })}>
            {file.filename} ({file.size}GQ)
          </Button>
        ))}
      </Section>
    </Section>
  );
};

const P2PAvailable = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    servers,
  } = data;
  return (
    <Section title="Available Files" buttons={
      <Button
        icon="upload"
        onClick={() => act("PRG_uploadmenu")}>
        Send File
      </Button>
    }>
      {servers.length && (
        <LabeledList>
          {servers.map(server => (
            <LabeledList.Item label={server.uid} key={server.uid}>
              {!!server.haspassword && <Icon name="lock" mr={1} />}
              {server.filename}&nbsp;
              ({server.size}GQ)&nbsp;
              <Button
                icon="download"
                onClick={() => act("PRG_downloadfile", { uid: server.uid })}>
                Download
              </Button>
            </LabeledList.Item>
          ))}
        </LabeledList>
      ) || (
        <Box>
          No upload servers found.
        </Box>
      )}
    </Section>
  );
};