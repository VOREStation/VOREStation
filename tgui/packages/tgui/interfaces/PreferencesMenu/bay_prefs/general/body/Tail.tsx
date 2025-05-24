import { type PropsWithChildren, useCallback, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, ImageButton, Input, Section } from 'tgui-core/components';

import {
  ColorizedImageButton,
  ColorPicker,
  ColorType,
  drawColorizedIconToOffscreenCanvas,
} from '../../helper_components';
import {
  type GeneralData,
  type GeneralDataConstant,
  type GeneralDataStatic,
} from '../data';
import { BodyPopup } from '../SubtabBody';

export const TailImageButton = (
  props: PropsWithChildren<{
    serverData: GeneralDataConstant;
    style: string;
    color?: string | null;
    color2?: string | null;
    color3?: string | null;
    onClick: () => void;
    tooltip?: string;
    selected?: boolean;
  }>,
) => {
  const { serverData, style, color, color2, color3, onClick } = props;

  if (!(style in serverData.tail_styles)) {
    return (
      <ImageButton
        verticalAlign="top"
        onClick={onClick}
        tooltip={props.tooltip}
        selected={props.selected}
        dmIcon="not_a_real_icon"
        dmIconState="not_a_real_icon"
        dmFallback={<Box width="64px" height="64px" />}
      >
        {props.children}
      </ImageButton>
    );
  }
  const data = serverData.tail_styles[style];

  // Must be wrapped with useCallback or else it'll rerender every frame
  const postRender = useCallback(
    async (ctx: OffscreenCanvasRenderingContext2D) => {
      ctx.globalCompositeOperation = 'source-over';

      if (data.extra_overlay) {
        const overlay = await drawColorizedIconToOffscreenCanvas(
          color2 || '#ffffff',
          data.icon,
          data.extra_overlay,
          '4',
        );
        if (overlay) {
          ctx.drawImage(overlay, 0, 0, 64, 64);
        }
      }

      if (data.extra_overlay2) {
        const overlay = await drawColorizedIconToOffscreenCanvas(
          color3 || '#ffffff',
          data.icon,
          data.extra_overlay2,
          '4',
        );
        if (overlay) {
          ctx.drawImage(overlay, 0, 0, 64, 64);
        }
      }
    },
    [data.extra_overlay, data.extra_overlay2, color2, color3],
  );

  return (
    <ColorizedImageButton
      iconRef={data.icon}
      iconState={data.icon_state}
      color={data.do_colouration ? color : '#ffffff'}
      dir={'4'}
      onClick={onClick}
      tooltip={props.tooltip}
      selected={props.selected}
      postRender={postRender}
    >
      {props.children}
    </ColorizedImageButton>
  );
};

export const TailDimmer = (props: {
  setShow: React.Dispatch<React.SetStateAction<BodyPopup>>;
  data: GeneralData;
  serverData: GeneralDataConstant;
  staticData: GeneralDataStatic;
}) => {
  const { act } = useBackend();
  const { setShow, data, serverData, staticData } = props;
  const color = data.tail_color1;
  const color2 = data.tail_color2;
  const color3 = data.tail_color3;
  const alpha = data.tail_alpha;

  const [search, setSearch] = useState('');
  const styles = staticData.available_tail_styles.filter((x) =>
    search ? x.toLowerCase().includes(search.toLowerCase()) : true,
  );
  styles.sort();

  return (
    <Section
      title="Tail"
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
              act('set_tail_color');
              break;
            case ColorType.Second:
              act('set_tail_color2');
              break;
            case ColorType.Third:
              act('set_tail_color3');
              break;
            case ColorType.Alpha:
              act('set_tail_alpha');
              break;
          }
        }}
        color_one={color || '#FFFFFF'}
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
        <TailImageButton
          key={style}
          style={style}
          serverData={serverData}
          color={color}
          color2={color2}
          color3={color3}
          tooltip={style}
          onClick={() => {
            act('set_tail_style', { style: style });
          }}
          selected={style === data.tail_style}
        >
          {style}
        </TailImageButton>
      ))}
    </Section>
  );
};
