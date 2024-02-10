import { Fragment } from 'react';
import { useBackend } from '../backend';
import { Box, Button, Flex, LabeledList, Slider, Section } from '../components';
import { Window } from '../layouts';

export const GeneralAtmoControl = (props) => {
  const { act, data } = useBackend();

  // While many of these variables are unused, it's helpful to have a consistent
  // list of all possible parameters in the core component of this UI.
  // So, keep them here and update them as necessary, pretty please.
  const {
    // All
    sensors,
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
    // Fuel /obj/machinery/computer/general_air_control/fuel_injection
    fuel,
    automation,
    device_info,
  } = data;

  return (
    <Window width={600} height={600}>
      <Window.Content>
        <AtmoControlSensors sensors={sensors} />
        {(core || tanks) && <AtmoControlTankCore />}
        {fuel && <AtmoControlFuel />}
      </Window.Content>
    </Window>
  );
};

const AtmoControlSensors = (props) => {
  const { act } = useBackend();

  const { sensors } = props;

  if (!sensors) {
    return (
      <Section title="Sensors">
        <Box color="bad">No Sensors Connected.</Box>
      </Section>
    );
  } else {
    return (
      <Section title="Sensors">
        {sensors.map((sensor) => (
          <Section title={sensor.long_name} key={sensor.long_name}>
            <AtmoSensor sensor={sensor} />
          </Section>
        ))}
      </Section>
    );
  }
};

const AtmoSensor = (props) => {
  const { sensor } = props;

  if (!sensor.sensor_data) {
    return <Box color="bad">UNABLE TO FIND SENSOR</Box>;
  }

  const { pressure, temperature, oxygen, nitrogen, carbon_dioxide, phoron } =
    sensor.sensor_data;

  let labeledListContents = [];
  if (pressure) {
    labeledListContents.push(
      <LabeledList.Item label="Pressure">{pressure} kPa</LabeledList.Item>,
    );
  }

  if (temperature) {
    labeledListContents.push(
      <LabeledList.Item label="Temperature">{temperature} K</LabeledList.Item>,
    );
  }

  if (oxygen || nitrogen || carbon_dioxide || phoron) {
    labeledListContents.push(
      <LabeledList.Item label="Gas Composition">
        <Flex justify="space-around">
          {oxygen ? <Flex.Item>({oxygen}% O²)</Flex.Item> : null}
          {nitrogen ? <Flex.Item>({nitrogen}% N²)</Flex.Item> : null}
          {carbon_dioxide ? (
            <Flex.Item>({carbon_dioxide}% CO²)</Flex.Item>
          ) : null}
          {phoron ? <Flex.Item>({phoron}% TX)</Flex.Item> : null}
        </Flex>
      </LabeledList.Item>,
    );
  }

  return <LabeledList>{labeledListContents.map((item) => item)}</LabeledList>;
};

const AtmoControlTankCore = (props) => {
  const { act, data } = useBackend();

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
    slider: (e, val) =>
      act('adj_input_flow_rate', {
        adj_input_flow_rate: val,
      }),
  };

  const outputActions = {
    power: () => act('out_toggle_power'),
    apply: () => act('out_set_pressure'),
    refresh: () => act('out_refresh_status'),
    slider: (e, val) => act('adj_pressure', { adj_pressure: val }),
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
            content="Refresh"
            icon="sync"
            disabled={!info}
            onClick={() => actions.refresh()}
          />
          <Button
            content="Power"
            icon="power-off"
            selected={info ? info.power : false}
            disabled={!info}
            onClick={() => actions.power()}
          />
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
            <Button
              icon="search"
              content="Search"
              onClick={() => actions.refresh()}
            />
          </LabeledList.Item>
        )}
        <LabeledList.Item
          label={limitName}
          buttons={
            <Button
              content="Apply"
              icon="edit"
              disabled={!info}
              onClick={() => actions.apply()}
            />
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
            onChange={(e, val) => actions.slider(e, val)}
          >
            {sliderFill ? sliderFill : 'UNK'} {unit} / {sliderControl} {unit}
          </Slider>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const AtmoControlFuel = (props) => {
  const { act, data } = useBackend();

  const { fuel, automation, device_info } = data;
  return (
    <Section
      title="Fuel Injection System"
      buttons={
        <>
          <Button
            icon="syringe"
            content="Inject"
            onClick={() => act('injection')}
            disabled={automation || !device_info}
          />
          <Button
            icon="sync"
            content="Refresh"
            onClick={() => act('refresh_status')}
          />
          <Button
            icon="power-off"
            content="Injector Power"
            onClick={() => act('toggle_injector')}
            selected={device_info ? device_info.power : false}
            disabled={automation || !device_info}
          />
        </>
      }
    >
      {device_info ? (
        <LabeledList>
          <LabeledList.Item label="Status">
            {device_info.power ? 'Injecting' : 'On Hold'}
          </LabeledList.Item>
          <LabeledList.Item label="Rate">
            {device_info.volume_rate}
          </LabeledList.Item>
          <LabeledList.Item label="Automated Fuel Injection">
            <Button
              icon="robot"
              content={automation ? 'Engaged' : 'Disengaged'}
              selected={automation}
              onClick={() => act('toggle_automation')}
            />
          </LabeledList.Item>
        </LabeledList>
      ) : (
        <>
          <Box color="bad">ERROR: Cannot Find Device</Box>
          <Button
            icon="search"
            content="Search"
            onClick={() => act('refresh_status')}
          />
        </>
      )}
    </Section>
  );
};
