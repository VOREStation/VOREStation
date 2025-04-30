/* eslint react/no-danger: "off" */

import { useBackend } from 'tgui/backend';
import { NtosWindow } from 'tgui/layouts';
import { Button, Section, Stack, Table } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

type Data = {
  PC_device_theme: string;
  error: string | null;
  filedata: string | null;
  filename: string | null;
  files: file[];
  usbconnected: BooleanLike;
  usbfiles: file[];
};

export type file = {
  name: string;
  type: string;
  uid: number;
  size: number;
  undeletable: BooleanLike;
};

export const NtosFileManager = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    PC_device_theme,
    usbconnected,
    filename,
    filedata,
    error,
    files = [],
    usbfiles = [],
  } = data;
  return (
    <NtosWindow resizable theme={PC_device_theme}>
      <NtosWindow.Content scrollable>
        {(filename && (
          <Section
            title={'Viewing File ' + filename}
            buttons={
              <Stack>
                <Stack.Item>
                  <Button icon="pen" onClick={() => act('PRG_edit')}>
                    Edit
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button icon="print" onClick={() => act('PRG_printfile')}>
                    Print
                  </Button>
                </Stack.Item>
                <Stack.Item>
                  <Button icon="times" onClick={() => act('PRG_closefile')}>
                    Close
                  </Button>
                </Stack.Item>
              </Stack>
            }
          >
            {/* This dangerouslySetInnerHTML is only ever passed data that has passed through pencode2html
             * It should be safe enough to support pencode in this way.
             */}
            {filedata && <div dangerouslySetInnerHTML={{ __html: filedata }} />}
          </Section>
        )) || (
          <>
            <Section>
              <FileTable
                files={files}
                usbconnected={usbconnected}
                onUpload={(file: file) => act('PRG_copytousb', { uid: file })}
                onDelete={(file: file) => act('PRG_deletefile', { uid: file })}
                onOpen={(file: file) => act('PRG_openfile', { uid: file })}
                onRename={(file: file, newName: string) =>
                  act('PRG_rename', {
                    uid: file,
                    new_name: newName,
                  })
                }
                onDuplicate={(file: file) => act('PRG_clone', { uid: file })}
              />
            </Section>
            {(usbconnected && (
              <Section title="Data Disk">
                <FileTable
                  usbmode
                  files={usbfiles}
                  usbconnected={usbconnected}
                  onUpload={(file: file) =>
                    act('PRG_copyfromusb', { uid: file })
                  }
                  onDelete={(file: file) =>
                    act('PRG_deletefile', { uid: file })
                  }
                  onOpen={(file: file) => act('PRG_openfile', { uid: file })}
                  onRename={(file: file, newName: string) =>
                    act('PRG_rename', {
                      uid: file,
                      new_name: newName,
                    })
                  }
                  onDuplicate={(file: file) => act('PRG_clone', { uid: file })}
                />
              </Section>
            )) ||
              null}
            <Section>
              <Button icon="plus" onClick={() => act('PRG_newtextfile')}>
                New Text File
              </Button>
            </Section>
          </>
        )}
        {error && (
          <Stack wrap="wrap" position="fixed" bottom="5px">
            <Stack.Item>
              <Section>
                <Button
                  bottom="0"
                  left="0"
                  icon="ban"
                  onClick={() => act('PRG_clearerror')}
                />
              </Section>
            </Stack.Item>
            <Stack.Item grow>
              <Section>{error}</Section>
            </Stack.Item>
          </Stack>
        )}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

const FileTable = (props: {
  files: file[];
  usbconnected: BooleanLike;
  usbmode?: boolean;
  onUpload: Function;
  onDelete: Function;
  onRename: Function;
  onOpen: Function;
  onDuplicate: Function;
}) => {
  const {
    files = [],
    usbconnected,
    usbmode,
    onUpload,
    onDelete,
    onRename,
    onOpen,
    onDuplicate,
  } = props;
  return (
    <Table>
      <Table.Row header>
        <Table.Cell>File</Table.Cell>
        <Table.Cell collapsing>Type</Table.Cell>
        <Table.Cell collapsing>Size</Table.Cell>
      </Table.Row>
      {files.map((file) => (
        <Table.Row key={file.name} className="candystripe">
          <Table.Cell>
            {!file.undeletable ? (
              <>
                <Button.Input
                  width="80%"
                  buttonText={file.name}
                  value={file.name}
                  tooltip="Rename"
                  onCommit={(value) => onRename(file.uid, value)}
                />
                <Button onClick={() => onOpen(file.uid)}>Open</Button>
              </>
            ) : (
              file.name
            )}
          </Table.Cell>
          <Table.Cell>{file.type}</Table.Cell>
          <Table.Cell>{file.size}</Table.Cell>
          <Table.Cell collapsing>
            {!file.undeletable && (
              <>
                <Button.Confirm
                  icon="trash"
                  confirmIcon="times"
                  confirmContent=""
                  tooltip="Delete"
                  onClick={() => onDelete(file.uid)}
                />
                {!!usbconnected &&
                  (usbmode ? (
                    <Button
                      icon="download"
                      tooltip="Download"
                      onClick={() => onUpload(file.uid)}
                    />
                  ) : (
                    <Button
                      icon="upload"
                      tooltip="Upload"
                      onClick={() => onUpload(file.uid)}
                    />
                  ))}
              </>
            )}
          </Table.Cell>
        </Table.Row>
      ))}
    </Table>
  );
};
