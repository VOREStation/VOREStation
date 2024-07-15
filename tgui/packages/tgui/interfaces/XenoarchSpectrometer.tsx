import { BooleanLike } from 'common/react';
import { decodeHtmlEntities } from 'common/string';

import { useBackend } from '../backend';
import {
  Box,
  Button,
  LabeledList,
  NoticeBox,
  ProgressBar,
  Section,
  Slider,
} from '../components';
import { Window } from '../layouts';

type Data = {
  scanned_item: string;
  scanned_item_desc: string;
  last_scan_data: string;
  scan_progress: number;
  scanning: BooleanLike;
  scanner_seal_integrity: number;
  scanner_rpm: number;
  scanner_temperature: number;
  coolant_usage_rate: number;
  coolant_usage_max: number;
  unused_coolant_abs: number;
  unused_coolant_per: number;
  coolant_purity: number;
  optimal_wavelength: number;
  maser_wavelength: number;
  maser_wavelength_max: number;
  maser_efficiency: number;
  radiation: number;
  t_left_radspike: number;
  rad_shield_on: BooleanLike;
};

export const XenoarchSpectrometer = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    scanned_item,
    scanned_item_desc,
    last_scan_data,
    scan_progress,
    scanning,
    scanner_seal_integrity,
    scanner_rpm,
    scanner_temperature,
    coolant_usage_rate,
    coolant_usage_max,
    unused_coolant_abs,
    unused_coolant_per,
    coolant_purity,
    optimal_wavelength,
    maser_wavelength,
    maser_wavelength_max,
    maser_efficiency,
    radiation,
    t_left_radspike,
    rad_shield_on,
  } = data;

  return (
    <Window width={900} height={760}>
      <Window.Content scrollable>
        <Section
          title="Status"
          buttons={
            <>
              <Button
                icon="signal"
                selected={scanning}
                onClick={() => act('scanItem')}
              >
                {scanning ? 'HALT SCAN' : 'Begin Scan'}
              </Button>
              <Button
                icon="eject"
                disabled={!scanned_item}
                onClick={() => act('ejectItem')}
              >
                Eject Item
              </Button>
            </>
          }
        >
          <LabeledList>
            <LabeledList.Item label="Item">
              {scanned_item || <Box color="bad">No item inserted.</Box>}
            </LabeledList.Item>
            <LabeledList.Item label="Heuristic Analysis">
              {scanned_item_desc || 'None found.'}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Scanner">
          <LabeledList>
            <LabeledList.Item label="Scan Progress">
              <ProgressBar
                value={scan_progress}
                minValue={0}
                maxValue={100}
                color="good"
              />
            </LabeledList.Item>
            <LabeledList.Item label="Vacuum Seal Integrity">
              <ProgressBar
                value={scanner_seal_integrity}
                minValue={0}
                maxValue={100}
                ranges={{
                  good: [66, 100],
                  average: [33, 66],
                  bad: [0, 33],
                }}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section
          title="MASER"
          buttons={
            <NoticeBox info>Match wavelengths to progress the scan.</NoticeBox>
          }
        >
          <LabeledList>
            <LabeledList.Item label="MASER Efficiency">
              <ProgressBar
                value={maser_efficiency}
                minValue={0}
                maxValue={100}
                ranges={{
                  good: [66, 100],
                  average: [33, 66],
                  bad: [0, 33],
                }}
              />
            </LabeledList.Item>
            <LabeledList.Item label="Wavelength">
              <Slider
                animated
                value={maser_wavelength}
                fillValue={optimal_wavelength}
                minValue={1}
                maxValue={maser_wavelength_max}
                format={(val: number) => val + ' MHz'}
                step={10}
                onDrag={(e, val: number) =>
                  act('maserWavelength', { wavelength: val })
                }
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Environment / Internal">
          <LabeledList>
            <LabeledList.Item label="Centrifuge Speed">
              <ProgressBar
                value={scanner_rpm}
                minValue={0}
                maxValue={1000}
                color="good"
              >
                {scanner_rpm} RPM
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="Internal Temperature">
              <ProgressBar
                minValue={0}
                value={scanner_temperature}
                maxValue={1273}
                ranges={{
                  bad: [1000, Infinity],
                  average: [250, 1000],
                  good: [0, 250],
                }}
              >
                {scanner_temperature} K
              </ProgressBar>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section
          title="Radiation"
          buttons={
            <Button
              selected={rad_shield_on}
              icon="radiation"
              onClick={() => act('toggle_rad_shield')}
            >
              {rad_shield_on
                ? 'Disable Radiation Shielding'
                : 'Enable Radiation Shielding'}
            </Button>
          }
        >
          <LabeledList>
            <LabeledList.Item label="Ambient Radiation">
              <ProgressBar
                minValue={0}
                value={radiation}
                maxValue={100}
                ranges={{
                  bad: [65, Infinity],
                  average: [15, 65],
                  good: [0, 15],
                }}
              >
                {radiation} mSv
              </ProgressBar>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Cooling">
          <LabeledList>
            <LabeledList.Item label="Coolant Remaining">
              <ProgressBar
                minValue={0}
                value={unused_coolant_per * 10}
                maxValue={1000}
                ranges={{
                  good: [65, Infinity],
                  average: [15, 65],
                  bad: [0, 15],
                }}
              >
                {unused_coolant_per * 10} u
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="Coolant Flow Rate">
              <Slider
                minValue={0}
                value={coolant_usage_rate}
                maxValue={coolant_usage_max}
                stepPixelSize={50}
                format={(val: number) => val + ' u/s'}
                onDrag={(e, val: number) =>
                  act('coolantRate', { coolant: val })
                }
              />
            </LabeledList.Item>
            <LabeledList.Item label="Coolant Purity">
              <ProgressBar
                minValue={0}
                value={coolant_purity}
                maxValue={100}
                ranges={{
                  good: [66, Infinity],
                  average: [33, 66],
                  bad: [0, 33],
                }}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Latest Results">
          {decodeHtmlEntities(last_scan_data)
            .split('\n')
            .map((val) => (
              <Box key={val}>{val}</Box>
            ))}
        </Section>
      </Window.Content>
    </Window>
  );
};
