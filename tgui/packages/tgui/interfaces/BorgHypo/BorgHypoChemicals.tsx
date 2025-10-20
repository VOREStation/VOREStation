import { useBackend } from 'tgui/backend';
import { Button, Section, Stack } from 'tgui-core/components';
import { BorgHypoSearch } from './BorgHypoSearch';
import type { Data } from './types';

export const BorgHypoChemicals = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    chemicals = [],
    isDispensingRecipe,
    selectedReagentId,
    uiChemicalsName,
  } = data;
  const flexFillers: boolean[] = [];

  for (let i = 0; i < (chemicals.length + 1) % 3; i++) {
    flexFillers.push(true);
  }
  return (
    <Section
      title={uiChemicalsName}
      fill
      scrollable
      buttons={<BorgHypoSearch />}
    >
      <Stack direction="row" wrap="wrap" align="flex-start" g={0.3}>
        {chemicals.length
          ? chemicals.map((chemical, i) => (
              <Stack.Item key={i} basis="40%" grow height="20px">
                <Button
                  icon="arrow-circle-down"
                  selected={
                    !isDispensingRecipe && selectedReagentId === chemical.id
                  }
                  fluid
                  ellipsis
                  align="flex-start"
                  onClick={() => {
                    if (selectedReagentId !== chemical.id) {
                      act('select_reagent', {
                        selectedReagentId: chemical.id,
                      });
                    }
                  }}
                >
                  {`${chemical.name} (${chemical.volume})`}
                </Button>
              </Stack.Item>
            ))
          : 'No Chemicals.'}
        {flexFillers.map((_, i) => (
          <Stack.Item key={i} grow basis="25%" height="20px" />
        ))}
      </Stack>
    </Section>
  );
};
