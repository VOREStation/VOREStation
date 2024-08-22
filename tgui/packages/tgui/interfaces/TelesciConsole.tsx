import { sortBy } from 'common/collections';
import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import {
  AnimatedNumber,
  Box,
  Button,
  LabeledList,
  NoticeBox,
  NumberInput,
  Section,
} from '../components';
import { Window } from '../layouts';

type Data = {
  noTelepad: BooleanLike;
  insertedGps: string | undefined;
  rotation: number | undefined;
  currentZ: number | undefined;
  cooldown: number | undefined;
  crystalCount: number | undefined;
  maxCrystals: number | undefined;
  maxPossibleDistance: number | undefined;
  maxAllowedDistance: number | undefined;
  distance: number | undefined;
  tempMsg: string | undefined;
  sectorOptions: string[] | undefined;
  lastTeleData:
    | { src_x: number; src_y: number; distance: number; time: number }
    | undefined
    | null;
};

export const TelesciConsole = (props) => {
  const { data } = useBackend<Data>();

  const { noTelepad } = data;

  return (
    <Window width={400} height={450}>
      <Window.Content scrollable>
        {(noTelepad && <TelesciNoTelepadError />) || <TelesciConsoleContent />}
      </Window.Content>
    </Window>
  );
};

const TelesciNoTelepadError = (props) => {
  return (
    <Section title="Error" color="bad">
      No telepad located.
      <br />
      Please add telepad data.
    </Section>
  );
};

export const TelesciConsoleContent = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    insertedGps,
    rotation,
    currentZ,
    cooldown,
    crystalCount,
    maxCrystals,
    maxPossibleDistance,
    maxAllowedDistance,
    distance,
    tempMsg,
    sectorOptions,
    lastTeleData,
  } = data;

  return (
    <Section
      title="Telepad Controls"
      buttons={
        <Button
          icon="eject"
          disabled={!insertedGps}
          onClick={() => act('ejectGPS')}
        >
          Eject GPS
        </Button>
      }
    >
      <NoticeBox info>
        {(cooldown && (
          <Box>
            Telepad is recharging. Please wait
            <AnimatedNumber value={cooldown} /> seconds.
          </Box>
        )) || <Box>{tempMsg}</Box>}
      </NoticeBox>
      <LabeledList>
        <LabeledList.Item label="Bearing">
          <NumberInput
            fluid
            value={rotation!}
            format={(v) => v + '°'}
            step={1}
            minValue={-900}
            maxValue={900}
            onDrag={(val) => act('setrotation', { val: val })}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Distance">
          <NumberInput
            fluid
            value={distance!}
            format={(v) => v + '/' + maxAllowedDistance + ' m'}
            minValue={0}
            maxValue={maxAllowedDistance!}
            step={1}
            stepPixelSize={4}
            onDrag={(val) => act('setdistance', { val: val })}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Sector">
          {sectorOptions &&
            sortBy(sectorOptions, (v) => v).map((z) => (
              <Button
                key={z}
                icon="check-circle"
                selected={currentZ === Number(z)}
                onClick={() => act('setz', { setz: z })}
              >
                {z}
              </Button>
            ))}
        </LabeledList.Item>
        <LabeledList.Item label="Controls">
          <Button icon="share" iconRotation={-90} onClick={() => act('send')}>
            Send
          </Button>
          <Button icon="share" iconRotation={90} onClick={() => act('receive')}>
            Receive
          </Button>
          <Button icon="sync" iconRotation={90} onClick={() => act('recal')}>
            Recalibrate
          </Button>
        </LabeledList.Item>
      </LabeledList>
      {(lastTeleData && (
        <Section mt={1}>
          <LabeledList>
            <LabeledList.Item label="Telepad Location">
              {lastTeleData.src_x}, {lastTeleData.src_y}
            </LabeledList.Item>
            <LabeledList.Item label="Distance">
              {lastTeleData.distance}m
            </LabeledList.Item>
            <LabeledList.Item label="Transit Time">
              {lastTeleData.time} secs
            </LabeledList.Item>
          </LabeledList>
        </Section>
      )) || <Section mt={1}>No teleport data found.</Section>}
      <Section>
        Crystals: {crystalCount} / {maxCrystals}
      </Section>
    </Section>
  );
};
