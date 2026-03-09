import {
  type ComponentProps,
  type ReactNode,
  useEffect,
  useEffectEvent,
  useState,
} from 'react';
import { useBackend } from 'tgui/backend';
import { ColorSelector } from 'tgui/interfaces/ColorPickerModal';
import { VorePanelTooltip } from 'tgui/interfaces/VorePanel/VorePanelElements/VorePanelTooltip';
import { type HsvaColor, hexToHsva, hsvaToHex } from 'tgui-core/color';
import { Box, Floating, Stack } from 'tgui-core/components';

export const PreferenceEditColor = (
  props: {
    /** Our action when closing the floating */
    onClose: (value: string) => void;
    /** The displayed color of the color box */
    back_color: string;
  } & Partial<{
    /** Our displayed tooltip behind the input element */
    tooltip: ReactNode;
    /** The position of the tooltip if static */
    tooltipPosition: ComponentProps<typeof Floating>['placement'];
    /** User preset colors */
    presets: string;
    /**The set action on color changes */
    onRealtimeValue: (val: string) => void;
  }>,
) => {
  const { act } = useBackend();
  const {
    onClose,
    back_color,
    presets,
    tooltip,
    tooltipPosition,
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
      }, 100);
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
    }, 100);

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
      const newHexColor = hsvaToHex(currentColor).toLowerCase();
      if (back_color.toLowerCase() !== newHexColor) {
        onClose(newHexColor);
      }
    }
  }

  return (
    <Stack>
      <Stack.Item shrink>
        <Floating
          onOpenChange={handleIsOpen}
          placement="top-end"
          contentClasses="VorePanel__Floating VorePanel__noScroll"
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
      </Stack.Item>
      {!!tooltip && (
        <Stack.Item>
          <VorePanelTooltip
            tooltip={tooltip}
            tooltipPosition={tooltipPosition}
            displayText="?"
          />
        </Stack.Item>
      )}
    </Stack>
  );
};
