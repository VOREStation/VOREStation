import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  LabeledList,
  ProgressBar,
  Section,
  Stack,
} from 'tgui-core/components';
import {
  gridStatusToColor,
  gridStatusToText,
  powerToColor,
  powerToText,
  statToColor,
  statToString,
} from '../constants';
import { ChargeStatus } from '../MedigunHelpers/ChargeStatus';
import type { Data, SModule } from '../types';

export const MedigunContent = (props: { smodule: SModule }) => {
  const { act, data } = useBackend<Data>();

  const {
    maintenance,
    tankmax,
    generator,
    gridstatus,
    power_cell_status,
    phoron_status,
    bruteheal_charge,
    burnheal_charge,
    toxheal_charge,
    bruteheal_vol,
    burnheal_vol,
    toxheal_vol,
    patient_name,
    patient_health,
    patient_brute,
    patient_burn,
    patient_tox,
    patient_oxy,
    blood_status,
    patient_status,
    organ_damage,
    inner_bleeding,
  } = data;

  const { smodule } = props;

  const moduleLevel = smodule?.rating || 0;

  return (
    <Stack vertical fill>
      <Stack.Item>
        <Section title="Power Status">
          <LabeledList>
            <LabeledList.Item label="Power Cell">
              {maintenance ? (
                <Box color="red">Maintenance Hatch Open</Box>
              ) : power_cell_status !== null ? (
                <ProgressBar
                  ranges={{
                    good: [50, Infinity],
                    average: [25, 50],
                    bad: [-Infinity, 25],
                  }}
                  minValue={0}
                  maxValue={100}
                  value={power_cell_status}
                />
              ) : (
                <Box color="red">Missing Cell</Box>
              )}
            </LabeledList.Item>
            {gridstatus !== 3 && (
              <LabeledList.Item
                label="Wireless Power"
                color={gridStatusToColor[gridstatus]}
              >
                {gridStatusToText[gridstatus] || 'Unavailable'}
              </LabeledList.Item>
            )}
            <LabeledList.Item
              label="Phoron Generator"
              color={powerToColor[generator]}
              buttons={
                <Button
                  content={generator ? 'On' : 'Off'}
                  selected={generator}
                  color={generator ? '' : 'bad'}
                  onClick={() => act('gentoggle')}
                />
              }
            >
              [ {powerToText[generator] || 'Unavailable'} ]
            </LabeledList.Item>
            {phoron_status !== null ? (
              <LabeledList.Item label="Phoron Volume">
                <ProgressBar color="pink" value={phoron_status} />
              </LabeledList.Item>
            ) : (
              <Box color="red">Missing Bin</Box>
            )}
          </LabeledList>
        </Section>
      </Stack.Item>
      <Stack.Item>
        <Section title="Heal Charge Status">
          <LabeledList>
            <ChargeStatus
              name="Brute Charge"
              color="bad"
              charge={bruteheal_charge}
              max={tankmax}
              volume={bruteheal_vol}
            />
            <ChargeStatus
              name="Burn Charge"
              color="average"
              charge={burnheal_charge}
              max={tankmax}
              volume={burnheal_vol}
            />
            <ChargeStatus
              name="Tox Charge"
              color="good"
              charge={toxheal_charge}
              max={tankmax}
              volume={toxheal_vol}
            />
          </LabeledList>
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        <Section fill title="Patient Status">
          <Stack vertical fill>
            {patient_health !== null &&
            patient_brute !== null &&
            patient_burn !== null &&
            patient_tox !== null &&
            patient_oxy !== null ? (
              <>
                <Stack.Item>
                  <LabeledList>
                    <LabeledList.Item label="Name">
                      {patient_name ? (
                        <Stack>
                          <Stack.Item grow>{patient_name}</Stack.Item>
                          <Stack.Item>
                            <Button
                              color="red"
                              onClick={() => act('cancel_healing')}
                            >
                              Stop Healing
                            </Button>
                          </Stack.Item>
                        </Stack>
                      ) : (
                        'No Target'
                      )}
                    </LabeledList.Item>
                    {!!data.patient_name && (
                      <>
                        <LabeledList.Item label="Total Health">
                          <ProgressBar
                            ranges={{
                              good: [0.5, Infinity],
                              average: [0.25, 0.5],
                              bad: [-Infinity, 0.25],
                            }}
                            value={patient_health}
                          >
                            <Stack>
                              {moduleLevel >= 2 && (
                                <>
                                  <Stack.Item grow />
                                  {!!organ_damage && (
                                    <Stack.Item>
                                      <Box bold>Organ Damage!</Box>
                                    </Stack.Item>
                                  )}
                                  {!!patient_status && (
                                    <Stack.Item>
                                      <Box
                                        bold
                                        color={statToColor[patient_status]}
                                      >
                                        {statToString[patient_status]}
                                      </Box>
                                    </Stack.Item>
                                  )}
                                </>
                              )}
                              <Stack.Item>
                                {`${(patient_health * 100).toFixed()}%`}
                              </Stack.Item>
                            </Stack>
                          </ProgressBar>
                        </LabeledList.Item>
                        {moduleLevel >= 2 && (
                          <LabeledList.Item label="Blood Volume">
                            {blood_status ? (
                              <ProgressBar
                                color="red"
                                value={
                                  blood_status.volume / blood_status.max_volume
                                }
                              >
                                <Stack>
                                  <Stack.Item grow />
                                  {!!inner_bleeding && (
                                    <Stack.Item grow>
                                      <Box bold>Inner Bleeding!</Box>
                                    </Stack.Item>
                                  )}
                                  <Stack.Item grow>
                                    {`${(
                                      (blood_status.volume /
                                        blood_status.max_volume) *
                                        100
                                    ).toFixed()}%`}
                                  </Stack.Item>
                                </Stack>
                              </ProgressBar>
                            ) : (
                              <Box color="red">No Blood Detected</Box>
                            )}
                          </LabeledList.Item>
                        )}
                      </>
                    )}
                  </LabeledList>
                </Stack.Item>
                <Stack.Item>
                  {!!data.patient_name && moduleLevel >= 2 && (
                    <Stack>
                      <Stack.Item basis="50%">
                        <LabeledList>
                          <LabeledList.Item label="Brute Damage">
                            <Box color="red">{patient_brute}</Box>
                          </LabeledList.Item>
                          <LabeledList.Item label="Burn Damage">
                            <Box color="orange">{patient_burn}</Box>
                          </LabeledList.Item>
                        </LabeledList>
                      </Stack.Item>
                      <Stack.Item>
                        <LabeledList>
                          <LabeledList.Item label="Tox Damage">
                            <Box color="green">{patient_tox}</Box>
                          </LabeledList.Item>
                          <LabeledList.Item label="Oxy Damage">
                            <Box color="blue">{patient_oxy}</Box>
                          </LabeledList.Item>
                        </LabeledList>
                      </Stack.Item>
                    </Stack>
                  )}
                </Stack.Item>
              </>
            ) : (
              <Box color="red">Missing Scanning Module</Box>
            )}
          </Stack>
        </Section>
      </Stack.Item>
    </Stack>
  );
};
