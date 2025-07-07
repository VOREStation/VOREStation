import { useBackend } from 'tgui/backend';
import {
  Button,
  Collapsible,
  LabeledList,
  NumberInput,
  Section,
} from 'tgui-core/components';

import { FilterDataEntry } from './FilterTypes/FilterDataEntry';
import type { ActiveFilters, Data } from './types';

export const FilterEntry = (props: {
  readonly name: string;
  readonly filterDataEntry: ActiveFilters;
}) => {
  const { act, data } = useBackend<Data>();
  const { name, filterDataEntry } = props;
  const { type, priority, ...restOfProps } = filterDataEntry;

  const filterDefaults = data['filter_info'];

  const targetFilterPossibleKeys = Object.keys(
    filterDefaults[type]['defaults'],
  );

  return (
    <Collapsible
      title={name + ' (' + type + ')'}
      buttons={
        <>
          <NumberInput
            minValue={-Infinity}
            maxValue={Infinity}
            value={priority}
            step={1}
            stepPixelSize={10}
            width="60px"
            onChange={(value) =>
              act('change_priority', {
                name: name,
                new_priority: value,
              })
            }
          />
          <Button.Input
            buttonText="Rename"
            onCommit={(value) =>
              act('rename_filter', {
                name,
                new_name: value,
              })
            }
            width="90px"
          />
          <Button.Confirm
            icon="minus"
            onClick={() => act('remove_filter', { name: name })}
          />
        </>
      }
    >
      <Section>
        <LabeledList>
          {targetFilterPossibleKeys.map((entryName) => {
            const defaults = filterDefaults[type]['defaults'];
            const value = restOfProps[entryName] || defaults[entryName];
            const hasValue = value !== defaults[entryName];
            return (
              <FilterDataEntry
                key={entryName}
                filterName={name}
                filterType={type}
                name={entryName}
                value={value}
                hasValue={hasValue}
              />
            );
          })}
        </LabeledList>
      </Section>
    </Collapsible>
  );
};
