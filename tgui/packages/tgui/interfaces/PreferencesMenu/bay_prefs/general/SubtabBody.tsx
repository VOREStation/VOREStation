import { useState } from 'react';
import { Box, Button, ColorBox, Icon, Stack } from 'tgui-core/components';

import { useBackend } from '../../../../backend';
import { CustomImageButton } from '../helper_components';
import { EarsDimmer, EarsImageButton } from './body/Ears';
import { EarsSecondaryDimmer } from './body/EarsSecondary';
import { FacialDimmer, FacialImageButton } from './body/Facial';
import { GradientDimmer, GradientImageButton } from './body/Gradient';
import { HairDimmer, HairImageButton } from './body/Hair';
import { MarkingsPopup } from './body/Markings';
import { TailDimmer, TailImageButton } from './body/Tail';
import { WingsDimmer, WingsImageButton } from './body/Wings';
import {
  AppearanceFlags,
  BodypartFlags,
  type GeneralData,
  type GeneralDataConstant,
  type GeneralDataStatic,
  is_organ,
  OrganStatus,
  proper_organ_name,
  type Species,
} from './data';

export const SubtabBody = (props: {
  data: GeneralData;
  staticData: GeneralDataStatic;
  serverData: GeneralDataConstant;
}) => {
  const { data, staticData, serverData } = props;
  const {
    species,
    eyes_color,
    skin_color,
    s_tone,
    b_type,
    digitigrade,
    synth_color,
    synth_color_toggle,
    synth_markings,
  } = data;
  const { digi_allowed } = staticData;
  const { species: species_list } = serverData;
  // if it's not there our entire UI is fucked anyways
  const our_species = species_list.find((x) => x.name === species) as Species;
  const { act } = useBackend();

  const [visiblePopup, setVisiblePopup] = useState<BodyPopup>(BodyPopup.None);

  if (visiblePopup !== BodyPopup.None) {
    return (
      <BodyPopupDimmer
        {...props}
        visiblePopup={visiblePopup}
        setVisiblePopup={setVisiblePopup}
      />
    );
  }

  return (
    <Stack fill>
      <Stack.Item>
        <BodyBuilder
          data={data}
          staticData={staticData}
          serverData={serverData}
          setVisiblePopup={setVisiblePopup}
        />
      </Stack.Item>
      <Stack.Item grow textAlign="right">
        <Button onClick={() => setVisiblePopup(BodyPopup.Markings)} mb={1}>
          Edit Markings
        </Button>
        {our_species.appearance_flags & AppearanceFlags.HAS_EYE_COLOR ? (
          <Box>
            <Button inline onClick={() => act('eye_color')}>
              Eyes Color
            </Button>{' '}
            <ColorBox color={eyes_color} />
          </Box>
        ) : null}
        {our_species.appearance_flags & AppearanceFlags.HAS_SKIN_TONE ? (
          <Box>
            <Button inline onClick={() => act('skin_tone')}>
              Skin Tone
            </Button>{' '}
            {s_tone}/220
          </Box>
        ) : null}
        {our_species.appearance_flags & AppearanceFlags.HAS_SKIN_COLOR ? (
          <Box>
            <Button inline onClick={() => act('skin_color')}>
              Body Color
            </Button>{' '}
            <ColorBox color={skin_color} />
          </Box>
        ) : null}
        {digi_allowed ? (
          <Box>
            Digitgrade:{' '}
            <Button inline onClick={() => act('digitigrade')}>
              {digitigrade ? 'Yes' : 'No'}
            </Button>
          </Box>
        ) : null}
        <Box>
          Blood Type:{' '}
          <Button inline onClick={() => act('blood_type')}>
            {b_type}
          </Button>
        </Box>
        <details>
          <summary style={{ cursor: 'pointer' }}>Synthetic Options</summary>
          <Box>
            <Box>
              Allow Synth markings:{' '}
              <Button inline onClick={() => act('synth_markings')}>
                {synth_markings ? 'Yes' : 'No'}
              </Button>
            </Box>
            <Box>
              Allow Synth Color:{' '}
              <Button inline onClick={() => act('synth_color_toggle')}>
                {synth_color_toggle ? 'Yes' : 'No'}
              </Button>
            </Box>
            {synth_color_toggle ? (
              <Box>
                Synth Color:{' '}
                <Button inline onClick={() => act('synth_color')}>
                  Change
                </Button>{' '}
                <ColorBox color={synth_color} />
              </Box>
            ) : null}
            <OrganBuilder
              data={data}
              staticData={staticData}
              serverData={serverData}
            />
          </Box>
        </details>
      </Stack.Item>
    </Stack>
  );
};

