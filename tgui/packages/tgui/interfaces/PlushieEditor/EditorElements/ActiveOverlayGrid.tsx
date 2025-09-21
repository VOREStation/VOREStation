// todo, cleanup
import type React from 'react';
import { memo } from 'react';
import { Box, ImageButton } from 'tgui-core/components';
import type { Overlay } from '../types';

type ActiveOverlaysGridProps = {
  icon: string;
  overlays: Overlay[];
  selectedOverlay: string | null;
  onSelect: React.Dispatch<React.SetStateAction<string | null>>;
};

export const ActiveOverlaysGrid = memo<ActiveOverlaysGridProps>(
  ({ icon, overlays, selectedOverlay, onSelect }) => (
    <Box>
      {overlays.map((ov) => (
        <ImageButton
          key={ov.icon_state}
          dmIcon={icon}
          dmIconState={ov.icon_state}
          onClick={() => onSelect(ov.icon_state)}
          backgroundColor={
            selectedOverlay === ov.icon_state ? '#21af39ff' : null
          }
          align="start"
        >
          {ov.name}
        </ImageButton>
      ))}
    </Box>
  ),
);
