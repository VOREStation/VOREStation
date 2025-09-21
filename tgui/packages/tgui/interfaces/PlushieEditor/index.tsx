import type React from 'react';
import { useState } from 'react';
import { Window } from 'tgui/layouts';
import { Stack } from 'tgui-core/components';
import { PreviewPanel } from './EditorElements/PreviewPanel';
import { SidebarPanel } from './EditorElements/SidePanel';

export const PlushieEditor: React.FC = () => {
  const [selectedOverlay, setSelectedOverlay] = useState<string | null>(null);

  return (
    <Window width={780} height={560}>
      <Window.Content scrollable>
        <Stack fill>
          <Stack.Item grow>
            <PreviewPanel setSelectedOverlay={setSelectedOverlay} />
          </Stack.Item>
          <Stack.Item grow>
            <SidebarPanel
              selectedOverlay={selectedOverlay}
              setSelectedOverlay={setSelectedOverlay}
            />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
