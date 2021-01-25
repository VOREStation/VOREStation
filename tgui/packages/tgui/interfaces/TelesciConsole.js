import { sortBy } from 'common/collections';
import { Fragment } from 'inferno';
import { useBackend } from "../backend";
import { AnimatedNumber, Box, Button, Flex, Icon, LabeledList, NoticeBox, NumberInput, ProgressBar, Section } from "../components";
import { Window } from "../layouts";

export const TelesciConsole = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    noTelepad,
  } = data;

  return (
    <Window width={400} height={450} resizable>
      <Window.Content scrollable>
        {noTelepad && <TelesciNoTelepadError /> || <TelesciConsoleContent />}
      </Window.Content>
    </Window>
  );
};

const TelesciNoTelepadError = (props, context) => {
  return (
    <Section title="Error" color="bad">
      No telepad located.<br />
      Please add telepad data.
    </Section>
  );
};

export const TelesciConsoleContent = (props, context) => {
  const { act, data } = useBackend(context);

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
    <Section title="Telepad Controls" buttons={
      <Button
        icon="eject"
        disabled={!insertedGps}
        onClick={() => act("ejectGPS")}
        content="Eject GPS" />
    }>
      <NoticeBox info>
        {cooldown && (
          <Box>
            Telepad is recharging. Please wait <AnimatedNumber value={cooldown} /> seconds.
          </Box>
        ) || (
          <Box>
            {tempMsg}
          </Box>
        )}
      </NoticeBox>
      <LabeledList>
        <LabeledList.Item label="Bearing">
          <NumberInput
            fluid
            value={rotation}
            format={v => v + "°"}
            step={1}
            minValue={-900}
            maxValue={900}
            onDrag={(e, val) => act("setrotation", { val: val })} />
        </LabeledList.Item>
        <LabeledList.Item label="Distance">
          <NumberInput
            fluid
            value={distance}
            format={v => v + "/" + maxAllowedDistance + " m"}
            minValue={0}
            maxValue={maxAllowedDistance}
            step={1}
            stepPixelSize={4}
            onDrag={(e, val) => act("setdistance", { val: val })} />
        </LabeledList.Item>
        <LabeledList.Item label="Sector">
          {sortBy(v => Number(v))(sectorOptions).map(z => (
            <Button
              key={z}
              icon="check-circle"
              content={z}
              selected={currentZ === z}
              onClick={() => act("setz", { setz: z })} />
          ))}
        </LabeledList.Item>
        <LabeledList.Item label="Controls">
          <Button
            icon="share"
            iconRotation={-90}
            onClick={() => act("send")}
            content="Send" />
          <Button
            icon="share"
            iconRotation={90}
            onClick={() => act("receive")}
            content="Receive" />
          <Button
            icon="sync"
            iconRotation={90}
            onClick={() => act("recal")}
            content="Recalibrate" />
        </LabeledList.Item>
      </LabeledList>
      {lastTeleData && (
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
      ) || (
        <Section mt={1}>
          No teleport data found.
        </Section>
      )}
      <Section>
        Crystals: {crystalCount} / {maxCrystals}
      </Section>
    </Section>
  );
};