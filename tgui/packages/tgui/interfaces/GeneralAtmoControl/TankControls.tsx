import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  LabeledList,
  Section,
  Slider,
} from 'tgui-core/components';

import type { Data } from './types';

export const AtmoControlTankCore = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    // Tanks /obj/machinery/computer/general_air_control
    tanks,
    // Tanks+Core /obj/machinery/computer/general_air_control/large_tank_control
    input_info,
    output_info,
    input_flow_setting,
    pressure_setting,
    max_pressure,
    max_flowrate,
    // Core /obj/machinery/computer/general_air_control/supermatter_core
    core,
  } = data;

  let sectionName = 'Unknown Control System';
  if (tanks) {
    sectionName = 'Tank Control System';
  } else if (core) {
    sectionName = 'Core Cooling Control System';
  }

  const inputActions = {
    power: () => act('in_toggle_injector'),
    apply: () => act('in_set_flowrate'),
    refresh: () => act('in_refresh_status'),
    slider: (e, val: number) =>
      act('adj_input_flow_rate', {
        adj_input_flow_rate: val,
      }),
  };

  const outputActions = {
    power: () => act('out_toggle_power'),
    apply: () => act('out_set_pressure'),
    refresh: () => act('out_refresh_status'),
    slider: (e, val: number) => act('adj_pressure', { adj_pressure: val }),
  };

  return (
    <Section title={sectionName}>
      <AtmoControlTankCoreControl
        info={input_info}
        maxSliderValue={max_flowrate}
        sliderControl={input_flow_setting}
        sliderFill={input_info && input_info.volume_rate}
        unit="L/s"
        name={core ? 'Coolant Input' : 'Input'}
        limitName="Flow Rate Limit"
        actions={inputActions}
      />
      <AtmoControlTankCoreControl
        info={output_info}
        maxSliderValue={max_pressure}
        sliderControl={pressure_setting}
        sliderFill={output_info && output_info.output_pressure}
        unit="kPa"
        name={core ? 'Core Outpump' : 'Output'}
        limitName={core ? 'Min Core Pressure' : 'Max Output Pressure'}
        actions={outputActions}
      />
    </Section>
  );
};

const AtmoControlTankCoreControl = (props) => {
  const {
    info,
    maxSliderValue,
    sliderControl,
    sliderFill,
    unit,
    name,
    limitName,
    actions,
  } = props;

  return (
    <Section
      title={name}
      buttons={
        <>
          <Button
            icon="sync"
            disabled={!info}
            onClick={() => actions.refresh()}
          >
            Refresh
          </Button>
          <Button
            icon="power-off"
            selected={info ? info.power : false}
            disabled={!info}
            onClick={() => actions.power()}
          >
            Power
          </Button>
        </>
      }
    >
      <LabeledList>
        {(info && (
          <LabeledList.Item label={name}>
            {info.power ? 'Injecting' : 'On Hold'}
          </LabeledList.Item>
        )) || (
          <LabeledList.Item>
            <Box color="bad">ERROR: Cannot Find {name} Port</Box>
            <Button icon="search" onClick={() => actions.refresh()}>
              Search
            </Button>
          </LabeledList.Item>
        )}
        <LabeledList.Item
          label={limitName}
          buttons={
            <Button
              icon="edit"
              disabled={!info}
              onClick={() => actions.apply()}
            >
              Apply
            </Button>
          }
        >
          <Slider
            mt="0.4em"
            animated
            minValue={0}
            maxValue={maxSliderValue}
            stepPixelSize={1 / (maxSliderValue / 500)}
            value={sliderControl}
            fillValue={sliderFill ? sliderFill : 0}
            onChange={(e, val: number) => actions.slider(e, val)}
          >
            {sliderFill ? sliderFill : 'UNK'} {unit} / {sliderControl} {unit}
          </Slider>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
