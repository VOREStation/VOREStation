export type Data = {
  species_with_whitelist: string[];
  language_with_whitelist: string[];
  robot_with_whitelist: string[];
  jobs_with_whitelist: string[];

  alienwhitelist: Record<string, string[] | null>;
  languagewhitelist: Record<string, string[] | null>;
  robotwhitelist: Record<string, string[] | null>;
  jobwhitelist: Record<string, string[] | null>;
};
