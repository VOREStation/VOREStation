/* eslint react/no-danger: "off" */
import { useBackend } from 'tgui/backend';
import { NtosWindow } from 'tgui/layouts';
import { Box, Button, Section, Table } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

import type { file } from './NtosFileManager';

type Data = {
  PC_device_theme: string;
  error: string | null;
  browsing: BooleanLike;
  files: file[];
  usbconnected: BooleanLike;
  usbfiles: file[];
  filedata: string | null;
  filename: string | null;
};

export const NtosWordProcessor = (props) => {
  const { act, data } = useBackend<Data>();

  const { PC_device_theme, error, browsing, files, filename, filedata } = data;

  return (
    <NtosWindow resizable theme={PC_device_theme}>
      <NtosWindow.Content scrollable>
        {(error && (
          <Box color="bad">
            <h2>An Error has occured:</h2>
            Additional Information: {error}
            Please try again. If the problem persists, contact your system
            administrator for assistance.
            <Button icon="arrow-left" onClick={() => act('PRG_backtomenu')}>
              Back to menu
            </Button>
          </Box>
        )) ||
          (browsing && (
            <Section
              title="File Browser"
              buttons={
                <Button
                  icon="arrow-left"
                  onClick={() => act('PRG_closebrowser')}
                >
                  Back to editor
                </Button>
              }
            >
              <Section title="Available documents (local)">
                <Table>
                  <Table.Row header>
                    <Table.Cell>Name</Table.Cell>
                    <Table.Cell>Size (GQ)</Table.Cell>
                    <Table.Cell collapsing />
                  </Table.Row>
                  {files.map((file, i) => (
                    <Table.Row key={i}>
                      <Table.Cell>{file.name}</Table.Cell>
                      <Table.Cell>{file.size}</Table.Cell>
                      <Table.Cell collapsing>
                        <Button
                          icon="file-word"
                          onClick={() =>
                            act('PRG_openfile', { PRG_openfile: file.name })
                          }
                        >
                          Open
                        </Button>
                      </Table.Cell>
                    </Table.Row>
                  ))}
                </Table>
              </Section>
            </Section>
          )) || (
            <Section title={'Document: ' + filename}>
              <Box>
                <Button onClick={() => act('PRG_newfile')}>New</Button>
                <Button onClick={() => act('PRG_loadmenu')}>Load</Button>
                <Button onClick={() => act('PRG_savefile')}>Save</Button>
                <Button onClick={() => act('PRG_saveasfile')}>Save As</Button>
              </Box>
              <Box>
                <Button onClick={() => act('PRG_editfile')}>Edit</Button>
                <Button onClick={() => act('PRG_txtrpeview')}>Preview</Button>
                <Button onClick={() => act('PRG_taghelp')}>
                  Formatting Help
                </Button>
                <Button
                  disabled={!filedata}
                  onClick={() => act('PRG_printfile')}
                >
                  Print
                </Button>
              </Box>
              {/* This dangerouslySetInnerHTML is only ever passed data that has passed through pencode2html
               * It should be safe enough to support pencode in this way.
               */}
              <Section mt={1}>
                <div dangerouslySetInnerHTML={{ __html: filedata! }} />
              </Section>
            </Section>
          )}
      </NtosWindow.Content>
    </NtosWindow>
  );
};
