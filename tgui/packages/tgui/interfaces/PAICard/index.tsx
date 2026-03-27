import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { PAIActiveCompanion } from './PAIActiveCompanion';
import { PAIFindCompanion } from './PAIFindCompanion';
import type { Data } from './types';

export const PAICard = (props) => {
  const { data } = useBackend<Data>();

  const { active_pai_data, available_pais } = data;

  return (
    <Window width={450} height={600}>
      <Window.Content>
        {(!!active_pai_data && (
          <PAIActiveCompanion activeData={active_pai_data} />
        )) ||
          (!!available_pais && (
            <PAIFindCompanion availablePais={available_pais} />
          ))}
      </Window.Content>
    </Window>
  );
};
