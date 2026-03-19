import { Box, Section, Stack, VirtualList } from 'tgui-core/components';

import { useRemappedBackend } from '../helpers';
import { TechNode } from '../nodes/TechNode';
import type { TechwebNode } from '../types';

export function TechwebDesignDisk(props) {
  const { data } = useRemappedBackend();
  const { design_cache, d_disk } = data;
  if (!d_disk) return;

  const { blueprints } = d_disk;

  return (
    <Section fill scrollable>
      {blueprints.map((x, i) => (
        <Section key={i} title={`Slot ${i + 1}`}>
          {(x === null && 'Empty') || (
            <Stack vertical>
              <Stack.Item>
                {`Contains the design for `}
                <Box bold inline>
                  {design_cache[x].name}
                </Box>
                :
              </Stack.Item>
              <Stack.Item width="32px" height="32px">
                <Box
                  className={`${design_cache[x].class}`}
                  style={{
                    transform: `${design_cache[x].transform}`,
                    transformOrigin: 'top left',
                    margin: `${design_cache[x].offsetY}px ${design_cache[x].offsetX}px`,
                  }}
                />
              </Stack.Item>
            </Stack>
          )}
        </Section>
      ))}
    </Section>
  );
}

export function TechwebTechDisk(props) {
  const { data } = useRemappedBackend();
  const { t_disk } = data;
  if (!t_disk) return;

  const { stored_research } = t_disk;

  return (
    <Section scrollable fill>
      <VirtualList>
        {Object.keys(stored_research)
          .map((x) => ({ id: x }))
          .map((n) => (
            <TechNode key={n.id} nocontrols node={n as TechwebNode} />
          ))}
      </VirtualList>
    </Section>
  );
}
