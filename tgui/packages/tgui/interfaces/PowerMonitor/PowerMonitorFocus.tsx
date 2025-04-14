import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Chart,
  LabeledList,
  ProgressBar,
  Section,
  Stack,
  Table,
} from 'tgui-core/components';
import { flow } from 'tgui-core/fp';
import { toFixed } from 'tgui-core/math';

import { PEAK_DRAW } from './constants';
import { powerRank } from './functions';
import { AreaCharge, AreaStatusColorBox } from './PowerMonitorHelpers';
import type { area, sensor } from './types';

export const PowerMonitorFocus = (props: { focus: sensor }) => {
  const { act } = useBackend();
  const { focus } = props;
  const { history } = focus;
  const [sortByField, setSortByField] = useState<string | null>(null);
  const supply: number = history.supply[history.supply.length - 1] || 0;
  const demand: number = history.demand[history.demand.length - 1] || 0;
  const supplyData: number[][] = history.supply.map((value, i) => [i, value]);
  const demandData: number[][] = history.demand.map((value, i) => [i, value]);
  const maxValue: number = Math.max(
    PEAK_DRAW,
    ...history.supply,
    ...history.demand,
  );

  // Process area data
  const areas: area[] = flow([
    (areas: area[]) =>
      areas.map((area, i) => ({
        ...area,
        // Generate a unique id
        id: area.name + i,
      })),
    (areas: area[]) => {
      if (sortByField !== 'name') {
        return areas;
      } else {
        return areas.sort((a, b) => a.name.localeCompare(b.name));
      }
    },
    (areas: area[]) => {
      if (sortByField !== 'charge') {
        return areas;
      } else {
        return areas.sort((a, b) => b.charge - a.charge);
      }
    },
    (areas: area[]) => {
      if (sortByField !== 'draw') {
        return areas;
      } else {
        return areas.sort(
          (a, b) =>
            powerRank(b.load) - powerRank(a.load) ||
            parseFloat(b.load) - parseFloat(a.load),
        );
      }
    },
    (areas: area[]) => {
      if (sortByField !== 'problems') {
        return areas;
      } else {
        return areas.sort(
          (a, b) =>
            a.eqp - b.eqp ||
            a.lgt - b.lgt ||
            a.env - b.env ||
            a.charge - b.charge ||
            a.name.localeCompare(b.name),
        );
      }
    },
  ])(focus.areas);

  return (
    <>
      <Section
        title={focus.name}
        buttons={
          <Button icon="sign-out-alt" onClick={() => act('clear')}>
            Back To Main
          </Button>
        }
      />
      <Stack mx={-0.5} mb={1}>
        <Stack.Item mx={0.5} width="200px">
          <Section>
            <LabeledList>
              <LabeledList.Item label="Supply">
                <ProgressBar
                  value={supply}
                  minValue={0}
                  maxValue={maxValue}
                  color="teal"
                >
                  {toFixed(supply / 1000) + ' kW'}
                </ProgressBar>
              </LabeledList.Item>
              <LabeledList.Item label="Draw">
                <ProgressBar
                  value={demand}
                  minValue={0}
                  maxValue={maxValue}
                  color="pink"
                >
                  {toFixed(demand / 1000) + ' kW'}
                </ProgressBar>
              </LabeledList.Item>
            </LabeledList>
          </Section>
        </Stack.Item>
        <Stack.Item mx={0.5} grow>
          <Section position="relative" fill>
            <Chart.Line
              fillPositionedParent
              data={supplyData}
              rangeX={[0, supplyData.length - 1]}
              rangeY={[0, maxValue]}
              strokeColor="rgba(0, 181, 173, 1)"
              fillColor="rgba(0, 181, 173, 0.25)"
            />
            <Chart.Line
              fillPositionedParent
              data={demandData}
              rangeX={[0, demandData.length - 1]}
              rangeY={[0, maxValue]}
              strokeColor="rgba(224, 57, 151, 1)"
              fillColor="rgba(224, 57, 151, 0.25)"
            />
          </Section>
        </Stack.Item>
      </Stack>
      <Section>
        <Box mb={1}>
          <Box inline mr={2} color="label">
            Sort by:
          </Box>
          <Button.Checkbox
            checked={sortByField === 'name'}
            onClick={() =>
              setSortByField((sortByField !== 'name' && 'name') || null)
            }
          >
            Name
          </Button.Checkbox>
          <Button.Checkbox
            checked={sortByField === 'charge'}
            onClick={() =>
              setSortByField((sortByField !== 'charge' && 'charge') || null)
            }
          >
            Charge
          </Button.Checkbox>
          <Button.Checkbox
            checked={sortByField === 'draw'}
            onClick={() =>
              setSortByField((sortByField !== 'draw' && 'draw') || null)
            }
          >
            Draw
          </Button.Checkbox>
          <Button.Checkbox
            checked={sortByField === 'problems'}
            onClick={() =>
              setSortByField((sortByField !== 'problems' && 'problems') || null)
            }
          >
            Problems
          </Button.Checkbox>
        </Box>
        <Table>
          <Table.Row header>
            <Table.Cell>Area</Table.Cell>
            <Table.Cell collapsing>Charge</Table.Cell>
            <Table.Cell textAlign="right">Draw</Table.Cell>
            <Table.Cell collapsing>Eqp</Table.Cell>
            <Table.Cell collapsing>Lgt</Table.Cell>
            <Table.Cell collapsing>Env</Table.Cell>
          </Table.Row>
          {areas.map((area, i) => (
            <tr key={i} className="Table__row candystripe">
              <td>{area.name}</td>
              <td className="Table__cell text-right text-nowrap">
                <AreaCharge charging={area.charging} charge={area.charge} />
              </td>
              <td className="Table__cell text-right text-nowrap">
                {area.load}
              </td>
              <td className="Table__cell text-center text-nowrap">
                <AreaStatusColorBox status={area.eqp} />
              </td>
              <td className="Table__cell text-center text-nowrap">
                <AreaStatusColorBox status={area.lgt} />
              </td>
              <td className="Table__cell text-center text-nowrap">
                <AreaStatusColorBox status={area.env} />
              </td>
            </tr>
          ))}
        </Table>
      </Section>
    </>
  );
};
