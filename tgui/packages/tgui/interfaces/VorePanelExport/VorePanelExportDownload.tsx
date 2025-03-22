import { useBackend } from 'tgui/backend';

import { Data } from './types';
import { generateBellyString } from './VorePanelExportBellyString';
import { generateSoulcatcherString } from './VorePanelExportSoulcatcherString';
import { getCurrentTimestamp } from './VorePanelExportTimestamp';

export const downloadPrefs = (extension: string) => {
  const { data } = useBackend<Data>();

  const { db_version, db_repo, mob_name, bellies, soulcatcher } = data;

  if (!bellies) {
    return;
  }

  let datesegment = getCurrentTimestamp();

  let filename = mob_name + datesegment + extension;
  let blob;

  if (extension === '.html') {
    let style = '<style>' + '</style>';

    blob = new Blob(
      [
        '<!DOCTYPE html><html lang="en"><head>' +
          '<meta charset="utf-8">' +
          '<meta name="viewport" content="width=device-width, initial-scale=1">' +
          '<title>' +
          bellies.length +
          ' Exported Bellies (DB_VER: ' +
          db_repo +
          '-' +
          db_version +
          ')</title>' +
          '<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-gH2yIJqKdNHPEq0n4Mqa/HGKIhSkIHeL5AyhkYV8i59U5AR6csBvApHHNl/vI1Bx" crossorigin="anonymous">' +
          '<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.9.1/font/bootstrap-icons.css">' +
          style +
          '</head><body class="py-4"><main><div class="container"><h2>Bellies of ' +
          mob_name +
          '</h2><p class="lead">Generated on: ' +
          datesegment +
          '</p><div class="accordion" id="accordionBellies">',
      ],
      {
        type: 'text/html',
      },
    );
    bellies.forEach((belly, i) => {
      blob = new Blob([blob, generateBellyString(belly, i)], {
        type: 'text/html',
      });
    });
    if (soulcatcher) {
      blob = new Blob([blob, generateSoulcatcherString(soulcatcher)], {
        type: 'text/html',
      });
    }
    blob = new Blob(
      [
        blob,
        '</div>',
        '<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-A3rJD856KowSb7dwlZdYEkO39Gagi7vIsF0jrRAoQmDKKtQBHUuLZ9AsSv4jD4Xa" crossorigin="anonymous"></script>',
        '</div></main></body></html>',
      ],
      { type: 'text/html' },
    );
  }

  if (extension === '.vrdb') {
    blob = new Blob(
      [JSON.stringify({ bellies: bellies, soulcatcher: soulcatcher })],
      {
        type: 'application/json',
      },
    );
  }

  Byond.saveBlob(blob, filename, extension);
};
