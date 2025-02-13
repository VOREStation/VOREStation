import { useBackend } from 'tgui/backend';
import { Button, LabeledList, Section } from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';

import type { Data } from './types';

export const RIGSuitHardware = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    // Disables buttons while the suit is busy
    sealing,
    // Each piece
    helmet,
    helmetDeployed,
    gauntlets,
    gauntletsDeployed,
    boots,
    bootsDeployed,
    chest,
    chestDeployed,
  } = data;

  return (
    <Section title="Hardware">
      <LabeledList>
        <LabeledList.Item
          label="Helmet"
          buttons={
            <Button
              icon={helmetDeployed ? 'sign-out-alt' : 'sign-in-alt'}
              disabled={sealing}
              selected={helmetDeployed}
              onClick={() => act('toggle_piece', { piece: 'helmet' })}
            >
              {helmetDeployed ? 'Deployed' : 'Deploy'}
            </Button>
          }
        >
          {helmet ? capitalize(helmet) : 'ERROR'}
        </LabeledList.Item>
        <LabeledList.Item
          label="Gauntlets"
          buttons={
            <Button
              icon={gauntletsDeployed ? 'sign-out-alt' : 'sign-in-alt'}
              disabled={sealing}
              selected={gauntletsDeployed}
              onClick={() => act('toggle_piece', { piece: 'gauntlets' })}
            >
              {gauntletsDeployed ? 'Deployed' : 'Deploy'}
            </Button>
          }
        >
          {gauntlets ? capitalize(gauntlets) : 'ERROR'}
        </LabeledList.Item>
        <LabeledList.Item
          label="Boots"
          buttons={
            <Button
              icon={bootsDeployed ? 'sign-out-alt' : 'sign-in-alt'}
              disabled={sealing}
              selected={bootsDeployed}
              onClick={() => act('toggle_piece', { piece: 'boots' })}
            >
              {bootsDeployed ? 'Deployed' : 'Deploy'}
            </Button>
          }
        >
          {boots ? capitalize(boots) : 'ERROR'}
        </LabeledList.Item>
        <LabeledList.Item
          label="Chestpiece"
          buttons={
            <Button
              icon={chestDeployed ? 'sign-out-alt' : 'sign-in-alt'}
              disabled={sealing}
              selected={chestDeployed}
              onClick={() => act('toggle_piece', { piece: 'chest' })}
            >
              {chestDeployed ? 'Deployed' : 'Deploy'}
            </Button>
          }
        >
          {chest ? capitalize(chest) : 'ERROR'}
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
