import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  ColorBox,
  Icon,
  LabeledList,
  Stack,
} from 'tgui-core/components';

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
    voice_freq,
    voice_sound,
    blood_color,
    blood_reagents,
    emote_sound_mode,
  } = data;
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
      <Stack.Item grow>
        <Stack vertical fill>
          <Stack.Item>
            <Stack fill justify="space-around">
              <Stack.Item>
                <SizePrefs
                  data={data}
                  staticData={staticData}
                  serverData={serverData}
                  setVisiblePopup={setVisiblePopup}
                />
              </Stack.Item>
              <Stack.Item textAlign="center">
                <LabeledList>
                  {our_species.appearance_flags &
                  AppearanceFlags.HAS_EYE_COLOR ? (
                    <LabeledList.Item label="Eye Color">
                      <ColorBox color={eyes_color} />
                      <Button inline ml={1} onClick={() => act('eye_color')}>
                        Change
                      </Button>{' '}
                    </LabeledList.Item>
                  ) : null}

                  {our_species.appearance_flags &
                  AppearanceFlags.HAS_SKIN_TONE ? (
                    <LabeledList.Item label="Skin Tone">
                      {s_tone}/220
                      <Button inline ml={1} onClick={() => act('skin_tone')}>
                        Change
                      </Button>
                    </LabeledList.Item>
                  ) : null}
                  {our_species.appearance_flags &
                  AppearanceFlags.HAS_SKIN_COLOR ? (
                    <LabeledList.Item label="Body Color">
                      <ColorBox color={skin_color} />
                      <Button inline ml={1} onClick={() => act('skin_color')}>
                        Change
                      </Button>
                    </LabeledList.Item>
                  ) : null}
                  <LabeledList.Item label="Digitigrade">
                    <Button
                      inline
                      onClick={() => act('digitigrade')}
                      selected={digitigrade}
                    >
                      {digitigrade ? 'Yes' : 'No'}
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item label="Blood Type">
                    <Button inline onClick={() => act('blood_type')}>
                      {b_type}
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item label="Blood Color">
                    <Button inline onClick={() => act('blood_color')}>
                      Set
                    </Button>
                    <Button inline onClick={() => act('reset_blood_color')}>
                      R
                    </Button>
                    <ColorBox color={blood_color} />
                  </LabeledList.Item>
                  <LabeledList.Item label="Blood Reagent">
                    <Button inline onClick={() => act('blood_reagents')}>
                      {blood_reagents}
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item label="Voice Frequency">
                    <Button onClick={() => act('voice_freq')}>
                      {voice_freq}
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item label="Voice Sounds">
                    <Button onClick={() => act('voice_sounds_list')}>
                      {voice_sound || 'Default'}
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item label="Emote Sound Mode">
                    <Button onClick={() => act('emote_sound_mode')}>
                      {emote_sound_mode}
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item>
                    <Button onClick={() => act('voice_test')}>
                      Test Selected Voice
                    </Button>
                  </LabeledList.Item>
                </LabeledList>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item grow>
            <details>
              <summary style={{ cursor: 'pointer' }}>Synthetic Options</summary>
              <Box>
                <LabeledList>
                  <LabeledList.Item label="Allow Synth markings">
                    <Button onClick={() => act('synth_markings')}>
                      {synth_markings ? 'Yes' : 'No'}
                    </Button>
                  </LabeledList.Item>
                  <LabeledList.Item label="Allow Synth Color">
                    <Button inline onClick={() => act('synth_color_toggle')}>
                      {synth_color_toggle ? 'Yes' : 'No'}
                    </Button>
                  </LabeledList.Item>
                  {synth_color_toggle ? (
                    <LabeledList.Item label="Synth Color">
                      <Button inline onClick={() => act('synth_color')}>
                        Change
                      </Button>{' '}
                      <ColorBox color={synth_color} />
                    </LabeledList.Item>
                  ) : null}
                </LabeledList>
                <OrganBuilder
                  data={data}
                  staticData={staticData}
                  serverData={serverData}
                />
              </Box>
            </details>
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

const SizePrefs = (props: {
  data: GeneralData;
  staticData: GeneralDataStatic;
  serverData: GeneralDataConstant;
  setVisiblePopup: React.Dispatch<React.SetStateAction<BodyPopup>>;
}) => {
  const { act } = useBackend();
  const { data, staticData, serverData, setVisiblePopup } = props;
  const {
    size_multiplier,
    fuzzy,
    offset_override,
    weight_vr,
    weight_gain,
    weight_loss,
  } = data;

  return (
    <Stack vertical>
      <Stack.Item textAlign="center">
        <Button
          onClick={() => setVisiblePopup(BodyPopup.Markings)}
          mb={1}
          icon="paint-roller"
          fontSize={1.2}
        >
          Edit Markings
        </Button>
      </Stack.Item>
      <Stack.Item>
        <LabeledList>
          <LabeledList.Item label="Scale">
            <Button onClick={() => act('size_multiplier')}>
              {size_multiplier}%
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Scaled Appearance">
            <Button onClick={() => act('toggle_fuzzy')}>
              {fuzzy ? 'Fuzzy' : 'Sharp'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Scaling Center">
            <Button onClick={() => act('toggle_offset_override')}>
              {offset_override ? 'Odd' : 'Even'}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Relative Weight">
            <Button onClick={() => act('weight')}>{weight_vr}</Button>
          </LabeledList.Item>
          <LabeledList.Item label="Weight Gain Rate">
            <Button onClick={() => act('weight_gain')}>{weight_gain}</Button>
          </LabeledList.Item>
          <LabeledList.Item label="Weight Loss Rate">
            <Button onClick={() => act('weight_loss')}>{weight_loss}</Button>
          </LabeledList.Item>
        </LabeledList>
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
