import { useBackend } from 'tgui/backend';
import { Box, Button, Section, Stack } from 'tgui-core/components';
import { classes } from 'tgui-core/react';

import type { Data } from './types';

export const LayerSection = (props) => {
  const { act, data } = useBackend<Data>();
  const { category: rootCategoryIndex, piping_layer, pipe_layers } = data;
  const previews = data.preview_rows.flatMap((row) => row.previews);
  return (
    <Section fill width="100px">
      {rootCategoryIndex === 0 && (
        <Stack vertical mb={1}>
          {Object.keys(pipe_layers).map((layer) => (
            <Stack.Item my={0} key={layer}>
              <Button.Checkbox
                checked={pipe_layers[layer] === piping_layer}
                onClick={() =>
                  act('piping_layer', {
                    piping_layer: pipe_layers[layer],
                  })
                }
              >
                {layer}
              </Button.Checkbox>
            </Stack.Item>
          ))}
        </Stack>
      )}
      <Stack wrap mt="30px">
        {previews.map((preview) => (
          <Button
            ml={0}
            key={preview.dir}
            tooltip={preview.dir_name}
            selected={preview.selected}
            style={{
              width: '40px',
              height: '40px',
              padding: '0',
            }}
            onClick={() =>
              act('setdir', {
                dir: preview.dir,
                flipped: preview.flipped,
              })
            }
          >
            <Box
              className={classes([
                'pipes32x32',
                preview.dir + '-' + preview.icon_state,
              ])}
              style={{
                transform: 'scale(1.5) translate(9.5%, 9.5%)',
              }}
            />
          </Button>
        ))}
      </Stack>
    </Section>
  );
};
