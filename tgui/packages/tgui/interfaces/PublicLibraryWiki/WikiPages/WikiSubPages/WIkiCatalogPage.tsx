import { Section, Stack } from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';

import type { CatalogData } from '../../types';

export const WikiCatalogPage = (props: { catalog: CatalogData }) => {
  const { catalog } = props;

  return (
    <Section fill scrollable title={capitalize(catalog.name)}>
      <Stack vertical fill>
        <Stack.Item grow>
          {/* eslint-disable-next-line react/no-danger */}
          <div dangerouslySetInnerHTML={{ __html: catalog.desc }} />
        </Stack.Item>
      </Stack>
    </Section>
  );
};
