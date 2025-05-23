import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Icon, LabeledList, Section } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

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

const specialIconColors = {
  'Enable Flashlight': '#0f0',
  'Disable Flashlight': '#f00',
};

export const pda_main_menu = (props) => {
  const { act, data } = useBackend<Data>();

  const [showTransition, setShowTransition] = useState('');

  const startProgram = (program: category) => {
    if (
      program.name.startsWith('Enable') ||
      program.name.startsWith('Disable')
    ) {
      // Special case, instant
      act('StartProgram', { program: program.ref });
      return;
    }

    setShowTransition(program.icon);

    setTimeout(() => {
      setShowTransition('');
      act('StartProgram', { program: program.ref });
    }, 200);
  };

  const { owner, ownjob, idInserted, categories, pai, notifying, apps } = data;

  return (
    <>
      {showTransition && (
        <Box className="Pda__Transition">
          <Icon name={showTransition} size={4} />
        </Box>
      )}
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
                      iconColor={
                        app.name in specialIconColors
                          ? specialIconColors[app.name]
                          : null
                      }
                      color={app.ref in notifying ? 'red' : 'transparent'}
                      onClick={() => startProgram(app)}
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
