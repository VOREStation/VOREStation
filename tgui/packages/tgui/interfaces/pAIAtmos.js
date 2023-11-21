import { filter } from 'common/collections';
import { decodeHtmlEntities } from 'common/string';
import { useBackend } from '../backend';
import { LabeledList, Section } from '../components';
import { Window } from '../layouts';

const getItemColor = (value, min2, min1, max1, max2) => {
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

export const pAIAtmos = (props, context) => {
  const { act, data } = useBackend(context);

  const { aircontents } = data;

  return (
    <Window width={450} height={600} resizable>
      <Window.Content scrollable>
        <Section>
          <LabeledList>
            {filter(
              (i) =>
                i.val !== '0' ||
                i.entry === 'Pressure' ||
                i.entry === 'Temperature'
            )(aircontents).map((item) => (
              <LabeledList.Item
                key={item.entry}
                label={item.entry}
                color={getItemColor(
                  item.val,
                  item.bad_low,
                  item.poor_low,
                  item.poor_high,
                  item.bad_high
                )}>
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
