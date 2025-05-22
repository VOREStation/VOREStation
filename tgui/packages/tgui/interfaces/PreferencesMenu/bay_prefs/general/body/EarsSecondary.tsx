import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Button, Input, Section } from 'tgui-core/components';

import { ColorPicker, ColorType } from '../../helper_components';
import {
  type GeneralData,
  type GeneralDataConstant,
  type GeneralDataStatic,
} from '../data';
import { BodyPopup } from '../SubtabBody';
import { EarsImageButton } from './Ears';

// Flavored as "Horns"
export const EarsSecondaryDimmer = (props: {
  setShow: React.Dispatch<React.SetStateAction<BodyPopup>>;
  data: GeneralData;
  serverData: GeneralDataConstant;
  staticData: GeneralDataStatic;
}) => {
  const { act } = useBackend();
  const { setShow, data, serverData, staticData } = props;

  const colors = data.ear_secondary_colors;

  const color1 = colors[0] || null;
  const color2 = colors[1] || null;
  const color3 = colors[2] || null;
  const alpha = data.ear_secondary_alpha;

  const [search, setSearch] = useState('');

  const styles = staticData.available_ear_styles.filter((x) =>
    search ? x.toLowerCase().includes(search.toLowerCase()) : true,
  );
  styles.sort();

  return (
    <Section
      title="Horns"
      fill
      scrollable
      mt={1}
      buttons={
        <Button onClick={() => setShow(BodyPopup.None)} color="bad">
          Close
        </Button>
      }
    >
      <ColorPicker
        onClick={(type: ColorType) => {
          switch (type) {
            case ColorType.First:
              act('set_ear_secondary_color', { ear_secondary_color: 1 });
              break;
            case ColorType.Second:
              act('set_ear_secondary_color', { ear_secondary_color: 2 });
              break;
            case ColorType.Third:
              act('set_ear_secondary_color', { ear_secondary_color: 3 });
              break;
            case ColorType.Alpha:
              act('secondary_ears_alpha');
          }
        }}
        color_one={color1 || '#FFFFFF'}
        color_two={color2 || '#FFFFFF'}
        color_three={color3 || '#FFFFFF'}
        alpha={alpha}
      />
      <Input
        fluid
        expensive
        onChange={(val) => setSearch(val)}
        value={search}
        mt={1}
      />

      {styles.map((style) => (
        <EarsImageButton
          key={style}
          style={style}
          color={color1}
          serverData={serverData}
          tooltip={style}
          selected={
            style === data.ear_secondary_style ||
            (data.ear_secondary_style === null && style === 'None')
          }
          onClick={() => act('set_ear_secondary_style', { ear_style: style })}
        >
          {style}
        </EarsImageButton>
      ))}
    </Section>
  );
};
