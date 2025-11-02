import {
  Button,
  LabeledList,
  Section,
  Slider,
  Stack,
} from 'tgui-core/components';

export const ChemDispenserSettings = (props: {
  /** The dispense amount the user has currently selected. */
  selectedAmount: number;
  /** Available amounts for this dispenser to use. */
  availableAmounts: number[];
  /** The minimum allowed selectable amount. Used for the slider UI element. */
  minAmount: number;
  /** The maximum allowed selectable amount. Used for the slider UI element. */
  maxAmount: number;
  /** Called when the user tries to change the dispensed amount. Arg is the amount the user is trying to set it to. */
  amountAct: (amount: number) => void;
}) => {
  const { selectedAmount, availableAmounts, minAmount, maxAmount, amountAct } =
    props;
  return (
    <Section
      title="Settings"
      fill
    >
      <LabeledList>
        <LabeledList.Item label="Dispense" verticalAlign="middle">
          <Stack g={0.1}>
            {availableAmounts.map((a, i) => (
              <Stack.Item key={i}>
                <Button
                  textAlign="center"
                  selected={selectedAmount === a}
                  m="0"
                  onClick={() => amountAct(a)}
                >
                  {`${a}u`}
                </Button>
              </Stack.Item>
            ))}
          </Stack>
        </LabeledList.Item>
        <LabeledList.Item label="Custom Amount">
          <Slider
            step={1}
            stepPixelSize={5}
            value={selectedAmount}
            minValue={minAmount}
            maxValue={maxAmount}
            onChange={(e, value) => amountAct(value)}
          />
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
