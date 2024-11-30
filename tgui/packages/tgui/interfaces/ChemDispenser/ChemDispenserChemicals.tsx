import { useEffect, useState } from 'react';

import { useBackend } from '../../backend';
import { Button, Flex, Icon, Section, Tooltip } from '../../components';
import { Data } from './types';

export const ChemDispenserChemicals = (props) => {
  const { act, data } = useBackend<Data>();
  const { chemicals = [] } = data;
  const flexFillers: boolean[] = [];
  for (let i = 0; i < (chemicals.length + 1) % 3; i++) {
    flexFillers.push(true);
  }
  return (
    <Section
      title={data.glass ? 'Drink Dispenser' : 'Chemical Dispenser'}
      fill
      scrollable
      buttons={<RecordingBlinker />}
    >
      <Flex direction="row" wrap="wrap" height="100%" align="flex-start">
        {chemicals.map((c, i) => (
          <Flex.Item key={i} grow="1" m={0.2} basis="40%" height="20px">
            <Button
              icon="arrow-circle-down"
              width="100%"
              height="100%"
              align="flex-start"
              onClick={() =>
                act('dispense', {
                  reagent: c.id,
                })
              }
            >
              {c.name + ' (' + c.volume + ')'}
            </Button>
          </Flex.Item>
        ))}
        {flexFillers.map((_, i) => (
          <Flex.Item key={i} grow="1" basis="25%" height="20px" />
        ))}
      </Flex>
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
