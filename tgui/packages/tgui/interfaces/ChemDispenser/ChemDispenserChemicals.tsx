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
  for (let i = 0; i < (chemicals.length + 1) % 3; i++) {
    flexFillers.push(true);
  }
  return (
    <Section
      //title={data.glass ? 'Drink Dispenser' : 'Chemical Dispenser'}
      title={sectionTitle}
      fill
      scrollable
      //buttons={<RecordingBlinker />}
      buttons={buttons}
    >
      <Stack direction="row" wrap="wrap" align="flex-start" g={0.3}>
        {chemicals.map((c, i) => (
          <Stack.Item key={i} basis="40%" grow height="20px">
            <Button
              icon="arrow-circle-down"
              fluid
              ellipsis
              align="flex-start"
              selected={
                chemicalButtonSelect ? chemicalButtonSelect(c.id) : false
              }
              // onClick={() => act('dispense', { reagent: c.id, }) }
              onClick={() => dispenseAct(c.id)}
            >
              {`${c.name} (${c.volume})`}
            </Button>
          </Stack.Item>
        ))}
        {flexFillers.map((_, i) => (
          <Stack.Item key={i} grow basis="25%" height="20px" />
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
