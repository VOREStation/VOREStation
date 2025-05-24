import { type PropsWithChildren, useCallback, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Button, ImageButton, Input, Section } from 'tgui-core/components';

import {
  ColorizedImageButton,
  ColorPicker,
  getImage,
} from '../../helper_components';
import {
  AppearanceFlags,
  type GeneralData,
  type GeneralDataConstant,
  type GeneralDataStatic,
  type Species,
} from '../data';
import { BodyPopup } from '../SubtabBody';

export const FacialImageButton = (
  props: PropsWithChildren<{
    serverData: GeneralDataConstant;
    hairStyle: string;
    hairColor: string;
    onClick: () => void;
    tooltip?: string;
    selected?: boolean;
  }>,
) => {
  const { serverData, hairStyle, hairColor, onClick } = props;

  const renderHuman = useCallback(
    async (ctx: OffscreenCanvasRenderingContext2D) => {
      ctx.globalCompositeOperation = 'destination-over';
      const image = await getImage(
        Byond.iconRefMap['icons/mob/human.dmi'] + '?state=body_f_s&dir=2',
      );

      ctx.drawImage(image, 0, 0, 32, 10, 0, 0, 64, 20);
    },
    [],
  );

  if (!(hairStyle in serverData.facial_styles)) {
    return (
      <ImageButton verticalAlign="top" onClick={onClick}>
        {props.children}
      </ImageButton>
    );
  }

  const data = serverData.facial_styles[hairStyle];
  return (
    <ColorizedImageButton
      iconRef={data.icon}
      iconState={data.icon_state + '_s'}
      color={hairColor}
      onClick={onClick}
      tooltip={props.tooltip}
      selected={props.selected}
      postRender={renderHuman}
    >
      {props.children}
    </ColorizedImageButton>
  );
};

export const FacialDimmer = (props: {
  setShow: React.Dispatch<React.SetStateAction<BodyPopup>>;
  data: GeneralData;
  staticData: GeneralDataStatic;
  serverData: GeneralDataConstant;
}) => {
  const { act } = useBackend();
  const { setShow, data, serverData, staticData } = props;
  // if the data is missing our UI is fucked anyways
  const our_species = serverData.species.find(
    (x) => x.name === data.species,
  ) as Species;
  const hairColor = data.facial_color;

  const [search, setSearch] = useState('');
  const hair_styles = staticData.available_facial_styles.filter((x) =>
    search ? x.toLowerCase().includes(search.toLowerCase()) : true,
  );
  hair_styles.sort();

  return (
    <Section
      title="Facial"
      fill
      scrollable
      mt={1}
      buttons={
        <Button onClick={() => setShow(BodyPopup.None)} color="bad">
          Close
        </Button>
      }
    >
      {our_species.appearance_flags & AppearanceFlags.HAS_HAIR_COLOR ? (
        <ColorPicker
          onClick={() => {
            act('set_facial_hair_color');
          }}
          color_one={hairColor}
        />
      ) : null}
      <Input
        fluid
        expensive
        onChange={(val) => setSearch(val)}
        value={search}
        mt={1}
      />

      {hair_styles.map((hairStyle) => (
        <FacialImageButton
          key={hairStyle}
          hairStyle={hairStyle}
          serverData={serverData}
          hairColor={hairColor}
          tooltip={hairStyle}
          onClick={() => {
            act('set_facial_hair_style', { facial_hair_style: hairStyle });
          }}
          selected={hairStyle === data.f_style}
        >
          {hairStyle}
        </FacialImageButton>
      ))}
    </Section>
  );
};
