import { filter } from 'common/collections';
import { decodeHtmlEntities } from 'common/string';
import { useBackend } from 'tgui/backend';
import { Box, LabeledList } from 'tgui/components';

type Data = {
  aircontents: aircontent[];
};

type aircontent = {
  val: string;
  units: string;
  entry: string;
  bad_low: number;
  poor_low: number;
  poor_high: number;
  bad_high: number;
};

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

export const pda_atmos_scan = (props) => {
  const { act, data } = useBackend<Data>();

  const { aircontents } = data;

  return (
    <Box>
      <LabeledList>
        {filter(
          aircontents,
          (i: aircontent) =>
            i.val !== '0' ||
            i.entry === 'Pressure' ||
            i.entry === 'Temperature',
        ).map((item) => (
          <LabeledList.Item
            key={item.entry}
            label={item.entry}
            color={getItemColor(
              item.val,
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
    </Box>
  );
};
