import { Button } from 'tgui-core/components';

export const CategoryButton = (props: {
  category: string;
  action: () => void;
  activeCategory: string;
}) => {
  const { category, action, activeCategory } = props;
  return (
    <Button
      className="RecyclerCategoryButton"
      key={category}
      onClick={() => action()}
      disabled={activeCategory === category}
      style={{
        opacity: activeCategory === category ? 0.5 : 1,
        pointerEvents: activeCategory === category ? 'none' : 'auto',
      }}
    >
      <h5> {category}</h5>
    </Button>
  );
};
