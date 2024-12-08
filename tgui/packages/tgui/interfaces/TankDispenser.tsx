import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

type Data = {
  phoron: number;
  oxygen: number;
};

export const TankDispenser = (props) => {
  const { act, data } = useBackend<Data>();
  const { phoron, oxygen } = data;
  return (
    <Window width={275} height={103}>
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item
              label="Phoron"
              buttons={
                <Button
                  icon={phoron ? 'square' : 'square-o'}
                  disabled={!phoron}
                  onClick={() => act('phoron')}
                >
                  Dispense
                </Button>
              }
            >
              {phoron}
            </LabeledList.Item>
            <LabeledList.Item
              label="Oxygen"
              buttons={
                <Button
                  icon={oxygen ? 'square' : 'square-o'}
                  disabled={!oxygen}
                  onClick={() => act('oxygen')}
                >
                  Dispense
                </Button>
              }
            >
              {oxygen}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
