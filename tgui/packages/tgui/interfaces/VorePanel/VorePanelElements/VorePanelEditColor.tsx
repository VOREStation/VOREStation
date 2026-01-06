import {
  type ComponentProps,
  useEffect,
  useEffectEvent,
  useState,
} from 'react';
import { useBackend } from 'tgui/backend';
import { ColorSelector } from 'tgui/interfaces/ColorPickerModal';
import { type HsvaColor, hexToHsva, hsvaToHex } from 'tgui-core/color';
import { Box, Floating, Stack, Tooltip } from 'tgui-core/components';
import { VorePanelColorBox } from './VorePanelCommonElements';
import { VorePanelEditNumber } from './VorePanelEditNumber';

export const VorePanelEditColor = (
  props: {
    /** Switch between Element editing and display */
    editMode: boolean;
    /** Our backend action on click */
    action: string;
    /** The displayed color of the color box */
    back_color: string;
  } & Partial<{
    /** Our secondary backend action on click */
    subAction: string;
    /** A number representing the alpha value for alpha inputs */
    alpha: number;
    /** Optional label to show before the color box */
    name_of: string;
    /** Our displayed tooltip behind the input element */
    tooltip: string;
    /** The position of the tooltip if static */
    tooltipPosition: ComponentProps<typeof Floating>['placement'];
    /** Removes the spacing behind the color box */
    removePlaceholder: boolean;
    /** User preset colors */
    presets: string;
    /**The set action on color changes */
    onRealtimeValue: (val: string) => void;
  }>,
) => {
  const { act } = useBackend();
  const {
    editMode,
    action,
    subAction = '',
    back_color,
    presets,
    alpha,
    name_of,
    tooltip,
    tooltipPosition,
    removePlaceholder,
    onRealtimeValue,
  } = props;

  const [isOpen, setIsOpen] = useState(false);
  const [initialColor, setInitialColor] = useState(back_color);
  const [currentColor, setCurrentColor] = useState<HsvaColor>(
    hexToHsva(back_color),
  );
  const [selectedPreset, setSelectedPreset] = useState<number | undefined>(
    undefined,
  );
  const [allowEditing, setAllowEditing] = useState<boolean>(false);
  const [lastSelectedColor, setLastSelectedColor] = useState<string>('');

  useEffect(() => {
    let timeoutId: NodeJS.Timeout;

    if (!isOpen) {
      timeoutId = setTimeout(() => {
        setInitialColor(back_color);
        setCurrentColor(hexToHsva(back_color));
      }, 300);
    }

    return () => {
      if (timeoutId) {
        clearTimeout(timeoutId);
      }
    };
  }, [isOpen, back_color]);

  useEffect(() => {
    if (!onRealtimeValue) return;
    if (!isOpen) return;

    const timeoutId = setTimeout(() => {
      onRealtimeValue(hsvaToHex(currentColor));
    }, 300);

    return () => {
      clearTimeout(timeoutId);
    };
  }, [currentColor]);

  const syncColorPreset = useEffectEvent(() => {
    const hexCol = hsvaToHex(currentColor);

    if (
      selectedPreset !== undefined &&
      lastSelectedColor !== hexCol &&
      allowEditing
    ) {
      setLastSelectedColor(hexCol);
      act('preset', { color: hexCol, index: selectedPreset + 1 });
    }
  });

  useEffect(() => {
    const timeoutId = setTimeout(() => {
      syncColorPreset();
    }, 100);

    return () => clearTimeout(timeoutId);
  }, [currentColor]);

  const pixelSize = 20;
  const parentSize = `${pixelSize}px`;
  const childSize = `${pixelSize - 4}px`;
  let presetList;
  if (presets) {
    const ourPresets = presets
      .replaceAll('#', '')
      .replace(/(^;)|(;$)/g, '')
      .split(';');
    while (ourPresets.length < 20) {
      ourPresets.push('FFFFFF');
    }
    presetList = ourPresets.reduce(
      (input, entry, index) => {
        if (index < 10) {
          return [[...input[0], entry], input[1]];
        } else {
          return [input[0], [...input[1], entry]];
        }
      },
      [[], []],
    );
  }

  function handleSetColor(value: HsvaColor | ((prev: HsvaColor) => HsvaColor)) {
    const newColor = typeof value === 'function' ? value(currentColor) : value;
    setCurrentColor(newColor);
  }

  function handleIsOpen(newState: boolean) {
    setIsOpen(newState);
    if (!newState) {
      const newHeColor = hsvaToHex(currentColor).toLowerCase();
      if (back_color.toLowerCase() !== newHeColor) {
        act(action, { attribute: subAction, val: newHeColor });
      }
    }
  }

  return (
    <>
      {!!name_of && (
        <Stack.Item>
          <Box color="label">{name_of}</Box>
        </Stack.Item>
      )}
      <Stack.Item shrink>
        {editMode && alpha === undefined ? (
          <Floating
            onOpenChange={handleIsOpen}
            placement="top-end"
            contentClasses="VorePanel__Floating"
            content={
              <ColorSelector
                color={currentColor}
                setColor={handleSetColor}
                presetList={presetList}
                defaultColor={initialColor}
                selectedPreset={selectedPreset}
                onSelectedPreset={setSelectedPreset}
                allowEditing={allowEditing}
                onAllowEditing={setAllowEditing}
              />
            }
          >
            <Box
              style={{
                border: '2px solid white',
                cursor: 'pointer',
              }}
              width={parentSize}
              height={parentSize}
            >
              <Box
                backgroundColor={hsvaToHex(currentColor) ?? back_color}
                width={childSize}
                height={childSize}
              />
            </Box>
          </Floating>
        ) : (
          <VorePanelColorBox back_color={back_color} alpha={alpha} />
        )}
      </Stack.Item>
      {editMode && (
        <Stack.Item basis={alpha !== undefined ? '65px' : undefined}>
          {alpha !== undefined ? (
            <VorePanelEditNumber
              action={action}
              subAction={subAction}
              editMode={editMode}
              value={alpha}
              minValue={0}
              maxValue={255}
              tooltip={tooltip}
            />
          ) : (
            <Tooltip content={tooltip} position={tooltipPosition}>
              <Box className="VorePanel__floatingButton">?</Box>
            </Tooltip>
          )}
        </Stack.Item>
      )}
      {!removePlaceholder && <Stack.Item grow />}
    </>
  );
};
