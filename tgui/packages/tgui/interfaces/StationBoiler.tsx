import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import {
  Button,
  LabeledList,
  ProgressBar,
  Section,
} from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';
import { capitalize } from 'tgui-core/string';

type Data = {
  materials: MaterialStack[];
  stored: number;
  max: number;
  percent: number;
  timeleft: string;
};

type MaterialStack = {
  name: string;
  display: string;
  qty: string;
  can_eject: BooleanLike;
};

export const StationBoiler = (props) => {
  const { act, data } = useBackend<Data>();
  const { materials, timeleft, stored, max } = data;
  return (
    <Window width={320} height={440}>
      <Window.Content>
        <Section
          title="Station Boiler"
          buttons={<Button onClick={() => act('ignite')}>Ignite</Button>}
          fill
          scrollable
        >
          <LabeledList>
            <LabeledList.Item label="Time Left">
              <ProgressBar value={stored} maxValue={max}>
                {timeleft}
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Divider size={1} />
            {materials.map((material) => (
              <LabeledList.Item
                key={material.name}
                label={capitalize(material.display)}
                buttons={
                  <Button
                    ml={1}
                    disabled={!material.can_eject}
                    onClick={() =>
                      act('ejectMaterial', {
                        mat: material.name,
                      })
                    }
                  >
                    Eject
                  </Button>
                }
              >
                {material.qty}
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
