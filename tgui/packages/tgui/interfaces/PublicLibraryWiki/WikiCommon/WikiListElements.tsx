import {
  Box,
  Collapsible,
  Divider,
  LabeledList,
  Section,
} from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';

import type {
  DistilledReactions,
  InstantReactions,
  ReactionComponent,
} from '../types';

export const WikiSpoileredList = (props: {
  ourKey: string;
  entries: string[] | Record<string, string> | Record<string, number>;
  title: string;
}) => {
  const { entries, title, ourKey } = props;

  if (Array.isArray(entries) && entries.length) {
    return (
      <>
        <LabeledList.Divider />
        <LabeledList.Item label={title}>
          <Collapsible
            key={ourKey}
            color="transparent"
            title={'Reveal ' + title}
          >
            {entries.map((entry) => (
              <Box key={capitalize(entry)}>- {entry}</Box>
            ))}
          </Collapsible>
        </LabeledList.Item>
      </>
    );
  }

  return (
    <>
      <LabeledList.Divider />
      <LabeledList.Item label={title}>
        <Collapsible color="transparent" title={'Reveal ' + title}>
          {Object.keys(entries).map((entry) => (
            <Box key={entry}>
              - {capitalize(entry)}: {entries[entry]}
            </Box>
          ))}
        </Collapsible>
      </LabeledList.Item>
    </>
  );
};

export const WikiList = (props: {
  entries: string[] | Record<string, string> | Record<string, number>;
  title: string;
}) => {
  const { entries, title } = props;

  if (Array.isArray(entries) && entries.length) {
    return (
      <>
        <LabeledList.Divider />
        <LabeledList.Item label={title}>
          {entries.map((entry) => (
            <Box key={entry}>- {capitalize(entry)}</Box>
          ))}
        </LabeledList.Item>
      </>
    );
  }

  return (
    <>
      <LabeledList.Divider />
      <LabeledList.Item label={title}>
        {Object.keys(entries).map((entry) => (
          <Box key={entry}>
            - {capitalize(entry)}: {entries[entry]}
          </Box>
        ))}
      </LabeledList.Item>
    </>
  );
};

export const ChemicalReactionList = (props: {
  ourKey: string;
  instant_reactions: InstantReactions;
  distilled_reactions: DistilledReactions;
}) => {
  const { ourKey, instant_reactions, distilled_reactions } = props;
  return (
    <>
      {!!instant_reactions && (
        <>
          <LabeledList.Divider />
          <LabeledList.Item label={'Potential Chemical breakdown'}>
            <Collapsible
              key={ourKey}
              color="transparent"
              title={'Reveal Potential Chemical breakdown'}
            >
              {Object.keys(instant_reactions).map((reaction) =>
                Array.isArray(instant_reactions[reaction])
                  ? instant_reactions[reaction].map((reactionTypes, index) =>
                      getReactionComponents(reactionTypes, index),
                    )
                  : getReactionComponents(instant_reactions[reaction]),
              )}
            </Collapsible>
          </LabeledList.Item>
        </>
      )}
      {!!instant_reactions && (
        <>
          <LabeledList.Divider />
          <LabeledList.Item label={'Potential Chemical breakdown'}>
            <Collapsible
              color="transparent"
              title={'Reveal Potential Chemical breakdown'}
            >
              adds
            </Collapsible>
          </LabeledList.Item>
        </>
      )}
    </>
  );
};

function getReactionComponents(
  reactionTypes: ReactionComponent,
  index?: number,
) {
  if (!reactionTypes) {
    return;
  }

  const componentName = reactionTypes.is_slime
    ? 'Slime Injection'
    : 'Component';

  return (
    <Section title={'Potential Chemical Breakdown ' + index}>
      {!!reactionTypes.required && !!reactionTypes.required.length && (
        <>
          <Divider />
          {reactionTypes.required.map((required) => (
            <Box key={required}>
              {!!reactionTypes.is_slime && (
                <Box>- Slime Type: {reactionTypes.is_slime}</Box>
              )}
              <Box>
                - {componentName}: {required}
              </Box>
            </Box>
          ))}
        </>
      )}
      {!!reactionTypes.inhibitor && !!reactionTypes.inhibitor.length && (
        <>
          <Divider />
          {reactionTypes.inhibitor.map((inhibitor) => (
            <Box key={inhibitor}>- Inhibitor: {inhibitor}</Box>
          ))}
        </>
      )}
      {!!reactionTypes.catalysts && !!reactionTypes.catalysts.length && (
        <>
          <Divider />
          {reactionTypes.catalysts.map((catalyst) => (
            <Box key={catalyst}>- Catalyst: {catalyst}</Box>
          ))}
        </>
      )}
    </Section>
  );
}
