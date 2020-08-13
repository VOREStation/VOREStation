import { round } from 'common/math';
import { Fragment } from 'inferno';
import { useBackend, useLocalState } from "../backend";
import { Box, Button, Flex, Icon, LabeledList, ProgressBar, Section, Tabs } from "../components";
import { Window } from "../layouts";

export const RCON = (props, context) => {
  return (
    <Window
      width={630}
      height={440}
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
  } = data;

  return (
    <Section title="SMESs">
      <LabeledList>
        {smes_info ? smes_info.map(smes => (
          <LabeledList.Item key={smes.RCON_tag} label={smes.RCON_tag}>
            <Box mb={1}>
              <ProgressBar
                value={smes.capacityPercent * 0.01}
                ranges={{
                  good: [0.5, Infinity],
                  average: [0.15, 0.5],
                  bad: [-Infinity, 0.15],
                }}>
                {
                  round(smes.charge/(1000*60), 1)
                } kWh / {
                  round(smes.capacity/(1000*60))
                } kWh ({smes.capacityPercent}%)
              </ProgressBar>
            </Box>
            <LabeledList>
              <LabeledList.Item
                label="Input"
                buttons={(
                  <Fragment>
                    <Button
                      icon="power-off"
                      onClick={() => act("smes_in_toggle", {
                        smes: smes.RCON_tag,
                      })} />
                    <Button
                      icon="pen"
                      onClick={() => act("smes_in_set", {
                        smes: smes.RCON_tag,
                      })} />
                  </Fragment>
                )}>
                {smes.input_val} kW - {smes.input_set ? "ON" : "OFF"}
              </LabeledList.Item>
              <LabeledList.Item
                label="Output"
                buttons={(
                  <Fragment>
                    <Button
                      icon="power-off"
                      onClick={() => act("smes_out_toggle", {
                        smes: smes.RCON_tag,
                      })} />
                    <Button
                      icon="pen"
                      onClick={() => act("smes_out_set", {
                        smes: smes.RCON_tag,
                      })} />
                  </Fragment>
                )}>
                {smes.output_val} kW - {smes.output_set ? "ONLINE" : "OFFLINE"}
              </LabeledList.Item>
              <LabeledList.Item label="Output Load">
                {smes.output_load} kW
              </LabeledList.Item>
            </LabeledList>
          </LabeledList.Item>
        )) : (
          <LabeledList.Item color="bad">
            No SMESs detected.
          </LabeledList.Item>
        )}
      </LabeledList>
    </Section>
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