import { Fragment } from 'inferno';
import { useBackend } from '../../backend';
import { Box, Button, LabeledList } from '../../components';

export const OvermapFlightData = (props, context) => {
  const { act, data } = useBackend(context);

  const { disableLimiterControls } = props;

  const { ETAnext, speed, speed_color, accel, heading, accellimit } = data;

  // While, yes, this is a strange choice to use fieldset over Section
  // just look at how pretty the legend is, sticking partially through the border ;///;
  return (
    <LabeledList>
      <LabeledList.Item label="ETA To Next Grid">{ETAnext}</LabeledList.Item>
      <LabeledList.Item label="Speed" color={speed_color}>
        {speed} Gm/h
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

export const OvermapPanControls = (props, context) => {
  const { act } = useBackend(context);

  const { disabled, actToDo, selected = (val) => false } = props;

  return (
    <Fragment>
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
    </Fragment>
  );
};
