import { useBackend } from 'tgui/backend';
import { Button, Divider, Section } from 'tgui-core/components';

import type { Data } from './types';

export const MenuUpload = (props) => {
  const { act, data } = useBackend<Data>();

  const { scanned, scanner_error } = data;

  let scanerr = '';
  if (scanned === null) {
    scanerr = scanner_error;
  }

  return (
    <Section title="Upload New Title">
      Scanner Data:
      {scanned !== null ? (
        <Section title={scanned.title} key={scanned.id}>
          {scanned.author} - {scanned.category}
          <Divider />
          <Button icon="eye" onClick={() => act('setauthor', { setauthor: 1 })}>
            Change Author
          </Button>
          <Button
            icon="eye"
            onClick={() => act('setcategory', { setcategory: 1 })}
          >
            Change Category
          </Button>
          <Button.Confirm
            icon="eye"
            disabled={scanned.unique}
            onClick={() => act('upload', { upload: 1 })}
          >
            Upload
          </Button.Confirm>
        </Section>
      ) : (
        ` - ${scanerr}`
      )}
    </Section>
  );
};
