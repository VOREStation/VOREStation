import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Button, Section } from 'tgui-core/components';
import { toTitleCase } from 'tgui-core/string';

type Data = { detail_color: string; color_list: Record<string, string> };

export const ICDetailer = (props) => {
  const { act, data } = useBackend<Data>();

  const { detail_color, color_list } = data;

  return (
    <Window width={420} height={254}>
      <Window.Content>
        <Section>
          {Object.keys(color_list).map((key, i) => (
            <Button
              key={key}
              ml={0}
              mr={0}
              mb={-0.4}
              mt={0}
              tooltip={toTitleCase(key)}
              tooltipPosition={i % 6 === 5 ? 'left' : 'right'}
              height="64px"
              width="64px"
              onClick={() => act('change_color', { color: key })}
              style={
                color_list[key] === detail_color
                  ? {
                      border: '4px solid black',
                      borderRadius: '0',
                    }
                  : {
                      borderRadius: '0',
                    }
              }
              backgroundColor={color_list[key]}
            />
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
};
