import { Fragment } from 'react';
import { Box, Collapsible, LabeledList, Section } from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';

import type {
  DistillComponent,
  DistilledReactions,
  GroundMaterial,
  InstantReactions,
} from '../types';
import { WikiSpoileredList } from './WikiListElements';
import { MinMaxBox, MinMaxBoxTemperature } from './WikiQuickElements';

const BaseChem = (props) => {
  return <Box color="red">UNKNOWN OR BASE REAGENT</Box>;
};

export const ChemicalReactionList = (props: {
  ourKey: string;
  grinding: GroundMaterial | null;
  instant_reactions: InstantReactions | null;
  distilled_reactions: DistilledReactions | null;
  fluid: string[] | null;
  produces: string[] | null;
}) => {
  const {
    ourKey,
    grinding,
    instant_reactions,
    distilled_reactions,
    fluid,
    produces,
  } = props;

  return (
    <>
      <>
        <LabeledList.Divider />
        <LabeledList.Item label={'Instant Reactions'}>
          <Collapsible
            key={ourKey}
            color="transparent"
            title={'Reveal Potential Instant Reactions'}
          >
            {instant_reactions ? (
              Array.isArray(instant_reactions) ? (
                instant_reactions.map((reactionTypes, index) =>
                  getReactionComponents(reactionTypes, 'Breakdown', index + 1),
                )
              ) : (
                Object.keys(instant_reactions).map((reaction) =>
                  getReactionComponents(
                    instant_reactions[reaction],
                    'Breakdown',
                    1,
                  ),
                )
              )
            ) : (
              <BaseChem />
            )}
          </Collapsible>
        </LabeledList.Item>
      </>
      {!!distilled_reactions && (
        <>
          <LabeledList.Divider />
          <LabeledList.Item label={'Distillery Reactions'}>
            <Collapsible
              color="transparent"
              title={'Reveal Potential Distillery Reactions'}
            >
              {Array.isArray(distilled_reactions)
                ? distilled_reactions.map((reactionTypes, index) =>
                    getReactionComponents(
                      reactionTypes,
                      'Destillation',
                      index + 1,
                    ),
                  )
                : Object.keys(distilled_reactions).map((reaction) =>
                    getReactionComponents(
                      distilled_reactions[reaction],
                      'Destillation',
                      1,
                    ),
                  )}
            </Collapsible>
          </LabeledList.Item>
        </>
      )}
      {!!grinding &&
        Object.keys(grinding).map(
          (entry) =>
            !!grinding[entry] && (
              <WikiSpoileredList
                key={entry}
                ourKey={ourKey}
                entries={grinding[entry]}
                title={capitalize(entry) + ' Grinding'}
              />
            ),
        )}
      {!!fluid && (
        <WikiSpoileredList
          ourKey={ourKey}
          entries={fluid}
          title={'Fluid Pumping'}
        />
      )}
      {!!produces && (
        <WikiSpoileredList
          ourKey={ourKey}
          entries={produces}
          title={'Used To Produce'}
        />
      )}
    </>
  );
};

function getReactionComponents(
  reactionTypes: DistillComponent,
  sectionTitle: string,
  index?: number,
) {
  if (!reactionTypes) {
    return;
  }

  const componentName = reactionTypes.is_slime
    ? 'Slime Injection'
    : 'Component';

  return (
    <Section title={'Potential Chemical ' + sectionTitle + ' ' + index}>
      <LabeledList>
        {(typeof reactionTypes.temp_min === 'number' ||
          typeof reactionTypes.temp_max === 'number') && (
          <LabeledList.Item label="Temperature">
            <MinMaxBoxTemperature
              min={reactionTypes.temp_min || null}
              max={reactionTypes.temp_max || null}
              minColor="blue"
              maxColor="orange"
            />
          </LabeledList.Item>
        )}
        {(typeof reactionTypes.xgm_min === 'number' ||
          typeof reactionTypes.xgm_max === 'number') && (
          <LabeledList.Item label="XGM">
            <MinMaxBox
              min={reactionTypes.xgm_min || null}
              max={reactionTypes.xgm_max || null}
              minColor="blue"
              maxColor="orange"
            />
          </LabeledList.Item>
        )}
        {(typeof reactionTypes.temp_min === 'number' ||
          typeof reactionTypes.temp_max === 'number' ||
          typeof reactionTypes.xgm_min === 'number' ||
          typeof reactionTypes.xgm_max === 'number') && <LabeledList.Divider />}
        {!!reactionTypes.require_xgm_gas && (
          <LabeledList.Item label="Requires XGM Gas">
            {reactionTypes.require_xgm_gas}
          </LabeledList.Item>
        )}
        {!!reactionTypes.rejects_xgm_gas && (
          <LabeledList.Item label="Rejects XGM Gas">
            {reactionTypes.rejects_xgm_gas}
          </LabeledList.Item>
        )}
        {(!!reactionTypes.require_xgm_gas ||
          !!reactionTypes.rejects_xgm_gas) && <LabeledList.Divider />}
        {!!reactionTypes.required && !!reactionTypes.required.length && (
          <>
            {reactionTypes.required.map((required) => (
              <Fragment key={required}>
                {!!reactionTypes.is_slime && (
                  <>
                    <LabeledList.Item label="- Slime Type">
                      {capitalize(reactionTypes.is_slime)}
                    </LabeledList.Item>
                    <LabeledList.Divider />
                  </>
                )}
                <LabeledList.Item label={' - ' + componentName}>
                  {required}
                </LabeledList.Item>
              </Fragment>
            ))}
          </>
        )}
        {!!reactionTypes.inhibitor && !!reactionTypes.inhibitor.length && (
          <>
            <LabeledList.Divider />
            {reactionTypes.inhibitor.map((inhibitor) => (
              <LabeledList.Item key={inhibitor} label="- Inhibitor">
                {inhibitor}
              </LabeledList.Item>
            ))}
          </>
        )}
        {!!reactionTypes.catalysts && !!reactionTypes.catalysts.length && (
          <>
            <LabeledList.Divider />
            {reactionTypes.catalysts.map((catalyst) => (
              <LabeledList.Item key={catalyst} label="- Catalyst">
                {catalyst}
              </LabeledList.Item>
            ))}
          </>
        )}
      </LabeledList>
    </Section>
  );
}
