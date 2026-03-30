import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, LabeledList, NoticeBox, Section } from 'tgui-core/components';

type Data = {
  explosions: Explosion[];
};

type Explosion = {
  index: number;
  time: string;
  x: number;
  y: number;
  z: number;
  devastation_range: number;
  heavy_impact_range: number;
  light_impact_range: number;
  seconds_taken: number;
};

export const DopplerArray = (props) => {
  const { act, data } = useBackend<Data>();

  const { explosions } = data;

  return (
    <Window width={300} height={500}>
      <Window.Content scrollable>
        {explosions ? (
          explosions.map((exp) => (
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
          ))
        ) : (
          <NoticeBox>
            <Box inline verticalAlign="middle">
              No recorded explosions.
            </Box>
          </NoticeBox>
        )}
      </Window.Content>
    </Window>
  );
};
