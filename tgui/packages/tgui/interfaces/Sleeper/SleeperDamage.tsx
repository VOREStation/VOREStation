import { toFixed } from 'common/math';

import { useBackend } from '../../backend';
import { LabeledList, ProgressBar, Section } from '../../components';
import { damageRange, damages } from './constants';
import { Data } from './types';

export const SleeperDamage = (props) => {
  const { data } = useBackend<Data>();
  const { occupant } = data;
  return (
    <Section title="Damage">
      <LabeledList>
        {damages.map((d, i) => (
          <LabeledList.Item key={i} label={d[0]}>
            <ProgressBar
              key={i}
              minValue={0}
              maxValue={1}
              value={occupant[d[1]] / 100}
              ranges={damageRange}
            >
              {toFixed(occupant[d[1]])}
            </ProgressBar>
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
  );
};
