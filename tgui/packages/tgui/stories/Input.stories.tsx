/**
 * @file
 * @copyright 2021 Aleksej Komarov
 * @license MIT
 */

import { useState } from 'react';
import {
  Box,
  DraggableControl,
  Icon,
  Input,
  Knob,
  LabeledList,
  NumberInput,
  Section,
  Slider,
} from 'tgui-core/components';

export const meta = {
  title: 'Input',
  render: () => <Story />,
};

function Story() {
  const [number, setNumber] = useState(0);
  const [text, setText] = useState('Sample text');
  return (
    <Section>
      <LabeledList>
        <LabeledList.Item label="Input (onChange)">
          <Input value={text} onChange={(value) => setText(value)} />
        </LabeledList.Item>
        <LabeledList.Item label="Input (onInput)">
          <Input value={text} onChange={(value) => setText(value)} />
        </LabeledList.Item>
        <LabeledList.Item label="NumberInput (onChange)">
          <NumberInput
            animated
            width="40px"
            step={1}
            stepPixelSize={5}
            value={number}
            minValue={-100}
            maxValue={100}
            onChange={(value) => setNumber(value)}
          />
        </LabeledList.Item>
        <LabeledList.Item label="NumberInput (onChange, tickWhileDragging)">
          <NumberInput
            animated
            tickWhileDragging
            width="40px"
            step={1}
            stepPixelSize={5}
            value={number}
            minValue={-100}
            maxValue={100}
            onChange={(value) => setNumber(value)}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Slider (onChange, tickWhileDragging)">
          <Slider
            tickWhileDragging
            step={1}
            stepPixelSize={5}
            value={number}
            minValue={-100}
            maxValue={100}
            onChange={(e, value) => setNumber(value)}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Knob (onChange, tickWhileDragging)">
          <Knob
            tickWhileDragging
            inline
            size={1}
            step={1}
            stepPixelSize={2}
            value={number}
            minValue={-100}
            maxValue={100}
            onChange={(e, value) => setNumber(value)}
          />
          <Knob
            tickWhileDragging
            ml={1}
            inline
            bipolar
            size={1}
            step={1}
            stepPixelSize={2}
            value={number}
            minValue={-100}
            maxValue={100}
            onChange={(e, value) => setNumber(value)}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Rotating Icon">
          <Box inline position="relative">
            <DraggableControl
              tickWhileDragging
              value={number}
              minValue={-100}
              maxValue={100}
              dragMatrix={[0, -1]}
              step={1}
              stepPixelSize={5}
              onChange={(e, value) => setNumber(value)}
            >
              {(control) => (
                <Box onMouseDown={control.handleDragStart}>
                  <Icon
                    size={4}
                    color="yellow"
                    name="times"
                    rotation={control.displayValue * 4}
                  />
                  {control.inputElement}
                </Box>
              )}
            </DraggableControl>
          </Box>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
}
