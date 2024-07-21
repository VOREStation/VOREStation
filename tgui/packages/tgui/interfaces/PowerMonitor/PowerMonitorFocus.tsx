import { map, sortBy } from 'common/collections';
import { flow } from 'common/fp';
import { toFixed } from 'common/math';
import { useState } from 'react';

import { useBackend } from '../../backend';
import {
  Box,
  Button,
  Chart,
  Flex,
  LabeledList,
  ProgressBar,
  Section,
  Table,
} from '../../components';
import { PEAK_DRAW } from './constants';
import { powerRank } from './functions';
import { AreaCharge, AreaStatusColorBox } from './PowerMonitorHelpers';
import { area, sensor } from './types';

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
    map((area: area, i) => ({
      ...area,
      // Generate a unique id
      id: area.name + i,
    })),
    sortByField === 'name' && sortBy((area: area) => area.name),
    sortByField === 'charge' && sortBy((area: area) => -area.charge),
    sortByField === 'draw' &&
      sortBy(
        (area: area) => -powerRank(area.load),
        (area: area) => -parseFloat(area.load),
      ),
    sortByField === 'problems' &&
      sortBy(
        (area: area) => area.eqp,
        (area: area) => area.lgt,
        (area: area) => area.env,
        (area: area) => area.charge,
        (area: area) => area.name,
      ),
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
      <Flex mx={-0.5} mb={1}>
        <Flex.Item mx={0.5} width="200px">
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
        </Flex.Item>
        <Flex.Item mx={0.5} grow={1}>
          <Section position="relative" height="100%">
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
        </Flex.Item>
      </Flex>
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
            <Table.Cell collapsing title="Equipment">
              Eqp
            </Table.Cell>
            <Table.Cell collapsing title="Lighting">
              Lgt
            </Table.Cell>
            <Table.Cell collapsing title="Environment">
              Env
            </Table.Cell>
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
