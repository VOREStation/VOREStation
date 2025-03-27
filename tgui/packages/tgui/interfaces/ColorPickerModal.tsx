/**
 * @file
 * @copyright 2023 itsmeow
 * @license MIT
 */

import {
  colorList,
  hexToHsva,
  type HsvaColor,
  hsvaToHex,
  hsvaToHslString,
  hsvaToRgba,
  rgbaToHsva,
  validHex,
} from 'common/colorpicker';
import React, { useCallback, useEffect, useMemo, useState } from 'react';
import { Pointer } from 'tgui/components';
import { type Interaction, Interactive } from 'tgui/components/Interactive';
import {
  Autofocus,
  Box,
  Button,
  NumberInput,
  Section,
  Stack,
  Tooltip,
} from 'tgui-core/components';
import { clamp } from 'tgui-core/math';
import { classes } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';
import { InputButtons } from './common/InputButtons';
import { Loader } from './common/Loader';

interface ColorPickerData {
  autofocus: boolean;
  buttons: string[];
  message: string;
  large_buttons: boolean;
  swapped_buttons: boolean;
  timeout: number;
  title: string;
  default_color: string;
  presets: string;
}

interface ColorPickerModalProps {}

export const ColorPickerModal: React.FC<ColorPickerModalProps> = () => {
  const { act, data } = useBackend<ColorPickerData>();
  const {
    timeout,
    message,
    autofocus,
    default_color = '#000000',
    presets = '',
  } = data;
  let { title } = data;

  const [selectedColor, setSelectedColor] = useState<HsvaColor>(
    hexToHsva(default_color),
  );

  const [lastSelectedColor, setLastSelectedColor] = useState<string>('');
  const [allowEditing, setAllowEditing] = useState<boolean>(false);

  useEffect(() => {
    setSelectedColor(hexToHsva(default_color));
  }, [default_color]);

  useEffect(() => {
    const hexCol = hsvaToHex(selectedColor);
    if (
      selectedPreset !== undefined &&
      lastSelectedColor !== hexCol &&
      allowEditing
    ) {
      setLastSelectedColor(hexCol);
      act('preset', { color: hexCol, index: selectedPreset + 1 });
    }
  }, [selectedColor]);

  if (!title) {
    title = 'Color';
  }

  const [selectedPreset, setSelectedPreset] = useState<number | undefined>(
    undefined,
  );

  const ourPresets = presets
    .replaceAll('#', '')
    .replace(/(^;)|(;$)/g, '')
    .split(';');
  while (ourPresets.length < 20) {
    ourPresets.push('FFFFFF');
  }
  const presetList = ourPresets.reduce(
    (input, entry, index) => {
      if (index < 10) {
        return [[...input[0], entry], input[1]];
      } else {
        return [input[0], [...input[1], entry]];
      }
    },
    [[], []],
  );
  return (
    <Window
      height={message ? 460 : 420}
      title={title}
      width={600}
      theme="generic"
    >
      {!!timeout && <Loader value={timeout} />}
      <Window.Content>
        <Stack fill vertical>
          {!!autofocus && <Autofocus />}
          {message && (
            <Stack.Item m={1}>
              <Section fill>
                <Box color="label" overflow="hidden">
                  {message}
                </Box>
              </Section>
            </Stack.Item>
          )}
          <Stack.Item grow>
            <Section fill>
              <ColorSelector
                color={selectedColor}
                setColor={setSelectedColor}
                defaultColor={default_color}
                presetList={presetList}
                selectedPreset={selectedPreset}
                onSelectedPreset={setSelectedPreset}
                allowEditing={allowEditing}
                onAllowEditing={setAllowEditing}
              />
            </Section>
          </Stack.Item>
          <Stack.Item>
            <InputButtons input={hsvaToHex(selectedColor)} />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

interface ColorPresetsProps {
  setColor: (color: HsvaColor) => void;
  setShowPresets: (show: boolean) => void;
  presetList: string[][];
  selectedPreset: number | undefined;
  onSelectedPreset: React.Dispatch<React.SetStateAction<number | undefined>>;
  allowEditing: boolean;
  onAllowEditing: React.Dispatch<React.SetStateAction<boolean>>;
}

const ColorPresets: React.FC<ColorPresetsProps> = React.memo(
  ({
    setColor,
    setShowPresets,
    presetList,
    selectedPreset,
    onSelectedPreset,
    allowEditing,
    onAllowEditing,
  }) => {
    return (
      <>
        <Button
          onClick={() => setShowPresets(false)}
          position="absolute"
          right="4px"
          icon="arrow-left"
        />
        <Stack justify="center" vertical>
          <Stack.Item>
            {colorList.map((row, index) => (
              <Stack.Item key={index} width="100%">
                <Stack justify="center">
                  {row.map((entry) => (
                    <Box key={entry} p="1px" backgroundColor="black">
                      <Box
                        p="1px"
                        backgroundColor="#AAAAAA"
                        onClick={() => {
                          setColor(hexToHsva(entry));
                          onSelectedPreset(undefined);
                        }}
                      >
                        <Box
                          backgroundColor={'#' + entry}
                          width="21px"
                          height="14px"
                        />
                      </Box>
                    </Box>
                  ))}
                </Stack>
              </Stack.Item>
            ))}
          </Stack.Item>
          <Stack.Item>
            {presetList.map((row, index) => (
              <Stack.Item key={index} grow>
                <Stack justify="center">
                  {row.map((entry, i) => (
                    <Box key={i} p="1px" backgroundColor="black">
                      <Box
                        p="1px"
                        backgroundColor={
                          selectedPreset === 10 * index + i
                            ? '#FF0000'
                            : '#AAAAAA'
                        }
                        onClick={() => {
                          setColor(hexToHsva(entry));
                          onSelectedPreset(10 * index + i);
                        }}
                      >
                        <Box
                          backgroundColor={'#' + entry}
                          width="21px"
                          height="14px"
                        />
                      </Box>
                    </Box>
                  ))}
                </Stack>
              </Stack.Item>
            ))}
          </Stack.Item>
        </Stack>
        <Button
          color={allowEditing ? 'green' : 'red'}
          position="absolute"
          right="4px"
          bottom="4px"
          icon="lock"
          onClick={() => onAllowEditing(!allowEditing)}
        />
      </>
    );
  },
);

interface ColorSelectorProps {
  color: HsvaColor;
  setColor: React.Dispatch<React.SetStateAction<HsvaColor>>;
  defaultColor: string;
  presetList: string[][];
  selectedPreset: number | undefined;
  onSelectedPreset: React.Dispatch<React.SetStateAction<number | undefined>>;
  allowEditing: boolean;
  onAllowEditing: React.Dispatch<React.SetStateAction<boolean>>;
}

const ColorSelector: React.FC<ColorSelectorProps> = React.memo(
  ({
    color,
    setColor,
    defaultColor,
    presetList,
    selectedPreset,
    onSelectedPreset,
    allowEditing,
    onAllowEditing,
  }) => {
    const handleChange = useCallback(
      (params: Partial<HsvaColor>) => {
        setColor((current) => ({ ...current, ...params }));
      },
      [setColor],
    );

    const [showPresets, setShowPresets] = useState<boolean>(false);
    const rgb = hsvaToRgba(color);
    const hexColor = hsvaToHex(color);

    return (
      <Stack direction="row">
        <Stack.Item mr={2}>
          <Stack vertical>
            <Stack.Item>
              <div className="react-colorful">
                <SaturationValue hsva={color} onChange={handleChange} />
                <Hue
                  hue={color.h}
                  onChange={handleChange}
                  className="react-colorful__last-control"
                />
              </div>
            </Stack.Item>
            <Stack.Item>
              <Box inline width="100px" height="20px" textAlign="center">
                Current
              </Box>
              <Box inline width="100px" height="20px" textAlign="center">
                Previous
              </Box>
              <br />
              <Tooltip content={hexColor} position="bottom">
                <Box
                  inline
                  width="100px"
                  height="30px"
                  backgroundColor={hexColor}
                />
              </Tooltip>
              <Tooltip content={defaultColor} position="bottom">
                <Box
                  inline
                  width="100px"
                  height="30px"
                  backgroundColor={defaultColor}
                />
              </Tooltip>
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item grow fontSize="15px" lineHeight="24px">
          {showPresets ? (
            <ColorPresets
              setColor={(c) => handleChange(c)}
              setShowPresets={setShowPresets}
              presetList={presetList}
              selectedPreset={selectedPreset}
              onSelectedPreset={onSelectedPreset}
              allowEditing={allowEditing}
              onAllowEditing={onAllowEditing}
            />
          ) : (
            <Stack vertical>
              <Stack.Item>
                <Stack>
                  <Stack.Item>
                    <Box textColor="label">Hex:</Box>
                  </Stack.Item>
                  <Stack.Item grow height="24px">
                    <HexColorInput
                      fluid
                      color={hsvaToHex(color).substring(1)}
                      onChange={(value) => {
                        setColor(hexToHsva(value));
                      }}
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      icon="eye-dropper"
                      onClick={() => setShowPresets(true)}
                    />
                  </Stack.Item>
                </Stack>
              </Stack.Item>
              <Stack.Divider />
              <HueRow color={color} handleChange={handleChange} />
              <SaturationRow color={color} handleChange={handleChange} />
              <ValueRow color={color} handleChange={handleChange} />
              <Stack.Divider />
              <RedRow color={color} handleChange={handleChange} />
              <GreenRow color={color} handleChange={handleChange} />
              <BlueRow color={color} handleChange={handleChange} />
            </Stack>
          )}
        </Stack.Item>
      </Stack>
    );
  },
);

interface RowProps {
  color: HsvaColor;
  handleChange: (c: Partial<HsvaColor>) => void;
}

const HueRow: React.FC<RowProps> = React.memo(({ color, handleChange }) => (
  <Stack.Item>
    <Stack>
      <Stack.Item width="25px">
        <Box textColor="label">H:</Box>
      </Stack.Item>
      <Stack.Item grow>
        <Hue hue={color.h} onChange={handleChange} />
      </Stack.Item>
      <Stack.Item>
        <TextSetter
          value={color.h}
          callback={(v) => handleChange({ h: v })}
          max={360}
          unit="°"
        />
      </Stack.Item>
    </Stack>
  </Stack.Item>
));

const SaturationRow: React.FC<RowProps> = React.memo(
  ({ color, handleChange }) => (
    <Stack.Item>
      <Stack>
        <Stack.Item width="25px">
          <Box textColor="label">S:</Box>
        </Stack.Item>
        <Stack.Item grow>
          <Saturation color={color} onChange={handleChange} />
        </Stack.Item>
        <Stack.Item>
          <TextSetter
            value={color.s}
            callback={(v) => handleChange({ s: v })}
            unit="%"
          />
        </Stack.Item>
      </Stack>
    </Stack.Item>
  ),
);

const ValueRow: React.FC<RowProps> = React.memo(({ color, handleChange }) => (
  <Stack.Item>
    <Stack>
      <Stack.Item width="25px">
        <Box textColor="label">V:</Box>
      </Stack.Item>
      <Stack.Item grow>
        <Value color={color} onChange={handleChange} />
      </Stack.Item>
      <Stack.Item>
        <TextSetter
          value={color.v}
          callback={(v) => handleChange({ v })}
          unit="%"
        />
      </Stack.Item>
    </Stack>
  </Stack.Item>
));

interface RGBRowProps {
  color: HsvaColor;
  handleChange: (c: HsvaColor) => void;
}

const RedRow: React.FC<RGBRowProps> = React.memo(({ color, handleChange }) => {
  const rgb = hsvaToRgba(color);
  return (
    <Stack.Item>
      <Stack>
        <Stack.Item width="25px">
          <Box textColor="label">R:</Box>
        </Stack.Item>
        <Stack.Item grow>
          <RGBSlider color={color} onChange={handleChange} target="r" />
        </Stack.Item>
        <Stack.Item>
          <TextSetter
            value={rgb.r}
            callback={(v) => {
              handleChange(rgbaToHsva({ ...rgb, r: v }));
            }}
            max={255}
          />
        </Stack.Item>
      </Stack>
    </Stack.Item>
  );
});

const GreenRow: React.FC<RGBRowProps> = React.memo(
  ({ color, handleChange }) => {
    const rgb = hsvaToRgba(color);
    return (
      <Stack.Item>
        <Stack>
          <Stack.Item width="25px">
            <Box textColor="label">G:</Box>
          </Stack.Item>
          <Stack.Item grow>
            <RGBSlider color={color} onChange={handleChange} target="g" />
          </Stack.Item>
          <Stack.Item>
            <TextSetter
              value={rgb.g}
              callback={(v) => {
                handleChange(rgbaToHsva({ ...rgb, g: v }));
              }}
              max={255}
            />
          </Stack.Item>
        </Stack>
      </Stack.Item>
    );
  },
);

const BlueRow: React.FC<RGBRowProps> = React.memo(({ color, handleChange }) => {
  const rgb = hsvaToRgba(color);
  return (
    <Stack.Item>
      <Stack>
        <Stack.Item width="25px">
          <Box textColor="label">B:</Box>
        </Stack.Item>
        <Stack.Item grow>
          <RGBSlider color={color} onChange={handleChange} target="b" />
        </Stack.Item>
        <Stack.Item>
          <TextSetter
            value={rgb.b}
            callback={(v) => {
              handleChange(rgbaToHsva({ ...rgb, b: v }));
            }}
            max={255}
          />
        </Stack.Item>
      </Stack>
    </Stack.Item>
  );
});

interface TextSetterProps {
  value: number;
  callback: (value: number) => void;
  min?: number;
  max?: number;
  unit?: string;
}

const TextSetter: React.FC<TextSetterProps> = React.memo(
  ({ value, callback, min = 0, max = 100, unit }) => {
    return (
      <NumberInput
        width="70px"
        value={Math.round(value)}
        step={1}
        minValue={min}
        maxValue={max}
        onChange={callback}
        unit={unit}
      />
    );
  },
);

interface HexColorInputProps {
  prefixed?: boolean;
  alpha?: boolean;
  color: string;
  fluid?: boolean;
  onChange: (newColor: string) => void;
}

const HexColorInput: React.FC<HexColorInputProps> = React.memo(
  ({ alpha, color, fluid, onChange, ...rest }) => {
    const initialColor = useMemo(() => {
      const stripped = color
        .replace(/[^0-9A-Fa-f]/g, '')
        .substring(0, 6)
        .toUpperCase();
      return stripped;
    }, [color]);

    const [localValue, setLocalValue] = useState(initialColor);

    useEffect(() => {
      setLocalValue(initialColor);
    }, [initialColor]);

    const isValidFullHex = useCallback(
      (val: string) => {
        return validHex(val, alpha) && val.length === 6;
      },
      [alpha],
    );

    const handleChangeEvent = (e: React.ChangeEvent<HTMLInputElement>) => {
      const inputValue = e.currentTarget.value;
      const strippedValue = inputValue
        .replace(/[^0-9A-Fa-f]/g, '')
        .substring(0, 6)
        .toUpperCase();

      setLocalValue(strippedValue);

      if (isValidFullHex(strippedValue)) {
        onChange(strippedValue);
      }
    };

    const commitOrRevert = useCallback(() => {
      if (isValidFullHex(localValue)) {
        onChange(localValue);
      } else {
        setLocalValue(initialColor);
      }
    }, [initialColor, isValidFullHex, localValue, onChange]);

    const handleBlur = (e: React.FocusEvent<HTMLInputElement>) => {
      commitOrRevert();
    };

    const handleKeyDown = (e: React.KeyboardEvent<HTMLInputElement>) => {
      if (e.key === 'Enter') {
        commitOrRevert();
        (e.currentTarget as HTMLInputElement).blur();
      }
    };

    return (
      <Box className={classes(['Input', fluid && 'Input--fluid'])}>
        <div className="Input__baseline">.</div>
        <input
          className="Input__input"
          value={localValue}
          spellCheck={false}
          onChange={handleChangeEvent}
          onBlur={handleBlur}
          onKeyDown={handleKeyDown}
          {...rest}
        />
      </Box>
    );
  },
);

interface SaturationValueProps {
  hsva: HsvaColor;
  onChange: (newColor: Partial<HsvaColor>) => void;
}

const SaturationValue: React.FC<SaturationValueProps> = React.memo(
  ({ hsva, onChange }) => {
    const handleMove = (interaction: Interaction) => {
      onChange({
        s: interaction.left * 100,
        v: 100 - interaction.top * 100,
      });
    };

    const handleKey = (offset: Interaction) => {
      onChange({
        s: clamp(hsva.s + offset.left * 100, 0, 100),
        v: clamp(hsva.v - offset.top * 100, 0, 100),
      });
    };

    const containerStyle = useMemo(
      () => ({
        backgroundColor: hsvaToHslString({
          h: hsva.h,
          s: 100,
          v: 100,
          a: 1,
        }),
      }),
      [hsva.h],
    );

    return (
      <div className="react-colorful__saturation_value" style={containerStyle}>
        <Interactive
          onMove={handleMove}
          onKey={handleKey}
          aria-label="Color"
          aria-valuetext={`Saturation ${Math.round(
            hsva.s,
          )}%, Brightness ${Math.round(hsva.v)}%`}
        >
          <Pointer
            className="react-colorful__saturation_value-pointer"
            top={1 - hsva.v / 100}
            left={hsva.s / 100}
            color={hsvaToHslString(hsva)}
          />
        </Interactive>
      </div>
    );
  },
);

interface HueProps {
  className?: string;
  hue: number;
  onChange: (newHue: Partial<HsvaColor>) => void;
}

const Hue: React.FC<HueProps> = React.memo(({ className, hue, onChange }) => {
  const handleMove = (interaction: Interaction) => {
    onChange({ h: 360 * interaction.left });
  };

  const handleKey = (offset: Interaction) => {
    onChange({ h: clamp(hue + offset.left * 360, 0, 360) });
  };

  const nodeClassName = classes(['react-colorful__hue', className]);

  return (
    <div className={nodeClassName}>
      <Interactive
        onMove={handleMove}
        onKey={handleKey}
        aria-label="Hue"
        aria-valuenow={Math.round(hue)}
        aria-valuemax={360}
        aria-valuemin={0}
      >
        <Pointer
          className="react-colorful__hue-pointer"
          left={hue / 360}
          color={hsvaToHslString({ h: hue, s: 100, v: 100, a: 1 })}
        />
      </Interactive>
    </div>
  );
});

interface SaturationProps {
  className?: string;
  color: HsvaColor;
  onChange: (newSaturation: Partial<HsvaColor>) => void;
}

const Saturation: React.FC<SaturationProps> = React.memo(
  ({ className, color, onChange }) => {
    const handleMove = (interaction: Interaction) => {
      onChange({ s: 100 * interaction.left });
    };

    const handleKey = (offset: Interaction) => {
      onChange({ s: clamp(color.s + offset.left * 100, 0, 100) });
    };

    const nodeClassName = classes(['react-colorful__saturation', className]);

    const background = useMemo(
      () =>
        `linear-gradient(to right, ${hsvaToHslString({
          h: color.h,
          s: 0,
          v: color.v,
          a: 1,
        })}, ${hsvaToHslString({ h: color.h, s: 100, v: color.v, a: 1 })})`,
      [color],
    );

    return (
      <div className={nodeClassName}>
        <Interactive
          style={{ background }}
          onMove={handleMove}
          onKey={handleKey}
          aria-label="Saturation"
          aria-valuenow={Math.round(color.s)}
          aria-valuemax={100}
          aria-valuemin={0}
        >
          <Pointer
            className="react-colorful__saturation-pointer"
            left={color.s / 100}
            color={hsvaToHslString({
              h: color.h,
              s: color.s,
              v: color.v,
              a: 1,
            })}
          />
        </Interactive>
      </div>
    );
  },
);

interface ValueProps {
  className?: string;
  color: HsvaColor;
  onChange: (newValue: Partial<HsvaColor>) => void;
}

const Value: React.FC<ValueProps> = React.memo(
  ({ className, color, onChange }) => {
    const handleMove = (interaction: Interaction) => {
      onChange({ v: 100 * interaction.left });
    };

    const handleKey = (offset: Interaction) => {
      onChange({
        v: clamp(color.v + offset.left * 100, 0, 100),
      });
    };

    const nodeClassName = classes(['react-colorful__value', className]);

    const background = useMemo(
      () =>
        `linear-gradient(to right, ${hsvaToHslString({
          h: color.h,
          s: color.s,
          v: 0,
          a: 1,
        })}, ${hsvaToHslString({ h: color.h, s: color.s, v: 100, a: 1 })})`,
      [color],
    );

    return (
      <div className={nodeClassName}>
        <Interactive
          style={{
            background,
          }}
          onMove={handleMove}
          onKey={handleKey}
          aria-label="Value"
          aria-valuenow={Math.round(color.v)}
          aria-valuemax={100}
          aria-valuemin={0}
        >
          <Pointer
            className="react-colorful__value-pointer"
            left={color.v / 100}
            color={hsvaToHslString(color)}
          />
        </Interactive>
      </div>
    );
  },
);

interface RGBSliderProps {
  className?: string;
  color: HsvaColor;
  onChange: (newValue: HsvaColor) => void;
  target: 'r' | 'g' | 'b';
}

const RGBSlider: React.FC<RGBSliderProps> = React.memo(
  ({ className, color, onChange, target }) => {
    const rgb = hsvaToRgba(color);

    const setNewTarget = (value: number) => {
      const newRgb = { ...rgb, [target]: value };
      onChange(rgbaToHsva(newRgb));
    };

    const handleMove = (interaction: Interaction) => {
      setNewTarget(255 * interaction.left);
    };

    const handleKey = (offset: Interaction) => {
      setNewTarget(clamp(rgb[target] + offset.left * 255, 0, 255));
    };

    const nodeClassName = classes([`react-colorful__${target}`, className]);

    const channels = {
      r: `rgb(${Math.round(rgb.r)},0,0)`,
      g: `rgb(0,${Math.round(rgb.g)},0)`,
      b: `rgb(0,0,${Math.round(rgb.b)})`,
    };

    const selected = channels[target];

    return (
      <div className={nodeClassName}>
        <Interactive
          onMove={handleMove}
          onKey={handleKey}
          aria-valuenow={rgb[target]}
          aria-valuemax={255}
          aria-valuemin={0}
        >
          <Pointer
            className={`react-colorful__${target}-pointer`}
            left={rgb[target] / 255}
            color={selected}
          />
        </Interactive>
      </div>
    );
  },
);
