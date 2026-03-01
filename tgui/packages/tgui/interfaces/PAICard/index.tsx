import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { PAIActiveCompanion } from './PAIActiveCompanion';
import { PAIFindCompanion } from './PAIFindCompanion';
import type { Data } from './types';

export const PAICard = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    has_pai,
    waiting_for_response,
    name,
    health,
    law_zero,
    law_extra,
    master_name,
    master_dna,
    available_pais,
    radio,
    radio_transmit,
    radio_recieve,
    screen_msg,
  } = data;

  return (
    <Window width={450} height={600}>
      <Window.Content>
        {(has_pai && <PAIActiveCompanion />) || <PAIFindCompanion />}
      </Window.Content>
    </Window>
  );
};
