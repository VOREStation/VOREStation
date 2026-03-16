import type React from 'react';
import type { Dispatch, SetStateAction } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  ColorBox,
  Image,
  Input,
  LabeledList,
  Section,
  Stack,
} from 'tgui-core/components';
import type { Data } from '../types';

type PreviewPanelProps = {
  setSelectedOverlay: Dispatch<SetStateAction<string | null>>;
};
export const PreviewPanel: React.FC<PreviewPanelProps> = ({
  setSelectedOverlay,
}) => {
  const { act, data } = useBackend<Data>();
  const { base_color, preview, name } = data;

  return (
    <Section
      fill
      title="Preview"
      buttons={
        <Button.Confirm
          icon="trash"
          color="red"
          tooltip="Reset the edits"
          onClick={() => {
            setSelectedOverlay(null);
            act('clear');
          }}
        >
          Clear
        </Button.Confirm>
      }
    >
      <Stack vertical fill>
        <Stack.Item>
          <Box
            p={2}
            align="center"
            width="100%"
            height="320px"
            style={{
              borderRadius: 16,
              border: '1px solid rgba(255,255,255,0.1)',
            }}
          >
            <Box m="auto" minWidth="256px" minHeight="256px">
              <Image
                src={`data:image/jpeg;base64,${preview}`}
                style={{ width: '256px', height: '256px' }}
              />
            </Box>
          </Box>
        </Stack.Item>
        <Stack.Divider />
        <Stack.Item>
          <LabeledList>
            <LabeledList.Item label="Name">
              <Input
                fluid
                value={name}
                onChange={(value) => act('rename', { name: value })}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Base color">
              <Stack align="center" justify="space-between">
                <ColorBox color={base_color} mr={2} />
                <Button icon="brush" onClick={() => act('change_base_color')}>
                  Recolor
                </Button>
              </Stack>
            </LabeledList.Item>
          </LabeledList>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
