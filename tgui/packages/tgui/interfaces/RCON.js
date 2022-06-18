import { round } from 'common/math';
import { formatPower } from '../format';
import { Fragment } from 'inferno';
import { useBackend, useLocalState } from "../backend";
import { Box, Button, Icon, LabeledList, ProgressBar, Stack, Section, Tabs, Slider } from "../components";
import { Window } from "../layouts";
import { capitalize } from 'common/string';

// Common power multiplier
const POWER_MUL = 1e3;


export const RCON = (props, context) => {
  return (
    <Window
      width={630}
      height={540}
      resizable>
      <Window.Content scrollable>
        <RCONContent />
      </Window.Content>
    </Window>
  );
};

export const RCONContent = (props, context) => {
  const [tabIndex, setTabIndex] = useLocalState(context, 'tabIndex', 0);

  let body;
  if (tabIndex === 0) {
    body = <RCONSmesList />;
  } else if (tabIndex === 1) {
    body = <RCONBreakerList />;
  }

  return (
    <Fragment>
      <Tabs>
        <Tabs.Tab
          key="SMESs"
          selected={0 === tabIndex}
          onClick={() => setTabIndex(0)}>
          <Icon name="power-off" /> SMESs
        </Tabs.Tab>
        <Tabs.Tab
          key="Breakers"
          selected={1 === tabIndex}
          onClick={() => setTabIndex(1)}>
          <Icon name="bolt" /> Breakers
        </Tabs.Tab>
      </Tabs>
      <Box m={2}>
        {body}
      </Box>
    </Fragment>
  );
};

const RCONSmesList = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    smes_info,
    pages,
    current_page,
  } = data;

  const runCallback = (cb) => {
    return cb();
  };

  return (
    <Section title={"SMESs (Page " + current_page + ")"}>
      <Stack vertical>
        {smes_info.map(smes => (
          <Stack.Item key={smes.RCON_tag}>
            <SMESItem smes={smes} />
          </Stack.Item>
        ))}
      </Stack>
      Page Selection:<br />
      {runCallback(() => {
        const row = [];
        for (let i = 1; i < pages; i++) {
          row.push(
            <Button
              selected={current_page === i}
              key={i}
              onClick={() => act("set_smes_page", {
                index: i,
              })}>
              {i}
            </Button>
          );
        }
        return row;
      })}
    </Section>
  );
};

const SMESItem = (props, context) => {
  const { act } = useBackend(context);
  const {
    capacityPercent,
    capacity,
    charge,
    inputAttempt,
    inputting,
    inputLevel,
    inputLevelMax,
    inputAvailable,
    outputAttempt,
    outputting,
    outputLevel,
    outputLevelMax,
    outputUsed,
    RCON_tag,
  } = props.smes;

  return (
    <Stack vertical>
      <Stack.Item>
        <Stack fill justify="space-between">
          <Stack.Item flexBasis="40%" fontSize={1.2}>
            {RCON_tag}
          </Stack.Item>
          <Stack.Item grow={1}>
            <ProgressBar
              value={capacityPercent * 0.01}
              ranges={{
                good: [0.5, Infinity],
                average: [0.15, 0.5],
                bad: [-Infinity, 0.15],
              }}>
              {round(charge/(1000*60), 1)} kWh / {round(capacity/(1000*60))} kWh
              ({capacityPercent}%)
            </ProgressBar>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <SMESControls smes={props.smes} way="input" />
      </Stack.Item>
      <Stack.Item>
        <SMESControls smes={props.smes} way="output" />
      </Stack.Item>
      <Stack.Divider />
    </Stack>
  );
};

const SMESControls = (props, context) => {
  const { act } = useBackend(context);
  const {
    way,
    smes,
  } = props;
  const {
    capacityPercent,
    capacity,
    charge,
    inputAttempt,
    inputting,
    inputLevel,
    inputLevelMax,
    inputAvailable,
    outputAttempt,
    outputting,
    outputLevel,
    outputLevelMax,
    outputUsed,
    RCON_tag,
  } = smes;

  let level;
  let levelMax;
  let available;
  let direction;
  let changeStatusAct;
  let changeAmountAct;
  let enabled;
  let powerColor;
  let powerTooltip;

  switch (way) {
    case "input":
      level = inputLevel;
      levelMax = inputLevelMax;
      available = inputAvailable;
      direction = "IN";
      changeStatusAct = "smes_in_toggle";
      changeAmountAct = "smes_in_set";
      enabled = inputAttempt;
      powerColor = !inputAttempt ? null : (inputting ? "green" : "yellow");
      powerTooltip = !inputAttempt ? "The SMES input is off." : (inputting ? "The SMES is drawing power." : "The SMES lacks power.");
      break;
    case "output":
      level = outputLevel;
      levelMax = outputLevelMax;
      available = outputUsed;
      direction = "OUT";
      changeStatusAct = "smes_out_toggle";
      changeAmountAct = "smes_out_set";
      enabled = outputAttempt;
      powerColor = !outputAttempt ? null : (outputting ? "green" : "yellow");
      powerTooltip = !outputAttempt ? "The SMES output is off." : (outputting ? "The SMES is outputting power." : "The SMES lacks any draw.");
      break;
  }

  return (
    <Stack fill>
      <Stack.Item basis="20%">
        {capitalize(way)}
      </Stack.Item>
      <Stack.Item grow={1}>
        <Stack>
          <Stack.Item>
            <Button
              icon="power-off"
              color={powerColor}
              tooltip={powerTooltip}
              onClick={() => act(changeStatusAct, {
                smes: RCON_tag,
              })} />
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="fast-backward"
              disabled={level === 0}
              onClick={() => act(changeAmountAct, {
                target: 'min',
                smes: RCON_tag,
              })} />
            <Button
              icon="backward"
              disabled={level === 0}
              onClick={() => act(changeAmountAct, {
                adjust: -10000,
                smes: RCON_tag,
              })} />
          </Stack.Item>
          <Stack.Item grow={1}>
            <Slider
              value={level / POWER_MUL}
              fillValue={available / POWER_MUL}
              minValue={0}
              maxValue={levelMax / POWER_MUL}
              step={5}
              stepPixelSize={4}
              format={value => formatPower(available, 1) + "/" + formatPower(value * POWER_MUL, 1)}
              onDrag={(e, value) => act(changeAmountAct, {
                target: value * POWER_MUL,
                smes: RCON_tag,
              })} />
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="forward"
              disabled={level === levelMax}
              onClick={() => act(changeAmountAct, {
                adjust: 10000,
                smes: RCON_tag,
              })} />
            <Button
              icon="fast-forward"
              disabled={level === levelMax}
              onClick={() => act(changeAmountAct, {
                target: 'max',
                smes: RCON_tag,
              })} />
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

const RCONBreakerList = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    breaker_info,
  } = data;

  return (
    <Section title="Breakers">
      <LabeledList>
        {breaker_info ? breaker_info.map(breaker => (
          <LabeledList.Item
            key={breaker.RCON_tag}
            label={breaker.RCON_tag}
            buttons={(
              <Button
                icon="power-off"
                content={breaker.enabled ? "Enabled" : "Disabled"}
                selected={breaker.enabled}
                color={breaker.enabled ? null : "bad"}
                onClick={() => act("toggle_breaker", {
                  breaker: breaker.RCON_tag,
                })} />
            )} />
        )) : (
          <LabeledList.Item color="bad">
            No breakers detected.
          </LabeledList.Item>
        )}
      </LabeledList>
    </Section>
  );
};
