import type React from 'react';
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Floating,
  ImageButton,
  Input,
  Section,
  Stack,
} from 'tgui-core/components';
import { createSearch } from 'tgui-core/string';
import { useOverlayMap } from '../function';
import type { Data } from '../types';

type OverlayModalProps = {
  toggleOverlay: (icon_state: string) => void;
};

export const OverlaySelector: React.FC<OverlayModalProps> = ({
  toggleOverlay,
}) => {
  const { data } = useBackend<Data>();
  const [filter, setFilter] = useState('');
  const { possible_overlays, overlays, icon } = data;

  const searcher = createSearch(
    filter,
    (ov: { name: string; icon_state: string }) => ov.name,
  );

  const overlayMap = useOverlayMap(overlays);
  const filteredPossible = possible_overlays.filter(searcher);

  return (
    <Floating
      placement="bottom-end"
      contentClasses="PlushEditor__Floating"
      content={
        <Section title="Overlays" scrollable>
          <Stack vertical fill>
            <Stack.Item>
              <Input
                placeholder="Search overlays..."
                value={filter}
                onChange={setFilter}
                fluid
              />
            </Stack.Item>
            <Box>
              {filteredPossible.map(({ name, icon_state }) => (
                <ImageButton
                  key={icon_state}
                  dmIcon={icon}
                  dmIconState={icon_state}
                  onClick={() => toggleOverlay(icon_state)}
                  color={overlayMap[icon_state] ? 'green' : 'red'}
                  fluid
                  align="start"
                >
                  {name}
                </ImageButton>
              ))}
            </Box>
          </Stack>
        </Section>
      }
    >
      <Box className="VorePanel__floatingButton">+/-</Box>
    </Floating>
  );
};
