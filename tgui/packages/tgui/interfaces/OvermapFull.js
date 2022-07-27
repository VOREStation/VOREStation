import { useLocalState } from "../backend";
import { Tabs } from "../components";
import { Window } from "../layouts";
import { OvermapEnginesContent } from './OvermapEngines';
import { OvermapHelmContent } from './OvermapHelm';
import { OvermapShipSensorsContent } from './OvermapShipSensors';

export const OvermapFull = (props, context) => {
  const [tab, setTab] = useLocalState(context, 'overmapFullState', 0);

  return (
    <Window width={800} height={800} resizable>
      <Window.Content scrollable>
        <Tabs>
          <Tabs.Tab
            selected={tab === 0}
            onClick={() => setTab(0)}>
            Engines
          </Tabs.Tab>
          <Tabs.Tab
            selected={tab === 1}
            onClick={() => setTab(1)}>
            Helm
          </Tabs.Tab>
          <Tabs.Tab
            selected={tab === 2}
            onClick={() => setTab(2)}>
            Sensors
          </Tabs.Tab>
        </Tabs>
        {tab === 0 && <OvermapEnginesContent />}
        {tab === 1 && <OvermapHelmContent />}
        {tab === 2 && <OvermapShipSensorsContent />}
      </Window.Content>
    </Window>
  );
};
