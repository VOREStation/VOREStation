import { type ReactNode, useEffect, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Button, Icon, Section, Stack, Tooltip } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import type { Data, Reagent } from './types';

export const ChemDispenserChemicals = (props: {
  sectionTitle: string;
  chemicals: Reagent[];
  /** Called when the user clicks on a reagent dispense button. Arg is the ID of the button's reagent. */
  dispenseAct: (reagentId: string) => void;
  /** Optional callback that returns whether or not a reagent dispense button will appear "activated". Arg is the ID of the button's reagent. */
  chemicalButtonSelect?: (reagentId: string) => BooleanLike;
  /** Extra UI elements that will appear within the header of the chemical UI. */
  buttons: ReactNode;
}) => {
  const {
    chemicals,
    sectionTitle,
    dispenseAct,
    chemicalButtonSelect,
    buttons,
  } = props;
  const flexFillers: boolean[] = [];
  const sortedChemicals: Reagent[] = chemicals;
  sortedChemicals.sort((a, b) => a.name.localeCompare(b.name));
  return (
    <Section title={sectionTitle} fill scrollable buttons={buttons}>
      <Stack direction="row" wrap="wrap" align="flex-start" g={0.3}>
        {sortedChemicals.map((c, i) => (
          <Stack.Item key={i} basis="49%" grow maxWidth="50%">
            <Button
              fluid
              align="flex-start"
              tooltip={c.name.length > 15 ? c.name : undefined}
              selected={
                chemicalButtonSelect ? chemicalButtonSelect(c.id) : false
              }
              onClick={() => dispenseAct(c.id)}
            >
              <Stack>
                <Stack.Item>
                  <Icon name="arrow-circle-down" />
                </Stack.Item>
                <Stack.Item grow overflow="hidden">
                  {c.name}
                </Stack.Item>
                <Stack.Item>{`(${c.volume})`}</Stack.Item>
              </Stack>
            </Button>
          </Stack.Item>
        ))}
      </Stack>
    </Section>
  );
};

export const RecordingBlinker = (props) => {
  const { data } = useBackend<Data>();
  const recording = !!data.recordingRecipe;

  const [blink, setBlink] = useState(false);

  useEffect(() => {
    if (recording) {
      const intervalId = setInterval(() => {
        setBlink((v) => !v);
      }, 1000);
      return () => clearInterval(intervalId);
    }
  }, [recording]);

  if (!recording) {
    return null;
  }

  return (
    <Tooltip content="Recording in progress">
      <Icon mt={0.7} color="bad" name={blink ? 'circle-o' : 'circle'} />
    </Tooltip>
  );
};
