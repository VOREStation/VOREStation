import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Button, Input, Section, Stack } from 'tgui-core/components';
import { SelectorElement } from '../RobotChoose/SelectorElement';
import { paiSpriteSearcher } from './functions';
import type { Data } from './types';

export const SpriteSection = (props) => {
  const { data } = useBackend<Data>();
  const { pai_chassises, pai_chassis, selected_chassis } = data;

  const [searchText, setSearchText] = useState<string>('');
  const [includeDefault, setIncludeDefault] = useState<boolean>(false);
  const [includeBig, setIncludeBig] = useState<boolean>(false);

  const filtered = paiSpriteSearcher(
    searchText,
    includeDefault,
    includeBig,
    pai_chassises,
  );
  return (
    <Section
      title="Sprites"
      fill
      buttons={
        <Stack g={0.2}>
          <Stack.Item>
            <Button.Checkbox
              checked={includeDefault}
              onClick={() => setIncludeDefault(!includeDefault)}
            >
              Def
            </Button.Checkbox>
          </Stack.Item>
          <Stack.Item>
            <Button.Checkbox
              checked={includeBig}
              onClick={() => setIncludeBig(!includeBig)}
            >
              Big
            </Button.Checkbox>
          </Stack.Item>
        </Stack>
      }
    >
      <Stack vertical fill>
        <Stack.Item>
          <Input
            fluid
            value={searchText}
            placeholder="Search for sprites..."
            onChange={(value: string) => setSearchText(value)}
          />
        </Stack.Item>
        <Stack.Divider />
        <Stack.Item grow>
          <Section fill scrollable>
            <Stack vertical fill>
              {!!filtered &&
                filtered.map((filter) => (
                  <SelectorElement
                    key={filter.sprite}
                    option={filter.sprite}
                    action="pick_icon"
                    selected={selected_chassis ?? pai_chassis}
                    belly={filter.belly}
                  />
                ))}
            </Stack>
          </Section>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
