import { useBackend, useSharedState } from "tgui/backend";
import { Window } from "tgui/layouts";
import {
	Box,
	Button,
	Icon,
	LabeledList,
	ProgressBar,
	Section,
	Stack,
	Tabs,
} from "tgui-core/components";
import { type BooleanLike, classes } from "tgui-core/react";

type MenuCategory = {
	id: string;
	name: string;
	ref: string;
	sortorder: number;
};

type Recipe = {
	id: string;
	name: string;
	ref: string;
	category: string;
	desc: string | null;
	hidden: BooleanLike;
};

type CrewCookie = {
	name: string;
	species: string;
	category: string;
};

type Data = {
	isThereCart: BooleanLike;
	cartFillStatus: number;
	active_menu: string;
	menucatagories: MenuCategory[];
	recipes: Recipe[];
	activefood: BooleanLike;
	crew_cookies: CrewCookie[];
	activecrew: BooleanLike;
	crewicon: string | null;
};

export const FoodSynthesizer = (props) => {
	return (
		<Window width={900} height={520}>
			<Window.Content>
				<Section>
					<SynthCartGuage />
				</Section>
				<Section title="Menu Selection">
					<FoodMenuTabs />
				</Section>
				<FoodSelectionMenu />
			</Window.Content>
		</Window>
	);
};

/** Displays the current Cartridge status. */
const SynthCartGuage = (props) => {
	const { data } = useBackend<Data>();
	const { isThereCart, cartFillStatus } = data;
	const adjustedCartChange = cartFillStatus / 100;

	return (
		<Section title="Cartridge Status">
			{isThereCart ? (
				<LabeledList.Item label="Product Remaining">
					<ProgressBar
						color={cartFillStatus ? "purple" : "red"}
						value={adjustedCartChange}
						width={20}
					/>
				</LabeledList.Item>
			) : (
				<LabeledList.Item label="Cartridge Problem">
					<Box color="label">
						One or more cartridges are missing or damaged. <br />
						<br />
						Sabresnacks Co. recommends ordering a genuine Sabresnacks
						replacement cartridge through your local logistical cargo service.
					</Box>
				</LabeledList.Item>
			)}
		</Section>
	);
};

/** Dynamic menu tabs for every listing in category groups. */
const FoodMenuTabs = (props) => {
	const { act, data } = useBackend<Data>();
	const { active_menu, menucatagories } = data;

	const menusToShow = [...menucatagories].sort(
		(a, b) => a.sortorder - b.sortorder,
	);

	const [, setActiveMenu] = useSharedState<string>("ActiveMenu", active_menu);

	const handleActiveMenu = (newMenu: string) => {
		setActiveMenu(newMenu);
		act("setactive_menu", { setactive_menu: newMenu });
	};

	return (
		<Stack>
			<Stack.Item grow>
				<Tabs fluid textAlign="center">
					{menusToShow.map((menu) => (
						<Tabs.Tab
							key={menu.ref}
							icon="list"
							selected={menu.id === active_menu}
							onClick={() => handleActiveMenu(menu.id)}
						>
							{menu.name}
						</Tabs.Tab>
					))}
				</Tabs>
			</Stack.Item>
		</Stack>
	);
};

