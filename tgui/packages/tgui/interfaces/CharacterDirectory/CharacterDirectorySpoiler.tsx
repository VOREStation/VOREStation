import { Box } from 'tgui-core/components';

/** Element to spoiler Text surrpunded with || */
export const MarkdownSpoilerText = (props: { text: string }) => {
  const { text } = props;

  const parts = text.split('||');

  return (
    <>
      {parts.map((part, index) => (
        <Box
          inline
          preserveWhitespace
          key={index}
          className={index % 2 === 1 ? 'spoiler' : undefined}
        >
          {part}
        </Box>
      ))}
    </>
  );
};

/** Element to spoiler Text */
export const SpoilerText = (props: { text: string }) => {
  const { text } = props;

  return (
    <Box inline preserveWhitespace>
      {text}
    </Box>
  );
};
