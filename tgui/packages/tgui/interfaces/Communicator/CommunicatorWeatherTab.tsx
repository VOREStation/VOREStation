import { useBackend } from 'tgui/backend';
import { Box, LabeledList, Section } from 'tgui-core/components';
import { decodeHtmlEntities, toTitleCase } from 'tgui-core/string';

import { AirContent, WeatherTabData } from './types';

export const CommunicatorWeatherTab = (props) => {
  const { act, data } = useBackend<WeatherTabData>();

  const { aircontents, weather } = data;

  const deg: string = '\u00B0';

  return (
    <Section title="Weather">
      <Section title="Current Conditions">
        <LabeledList>
          {aircontents
            .filter(
              (i: AirContent) =>
                i.val !== '0' ||
                i.entry === 'Pressure' ||
                i.entry === 'Temperature',
            )
            .map((item: AirContent) => (
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
      </Section>
      <Section title="Weather Reports">
        {(!!weather.length && (
          <LabeledList>
            {weather.map((wr) => (
              <LabeledList.Item label={wr.Planet} key={wr.Planet}>
                <LabeledList>
                  <LabeledList.Item label="Time">{wr.Time}</LabeledList.Item>
                  <LabeledList.Item label="Weather">
                    {toTitleCase(wr.Weather)}
                  </LabeledList.Item>
                  <LabeledList.Item label="Temperature">
                    Current: {wr.Temperature.toFixed()} {deg}C | High:{' '}
                    {wr.High.toFixed()} {deg}C | Low: {wr.Low.toFixed()} {deg}C
                  </LabeledList.Item>
                  <LabeledList.Item label="Wind Direction">
                    {wr.WindDir}
                  </LabeledList.Item>
                  <LabeledList.Item label="Wind Speed">
                    {wr.WindSpeed}
                  </LabeledList.Item>
                  <LabeledList.Item label="Forecast">
                    {decodeHtmlEntities(wr.Forecast)}
                  </LabeledList.Item>
                </LabeledList>
              </LabeledList.Item>
            ))}
          </LabeledList>
        )) || (
          <Box color="bad">
            No weather reports available. Please check back later.
          </Box>
        )}
      </Section>
    </Section>
  );
};

/* Weather App */
const getItemColor = (
  value: number,
  min2: number,
  min1: number,
  max1: number,
  max2: number,
) => {
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
