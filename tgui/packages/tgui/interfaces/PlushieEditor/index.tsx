import React, { useCallback, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Button, Dialog, NoticeBox, Stack } from 'tgui-core/components';
import { Data } from './types';

import { PlushieOverlayModal } from './PlushieOverlayModal';
import { PreviewPanel, SidebarPanel } from './PlushiePanels';
import { useOverlayMap } from './function';

export const PlushieEditor: React.FC = () => {
  const { act, data } = useBackend<Data>();

  const [overlayModalOpen, setOverlayModalOpen] = useState(false);
  const [warningDialogOpen, setWarningDialogOpen] = useState(false);

  const { overlays } = data;
  const overlayMap = useOverlayMap(overlays);

  const clear = () => {
    setWarningDialogOpen(false);
    setSelectedOverlay(null);
    act('clear');
  };

  const [selectedOverlay, setSelectedOverlay] = useState<string | null>(null);

  const toggleOverlay = useCallback(
    (icon_state: string) => {
      if (overlayMap[icon_state]) {
        act('remove_overlay', { removed_overlay: icon_state });
        if (selectedOverlay === icon_state) setSelectedOverlay(null);
      } else {
        act('add_overlay', { new_overlay: icon_state });
      }
    },
    [act, overlayMap, selectedOverlay],
  );

  return (
    <Window width={780} height={560}>
      <Window.Content scrollable>
        <Stack fill>
          <Stack.Item grow={1}>
            <PreviewPanel onClear={() => setWarningDialogOpen(true)} />
          </Stack.Item>

          <Stack.Item grow={1}>
            <SidebarPanel
              selectedOverlay={selectedOverlay}
              setSelectedOverlay={setSelectedOverlay}
              toggleOverlay={toggleOverlay}
              onOpenModal={() => setOverlayModalOpen(true)}
            />
          </Stack.Item>
        </Stack>

        {overlayModalOpen && (
          <PlushieOverlayModal
            toggleOverlay={toggleOverlay}
            onClose={() => setOverlayModalOpen(false)}
          />
        )}
        {warningDialogOpen && (
          <Dialog title="Warning!" onClose={() => setWarningDialogOpen(false)}>
            <NoticeBox>
              Warning! Clicking confirm will delete all your progress! Make sure
              to save the dragons that you don't wish to lose!!
            </NoticeBox>
            <Stack>
              <Button onClick={clear} icon="trash" backgroundColor="#d63939ff">
                Confirm
              </Button>
              <Button
                onClick={() => setWarningDialogOpen(false)}
                icon="times"
                backgroundColor="#21af39ff"
              >
                Cancel
              </Button>
            </Stack>
          </Dialog>
        )}
      </Window.Content>
    </Window>
  );
};
