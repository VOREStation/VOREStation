import { filter } from 'common/collections';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { LabeledList, Section } from 'tgui-core/components';
import { decodeHtmlEntities } from 'tgui-core/string';

type Data = {
  aircontents: aircontent[];
};

type aircontent = {
  entry: string;
  units: string;
  val: string;
  bad_high: number;
  poor_high: number;
  poor_low: number;
  bad_low: number;
};

const getItemColor = (
  value: number,
  min2: number,
  min1: number,
  max1: number,
  max2: number,
): string => {
  if (value < min2) {
    return 'bad';
  } else if (value < min1) {
    return 'average';
  } else if (value > max1) {
    return 'average';
  } else if (value > max2) {
    return 'bad';
  }
  return 'good';
};

export const pAIAtmos = (props) => {
  const { data } = useBackend<Data>();

  const { aircontents } = data;

  return (
    <Window width={450} height={600}>
      <Window.Content scrollable>
        <Section>
          <LabeledList>
            {filter(
              aircontents,
              (i: aircontent) =>
                i.val !== '0' ||
                i.entry === 'Pressure' ||
                i.entry === 'Temperature',
            ).map((item: aircontent) => (
              <LabeledList.Item
                key={item.entry}
                label={item.entry}
                color={getItemColor(
                  parseFloat(item.val),
                  item.bad_low,
                  item.poor_low,
                  item.poor_high,
                  item.bad_high,
                )}
              >
                {item.val}
                {decodeHtmlEntities(item.units)}
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
