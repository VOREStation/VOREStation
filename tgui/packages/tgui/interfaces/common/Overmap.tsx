import { useBackend } from 'tgui/backend';
import { Box, Button, LabeledList } from 'tgui-core/components';
import { toFixed } from 'tgui-core/math';
import { BooleanLike } from 'tgui-core/react';
type Data = {
  ETAnext: string;
  speed: number;
  speed_color: string;
  accel: number;
  heading: number;
  accellimit: number;
};

export const OvermapFlightData = (props) => {
  const { act, data } = useBackend<Data>();

  const { disableLimiterControls } = props;

  const { ETAnext, speed, speed_color, accel, heading, accellimit } = data;

  // While, yes, this is a strange choice to use fieldset over Section
  // just look at how pretty the legend is, sticking partially through the border ;///;
  return (
    <LabeledList>
      <LabeledList.Item label="ETA To Next Grid">{ETAnext}</LabeledList.Item>
      <LabeledList.Item label="Speed" color={speed_color}>
        {toFixed(speed, 2)} Gm/h
      </LabeledList.Item>
      <LabeledList.Item label="Acceleration">{accel} Gm/h</LabeledList.Item>
      <LabeledList.Item label="Heading">{heading}&deg;</LabeledList.Item>
      {(!disableLimiterControls && (
        <LabeledList.Item label="Acceleration Limiter">
          <Button onClick={() => act('accellimit')}>{accellimit} Gm/h</Button>
        </LabeledList.Item>
      )) ||
        null}
    </LabeledList>
  );
};

export const OvermapPanControls = (props: {
  disabled?: BooleanLike;
  actToDo: string;
  selected?: (val: number) => boolean;
}) => {
  const { act } = useBackend();

  const { disabled, actToDo, selected = (val) => false } = props;

  return (
    <>
      <Box>
        <Button
          disabled={disabled}
          selected={selected(9)}
          onClick={() => act(actToDo, { dir: 9 })}
          icon="arrow-up"
          iconRotation={-45}
        />
        <Button
          disabled={disabled}
          selected={selected(1)}
          onClick={() => act(actToDo, { dir: 1 })}
          icon="arrow-up"
        />
        <Button
          disabled={disabled}
          selected={selected(5)}
          onClick={() => act(actToDo, { dir: 5 })}
          icon="arrow-up"
          iconRotation={45}
        />
      </Box>
      <Box>
        <Button
          disabled={disabled}
          selected={selected(8)}
          onClick={() => act(actToDo, { dir: 8 })}
          icon="arrow-left"
        />
        <Button
          disabled={disabled}
          selected={selected(0)}
          onClick={() => act('brake')}
          icon="ban"
        />
        <Button
          disabled={disabled}
          selected={selected(4)}
          onClick={() => act(actToDo, { dir: 4 })}
          icon="arrow-right"
        />
      </Box>
      <Box>
        <Button
          disabled={disabled}
          selected={selected(10)}
          onClick={() => act(actToDo, { dir: 10 })}
          icon="arrow-down"
          iconRotation={45}
        />
        <Button
          disabled={disabled}
          selected={selected(2)}
          onClick={() => act(actToDo, { dir: 2 })}
          icon="arrow-down"
        />
        <Button
          disabled={disabled}
          selected={selected(6)}
          onClick={() => act(actToDo, { dir: 6 })}
          icon="arrow-down"
          iconRotation={-45}
        />
      </Box>
    </>
  );
};
