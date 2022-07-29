import { Fragment } from 'inferno';
import { flow } from 'common/fp';
import { filter, sortBy } from 'common/collections';
import { useBackend, useSharedState } from "../backend";
import { Button, Flex, Input, Section, Dropdown, Box, Table, Tooltip } from "../components";
import { Window } from "../layouts";
import { createSearch, toTitleCase } from 'common/string';
import { classes } from 'common/react';
import { ComplexModal, modalOpen } from '../interfaces/common/ComplexModal';

export const Synthesizer = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    screen,
    recipes,
    busy,
    categories,
  } = data;
  const { recipe } = props;
  return (
    <Table.Row>
      <Table.Cell collapsing>
        {(recipe.isatom && (
          <span
            className={classes(['synthesizer32x32', recipe.path])}
            style={{
              'vertical-align': 'middle',
              'horizontal-align': 'middle',
            }}
          />
        )) ||
          null}

  let body;
  if (screen === 1) {
    // Menu time!
    body = <AppatizerMenu />;
  } else if (screen === 2) {
    body = <BreakfastMenu />;
  } else if (screen === 3) {
    body = <LunchMenu />;
  } else if (screen === 4) {
    body = <DinnerMenu />;
  } else if (screen === 5) {
    body = <DessertMenu />;
  } else if (screen === 6) {
    body = <ExoticMenu />;
  } else if (screen === 7) {
    body = <RawMenu />;
  } else if (screen === 8) {
    body = <CrewMenu />;
  }

  return (
    <Window width={700} height={680} resizable>
      <ComplexModal maxHeight="100%" maxWidth="400px" />
      <Window.Content scrollable>
        <LoginInfo />
        <TemporaryNotice />
        <SecurityRecordsNavigation />
        <Section flexGrow>{body}</Section>
      </Window.Content>
    </Window>
  );
};

const AppatizerMenu = (_properties, context) => {
  const { act, data } = useBackend(context);
  const { records } = data;
  return (
    <Fragment>
      <Input
        fluid
        placeholder="Search by Name"
        onChange={(_event, value) => act('search', { t1: value })}
      />
      <Box mt="0.5rem">
        {records.map((record, i) => (
          <Button
            color={recipe.hidden && "red" || null}
            icon="hammer"
            iconSpin={busy === recipe.name}
            onClick={() => act("make", { make: recipe.ref })}>
            {toTitleCase(recipe.name)}

            key={i}
            icon="user"
            mb="0.5rem"
            color={record.color}
            content={record.id + ': ' + record.name + ' (Criminal Status: ' + record.criminal + ')'}
            onClick={() => act('d_rec', { d_rec: record.ref })}
          />
        ))}
      </Box>
    </Fragment>
  );
};
  const [category, setCategory] = useSharedState(context, "category", 0);

  const [
    searchText,
    setSearchText,
  ] = useSharedState(context, "search_text", "");

  const testSearch = createSearch(searchText, recipe => recipe.name);

  const recipesToShow = flow([
    filter(recipe => recipe.category === categories[category]),
    searchText && filter(testSearch),
    sortBy(recipe => recipe.name.toLowerCase()),
  ])(recipes);

  return (
    <Window width={550} height={700}>
      <Window.Content scrollable>
        <Section title="Recipes" buttons={
          <Dropdown
            width="190px"
            options={categories}
            selected={categories[category]}
            onSelected={val => setCategory(categories.indexOf(val))} />
        }>
          <Input
            fluid
            placeholder="Search for..."
            onInput={(e, v) => setSearchText(v)}
            mb={1} />
          {recipesToShow.map(recipe => (
            <Flex justify="space-between" align="center" key={recipe.ref}>
              <Flex.Item>
                <Button
                  color={recipe.hidden && "red" || null}
                  icon="hammer"
                  iconSpin={busy === recipe.name}
                  onClick={() => act("make", { make: recipe.ref })}>
                  {toTitleCase(recipe.name)}
                </Button>
              </Flex.Item>
            </Flex>
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
};
