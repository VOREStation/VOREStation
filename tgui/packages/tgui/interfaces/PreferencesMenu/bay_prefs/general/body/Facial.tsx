import { type PropsWithChildren, useCallback, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { getIconFromRefMap } from 'tgui/events/handlers/assets';
import {
  Box,
  Button,
  ImageButton,
  Input,
  Section,
  Stack,
} from 'tgui-core/components';
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
      const iconRef = getIconFromRefMap('icons/mob/human.dmi');
      if (!iconRef) return;
      const image = await getImage(`${iconRef}?state=body_f_s&dir=2`);

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
  if (data.icon_state === null || data.icon === null) {
    return (
      <ImageButton
        verticalAlign="top"
        onClick={onClick}
        tooltip={props.tooltip}
        selected={props.selected}
        dmIcon="icons/mob/mob.dmi"
        dmIconState="blank"
        dmFallback={<Box width="64px" height="64px" />}
      >
        {props.children}
      </ImageButton>
    );
  }

  return (
    <ColorizedImageButton
      iconRef={data.icon}
      iconState={`${data.icon_state}_s`}
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
  const { available_facial_styles = [] } = staticData;
  // if the data is missing our UI is fucked anyways
  const our_species = serverData.species.find(
    (x) => x.name === data.species,
  ) as Species;
  const hairColor = data.facial_color;

  const [search, setSearch] = useState('');
  const hair_styles = available_facial_styles.filter((x) =>
    search ? x.toLowerCase().includes(search.toLowerCase()) : true,
  );
  hair_styles.sort();

  return (
    <Section
      title="Facial"
      fill
      scrollable
      buttons={
        <Button onClick={() => setShow(BodyPopup.None)} color="bad">
          Close
        </Button>
      }
    >
      <Stack vertical fill>
        {our_species.appearance_flags & AppearanceFlags.HAS_HAIR_COLOR ? (
          <Stack.Item>
            <ColorPicker
              onClick={() => {
                act('set_facial_hair_color');
              }}
              color_one={hairColor}
            />
          </Stack.Item>
        ) : null}
        <Stack.Item>
          <Input
            fluid
            expensive
            placeholder="Search for facials..."
            onChange={(val) => setSearch(val)}
            value={search}
          />
        </Stack.Item>
        <Stack.Item grow>
          <Section fill scrollable>
            {hair_styles.map((hairStyle) => (
              <FacialImageButton
                key={hairStyle}
                hairStyle={hairStyle}
                serverData={serverData}
                hairColor={hairColor}
                tooltip={hairStyle}
                onClick={() => {
                  act('set_facial_hair_style', {
                    facial_hair_style: hairStyle,
                  });
                }}
                selected={hairStyle === data.f_style}
              >
                {hairStyle}
              </FacialImageButton>
            ))}
          </Section>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
