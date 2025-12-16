import { useBackend } from 'tgui/backend';
import { Button, Section, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { preyAbilityToData } from '../constants';
import type { InsideData, PreyAbilityData } from '../types';
import { VoreContentsPanel } from './VoreContentsPanel';

export const VoreContentsPreyPanel = (props: {
  inside: InsideData;
  prey_abilities: PreyAbilityData[] | null;
  show_pictures: BooleanLike;
  icon_overflow: BooleanLike;
}) => {
  const { act } = useBackend();

  const { inside, prey_abilities, show_pictures, icon_overflow } = props;

  return (
    <Section fill>
      <Stack vertical fill>
        {!!prey_abilities?.length && (
          <Stack.Item>
            <Section title="Abilities">
              <Stack>
                {prey_abilities.map((ability) => (
                  <Stack.Item key={ability.name}>
                    <Button
                      disabled={!ability.available}
                      color={preyAbilityToData[ability.name].color}
                      tooltip={preyAbilityToData[ability.name].desc}
                      onClick={() =>
                        act('prey_ability', {
                          ability: ability.name,
                          belly: inside.ref,
                        })
                      }
                    >
                      {preyAbilityToData[ability.name].displayName}
                    </Button>
                  </Stack.Item>
                ))}
              </Stack>
            </Section>
          </Stack.Item>
        )}
        <Stack.Item grow>
          <VoreContentsPanel
            contents={inside.contents}
            belly={inside.ref}
            show_pictures={show_pictures}
            icon_overflow={icon_overflow}
          />
        </Stack.Item>
      </Stack>
    </Section>
  );
};
