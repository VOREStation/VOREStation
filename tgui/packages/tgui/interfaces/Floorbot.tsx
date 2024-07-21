import { BooleanLike } from 'common/react';

import { useBackend } from '../backend';
import {
  AnimatedNumber,
  Button,
  Dropdown,
  LabeledList,
  Section,
} from '../components';
import { Window } from '../layouts';

type Data = {
  on: BooleanLike;
  open: BooleanLike;
  locked: BooleanLike;
  vocal: BooleanLike;
  amount: number;
  possible_bmode: string[];
  improvefloors: BooleanLike;
  eattiles: BooleanLike;
  maketiles: BooleanLike;
  bmode: string | null;
};

export const Floorbot = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    on,
    open,
    locked,
    vocal,
    amount,
    possible_bmode,
    improvefloors,
    eattiles,
    maketiles,
    bmode,
  } = data;

  return (
    <Window width={390} height={310}>
      <Window.Content scrollable>
        <Section
          title="Automatic Station Floor Repairer v2.0"
          buttons={
            <Button icon="power-off" selected={on} onClick={() => act('start')}>
              {on ? 'On' : 'Off'}
            </Button>
          }
        >
          <LabeledList>
            <LabeledList.Item label="Tiles Left">
              <AnimatedNumber value={amount} />
            </LabeledList.Item>
            <LabeledList.Item
              label="Maintenance Panel"
              color={open ? 'bad' : 'good'}
            >
              {open ? 'Open' : 'Closed'}
            </LabeledList.Item>
            <LabeledList.Item
              label="Behavior Controls"
              color={locked ? 'good' : 'bad'}
            >
              {locked ? 'Locked' : 'Unlocked'}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        {(!locked && (
          <Section title="Behavior Controls">
            <LabeledList>
              <LabeledList.Item label="Speaker">
                <Button
                  icon={vocal ? 'toggle-on' : 'toggle-off'}
                  selected={vocal}
                  onClick={() => act('vocal')}
                >
                  {vocal ? 'On' : 'Off'}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="Improves Floors">
                <Button
                  icon={improvefloors ? 'toggle-on' : 'toggle-off'}
                  selected={improvefloors}
                  onClick={() => act('improve')}
                >
                  {improvefloors ? 'On' : 'Off'}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="Finds Tiles">
                <Button
                  icon={eattiles ? 'toggle-on' : 'toggle-off'}
                  selected={eattiles}
                  onClick={() => act('tiles')}
                >
                  {eattiles ? 'On' : 'Off'}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="Makes Metal Sheets into Tiles">
                <Button
                  icon={maketiles ? 'toggle-on' : 'toggle-off'}
                  selected={maketiles}
                  onClick={() => act('make')}
                >
                  {maketiles ? 'On' : 'Off'}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="Bridge Mode">
                <Dropdown
                  over
                  width="100%"
                  selected={bmode ? bmode : 'Disabled'}
                  options={possible_bmode}
                  onSelected={(val) => act('bridgemode', { dir: val })}
                />
              </LabeledList.Item>
            </LabeledList>
          </Section>
        )) ||
          null}
      </Window.Content>
    </Window>
  );
};
