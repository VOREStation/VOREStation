import { Button, Dropdown, Stack } from 'tgui-core/components';

export const DateDropdown = (props: {
  selectedIndex: number;
  setData: React.Dispatch<React.SetStateAction<string>>;
  setSelectedIndex: React.Dispatch<React.SetStateAction<number>>;
  selectedDate: string;
  setSelectedDate: React.Dispatch<React.SetStateAction<string>>;
  dateChoices: string[];
  sortedDates: string[];
  getData: (date: string, attemptNumber?: number) => any;
}) => {
  const {
    selectedIndex,
    setData,
    setSelectedIndex,
    selectedDate,
    setSelectedDate,
    dateChoices,
    sortedDates,
    getData,
  } = props;

  if (!dateChoices.length) {
    return null;
  }

  function handleSelect(date: string) {
    const index = dateChoices.indexOf(date);
    if (index === -1) return;

    setData('Loading changelog data...');
    setSelectedIndex(index);
    setSelectedDate(dateChoices[index]);
    getData(sortedDates[index]);
  }

  function handlePrev() {
    if (selectedIndex >= dateChoices.length - 1) return;
    handleSelect(dateChoices[selectedIndex + 1]);
  }

  const handleNext = () => {
    if (selectedIndex <= 0) return;
    handleSelect(dateChoices[selectedIndex - 1]);
  };

  return (
    <Stack mb={1}>
      <Stack.Item>
        <Button
          className="Changelog__Button"
          disabled={selectedIndex === dateChoices.length - 1}
          icon="chevron-left"
          onClick={handlePrev}
        />
      </Stack.Item>
      <Stack.Item>
        <Dropdown
          displayText={selectedDate}
          options={dateChoices}
          onSelected={handleSelect}
          selected={selectedDate}
          width="150px"
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          className="Changelog__Button"
          disabled={selectedIndex === 0}
          icon="chevron-right"
          onClick={handleNext}
        />
      </Stack.Item>
    </Stack>
  );
};
