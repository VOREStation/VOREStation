import { useBackend } from "../backend";
import { Button, LabeledList, Section } from "../components";
import { Window } from "../layouts";

export const InventoryPanelHuman = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    slots,
    specialSlots,
    internals,
    internalsValid,
    sensors,
    handcuffed,
    handcuffedParams,
    legcuffed,
    legcuffedParams,
    accessory,
  } = data;

  return (
    <Window width={400} height={600} resizable>
      <Window.Content scrollable>
        <Section>
          <LabeledList>
            {slots && slots.length && slots.map(slot => (
              <LabeledList.Item key={slot.name} label={slot.name}>
                <Button
                  mb={-1}
                  icon={slot.item ? "hand-paper" : "gift"}
                  onClick={() => act(slot.act, slot.params)}>
                  {slot.item || "Nothing"}
                </Button>
              </LabeledList.Item>
            ))}
            <LabeledList.Divider />
            {specialSlots && specialSlots.length && specialSlots.map(slot => (
              <LabeledList.Item key={slot.name} label={slot.name}>
                <Button
                  mb={-1}
                  icon={slot.item ? "hand-paper" : "gift"}
                  onClick={() => act(slot.act, slot.params)}>
                  {slot.item || "Nothing"}
                </Button>
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Section>
        <Section title="Actions">
          <Button
            fluid
            icon="running"
            onClick={() => act("targetSlot", { slot: "splints" })}>
            Remove Splints
          </Button>
          <Button
            fluid
            icon="hand-paper"
            onClick={() => act("targetSlot", { slot: "pockets" })}>
            Empty Pockets
          </Button>
          {internalsValid && (
            <Button
              fluid
              icon="lungs"
              onClick={() => act("targetSlot", { slot: "internals" })}>
              Set Internals
            </Button>
          ) || null}
          {sensors && (
            <Button
              fluid
              icon="book-medical"
              onClick={() => act("targetSlot", { slot: "sensors" })}>
              Set Sensors
            </Button>
          ) || null}
          {handcuffed && (
            <Button
              fluid
              color="bad"
              icon="unlink"
              onClick={() => act("targetSlot", handcuffedParams)}>
              Handcuffed
            </Button>
          ) || null}
          {legcuffed && (
            <Button
              fluid
              color="bad"
              icon="unlink"
              onClick={() => act("targetSlot", legcuffedParams)}>
              Legcuffed
            </Button>
          ) || null}
          {accessory && (
            <Button
              fluid
              color="bad"
              icon="unlink"
              onClick={() => act("targetSlot", { slot: "tie" })}>
              Remove Accessory
            </Button>
          ) || null}
        </Section>
      </Window.Content>
    </Window>
  );
};
