import { BooleanLike } from 'common/react';

export type Data = {
  hasOccupant: BooleanLike;
  occupant: occupant;
  verbose: BooleanLike;
  oxyAlarm: number;
  choice: BooleanLike;
  health: BooleanLike;
  crit: BooleanLike;
  healthAlarm: BooleanLike;
  oxy: BooleanLike;
};

export type occupant = {
  name: string;
  stat: number;
  health: number;
  maxHealth: number;
  minHealth: number;
  bruteLoss: number;
  oxyLoss: number;
  toxLoss: number;
  fireLoss: number;
  paralysis: number;
  hasBlood: BooleanLike;
  bodyTemperature: number;
  maxTemp: number;
  temperatureSuitability: number;
  btCelsius: number;
  btFaren: number;
  pulse: number | undefined;
  bloodLevel: number | undefined;
  bloodMax: number | undefined;
  bloodPercent: number | undefined;
  bloodType: string | undefined;
  surgery: { name: string; currentStage: string; nextSteps: string[] }[] | null;
};
