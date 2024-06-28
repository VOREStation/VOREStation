import { BooleanLike } from 'common/react';

export type Data = { internalTemplateName: string };

export type AirlockConsoleDockingData = {
  chamber_pressure: number;
  exterior_status: status;
  interior_status: status;
  processing: BooleanLike;
  docking_status: string;
  airlock_disabled: BooleanLike;
  override_enabled: BooleanLike;
  docking_codes?: string;
  name?: string;
  internalTemplateName: string;
};

export type DockingConsoleSimpleData = {
  docking_status: string;
  override_enabled: BooleanLike;
  exterior_status: status;
  internalTemplateName: string;
};

export type EscapePodBerthConsoleData = {
  docking_status: string;
  override_enabled: BooleanLike;
  exterior_status: status;
  armed: BooleanLike;
  internalTemplateName: string;
};

export type DockingConsoleMultiData = {
  docking_status: string;
  airlocks: { name: string; override_enabled: BooleanLike }[];
  internalTemplateName: string;
};

export type AirlockConsoleAdvancedData = {
  chamber_pressure: number;
  external_pressure: number;
  internal_pressure: number;
  processing: BooleanLike;
  purge: BooleanLike;
  secure: BooleanLike;
  internalTemplateName: string;
};

export type AirlockConsoleSimpleData = {
  chamber_pressure: number;
  exterior_status: status;
  interior_status: status;
  processing: BooleanLike;
  internalTemplateName: string;
};

export type AirlockConsolePhoronData = {
  chamber_pressure: number;
  chamber_phoron: number;
  exterior_status: status;
  interior_status: status;
  processing: BooleanLike;
  internalTemplateName: string;
};

export type DoorAccessConsoleData = {
  exterior_status: status;
  interior_status: status;
  processing: BooleanLike;
  internalTemplateName: string;
};

export type EscapePodConsoleData = {
  docking_status: string;
  override_enabled: BooleanLike;
  exterior_status: status;
  can_force: BooleanLike;
  armed: BooleanLike;
  internalTemplateName: string;
};

export type status = { state: string; lock: string };
