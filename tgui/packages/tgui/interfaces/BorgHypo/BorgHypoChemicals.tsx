import { useEffect, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Button, Icon, Section, Stack, Tooltip } from 'tgui-core/components';

import type { Data } from './types';

export const BorgHypoChemicals = (props) => {
  const { act, data } = useBackend<Data>();
  const { chemicals } = data;
  const flexFillers: boolean[] = [];

  const chemicalData = Object.keys(chemicals).sort();

  for (let i = 0; i < (chemicals.length + 1) % 3; i++) {
    flexFillers.push(true);
  }
  return (
    <Section title="Dispenser" fill scrollable buttons={<RecordingBlinker />}>
      <Stack direction="row" wrap="wrap" align="flex-start" g={0.3}>
        {chemicalData.length
          ? chemicalData.map((chemName) => (
              <Stack.Item key={chemName} basis="40%" grow height="20px">
                <Button
                  icon="arrow-circle-down"
                  fluid
                  ellipsis
                  align="flex-start"
                  onClick={() =>
                    act('select_reagent', {
                      selectedReagent: chemName,
                    })
                  }
                >
                  {`${chemName} (${chemicals[chemName]})`}
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

const RecordingBlinker = (props) => {
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
