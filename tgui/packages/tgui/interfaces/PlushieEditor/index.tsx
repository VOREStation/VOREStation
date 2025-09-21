import type React from 'react';
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Button, Dialog, NoticeBox, Stack } from 'tgui-core/components';
import { PreviewPanel } from './EditorElements/PreviewPanel';
import { SidebarPanel } from './EditorElements/SidePanel';
import type { Data } from './types';

export const PlushieEditor: React.FC = () => {
  const { act } = useBackend<Data>();

  const [selectedOverlay, setSelectedOverlay] = useState<string | null>(null);
  const [warningDialogOpen, setWarningDialogOpen] = useState(false);

  const clear = () => {
    setSelectedOverlay(null);
    act('clear');
  };

  return (
    <Window width={780} height={560}>
      <Window.Content scrollable>
        <Stack fill>
          <Stack.Item grow>
            <PreviewPanel onClear={() => setWarningDialogOpen(true)} />
          </Stack.Item>
          <Stack.Item grow>
            <SidebarPanel
              selectedOverlay={selectedOverlay}
              setSelectedOverlay={setSelectedOverlay}
            />
          </Stack.Item>
        </Stack>
        {warningDialogOpen && (
          <Dialog title="Warning!" onClose={() => setWarningDialogOpen(false)}>
            <NoticeBox>
              Warning! Clicking confirm will delete all your progress! Make sure
              to save the dragons that you don't wish to lose!!
            </NoticeBox>
            <Stack>
              <Stack.Item>
                <Button onClick={clear} icon="trash" color="red">
                  Confirm
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button
                  onClick={() => setWarningDialogOpen(false)}
                  icon="times"
                  color="green"
                >
                  Cancel
                </Button>
              </Stack.Item>
            </Stack>
          </Dialog>
        )}
      </Window.Content>
    </Window>
  );
};
