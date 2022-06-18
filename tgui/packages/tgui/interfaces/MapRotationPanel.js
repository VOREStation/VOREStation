import { useBackend } from "../backend";
import { Button, LabeledList, Section } from "../components";
import { Window } from "../layouts";

export const MapRotationPanel = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    current_map_name,
    next_map_name,
    allow_map_rotation,
    custom_rotation_handling,
    rotation_due,
    rotation_overridden,
    map_rotation_mode,
    rotation_schedule_mode,
    rotate_after_round,
    rotate_after_day,
  } = data;

  return (
    <Window width={450} height={600} resizable>
      <Window.Content scrollable>
        <Section title="== Map Rotation Status ==">
          Currently on map: {current_map_name}
          Map currently in rotation: {next_map_name}

          Allow map rotation: {allow_map_rotation}
          Custom rotation handling: {custom_rotation_handling}

          Rotation due: {rotation_due}
          Rotation overridden: {rotation_overridden}

          Rotation mode: {map_rotation_mode}

          {rotation_schedule_mode ? "Rotation schedule mode: Rotate every" + { rotate_after_round } + " rounds." : "Rotation schedule mode: Rotate every" + { rotate_after_day } + "."}
        </Section>
        <Section title="== Map Rotation Control ==">
          <LabeledList>
            <LabeledList.Item label="Toggle Rotation Due">
              <Button
                fluid
                icon="user-astronaut"
                selected={rotation_due}
                onClick={() => act("toggle_rotation_due")}>
                {rotation_due ? "Yes" : "No"}
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Override Map Rotation">
              <Button
                mt={-1}
                fluid
                icon="eye"
                selected={rotation_overridden}
                onClick={() => act("toggle_rotation_override")}>
                {rotation_overridden ? "Yes" : "No"}
              </Button>
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
