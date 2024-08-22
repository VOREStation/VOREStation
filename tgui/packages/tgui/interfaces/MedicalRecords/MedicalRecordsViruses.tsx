import { Fragment } from 'react';

import { useBackend } from '../../backend';
import { Button } from '../../components';
import { Data } from './types';

export const MedicalRecordsViruses = (props) => {
  const { act, data } = useBackend<Data>();
  const { virus } = data;
  virus && virus.sort((a, b) => (a.name > b.name ? 1 : -1));
  return (
    virus &&
    virus.map((vir, i) => (
      <Fragment key={i}>
        <Button
          icon="flask"
          mb="0.5rem"
          onClick={() => act('vir', { vir: vir.D })}
        >
          {vir.name}
        </Button>
        <br />
      </Fragment>
    ))
  );
};