const BodyBuilder = (props: {
  data: GeneralData;
  staticData: GeneralDataStatic;
  serverData: GeneralDataConstant;
  setVisiblePopup: React.Dispatch<React.SetStateAction<BodyPopup>>;
}) => {
  const { data, staticData, serverData, setVisiblePopup } = props;

  return (
    <Stack vertical width="fit-content">
      <Stack.Item textAlign="center">
        <EarsImageButton
          color={data.ears_color1}
          color2={data.ears_color2}
          color3={data.ears_color3}
          style={data.ear_style || 'None'}
          serverData={serverData}
          onClick={() => setVisiblePopup(BodyPopup.Ears)}
          tooltip={data.ear_style || 'None'}
        >
          Ears
        </EarsImageButton>
        <EarsImageButton
          color={data.ear_secondary_colors[0]}
          color2={data.ear_secondary_colors[1]}
          color3={data.ear_secondary_colors[2]}
          style={data.ear_secondary_style || 'None'}
          serverData={serverData}
          onClick={() => setVisiblePopup(BodyPopup.Ears2)}
          tooltip={data.ear_secondary_style || 'None'}
        >
          Horns
        </EarsImageButton>
      </Stack.Item>
      <Stack.Item>
        <WingsImageButton
          style={data.wing_style}
          color={data.wing_color1}
          color2={data.wing_color2}
          color3={data.wing_color3}
          serverData={serverData}
          onClick={() => setVisiblePopup(BodyPopup.Wings)}
          tooltip={data.wing_style}
        >
          Wings
        </WingsImageButton>
        <HairImageButton
          hairColor={data.hair_color}
          hairStyle={data.h_style}
          serverData={serverData}
          onClick={() => setVisiblePopup(BodyPopup.Hair)}
          tooltip={data.h_style}
        >
          Hair
        </HairImageButton>
        <GradientImageButton
          color={data.grad_color}
          style={data.grad_style}
          serverData={serverData}
          onClick={() => setVisiblePopup(BodyPopup.Gradient)}
          tooltip={data.grad_style}
        >
          Gradient
        </GradientImageButton>
      </Stack.Item>
      <Stack.Item>
        <TailImageButton
          style={data.tail_style}
          color={data.tail_color1}
          color2={data.tail_color2}
          color3={data.tail_color3}
          serverData={serverData}
          onClick={() => setVisiblePopup(BodyPopup.Tail)}
          tooltip={data.tail_style}
        >
          Tail
        </TailImageButton>
        <FacialImageButton
          hairColor={data.facial_color}
          hairStyle={data.f_style}
          serverData={serverData}
          onClick={() => setVisiblePopup(BodyPopup.Facial)}
          tooltip={data.f_style}
        >
          Facial
        </FacialImageButton>
      </Stack.Item>
    </Stack>
  );
};

export enum BodyPopup {
  None,
  Hair,
  Facial,
  Gradient,
  Ears,
  Ears2,
  Markings,
  Tail,
  Wings,
}

