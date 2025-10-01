import { type HsvaColor, hexToHsva, hsvaToHex } from 'common/colorpicker';
import { useEffect, useState } from 'react';
import { Box, Floating } from 'tgui-core/components';
import { ColorSelector } from '../../ColorPickerModal';

export const ColorMatrixColorBox = (props: {
  selectedColor: string;
  onSelectedColor: (value: string) => void;
}) => {
  const { selectedColor, onSelectedColor } = props;

  const [selectedPreset, setSelectedPreset] = useState<number | undefined>(
    undefined,
  );
  const [currentColor, setCurrentColor] = useState<HsvaColor>(
    hexToHsva(selectedColor),
  );
  const [initialColor, setInitialColor] = useState(selectedColor);
  const [isOpen, setIsOpen] = useState(false);

  useEffect(() => {
    if (!isOpen) {
      setInitialColor(selectedColor);
      setCurrentColor(hexToHsva(selectedColor));
    }
  }, [isOpen, selectedColor]);

  const handleSetColor = (
    value: HsvaColor | ((prev: HsvaColor) => HsvaColor),
  ) => {
    const newColor = typeof value === 'function' ? value(currentColor) : value;
    setCurrentColor(newColor);
    onSelectedColor(hsvaToHex(newColor));
  };

  const pixelSize = 20;
  const parentSize = `${pixelSize}px`;
  const childSize = `${pixelSize - 4}px`;

  return (
    <Floating
      onOpenChange={setIsOpen}
      placement="bottom-end"
      contentClasses="MatrixEditor__Floating"
      content={
        <ColorSelector
          color={currentColor}
          setColor={handleSetColor}
          defaultColor={initialColor}
          selectedPreset={selectedPreset}
          onSelectedPreset={setSelectedPreset}
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
          backgroundColor={selectedColor}
          width={childSize}
          height={childSize}
        />
      </Box>
    </Floating>
  );
};
