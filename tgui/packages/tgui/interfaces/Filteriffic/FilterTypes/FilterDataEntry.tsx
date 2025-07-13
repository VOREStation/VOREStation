import { Box, LabeledList } from 'tgui-core/components';

import { type FilterEntryProps } from '../types';
import { FilterColorEntry } from './FilterColorEntry';
import { FilterEnumEntry } from './FilterEnumEntry';
import { FilterFlagsEntry } from './FilterFlagsEntry';
import { FilterFloatEntry } from './FilterFloatEntry';
import { FilterIconEntry } from './FilterIconEntry';
import { FilterIntegerEntry } from './FilterIntegerEntry';
import { FilterTextEntry } from './FilterTextEntry';
import { FilterTransformEntry } from './FilterTransformEntry';

export const FilterDataEntry = (props: FilterEntryProps) => {
  const { name, value, hasValue, filterName, filterType } = props;

  const filterEntryTypes = {
    int: <FilterIntegerEntry {...props} />,
    float: <FilterFloatEntry {...props} />,
    string: <FilterTextEntry {...props} />,
    color: <FilterColorEntry {...props} />,
    icon: <FilterIconEntry {...props} />,
    flags: <FilterFlagsEntry {...props} />,
    enum: <FilterEnumEntry {...props} />,
    transform: <FilterTransformEntry {...props} />,
  };

  const filterEntryMap = {
    x: 'float',
    y: 'float',
    icon: 'icon',
    render_source: 'string',
    flags: 'flags',
    size: 'float',
    color: 'color',
    offset: 'float',
    radius: 'float',
    falloff: 'float',
    density: 'int',
    threshold: 'float',
    factor: 'float',
    repeat: 'int',
    alpha: 'int',
    space: 'enum',
    blend_mode: 'enum',
    transform: 'transform',
  };

  return (
    <LabeledList.Item label={name}>
      {filterEntryTypes[filterEntryMap[name]] || 'Not Found (This is an error)'}{' '}
      {!hasValue && (
        <Box inline color="average">
          (Default)
        </Box>
      )}
    </LabeledList.Item>
  );
};
