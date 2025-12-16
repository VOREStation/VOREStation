import { useBackend } from 'tgui/backend';
import { Box, Button, Section, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import type { InsideData, PreyAbilityData } from '../types';
import { VoreContentsPanel } from './VoreContentsPanel';

export const VoreContentsPreyPanel = (props: {
  inside: InsideData;
  prey_abilities: PreyAbilityData | null;
  show_pictures: BooleanLike;
  icon_overflow: BooleanLike;
}) => {
  const { act } = useBackend();

  const { inside, prey_abilities, show_pictures, icon_overflow } = props;

  return (
    <Section fill>
      <Stack fill>
        {prey_abilities && (
          <Stack.Item>
            <Section title="Abilities">
              <Stack>
                {prey_abilities.absorbed_devour_others && (
                  <Stack.Item>
                    <Button
                      onClick={() =>
                        act('prey_ability', {
                          ability: 'devour_absorbed',
                          belly: inside.ref,
                        })
                      }
                    >
                      Devour nearby
                    </Button>
                  </Stack.Item>
                )}
              </Stack>
            </Section>
          </Stack.Item>
        )}
        <Stack.Item>
          {inside.contents?.length ? (
            <VoreContentsPanel
              contents={inside.contents}
              belly={inside.ref}
              show_pictures={show_pictures}
              icon_overflow={icon_overflow}
            />
          ) : (
            <Box>There is nothing else around you.</Box>
          )}
        </Stack.Item>
      </Stack>
    </Section>
  );
};
