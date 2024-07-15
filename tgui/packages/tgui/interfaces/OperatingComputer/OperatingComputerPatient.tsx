import { toFixed } from 'common/math';

import { Box, LabeledList, ProgressBar, Section } from '../../components';
import { damageRange, damages, stats, tempColors } from './constants';
import { occupant } from './types';

export const OperatingComputerPatient = (props: { occupant: occupant }) => {
  const { occupant } = props;
  return (
    <>
      <Section title="Patient">
        <LabeledList>
          <LabeledList.Item label="Name">{occupant.name}</LabeledList.Item>
          <LabeledList.Item label="Status" color={stats[occupant.stat][0]}>
            {stats[occupant.stat][1]}
          </LabeledList.Item>
          <LabeledList.Item label="Health">
            <ProgressBar
              minValue={0}
              maxValue={1}
              value={occupant.health / occupant.maxHealth}
              ranges={{
                good: [0.5, Infinity],
                average: [0, 0.5],
                bad: [-Infinity, 0],
              }}
            />
          </LabeledList.Item>
          {damages.map((d, i) => (
            <LabeledList.Item key={i} label={d[0] + ' Damage'}>
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
          <LabeledList.Item label="Temperature">
            <ProgressBar
              minValue={0}
              maxValue={1}
              value={occupant.bodyTemperature / occupant.maxTemp}
              color={tempColors[occupant.temperatureSuitability + 3]}
            >
              {toFixed(occupant.btCelsius)}&deg;C, {toFixed(occupant.btFaren)}
              &deg;F
            </ProgressBar>
          </LabeledList.Item>
          {!!occupant.hasBlood && (
            <>
              <LabeledList.Item label="Blood Level">
                <ProgressBar
                  minValue={0}
                  maxValue={1}
                  value={occupant.bloodLevel! / occupant.bloodMax!}
                  ranges={{
                    bad: [-Infinity, 0.6],
                    average: [0.6, 0.9],
                    good: [0.6, Infinity],
                  }}
                >
                  {occupant.bloodPercent}%, {occupant.bloodLevel}cl
                </ProgressBar>
              </LabeledList.Item>
              <LabeledList.Item label="Pulse">
                {occupant.pulse} BPM
              </LabeledList.Item>
            </>
          )}
        </LabeledList>
      </Section>
      <Section title="Current Procedure">
        {occupant.surgery && occupant.surgery.length ? (
          <LabeledList>
            {occupant.surgery.map((limb) => (
              <LabeledList.Item key={limb.name} label={limb.name}>
                <LabeledList>
                  <LabeledList.Item label="Current State">
                    {limb.currentStage}
                  </LabeledList.Item>
                  <LabeledList.Item label="Possible Next Steps">
                    {limb.nextSteps.map((step) => (
                      <div key={step}>{step}</div>
                    ))}
                  </LabeledList.Item>
                </LabeledList>
              </LabeledList.Item>
            ))}
          </LabeledList>
        ) : (
          <Box color="label">No procedure ongoing.</Box>
        )}
      </Section>
    </>
  );
};
