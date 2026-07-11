import { useBackend } from 'tgui/backend';
import { Box, Button, Table } from 'tgui-core/components';
import { buildMultiplier } from './functions';
import type { Data, Recipe } from './types';

export const RecipeElement = (props: { recipe: Recipe; title: string }) => {
  const { act, data } = useBackend<Data>();

  const { amount } = data;

  const { recipe, title } = props;

  const { res_amount, max_res_amount, req_amount, ref } = recipe;

  let buttonName = title;
  buttonName += ' (';
  buttonName += `${req_amount} `;
  buttonName += `sheet${req_amount > 1 ? 's' : ''}`;
  buttonName += ')';

  if (res_amount > 1) {
    buttonName = `${res_amount}x ${buttonName}`;
  }

  const maxMultiplier = buildMultiplier(recipe, amount);

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

const Multipliers = (props) => {
  const { act, data } = useBackend();

  const { recipe, maxMultiplier } = props;

  const maxM = Math.min(
    maxMultiplier,
    Math.floor(recipe.max_res_amount / recipe.res_amount),
  );

  const multipliers = [5, 10, 25];

  const finalResult: React.JSX.Element[] = [];

  for (const multiplier of multipliers) {
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
          {`${multiplier * recipe.res_amount}x`}
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
        {`${maxM * recipe.res_amount}x`}
      </Button>,
    );
  }

  return finalResult;
};
