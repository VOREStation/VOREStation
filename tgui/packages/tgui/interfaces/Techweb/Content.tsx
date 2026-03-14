import { Button, LabeledList, Stack } from 'tgui-core/components';

import { useRemappedBackend } from './helpers';
import { useTechWebRoute } from './hooks';
import { TechwebRouter } from './Router';

export function TechwebContent(props) {
  const { act, data } = useRemappedBackend();
  const {
    d_disk,
    node_cache,
    points_last_tick,
    point_types_abbreviations = [],
    points,
    queue_nodes = [],
    sec_protocols,
    t_disk,
  } = data;
  const [techwebRoute, setTechwebRoute] = useTechWebRoute();

  return (
    <Stack direction="column" className="Techweb__Viewport" fill g={0}>
      <Stack.Item className="Techweb__HeaderSection">
        <Stack className="Techweb__HeaderContent" g={0}>
          <Stack.Item>
            <LabeledList>
              <LabeledList.Item label="Security">
                <span
                  className={`Techweb__SecProtocol ${
                    !!sec_protocols && 'engaged'
                  }`}
                >
                  {sec_protocols ? 'Engaged' : 'Disengaged'}
                </span>
              </LabeledList.Item>
              {Object.keys(points).map((k) => (
                <LabeledList.Item key={k} label={point_types_abbreviations[k]}>
                  <b>{points[k]}</b>
                  {!!points_last_tick[k] && ` (+${points_last_tick[k]}/sec)`}
                </LabeledList.Item>
              ))}
              <LabeledList.Item label="Queue">
                {queue_nodes.length !== 0
                  ? Object.keys(queue_nodes).map((node_id) => (
                      <Button
                        key={node_id}
                        tooltip={`Added by: ${queue_nodes[node_id]}`}
                      >
                        {node_cache[node_id].name}
                      </Button>
                    ))
                  : 'Empty'}
              </LabeledList.Item>
            </LabeledList>
          </Stack.Item>
          <Stack.Item grow />
          <Stack.Item>
            <Button fluid onClick={() => act('toggleLock')} icon="lock">
              Lock Console
            </Button>
            {d_disk && (
              <Stack.Item>
                <Button
                  fluid
                  onClick={() =>
                    setTechwebRoute({ route: 'disk', diskType: 'design' })
                  }
                >
                  Design Disk Inserted
                </Button>
              </Stack.Item>
            )}
            {t_disk && (
              <Stack.Item>
                <Button
                  fluid
                  onClick={() =>
                    setTechwebRoute({ route: 'disk', diskType: 'tech' })
                  }
                >
                  Tech Disk Inserted
                </Button>
              </Stack.Item>
            )}
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item className="Techweb__RouterContent" height="100%">
        <TechwebRouter />
      </Stack.Item>
    </Stack>
  );
}
