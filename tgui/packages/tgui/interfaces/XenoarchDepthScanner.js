import { useBackend } from "../backend";
import { Box, Button, LabeledList, Section } from "../components";
import { Window } from "../layouts";

export const XenoarchDepthScanner = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    current,
    positive_locations,
  } = data;

  return (
    <Window width={300} height={500} resizable>
      <Window.Content scrollable>
        {Object.keys(current).length && (
          <Section title="Selected" buttons={
            <Button.Confirm
              color="bad"
              icon="trash"
              confirmIcon="trash"
              content="Delete Entry"
              onClick={() => act("clear", { index: current.index })} />
          }>
            <LabeledList>
              <LabeledList.Item label="Time">
                {current.time}
              </LabeledList.Item>
              <LabeledList.Item label="Coords">
                {current.coords}
              </LabeledList.Item>
              <LabeledList.Item label="Anomaly Depth">
                {current.depth} cm
              </LabeledList.Item>
              <LabeledList.Item label="Anomaly Size">
                {current.clearance} cm
              </LabeledList.Item>
              <LabeledList.Item label="Dissonance Spread">
                {current.dissonance_spread}
              </LabeledList.Item>
              <LabeledList.Item label="Anomaly Material">
                {current.material}
              </LabeledList.Item>
            </LabeledList>
          </Section>
        ) || null}
        <Section title="Entries" buttons={
          <Button.Confirm
            color="red"
            icon="trash"
            confirmIcon="trash"
            content="Delete All"
            onClick={() => act("clear")} />
        }>
          {positive_locations.length && positive_locations.map(loc => (
            <Button
              key={loc.index}
              icon="eye"
              onClick={() => act("select", { select: loc.index })}>
              {loc.time}, {loc.coords}
            </Button>
          )) || (
            <Box color="bad">No traces found.</Box>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
