import { Fragment } from 'inferno';
import { formatCommaNumber } from '../format';
import { useBackend } from '../backend';
import { Box, Button, Flex, LabeledList, ProgressBar, Section } from '../components';
import { Window } from '../layouts';

export const DishIncubator = (props) => {
  const { act, data } = useBackend();

  const {
    on,
    system_in_use,
    food_supply,
    radiation,
    growth,
    toxins,
    chemicals_inserted,
    can_breed_virus,
    chemical_volume,
    max_chemical_volume,
    dish_inserted,
    blood_already_infected,
    virus,
    analysed,
    infection_rate,
  } = data;

  return (
    <Window width={400} height={600}>
      <Window.Content scrollable>
        <Section
          title="Environmental Conditions"
          buttons={
            <Button
              icon="power-off"
              selected={on}
              content={on ? 'On' : 'Off'}
              onClick={() => act('power')}
            />
          }>
          <Flex spacing={1} mb={1}>
            <Flex.Item grow={1}>
              <Button
                fluid
                icon="radiation"
                content="Add Radiation"
                onClick={() => act('rad')}
              />
            </Flex.Item>
            <Flex.Item grow={1}>
              <Button.Confirm
                fluid
                color="red"
                icon="trash"
                confirmIcon="trash"
                content="Flush System"
                disabled={!system_in_use}
                onClick={() => act('flush')}
              />
            </Flex.Item>
          </Flex>
          <LabeledList>
            <LabeledList.Item label="Virus Food">
              <ProgressBar
                minValue={0}
                maxValue={100}
                ranges={{
                  good: [40, Infinity],
                  average: [20, 40],
                  bad: [-Infinity, 20],
                }}
                value={food_supply}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Radiation Level">
              <ProgressBar
                minValue={0}
                maxValue={100}
                color={
                  radiation >= 50 ? 'bad' : growth >= 25 ? 'average' : 'good'
                }
                value={radiation}>
                {formatCommaNumber(radiation * 10000)} &micro;Sv
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="Toxicity">
              <ProgressBar
                minValue={0}
                maxValue={100}
                ranges={{
                  bad: [50, Infinity],
                  average: [25, 50],
                  good: [-Infinity, 25],
                }}
                value={toxins}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section
          title={can_breed_virus ? 'Vial' : 'Chemicals'}
          buttons={
            <Fragment>
              <Button
                icon="eject"
                content={'Eject ' + (can_breed_virus ? 'Vial' : 'Chemicals')}
                disabled={!chemicals_inserted}
                onClick={() => act('ejectchem')}
              />
              <Button
                icon="virus"
                content="Breed Virus"
                disabled={!can_breed_virus}
                onClick={() => act('virus')}
              />
            </Fragment>
          }>
          {(chemicals_inserted && (
            <Box>
              <LabeledList>
                <LabeledList.Item label="Volume">
                  <ProgressBar
                    minValue={0}
                    maxValue={max_chemical_volume}
                    value={chemical_volume}>
                    {chemical_volume}/{max_chemical_volume}
                  </ProgressBar>
                </LabeledList.Item>
                <LabeledList.Item
                  label="Breeding Environment"
                  color={can_breed_virus ? 'good' : 'average'}>
                  {dish_inserted
                    ? can_breed_virus
                      ? 'Suitable'
                      : 'No hemolytic samples detected'
                    : 'N/A'}
                  {blood_already_infected ? (
                    <Box color="bad">
                      CAUTION: Viral infection detected in blood sample.
                    </Box>
                  ) : null}
                </LabeledList.Item>
              </LabeledList>
            </Box>
          )) || <Box color="average">No chemicals inserted.</Box>}
        </Section>
        <Section
          title="Virus Dish"
          buttons={
            <Button
              icon="eject"
              content="Eject Dish"
              disabled={!dish_inserted}
              onClick={() => act('ejectdish')}
            />
          }>
          {dish_inserted ? (
            virus ? (
              <LabeledList>
                <LabeledList.Item label="Growth Density">
                  <ProgressBar
                    minValue={0}
                    maxValue={100}
                    ranges={{
                      good: [50, Infinity],
                      average: [25, 50],
                      bad: [-Infinity, 25],
                    }}
                    value={growth}
                  />
                </LabeledList.Item>
                <LabeledList.Item label="Infection Rate">
                  {analysed ? infection_rate : 'Unknown.'}
                </LabeledList.Item>
              </LabeledList>
            ) : (
              <Box color="bad">No virus detected.</Box>
            )
          ) : (
            <Box color="average">No dish loaded.</Box>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
