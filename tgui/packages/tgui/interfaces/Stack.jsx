import { useBackend } from '../backend';
import { Box, Button, Collapsible, Section, Table } from '../components';
import { Window } from '../layouts';

export const Stack = (props) => {
  const { act, data } = useBackend();

  const { amount, recipes } = data;

  return (
    <Window width={400} height={600}>
      <Window.Content scrollable>
        <Section title={'Amount: ' + amount}>
          <RecipeList recipes={recipes} />
        </Section>
      </Window.Content>
    </Window>
  );
};

const RecipeList = (props) => {
  const { act, data } = useBackend();

  const { recipes } = props;

  let sortedKeys = Object.keys(recipes).sort();

  // Shunt all categories to the top.
  // We're not using this for now, keeping it here in case someone really hates color coding later.
  // let nonCategories = sortedKeys.filter(item => recipes[item].ref !== undefined);
  // let categories = sortedKeys.filter(item => recipes[item].ref === undefined);

  // categories.unshift("--DIVIDER--");

  // let newSortedKeys = nonCategories.concat(categories);

  return sortedKeys.map((title, index) => {
    // if (title === "--DIVIDER--") {
    //   return (
    //     <Box mt={1} mb={1}>
    //       <Divider />
    //     </Box>
    //   );
    // }
    let recipe = recipes[title];
    if (recipe.ref === undefined) {
      return (
        <Collapsible key={index} ml={1} mb={-0.7} color="label" title={title}>
          <Box ml={1}>
            <RecipeList recipes={recipe} />
          </Box>
        </Collapsible>
      );
    } else {
      return <Recipe key={index} title={title} recipe={recipe} />;
    }
  });
};

const buildMultiplier = (recipe, amount) => {
  if (recipe.req_amount > amount) {
    return 0;
  }

  return Math.floor(amount / recipe.req_amount);
};

const Multipliers = (props) => {
  const { act, data } = useBackend();

  const { recipe, maxMultiplier } = props;

  let maxM = Math.min(
    maxMultiplier,
    Math.floor(recipe.max_res_amount / recipe.res_amount),
  );

  let multipliers = [5, 10, 25];

  let finalResult = [];

  for (let multiplier of multipliers) {
    if (maxM >= multiplier) {
      finalResult.push(
        <Button
          onClick={() =>
            act('make', {
              ref: recipe.ref,
              multiplier: multiplier,
            })
          }
        >
          {multiplier * recipe.res_amount + 'x'}
        </Button>,
      );
    }
  }

  if (multipliers.indexOf(maxM) === -1) {
    finalResult.push(
      <Button
        onClick={() =>
          act('make', {
            ref: recipe.ref,
            multiplier: maxM,
          })
        }
      >
        {maxM * recipe.res_amount + 'x'}
      </Button>,
    );
  }

  return finalResult;
};

const Recipe = (props) => {
  const { act, data } = useBackend();

  const { amount } = data;

  const { recipe, title } = props;

  const { res_amount, max_res_amount, req_amount, ref } = recipe;

  let buttonName = title;
  buttonName += ' (';
  buttonName += req_amount + ' ';
  buttonName += 'sheet' + (req_amount > 1 ? 's' : '');
  buttonName += ')';

  if (res_amount > 1) {
    buttonName = res_amount + 'x ' + buttonName;
  }

  let maxMultiplier = buildMultiplier(recipe, amount);

  return (
    <Box>
      <Table>
        <Table.Row>
          <Table.Cell>
            <Button
              fluid
              disabled={!maxMultiplier}
              icon="wrench"
              onClick={() =>
                act('make', {
                  ref: recipe.ref,
                  multiplier: 1,
                })
              }
            >
              {buttonName}
            </Button>
          </Table.Cell>
          {max_res_amount > 1 && maxMultiplier > 1 && (
            <Table.Cell collapsing>
              <Multipliers recipe={recipe} maxMultiplier={maxMultiplier} />
            </Table.Cell>
          )}
        </Table.Row>
      </Table>
    </Box>
  );
};
