import { useBackend } from 'tgui/backend';
import { NtosWindow } from 'tgui/layouts';
import {
  Box,
  Button,
  Icon,
  LabeledList,
  ProgressBar,
  Section,
} from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

type Data = {
  error: string;
  downloading: BooleanLike;
  download_size: number | undefined;
  download_progress: number | undefined;
  download_netspeed: number | undefined;
  download_name: string | undefined;
  uploading: BooleanLike;
  upload_uid: number | undefined;
  upload_clients: number | undefined;
  upload_haspassword: BooleanLike;
  upload_filename: string | undefined;
  upload_filelist: uploadFile[] | [];
  servers: server[] | [];
};

type server = {
  uid: number;
  filename: string;
  size: number;
  haspassword: BooleanLike;
};

type uploadFile = { uid: number; filename: string; size: number };

export const NtosNetTransfer = (props) => {
  const { data } = useBackend<Data>();

  const { error, downloading, uploading, upload_filelist } = data;

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
    <NtosWindow width={575} height={700}>
      <NtosWindow.Content scrollable>{body}</NtosWindow.Content>
    </NtosWindow>
  );
};

const P2PError = (props) => {
  const { act, data } = useBackend<Data>();
  const { error } = data;
  return (
    <Section
      title="An error has occured during operation."
      buttons={
        <Button icon="undo" onClick={() => act('PRG_reset')}>
          Reset
        </Button>
      }
    >
      Additional Information: {error}
    </Section>
  );
};

const P2PDownload = (props) => {
  const { act, data } = useBackend<Data>();
  const { download_name, download_progress, download_size, download_netspeed } =
    data;
  return (
    <Section title="Download in progress">
      <LabeledList>
        <LabeledList.Item label="Downloaded File">
          {download_name}
        </LabeledList.Item>
        <LabeledList.Item label="Progress">
          <ProgressBar value={download_progress!} maxValue={download_size}>
            {download_progress} / {download_size} GQ
          </ProgressBar>
        </LabeledList.Item>
        <LabeledList.Item label="Transfer Speed">
          {download_netspeed} GQ/s
        </LabeledList.Item>
        <LabeledList.Item label="Controls">
          <Button icon="ban" onClick={() => act('PRG_reset')}>
            Cancel Download
          </Button>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const P2PUpload = (props) => {
  const { act, data } = useBackend<Data>();
  const { upload_clients, upload_filename, upload_haspassword } = data;
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
          {upload_haspassword ? 'Enabled' : 'Disabled'}
        </LabeledList.Item>
        <LabeledList.Item label="Commands">
          <Button icon="lock" onClick={() => act('PRG_setpassword')}>
            Set Password
          </Button>
          <Button icon="ban" onClick={() => act('PRG_reset')}>
            Cancel Upload
          </Button>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const P2PUploadServer = (props) => {
  const { act, data } = useBackend<Data>();
  const { upload_filelist } = data;
  return (
    <Section
      title="File transfer server ready."
      buttons={
        <Button icon="undo" onClick={() => act('PRG_reset')}>
          Cancel
        </Button>
      }
    >
      <Button fluid icon="lock" onClick={() => act('PRG_setpassword')}>
        Set Password
      </Button>
      <Section title="Pick file to serve.">
        {upload_filelist.map((file: uploadFile) => (
          <Button
            key={file.uid}
            fluid
            icon="upload"
            onClick={() => act('PRG_uploadfile', { uid: file.uid })}
          >
            {file.filename} ({file.size}GQ)
          </Button>
        ))}
      </Section>
    </Section>
  );
};

const P2PAvailable = (props) => {
  const { act, data } = useBackend<Data>();
  const { servers } = data;
  return (
    <Section
      title="Available Files"
      buttons={
        <Button icon="upload" onClick={() => act('PRG_uploadmenu')}>
          Send File
        </Button>
      }
    >
      {(servers.length && (
        <LabeledList>
          {servers.map((server: server) => (
            <LabeledList.Item label={server.uid} key={server.uid}>
              {!!server.haspassword && <Icon name="lock" mr={1} />}
              {server.filename}&nbsp; ({server.size}GQ)&nbsp;
              <Button
                icon="download"
                onClick={() => act('PRG_downloadfile', { uid: server.uid })}
              >
                Download
              </Button>
            </LabeledList.Item>
          ))}
        </LabeledList>
      )) || <Box>No upload servers found.</Box>}
    </Section>
  );
};
