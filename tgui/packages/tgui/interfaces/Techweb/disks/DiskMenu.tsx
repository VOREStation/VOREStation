import { Button, Stack, Tabs } from 'tgui-core/components';

import { useRemappedBackend } from '../helpers';
import { useTechWebRoute } from '../hooks';
import { TechwebDesignDisk, TechwebTechDisk } from './disks';

type Props = {
  diskType: string;
};

export function TechwebDiskMenu(props: Props) {
  const { act, data } = useRemappedBackend();
  const { diskType } = props;
  const { t_disk, d_disk } = data;
  const [techwebRoute, setTechwebRoute] = useTechWebRoute();

  // Check for the disk actually being inserted
  if ((diskType === 'design' && !d_disk) || (diskType === 'tech' && !t_disk)) {
    return null;
  }

  const DiskContent =
    (diskType === 'design' && TechwebDesignDisk) || TechwebTechDisk;

  return (
    <Stack g={0} direction="column" fill>
      <Stack.Item>
        <Stack
          g={0}
          justify="space-between"
          className="Techweb__HeaderSectionTabs"
        >
          <Stack.Item align="center" className="Techweb__HeaderTabTitle">
            {diskType.charAt(0).toUpperCase() + diskType.slice(1)} Disk
          </Stack.Item>
          <Stack.Item grow>
            <Tabs>
              <Tabs.Tab selected>Stored Data</Tabs.Tab>
            </Tabs>
          </Stack.Item>
          <Stack.Item align="center">
            {diskType === 'tech' && (
              <Button icon="save" onClick={() => act('loadTech')}>
                Web &rarr; Disk
              </Button>
            )}
            <Stack>
              <Stack.Item>
                <Button
                  icon="upload"
                  onClick={() => act('uploadDisk', { type: diskType })}
                >
                  Disk &rarr; Web
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon="eject"
                  onClick={() => {
                    act('ejectDisk', { type: diskType });
                    setTechwebRoute({ route: '' });
                  }}
                >
                  Eject
                </Button>
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon="home"
                  onClick={() => setTechwebRoute({ route: '' })}
                >
                  Home
                </Button>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item grow className="Techweb__OverviewNodes">
        <DiskContent />
      </Stack.Item>
    </Stack>
  );
}
