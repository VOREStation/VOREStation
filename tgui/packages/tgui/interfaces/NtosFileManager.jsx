/* eslint react/no-danger: "off" */
import { Fragment } from 'react';
import { useBackend } from '../backend';
import { Button, Section, Table, Flex } from '../components';
import { NtosWindow } from '../layouts';

export const NtosFileManager = (props) => {
  const { act, data } = useBackend();
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
              <>
                <Button
                  icon="pen"
                  content="Edit"
                  onClick={() => act('PRG_edit')}
                />
                <Button
                  icon="print"
                  content="Print"
                  onClick={() => act('PRG_printfile')}
                />
                <Button
                  icon="times"
                  content="Close"
                  onClick={() => act('PRG_closefile')}
                />
              </>
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
                onUpload={(file) => act('PRG_copytousb', { uid: file })}
                onDelete={(file) => act('PRG_deletefile', { uid: file })}
                onOpen={(file) => act('PRG_openfile', { uid: file })}
                onRename={(file, newName) =>
                  act('PRG_rename', {
                    uid: file,
                    new_name: newName,
                  })
                }
                onDuplicate={(file) => act('PRG_clone', { uid: file })}
              />
            </Section>
            {(usbconnected && (
              <Section title="Data Disk">
                <FileTable
                  usbmode
                  files={usbfiles}
                  usbconnected={usbconnected}
                  onUpload={(file) => act('PRG_copyfromusb', { uid: file })}
                  onDelete={(file) => act('PRG_deletefile', { uid: file })}
                  onOpen={(file) => act('PRG_openfile', { uid: file })}
                  onRename={(file, newName) =>
                    act('PRG_rename', {
                      uid: file,
                      new_name: newName,
                    })
                  }
                  onDuplicate={(file) => act('PRG_clone', { uid: file })}
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
          <Flex wrap="wrap" position="fixed" bottom="5px">
            <Flex.Item>
              <Section>
                <Button
                  bottom="0"
                  left="0"
                  icon="ban"
                  onClick={() => act('PRG_clearerror')}
                />
              </Section>
            </Flex.Item>
            <Section>
              <Flex.Item grow>{error}</Flex.Item>
            </Section>
          </Flex>
        )}
      </NtosWindow.Content>
    </NtosWindow>
  );
};

const FileTable = (props) => {
  const {
    files = [],
    usbconnected,
    usbmode,
    onUpload,
    onDelete,
    onRename,
    onOpen,
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
                  content={file.name}
                  currentValue={file.name}
                  tooltip="Rename"
                  onCommit={(e, value) => onRename(file.uid, value)}
                />
                <Button content="Open" onClick={() => onOpen(file.uid)} />
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
