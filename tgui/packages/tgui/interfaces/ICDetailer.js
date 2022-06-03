import { useBackend } from "../backend";
import { Button, Section } from "../components";
import { Window } from "../layouts";
import { toTitleCase } from 'common/string';

export const ICDetailer = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    detail_color,
    color_list,
  } = data;

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
              tooltipPosition={i % 6 === 5 ? "left" : "right"}
              height="64px"
              width="64px"
              onClick={() => act("change_color", { color: key })}
              style={color_list[key] === detail_color ? {
                border: "4px solid black",
                "border-radius": 0,
              } : {
                "border-radius": 0,
              }}
              backgroundColor={color_list[key]} />
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
};