/** Chooses the menu item, displays information, and an image. */
const FoodSelectionMenu = (props) => {
	const { act, data } = useBackend<Data>();
	const { active_menu, recipes, activefood, crew_cookies, activecrew } = data;

	if (!recipes) {
		return <Box color="bad">Recipes records missing!</Box>;
	}

	const [activeFoodState, setActiveFoodState] = useSharedState<
		Recipe | Recipe[]
	>("ActiveFood", recipes);

	const [activeCookieState, setActiveCookieState] = useSharedState<
		CrewCookie | CrewCookie[]
	>("ActiveCookie", crew_cookies);

	const singleActiveFood = activeFoodState as Recipe;
	const singleActiveCookie = activeCookieState as CrewCookie;

	const recipesToShow = recipes
		.filter((recipe) => recipe.category === active_menu)
		.filter((recipe) => !recipe.hidden)
		.sort((a, b) => a.name.localeCompare(b.name));

	const cookiesToShow = crew_cookies
		.filter((cookie) => cookie.category === active_menu)
		.sort((a, b) => a.name.localeCompare(b.name));

	if (active_menu === "crew") {
		return (
			<Section>
				<Stack>
					<Stack.Item basis="30%">
						<Section title="Food Selection" scrollable fill>
							<Tabs vertical>
								{cookiesToShow.map((cookie) => (
									<Tabs.Tab key={cookie.name}>
										<Button
											fluid
											content={cookie.name}
											selected={
												singleActiveCookie &&
												cookie.name === singleActiveCookie.name
											}
											onClick={() =>
												act("setactive_crew", { setactive_crew: cookie.name })
											}
										/>
									</Tabs.Tab>
								))}
							</Tabs>
						</Section>
					</Stack.Item>
					<Stack.Item grow={1} ml={2}>
						{activecrew && singleActiveCookie ? (
							<Section title="Product Details" fill>
								<Box>
									<Stack align="center" justify="flex-start">
										<Stack.Item>
											<LabeledList>
												<LabeledList.Item label="Name">
													{singleActiveCookie.name}
												</LabeledList.Item>
												<br />
												<LabeledList.Item label="Species">
													{singleActiveCookie.species}
												</LabeledList.Item>
											</LabeledList>
											<Button
												content="Print this Cookie"
												onClick={() =>
													act("crewprint", {
														crewprint: singleActiveCookie.name,
													})
												}
											>
												<CrewCookieIcon />
											</Button>
											<br />
											<br />
											<Box>
												<Button
													content="Refresh Information"
													onClick={() => act("refresh")}
												/>
											</Box>
										</Stack.Item>
									</Stack>
								</Box>
							</Section>
						) : (
							<Section>
								<Box color="label">Please select an offering.</Box>
								<br />
								<br />
								<br />
								<Box>
									<Button
										content="Refresh Information"
										onClick={() => act("refresh")}
									/>
								</Box>
							</Section>
						)}
					</Stack.Item>
				</Stack>
			</Section>
		);
	}

	return (
		<Section>
			<Stack>
				<Stack.Item basis="30%">
					<Section title="Food Selection" scrollable fill>
						<Tabs vertical>
							{recipesToShow.map((recipe) => (
								<Tabs.Tab key={recipe.ref}>
									<Button
										fluid
										content={recipe.name}
										selected={
											singleActiveFood && recipe.ref === singleActiveFood.ref
										}
										onClick={() =>
											act("setactive_food", { setactive_food: recipe.id })
										}
									/>
								</Tabs.Tab>
							))}
						</Tabs>
					</Section>
				</Stack.Item>
				<Stack.Item grow={1} ml={4}>
					{activefood && singleActiveFood ? (
						<Section title="Product Details" fill>
							<Box>
								<Stack align="center" justify="flex-start">
									<Stack.Item>
										<LabeledList>
											<LabeledList.Item label="Name">
												{singleActiveFood.name}
											</LabeledList.Item>
											<br />
											<LabeledList.Item label="Description">
												{singleActiveFood.desc || "No description available."}
											</LabeledList.Item>
										</LabeledList>
										<br />
										<Button
											content="Print this meal"
											width="128px"
											height="128px"
											className={classes([
												"synthesizer128x128",
												singleActiveFood.id,
											])}
											onClick={() =>
												act("make", { make: singleActiveFood.ref })
											}
										/>
									</Stack.Item>
								</Stack>
							</Box>
						</Section>
					) : (
						<Section>
							<Box color="label">Please select an offering.</Box>
						</Section>
					)}
				</Stack.Item>
			</Stack>
		</Section>
	);
};

const CrewCookieIcon = (props) => {
	const { data } = useBackend<Data>();
	const { crewicon } = data;

	return (
		<Section>
			{crewicon ? (
				<img
					src={crewicon.substring(1, crewicon.length - 1)}
					style={{
						position: "relative",
						left: 0,
						right: 0,
						top: 0,
						bottom: 0,
						width: "128px",
						height: "128px",
						imageRendering: "pixelated",
					}}
					alt="Crew Cookie Icon"
				/>
			) : (
				<Icon
					style={{
						position: "relative",
						left: "10px",
						right: "10px",
						top: "10px",
						bottom: "10px",
						width: "128px",
						height: "128px",
					}}
					fontSize={4}
					name="camera"
				/>
			)}
		</Section>
	);
};
