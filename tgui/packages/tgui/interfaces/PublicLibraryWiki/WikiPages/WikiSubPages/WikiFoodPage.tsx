import { LabeledList, Section, Stack } from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';

import type { FoodData } from '../../types';
import { ChemicalReactionList } from '../../WikiCommon/WikiChemList';
import { ColorizedImage } from '../../WikiCommon/WikiColorIcon';
import { RecipeList } from '../../WikiCommon/WikiFoodList';
import { WikiSpoileredList } from '../../WikiCommon/WikiListElements';
import { NotAvilableBox } from '../../WikiCommon/WikiQuickElements';

export const WikiFoodPage = (props: { food: FoodData }) => {
  const {
    title,
    description,
    flavor,
    allergen,
    grinding,
    instant_reactions,
    distilled_reactions,
    fluid,
    produces,
    icon_data,
    recipe,
  } = props.food;

  return (
    <Section fill scrollable title={capitalize(title)}>
      <Stack vertical fill>
        <Stack.Item grow>
          <LabeledList>
            <LabeledList.Item label="Icon">
              <ColorizedImage
                icon={icon_data.icon}
                iconState={icon_data.state}
                color={icon_data.color}
              />
            </LabeledList.Item>
            <LabeledList.Divider />
            <LabeledList.Item label="Description">
              {description ? description : <NotAvilableBox />}
            </LabeledList.Item>
            <LabeledList.Item label="Flavor">
              {flavor ? flavor : <NotAvilableBox />}
            </LabeledList.Item>
            {!!allergen && (
              <WikiSpoileredList
                ourKey={title}
                entries={allergen}
                title={'Allergens'}
              />
            )}
            {!!recipe && <RecipeList title={title} recipe={recipe} />}
            {!recipe && (
              <ChemicalReactionList
                ourKey={title}
                grinding={grinding || null}
                instant_reactions={instant_reactions || null}
                distilled_reactions={distilled_reactions || null}
                fluid={fluid || null}
                produces={produces || null}
              />
            )}
          </LabeledList>
        </Stack.Item>
      </Stack>
    </Section>
  );
};
