import { round } from 'common/math';
import { Fragment } from 'inferno';
import { useBackend } from "../backend";
import { Box, Button, Flex, Icon, LabeledList, ProgressBar, Section } from "../components";
import { Window } from "../layouts";

/* data["health"] = health
	data["wave"] = current_wave
	data["warmup_enabled"] = warmup
	data["currentTab"] = current_tab
	data["warmup_time_left"] = (warmup_complete - world.time) / 10 // We want to take the TOTAL time and subtract the CURRENT time, then divide it, to get our fancy UI percentage/time.
	data["wave_time_left"] = (wave_complete - world.time) / 10 // Same as above method, but for wave time.
*/

export const DamagedReactor = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    health,
    wave,
    warmup_enabled,
    currentTab,
    warmup_time_left,
    wave_time_left
  } = data;
  let body = <DamagedReactorTab1 />;
  if (currentTab === 1) { body = <DamagedReactorTab1 />; }
  if (currentTab === 2 && warmup === 1) { body = <DamagedReactorTab2 />; }
  if (currentTab === 3) { body = <DamagedReactorTab3 />; }
  if (currentTab === 4) { body = <DamagedReactorTab4 />; }
  return (
    <Window width={600} height={600} resizable>
      <Window.Content>
        {body}
      </Window.Content>
    </Window>
  );
};

const DamagedReactorTab1 = (props, context) => {
  return (
    <Section>
      <LabeledList>
        <LabeledList.Item label="Reactor Status">
          <ProgressBar
            animated
            ranges={{
              'good': [1500, Infinity],
              'average': [500, 1500],
              'bad': [-Infinity, 500],
            }}
            {health}>
            
          </ProgressBar>
        </LabeledList.Item>
        <LabeledList.Item label="STARTUP MESSAGE TBD">
          
        </LabeledList.Item>
      </LabeledList>
    </Section>
  )
};

const DamagedReactorTab2 = (props, context) => {
  
};

const DamagedReactorTab3 = (props, context) => {
  
};

const DamagedReactorTab4 = (props, context) => {
  
};

const DamagedReactorTab5 = (props, context) => {
  
}