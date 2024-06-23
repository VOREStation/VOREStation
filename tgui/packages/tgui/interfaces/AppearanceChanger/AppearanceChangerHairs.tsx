import { useBackend } from '../../backend';
import { Button, Section } from '../../components';
import { Data } from './types';

export const AppearanceChangerHair = (props) => {
  const { act, data } = useBackend<Data>();

  const { hair_style, hair_styles } = data;

  return (
    <Section title="Hair" fill scrollable>
      {hair_styles.map((hair) => (
        <Button
          key={hair.hairstyle}
          onClick={() => act('hair', { hair: hair.hairstyle })}
          selected={hair.hairstyle === hair_style}
        >
          {hair.hairstyle}
        </Button>
      ))}
    </Section>
  );
};

export const AppearanceChangerFacialHair = (props) => {
  const { act, data } = useBackend<Data>();

  const { facial_hair_style, facial_hair_styles } = data;

  return (
    <Section title="Facial Hair" fill scrollable>
      {facial_hair_styles.map((hair) => (
        <Button
          key={hair.facialhairstyle}
          onClick={() =>
            act('facial_hair', { facial_hair: hair.facialhairstyle })
          }
          selected={hair.facialhairstyle === facial_hair_style}
        >
          {hair.facialhairstyle}
        </Button>
      ))}
    </Section>
  );
};
