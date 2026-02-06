import dateformat from 'dateformat';
import yaml from 'js-yaml';
import { useEffect, useMemo, useState } from 'react';
import { resolveAsset } from 'tgui/assets';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Stack } from 'tgui-core/components';
import { fetchRetry } from 'tgui-core/http';
import { Changes } from './Changes';
import { DateDropdown } from './DateDropdown';
import { Footer } from './Resources/Footer';
import { Header } from './Resources/Header';
import { Testmerges } from './Testmerges';
import type { ChangelogData, ChangelogEntry } from './types';

export const Changelog = (props) => {
  const {
    act,
    data: { dates, testmerges },
  } = useBackend<ChangelogData>();
  const [selectedDate, setSelectedDate] = useState('');
  const [selectedIndex, setSelectedIndex] = useState(0);
  const [data, setData] = useState<string | ChangelogEntry>(
    'Loading changelog data...',
  );

  const sortedDates = useMemo(() => dates.toSorted().toReversed(), [dates]);
  const dateChoices: string[] = useMemo(
    () => sortedDates.map((date) => dateformat(date, 'mmmm yyyy', true)),
    [sortedDates],
  );

  function getData(date: string, attemptNumber = 1) {
    const maxAttempts = 6;

    if (attemptNumber > maxAttempts) {
      return setData(`Failed to load data after ${maxAttempts} attempts`);
    }

    act('get_month', { date });

    fetchRetry(resolveAsset(`${date}.yml`)).then(async (changelogData) => {
      const result = await changelogData.text();
      const errorRegex = /^Cannot find/;

      if (errorRegex.test(result)) {
        const timeout = 50 + attemptNumber * 50;

        setData(`Loading changelog data${'.'.repeat(attemptNumber + 3)}`);
        setTimeout(() => {
          getData(date, attemptNumber + 1);
        }, timeout);
      } else {
        const parsed = yaml.load(result, { schema: yaml.CORE_SCHEMA });
        if (parsed === null || parsed === undefined) {
          setData('Changelog is empty or invalid');
        } else if (typeof parsed === 'string' || typeof parsed === 'object') {
          setData(parsed);
        } else {
          setData('Unexpected changelog format');
        }
      }
    });
  }

  useEffect(() => {
    setSelectedDate(dateChoices[0]);
    getData(sortedDates[0]);
  }, []);

  return (
    <Window
      title="Changelog"
      width={testmerges.length > 0 ? 1000 : 675}
      height={650}
    >
      <Window.Content scrollable>
        <Header
          dateDropdown={
            <DateDropdown
              selectedIndex={selectedIndex}
              setData={setData}
              setSelectedIndex={setSelectedIndex}
              selectedDate={selectedDate}
              setSelectedDate={setSelectedDate}
              dateChoices={dateChoices}
              sortedDates={sortedDates}
              getData={getData}
            />
          }
        />
        <Stack>
          <Stack.Item grow>
            <Changes data={data} />
          </Stack.Item>
          {testmerges.length > 0 && (
            <Stack.Item width="50%">
              <Testmerges />
            </Stack.Item>
          )}
        </Stack>
        {typeof data === 'string' && <p>{data}</p>}
        <Footer
          dateDropdown={
            <DateDropdown
              selectedIndex={selectedIndex}
              setData={setData}
              setSelectedIndex={setSelectedIndex}
              selectedDate={selectedDate}
              setSelectedDate={setSelectedDate}
              dateChoices={dateChoices}
              sortedDates={sortedDates}
              getData={getData}
            />
          }
        />
      </Window.Content>
    </Window>
  );
};
