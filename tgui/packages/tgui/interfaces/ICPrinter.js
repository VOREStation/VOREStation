import { useBackend, useSharedState } from "../backend";
import { Box, Button, LabeledList, ProgressBar, Section, Tabs, Stack } from "../components";
import { Window } from "../layouts";
import { sortBy, filter } from 'common/collections';

export const ICPrinter = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    metal,
    max_metal,
    metal_per_sheet,
    debug,
    upgraded,
    can_clone,
    assembly_to_clone,
    categories,
  } = data;

  return (
    <Window width={600} height={630}>
      <Window.Content scrollable>
        <Section title="Status">
          <LabeledList>
            <LabeledList.Item label="Metal">
              <ProgressBar
                value={metal}
                maxValue={max_metal}>
                {metal / metal_per_sheet} / {max_metal / metal_per_sheet} sheets
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="Circuits Available">
              {upgraded ? "Advanced" : "Regular"}
            </LabeledList.Item>
            <LabeledList.Item label="Assembly Cloning">
              {can_clone ? "Available" : "Unavailable"}
            </LabeledList.Item>
          </LabeledList>
          <Box mt={1}>
            Note: A red component name means that the printer must be upgraded to create that component.
          </Box>
        </Section>
        <ICPrinterCategories />
      </Window.Content>
    </Window>
  );
};

const canBuild = (item, data) => {
  if (!item.can_build) {
    return false;
  }

  if (item.cost > data.metal) {
    return false;
  }

  return true;
};

const ICPrinterCategories = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    categories,
    debug,
  } = data;

  const [categoryTarget, setcategoryTarget] = useSharedState(context, "categoryTarget", null);

  const selectedCategory = filter(cat => cat.name === categoryTarget)(categories)[0];

  return (
    <Section title="Circuits">
      <Stack fill>
        <Stack.Item mr={2}>
          <Tabs vertical>
            {sortBy(cat => cat.name)(categories).map(cat => (
              <Tabs.Tab
                selected={categoryTarget === cat.name}
                onClick={() => setcategoryTarget(cat.name)}
                key={cat.name}>
                {cat.name}
              </Tabs.Tab>
            ))}
          </Tabs>
        </Stack.Item>
        <Stack.Item>
          {selectedCategory && (
            <Section>
              <LabeledList>
                {sortBy(item => item.name)(selectedCategory.items).map(item => (
                  <LabeledList.Item
                    key={item.name}
                    label={item.name}
                    labelColor={item.can_build ? "good" : "bad"}
                    buttons={
                      <Button
                        disabled={!canBuild(item, data)}
                        icon="print"
                        onClick={() => act("build", { build: item.path })}>
                        Print
                      </Button>
                    }>
                    {item.desc}
                  </LabeledList.Item>
                ))}
              </LabeledList>
            </Section>
          ) || "No category selected."}
        </Stack.Item>
      </Stack>
    </Section>
  );
};
