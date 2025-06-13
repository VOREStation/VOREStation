import { useState } from 'react';
import { resolveAsset } from 'tgui/assets';
import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  Dimmer,
  DmIcon,
  Image,
  ImageButton,
  Stack,
} from 'tgui-core/components';
import { type BooleanLike } from 'tgui-core/react';

import {
  AppearanceFlags,
  type GeneralData,
  type GeneralDataConstant,
  type GeneralDataStatic,
  SpawnFlags,
  type Species,
  SpeciesFlags,
} from './data';

const rarity2text = (rarity: number) => {
  switch (rarity) {
    case 1:
    case 2:
      return 'Often present on human stations.';
    case 3:
    case 4:
      return 'Rarely present on human stations.';
    case 5:
      return 'Unheard of on human stations.';
    default:
      return 'May be present on human stations.';
  }
};

const SpeciesImage = (props: { species_name: string }) => {
  const { species_name } = props;
  if (species_name === 'Custom Species') {
    return (
      <Image
        width={6}
        height={6}
        src={resolveAsset('preview_custom_animation.gif')}
      />
    );
  } else if (species_name === 'Protean') {
    return (
      <Image
        width={6}
        height={6}
        src={resolveAsset('preview_protean_animation.gif')}
      />
    );
  }
  return (
    <DmIcon
      icon="icons/mob/human_races/preview.dmi"
      icon_state={species_name}
      width={6}
      height={6}
    />
  );
};

const SpeciesImageButton = (props: {
  species_name: string;
  onClick: () => void;
  selected: BooleanLike;
}) => {
  const { species_name, onClick, selected } = props;
  if (species_name === 'Custom Species') {
    return (
      <ImageButton
        key={species_name}
        imageSrc={resolveAsset('preview_custom_animation.gif')}
        selected={selected}
        onClick={onClick}
      >
        {species_name}
      </ImageButton>
    );
  } else if (species_name === 'Protean') {
    return (
      <ImageButton
        key={species_name}
        imageSrc={resolveAsset('preview_protean_animation.gif')}
        selected={selected}
        onClick={onClick}
      >
        {species_name}
      </ImageButton>
    );
  }

  return (
    <ImageButton
      key={species_name}
      dmIcon={'icons/mob/human_races/preview.dmi'}
      dmIconState={species_name}
      selected={selected}
      onClick={onClick}
    >
      {species_name}
    </ImageButton>
  );
};

export const SubtabSpecies = (props: {
  data: GeneralData;
  staticData: GeneralDataStatic;
  serverData: GeneralDataConstant;
}) => {
  const { act } = useBackend();
  const { data, staticData, serverData } = props;
  const { species } = serverData;
  const { can_play } = staticData;
  const [viewingSpecies, setViewingSpecies] = useState<string>('');

  species.sort((a, b) => a.name.localeCompare(b.name));
  const viewed_species: Species | undefined = species.find(
    (x) => x.name === viewingSpecies,
  );

  return (
    <Stack fill vertical>
      {viewed_species ? (
        <Dimmer>
          <Box
            backgroundColor="#1a1a1a"
            width={40}
            height={20}
            overflowY="auto"
            p={1}
            style={{ borderRadius: '10px' }}
          >
            <Stack>
              <Stack.Item basis="60%">
                <Box bold fontSize={2} mb={1}>
                  {viewed_species.name}
                </Box>
                <Box>
                  {/* eslint-disable react/no-danger */}
                  <div
                    dangerouslySetInnerHTML={{ __html: viewed_species.blurb }}
                  />
                </Box>
              </Stack.Item>
              <Stack.Item grow textAlign="center">
                <Stack vertical p={1}>
                  <Stack.Item textAlign="right">
                    <Button
                      icon="window-close"
                      color="bad"
                      onClick={() => setViewingSpecies('')}
                    />
                  </Stack.Item>
                  <Stack.Item>
                    <SpeciesImage species_name={viewed_species.name} />
                    {/* <DmIcon
                      icon={'icons/mob/human_races/preview.dmi'}
                      icon_state={viewed_species.name}
                      width={6}
                      height={6}
                    /> */}
                  </Stack.Item>
                  <Stack.Item>
                    Language: {viewed_species.species_language}
                  </Stack.Item>
                  <Stack.Item fontSize={0.8}>
                    <Box>{rarity2text(viewed_species.rarity)}</Box>
                    {viewed_species.spawn_flags &
                    SpawnFlags.SPECIES_IS_WHITELISTED ? (
                      <Box>Whitelist restricted.</Box>
                    ) : null}
                    {viewed_species.has_organ['heart'] ? null : (
                      <Box>Does not have a circulatory system.</Box>
                    )}
                    {viewed_species.has_organ['lungs'] ? null : (
                      <Box>Does not have a respiratory system.</Box>
                    )}
                    {viewed_species.flags & SpeciesFlags.NO_DNA ? (
                      <Box>Does not have DNA.</Box>
                    ) : null}
                    {viewed_species.flags & SpeciesFlags.NO_SLEEVE ? (
                      <Box>Cannot be cloned.</Box>
                    ) : null}
                    {viewed_species.flags & SpeciesFlags.NO_DEFIB ? (
                      <Box>Cannot be defibrillated.</Box>
                    ) : null}
                    {viewed_species.flags & SpeciesFlags.NO_PAIN ? (
                      <Box>Does not feel pain.</Box>
                    ) : null}
                    {viewed_species.flags & SpeciesFlags.NO_SLIP ? (
                      <Box>Has excellent traction.</Box>
                    ) : null}
                    {viewed_species.flags & SpeciesFlags.NO_POISON ? (
                      <Box>Immune to most poisons.</Box>
                    ) : null}
                    {viewed_species.flags & SpeciesFlags.PLANT ? (
                      <Box>Has a plantlike physiology.</Box>
                    ) : null}
                    {viewed_species.appearance_flags &
                    AppearanceFlags.HAS_SKIN_TONE ? (
                      <Box>Has a variety of skin tones.</Box>
                    ) : null}
                    {viewed_species.appearance_flags &
                    AppearanceFlags.HAS_SKIN_COLOR ? (
                      <Box>Has a variety of skin colors.</Box>
                    ) : null}
                    {viewed_species.appearance_flags &
                    AppearanceFlags.HAS_EYE_COLOR ? (
                      <Box>Has a variety of eye colors.</Box>
                    ) : null}
                  </Stack.Item>
                  {can_play[viewed_species.name].restricted === 2 ? (
                    <Stack.Item>
                      You cannot play as this species. If you wish to be
                      whitelisted, you can make an application post on the
                      forums or discord.
                    </Stack.Item>
                  ) : can_play[viewed_species.name].restricted === 1 ? (
                    <Stack.Item>
                      You cannot play as this race. This species is not
                      available for play as a station race.
                    </Stack.Item>
                  ) : null}
                  <Stack.Item>
                    <Button
                      disabled={!can_play[viewed_species.name].can_select}
                      color={
                        can_play[viewed_species.name].can_select
                          ? 'good'
                          : 'bad'
                      }
                      onClick={() =>
                        act('set_species', { species: viewed_species.name })
                      }
                    >
                      Select
                    </Button>
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            </Stack>
          </Box>
        </Dimmer>
      ) : null}
      <Stack.Item>
        {species.map((species) => (
          <SpeciesImageButton
            key={species.name}
            onClick={() => setViewingSpecies(species.name)}
            selected={species.name === data.species}
            species_name={species.name}
          />
        ))}
      </Stack.Item>
    </Stack>
  );
};