export const BodyPopupDimmer = (props: {
  data: GeneralData;
  staticData: GeneralDataStatic;
  serverData: GeneralDataConstant;
  visiblePopup: BodyPopup;
  setVisiblePopup: React.Dispatch<React.SetStateAction<BodyPopup>>;
}) => {
  const { data, staticData, serverData, visiblePopup, setVisiblePopup } = props;

  switch (visiblePopup) {
    case BodyPopup.Hair: {
      return (
        <HairDimmer
          data={data}
          staticData={staticData}
          serverData={serverData}
          setShow={setVisiblePopup}
        />
      );
    }
    case BodyPopup.Facial: {
      return (
        <FacialDimmer
          data={data}
          staticData={staticData}
          serverData={serverData}
          setShow={setVisiblePopup}
        />
      );
    }
    case BodyPopup.Gradient: {
      return (
        <GradientDimmer
          data={data}
          staticData={staticData}
          serverData={serverData}
          setShow={setVisiblePopup}
        />
      );
    }
    case BodyPopup.Ears: {
      return (
        <EarsDimmer
          data={data}
          staticData={staticData}
          serverData={serverData}
          setShow={setVisiblePopup}
        />
      );
    }
    case BodyPopup.Ears2: {
      return (
        <EarsSecondaryDimmer
          data={data}
          staticData={staticData}
          serverData={serverData}
          setShow={setVisiblePopup}
        />
      );
    }
    case BodyPopup.Markings: {
      return (
        <MarkingsPopup
          data={data}
          staticData={staticData}
          serverData={serverData}
          setShow={setVisiblePopup}
        />
      );
    }
    case BodyPopup.Wings: {
      return (
        <WingsDimmer
          data={data}
          staticData={staticData}
          serverData={serverData}
          setShow={setVisiblePopup}
        />
      );
    }
    case BodyPopup.Tail: {
      return (
        <TailDimmer
          data={data}
          staticData={staticData}
          serverData={serverData}
          setShow={setVisiblePopup}
        />
      );
    }
  }
};

const OrganBuilder = (props: {
  data: GeneralData;
  staticData: GeneralDataStatic;
  serverData: GeneralDataConstant;
}) => {
  const { data, staticData, serverData } = props;
  const { organ_data, rlimb_data } = data;
  const { act } = useBackend();

  return (
    <Box
      style={{
        display: 'grid',
        gridTemplateColumns: '1fr 1fr 1fr 1fr',
        columnGap: '8%',
        direction: 'rtl',
      }}
    >
      {Object.values(BodypartFlags).map((flag: BodypartFlags) => {
        const status = organ_data[flag];
        const robolimb = rlimb_data[flag] || 'Unbranded';

        let status_text = 'Normal';
        let icon = 'dna';
        switch (status) {
          case OrganStatus.Cyborg:
            icon = 'robot';
            status_text = `${robolimb} Prosthesis`;
            break;
          case OrganStatus.Amputated:
            icon = 'bone';
            status_text = 'Amputated';
            break;
          case OrganStatus.Mechanical:
            icon = 'robot';
            if (flag === BodypartFlags.O_BRAIN) {
              status_text = 'Positronic';
            } else {
              status_text = 'Synthetic';
            }
            break;
          case OrganStatus.Digital:
            icon = 'wifi';
            status_text = 'Digital';
            break;
          case OrganStatus.Assisted:
            switch (flag) {
              case BodypartFlags.O_HEART:
                icon = 'heart-circle-bolt';
                status_text = 'Pacemaker-assisted';
                break;
              case BodypartFlags.O_LUNGS:
                icon = 'lungs-virus';
                status_text = 'Assisted';
                break;
              case BodypartFlags.O_VOICE:
                icon = 'phone';
                status_text = 'Surgically Altered';
                break;
              case BodypartFlags.O_EYES:
                icon = 'eye';
                status_text = 'Retinal overlayed';
                break;
              case BodypartFlags.O_BRAIN:
                icon = 'brain';
                status_text = 'Assisted-interface';
                break;
              default:
                icon = 'robot';
                status_text = 'Mechanically assisted';
                break;
            }
            break;
        }

        return (
          <CustomImageButton
            key={flag}
            image={<Icon size={2} name={icon} />}
            tooltip={status_text}
            onClick={() =>
              act(
                is_organ(flag)
                  ? 'robolimb_select_organ'
                  : 'robolimb_select_bodypart',
                { zone: flag },
              )
            }
          >
            <Box style={{ textTransform: 'capitalize' }}>
              {proper_organ_name(flag)}
            </Box>
          </CustomImageButton>
        );
      })}
      <CustomImageButton
        image={<Icon name="refresh" size={2} />}
        onClick={() => act('reset_limbs')}
      >
        Reset
      </CustomImageButton>
    </Box>
  );
};
