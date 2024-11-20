import { Chart } from 'react-google-charts';
import { Section, Stack } from 'tgui-core/components';

import { Stats } from './types';

const PieChart = (props: { data: (string | number)[][]; title: string }) => (
  <Chart
    chartType="PieChart"
    data={props.data}
    options={{
      backgroundColor: 'none',
      title: props.title,
      titleTextStyle: { color: 'white' },
      legend: { textStyle: { color: 'white' } },
      height: 300,
    }}
    height="300px"
    width="300px"
  />
);

const PreyPredPieChart = (props: { prey: number; pred: number }) => {
  const { prey, pred } = props;

  const slices = [
    ['Type', 'Count'],
    ['Prey', prey],
    ['Pred', pred],
  ];

  return <PieChart data={slices} title="Pred/Prey Ratio" />;
};

const EndResultPieChart = (props: {
  title: string;
  absorb: number;
  digest: number;
  release: number;
}) => {
  const { title, absorb, digest, release, ...rest } = props;

  let slices = [
    ['Type', 'Count'],
    ['Absorb', absorb],
    ['Digest', digest],
    ['Release', release],
  ];

  if (!absorb && !digest && !release) {
    slices = [
      ['Type', 'Count'],
      ['None', 1],
    ];
  }

  return <PieChart data={slices} title={title} {...rest} />;
};

export const VoreStats = (props: { stats: Stats }) => {
  const { stats } = props;

  if (!stats.enabled) {
    return (
      <Section title="Statistics" fill>
        Statistics are disabled by preference.
      </Section>
    );
  }

  return (
    <Section title="Statistics" fill>
      <Stack>
        <Stack.Item>
          <PreyPredPieChart
            pred={stats.stats_eaten_prey}
            prey={stats.stats_times_eaten}
          />
        </Stack.Item>
        <Stack.Item>
          <EndResultPieChart
            title="Absorb/Digest/Release (Pred)"
            absorb={stats.stats_absorbed_prey}
            digest={stats.stats_digested_prey}
            release={stats.stats_released_prey}
          />
        </Stack.Item>
        <Stack.Item>
          <EndResultPieChart
            title="Absorb/Digest/Release (Prey)"
            absorb={stats.stats_times_absorbed}
            digest={stats.stats_times_digested}
            release={stats.stats_times_released}
          />
        </Stack.Item>
      </Stack>
    </Section>
  );
};
