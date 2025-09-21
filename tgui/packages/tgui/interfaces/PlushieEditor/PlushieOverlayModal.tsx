// todo, cleanup

import type React from 'react';
import { useMemo, useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  ImageButton,
  Input,
  Modal,
  Section,
  Stack,
} from 'tgui-core/components';
import { createSearch } from 'tgui-core/string';
import type { Data } from './types';

type OverlayModalProps = {
  onClose: () => void;
  toggleOverlay: (icon_state: string) => void;
};

export const PlushieOverlayModal: React.FC<OverlayModalProps> = ({
  onClose,
  toggleOverlay,
}) => {
  const { data } = useBackend<Data>();
  const [filter, setFilter] = useState('');
  const { possible_overlays, overlays, icon } = data;

  const searcher = useMemo(
    () =>
      createSearch(
        filter,
        (ov: { name: string; icon_state: string }) => ov.name,
      ),
    [filter],
  );

  const overlayMap = useOverlayMap(overlays);
  const filteredPossible = possible_overlays.filter(searcher);

  return (
    <Modal onEscape={onClose} minWidth="320px">
      <Section
        title="Overlays"
        buttons={
          <Button icon="times" onClick={onClose} backgroundColor="#d63939ff" />
        }
        scrollable
      >
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
                backgroundColor={
                  overlayMap[icon_state] ? '#21af39ff' : '#d63939ff'
                }
                fluid
                align="start"
              >
                {name}
              </ImageButton>
            ))}
          </Box>
        </Stack>
      </Section>
    </Modal>
  );
};
