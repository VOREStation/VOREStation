import { LabeledList, Section } from 'tgui-core/components';
import type { Explosion } from './types';

export const DopplerExplosions = (props: { explosions: Explosion[] }) => {
  const { explosions } = props;

  return explosions.map((exp) => (
    <Section key={exp.index} title={exp.time}>
      <LabeledList>
        <LabeledList.Item label="Coordinates">
          {exp.x}.{exp.y}.{exp.z}
        </LabeledList.Item>
        <LabeledList.Item label="Inner Radius">
          {exp.devastation_range}
        </LabeledList.Item>
        <LabeledList.Item label="Outer Radius">
          {exp.heavy_impact_range}
        </LabeledList.Item>
        <LabeledList.Item label="Shockwave Radius">
          {exp.light_impact_range}
        </LabeledList.Item>
        <LabeledList.Item label="Tachyon Displacement">
          {exp.seconds_taken}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  ));
};
