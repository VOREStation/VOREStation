import { useBackend } from 'tgui/backend';
import {
  Box,
  Button,
  ColorBox,
  Divider,
  LabeledList,
  Stack,
} from 'tgui-core/components';
import { type BooleanLike } from 'tgui-core/react';

import {
  type GeneralData,
  type GeneralDataConstant,
  type GeneralDataStatic,
  type Trait,
  TraitCategory,
  TraitPrefType,
  type TraitSubpref,
} from './data';

function ensureRecord<T>(
  trait: string[] | Record<string, T>,
): Record<string, any> {
  if (Array.isArray(trait)) {
    const new_obj: Record<string, null> = {};
    for (let i = 0; i < trait.length; i++) {
      new_obj[trait[i]] = null;
    }
    return new_obj;
  } else {
    return trait;
  }
}

export const SubtabTraits = (props: {
  data: GeneralData;
  staticData: GeneralDataStatic;
  serverData: GeneralDataConstant;
}) => {
  const { act } = useBackend();
  const { data, staticData, serverData } = props;
  const {
    pos_traits,
    neu_traits,
    neg_traits,
    traits_cheating,
    max_traits,
    trait_points,
  } = data;
  const { all_traits } = serverData;

  const pos_traits_object = ensureRecord(pos_traits);
  const neu_traits_object = ensureRecord(neu_traits);
  const neg_traits_object = ensureRecord(neg_traits);

  const pos_trait_paths = Object.keys(pos_traits_object);
  const neu_trait_paths = Object.keys(neu_traits_object);
  const neg_trait_paths = Object.keys(neg_traits_object);

  const positive_and_negative_traits = pos_trait_paths.concat(neg_trait_paths);

  const traits_left = max_traits - pos_trait_paths.length;

  let points_left = trait_points;
  for (const path of positive_and_negative_traits) {
    points_left -= all_traits[path].cost;
  }

  const pos_traits_total = pos_trait_paths
    .map((x) => all_traits[x].cost)
    .reduce((a, b) => a + b, 0);
  const neg_traits_total = neg_trait_paths
    .map((x) => all_traits[x].cost)
    .reduce((a, b) => a + b, 0);

  return (
    <Stack vertical fill>
      <Stack.Item>
        <Stack justify="space-around" fontSize={2}>
          <Stack.Item>Traits Left: {traits_left}</Stack.Item>
          {traits_cheating ? (
            <Stack.Item>
              <Box bold color="bad">
                ADMIN
              </Box>
            </Stack.Item>
          ) : null}
          <Stack.Item>Points Left: {points_left}</Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item grow>
        <Stack fill>
          <Stack.Item grow>
            <Box bold textAlign="center">
              Positive Traits ({pos_traits_total})
              <Button ml={1} onClick={() => act('add_trait', { add_trait: 1 })}>
                Add
              </Button>
            </Box>
            <Divider />
            <Stack vertical fill>
              {Object.entries(pos_traits_object).map(([key, data]) => (
                <Stack.Item key={key}>
                  <TraitComponent
                    traitPath={key}
                    trait={all_traits[key]}
                    data={data}
                  />
                </Stack.Item>
              ))}
            </Stack>
          </Stack.Item>
          <Stack.Divider />
          <Stack.Item grow>
            <Box bold textAlign="center">
              Negative Traits ({neg_traits_total})
              <Button ml={1} onClick={() => act('add_trait', { add_trait: 3 })}>
                Add
              </Button>
            </Box>
            <Divider />
            <Stack vertical fill>
              {Object.entries(neg_traits_object).map(([key, data]) => (
                <Stack.Item key={key}>
                  <TraitComponent
                    traitPath={key}
                    trait={all_traits[key]}
                    data={data}
                  />
                </Stack.Item>
              ))}
            </Stack>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Divider />
      <Stack.Item grow>
        <Box bold>
          Neutral Traits
          <Button ml={1} onClick={() => act('add_trait', { add_trait: 2 })}>
            Add
          </Button>
        </Box>
        <Divider />
        <Stack vertical fill>
          {Object.entries(neu_traits_object).map(([key, data]) => (
            <Stack.Item key={key}>
              <TraitComponent
                traitPath={key}
                trait={all_traits[key]}
                data={data}
              />
            </Stack.Item>
          ))}
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

export const TraitComponent = (props: {
  traitPath: string;
  trait: Trait;
  data: any;
}) => {
  const { act } = useBackend();
  const { traitPath, trait, data } = props;

  return (
    <Box>
      <Button
        onClick={() =>
          act(
            trait.category === TraitCategory.Positive
              ? 'clicked_pos_trait'
              : trait.category === TraitCategory.Neutral
                ? 'clicked_neu_trait'
                : 'clicked_neg_trait',
            { trait: traitPath },
          )
        }
      >
        {trait.name} ({trait.cost})
      </Button>
      {trait.has_preferences ? (
        <Box ml={4}>
          <LabeledList>
            {Object.entries(trait.has_preferences).map(
              ([prefKey, prefData]) => (
                <LabeledList.Item key={prefKey} label={prefData[1]}>
                  <TraitSubprefSelector
                    trait={traitPath}
                    prefKey={prefKey}
                    prefData={prefData}
                    data={data ? data[prefKey] : undefined}
                  />
                </LabeledList.Item>
              ),
            )}
          </LabeledList>
        </Box>
      ) : null}
    </Box>
  );
};

export const TraitSubprefSelector = (props: {
  trait: string;
  prefKey: string;
  prefData: TraitSubpref;
  data: any;
}) => {
  const { act } = useBackend();
  const { trait, prefKey, prefData, data } = props;

  if (data === undefined) {
    return (
      <Box>Preference Error, please remove and readd this preference.</Box>
    );
  }

  switch (prefData[0]) {
    case TraitPrefType.TRAIT_PREF_TYPE_BOOLEAN:
      return (
        <Button
          onClick={() =>
            act('clicked_trait_pref', {
              clicked_trait_pref: trait,
              pref: prefKey,
            })
          }
          selected={!!data}
        >
          {(!!data as BooleanLike) ? 'Enabled' : 'Disabled'}
        </Button>
      );
    case TraitPrefType.TRAIT_PREF_TYPE_COLOR:
      return (
        <>
          <ColorBox color={data as string} />
          <Button
            onClick={() =>
              act('clicked_trait_pref', {
                clicked_trait_pref: trait,
                pref: prefKey,
              })
            }
          >
            Change
          </Button>
        </>
      );
    case TraitPrefType.TRAIT_PREF_TYPE_STRING:
      return (
        <Button
          onClick={() =>
            act('clicked_trait_pref', {
              clicked_trait_pref: trait,
              pref: prefKey,
            })
          }
        >
          {`${data}`}
        </Button>
      );
  }
};
