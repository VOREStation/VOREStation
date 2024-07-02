import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import { Button, LabeledList, Section } from '../components';
import { Window } from '../layouts';

type Data = {
  breaker: BooleanLike;
  charge_count: number;
  charging_state: number;
  on: BooleanLike;
  operational: BooleanLike;
};

export const GravityGenerator = (props) => {
  const { act, data } = useBackend<Data>();

  const { breaker, charge_count } = data;

  let genstatus = 'Offline';
  if (breaker && charge_count < 100) {
    genstatus = 'CHARGING';
  } else if (breaker && charge_count >= 100) {
    genstatus = 'Running';
  } else if (!breaker && charge_count > 0) {
    genstatus = 'DISCHARGING';
  }

  return (
    <Window width={500} height={400}>
      <Window.Content>
        <Section
          title="Status"
          buttons={
            <Button.Confirm
              icon="exclamation-triangle"
              confirmIcon="exclamation-triangle"
              color="red"
              confirmContent={
                breaker
                  ? 'This will disable gravity!'
                  : 'This will enable gravity!'
              }
              onClick={() => act('gentoggle')}
            >
              Toggle Breaker
            </Button.Confirm>
          }
        >
          <LabeledList>
            <LabeledList.Item label="Breaker Setting">
              {breaker ? 'Generator Enabled' : 'Generator Disabled'}
            </LabeledList.Item>
            <LabeledList.Item label="Charge Mode">
              Generator {genstatus}
            </LabeledList.Item>
            <LabeledList.Item label="Charge Status">
              {charge_count}%
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
