/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { ComponentProps } from 'react';
import { Stack } from 'tgui-core/components';

export function LabeledControls(props: ComponentProps<typeof Stack>) {
  const { children, wrap, ...rest } = props;

  return (
    <Stack
      mx={-0.5}
      wrap={wrap}
      align="stretch"
      justify="space-between"
      {...rest}
    >
      {children}
    </Stack>
  );
}

type ItemProps = {
  label: string;
} & ComponentProps<typeof Stack>;

function LabeledControlsItem(props: ItemProps) {
  const { label, children, mx = 1, ...rest } = props;

  return (
    <Stack.Item mx={mx}>
      <Stack
        height="100%"
        direction="column"
        align="center"
        textAlign="center"
        justify="space-between"
        {...rest}
      >
        <Stack.Item />
        <Stack.Item>{children}</Stack.Item>
        <Stack.Item color="label">{label}</Stack.Item>
      </Stack>
    </Stack.Item>
  );
}

LabeledControls.Item = LabeledControlsItem;
