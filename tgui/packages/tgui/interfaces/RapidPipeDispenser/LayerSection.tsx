import { classes } from 'common/react';

import { useBackend } from '../../backend';
import { Box, Button, Section, Stack } from '../../components';
import { Data } from './types';

export const LayerSection = (props) => {
  const { act, data } = useBackend<Data>();
  const { category: rootCategoryIndex, piping_layer, pipe_layers } = data;
  const previews = data.preview_rows.flatMap((row) => row.previews);
  return (
    <Section fill width={7.5}>
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
      <Box width="120px">
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
      </Box>
    </Section>
  );
};
