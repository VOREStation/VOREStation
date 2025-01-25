import { useBackend } from 'tgui/backend';
import { NtosWindow } from 'tgui/layouts';
import {
  Box,
  Button,
  LabeledList,
  ProgressBar,
  Section,
} from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

type Data = {
  PC_device_theme: string;
  power_usage: number;
  battery_exists: BooleanLike;
  battery_rating: number | undefined;
  battery_percent: number | undefined;
  battery: battery | undefined;
  hardware:
    | {
        name: string;
        desc: string;
        enabled: BooleanLike;
        critical: BooleanLike;
        powerusage: number;
      }[]
    | [];
  disk_size: number;
  disk_used: number;
};

type battery = { max: number; charge: number };

export const NtosConfiguration = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    PC_device_theme,
    power_usage,
    battery_exists,
    battery = {} as battery,
    disk_size,
    disk_used,
    hardware = [],
  } = data;
  return (
    <NtosWindow theme={PC_device_theme} width={520} height={630}>
      <NtosWindow.Content scrollable>
        <Section
          title="Power Supply"
          buttons={
            <Box inline bold mr={1}>
              Power Draw: {power_usage}W
            </Box>
          }
        >
          <LabeledList>
            <LabeledList.Item
              label="Battery Status"
              color={(!battery_exists && 'average') || undefined}
            >
              {battery_exists ? (
                <ProgressBar
                  value={battery.charge}
                  minValue={0}
                  maxValue={battery.max}
                  ranges={{
                    good: [battery.max / 2, Infinity],
                    average: [battery.max / 4, battery.max / 2],
                    bad: [-Infinity, battery.max / 4],
                  }}
                >
                  {battery.charge} / {battery.max}
                </ProgressBar>
              ) : (
                'Not Available'
              )}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="File System">
          <ProgressBar
            value={disk_used}
            minValue={0}
            maxValue={disk_size}
            color="good"
          >
            {disk_used} GQ / {disk_size} GQ
          </ProgressBar>
        </Section>
        <Section title="Hardware Components">
          {hardware.map((component) => (
            <Section
              key={component.name}
              title={component.name}
              buttons={
                <>
                  {!component.critical && (
                    <Button.Checkbox
                      checked={component.enabled}
                      mr={1}
                      onClick={() =>
                        act('PC_toggle_component', {
                          name: component.name,
                        })
                      }
                    >
                      Enabled
                    </Button.Checkbox>
                  )}
                  <Box inline bold mr={1}>
                    Power Usage: {component.powerusage}W
                  </Box>
                </>
              }
            >
              {component.desc}
            </Section>
          ))}
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
