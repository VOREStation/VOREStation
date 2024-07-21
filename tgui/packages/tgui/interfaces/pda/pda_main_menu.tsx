import { BooleanLike } from 'common/react';

import { useBackend } from '../../backend';
import { Box, Button, LabeledList, Section } from '../../components';

type Data = {
  owner: string;
  ownjob: string;
  idInserted: boolean;
  categories: string[];
  apps: Record<string, category>[];
  pai: BooleanLike;
  notifying: Record<string | number, BooleanLike>;
};

type category = {
  name: string;
  icon: string;
  notify_icon: string;
  ref: string;
};

export const pda_main_menu = (props) => {
  const { act, data } = useBackend<Data>();

  const { owner, ownjob, idInserted, categories, pai, notifying, apps } = data;

  return (
    <>
      <Box>
        <LabeledList>
          <LabeledList.Item label="Owner" color="average">
            {owner}, {ownjob}
          </LabeledList.Item>
          <LabeledList.Item label="ID">
            <Button
              icon="sync"
              disabled={!idInserted}
              onClick={() => act('UpdateInfo')}
            >
              Update PDA Info
            </Button>
          </LabeledList.Item>
        </LabeledList>
      </Box>
      <Section title="Functions">
        <LabeledList>
          {categories.map((name) => {
            let valid_apps = apps[name];

            if (!valid_apps || !valid_apps.length) {
              return null;
            } else {
              return (
                <LabeledList.Item label={name} key={name}>
                  {valid_apps.map((app: category) => (
                    <Button
                      key={app.ref}
                      icon={app.ref in notifying ? app.notify_icon : app.icon}
                      iconSpin={app.ref in notifying}
                      color={app.ref in notifying ? 'red' : 'transparent'}
                      onClick={() => act('StartProgram', { program: app.ref })}
                    >
                      {app.name}
                    </Button>
                  ))}
                </LabeledList.Item>
              );
            }
          })}
        </LabeledList>
      </Section>
      {!!pai && (
        <Section title="pAI">
          <Button fluid icon="cog" onClick={() => act('pai', { option: 1 })}>
            Configuration
          </Button>
          <Button fluid icon="eject" onClick={() => act('pai', { option: 2 })}>
            Eject pAI
          </Button>
        </Section>
      )}
    </>
  );
};
