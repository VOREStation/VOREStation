use meowtonin::{value::ByondValue, ByondError, ByondResult};
use rand::{distributions::Bernoulli, prelude::Distribution};

const CELL_THRESHOLD: usize = 5;

#[byond_fn]
pub fn generate_automata(
    limit_x: ByondValue,
    limit_y: ByondValue,
    iterations: ByondValue,
    initial_wall_cell: ByondValue,
) -> ByondResult<Vec<ByondValue>> {
    let limit_x = limit_x.get_number()? as usize;
    let limit_y = limit_y.get_number()? as usize;
    let iterations = iterations.get_number()? as usize;
    let initial_wall_cell = initial_wall_cell.get_number()? as usize;

    let mut map = seed_map(limit_x, limit_y, initial_wall_cell)?;
    for _ in 1..iterations {
        map = map
            .iter()
            .enumerate()
            .map(|(i, _)| {
                let mut count = 0;

                for x in [-1, 0, 1] {
                    for y in [-1, 0, 1] {
                        let idx = ((i as i32) + x + (y * (limit_y as i32))) as usize;

                        if let Some(&value) = map.get(idx) {
                            let is_border_left = idx % limit_x == 0;
                            let is_border_right = (idx + 1) % limit_x == 0;

                            if is_border_left && x == -1 {
                                continue;
                            }
                            if is_border_right && x == 1 {
                                continue;
                            }

                            if value {
                                count += 1;
                            }
                        }
                    }
                }

                count >= CELL_THRESHOLD
            })
            .collect()
    }

    let byond_list: Vec<ByondValue> = map
        .iter()
        .map(|&b| ByondValue::new_num(if b { 1. } else { 0. }))
        .collect();

    Ok(byond_list)
}

fn seed_map(limit_x: usize, limit_y: usize, percent_chance: usize) -> ByondResult<Vec<bool>> {
    let mut map = vec![false; limit_x * limit_y];

    let d = Bernoulli::new(percent_chance as f64 / 100.0).map_err(ByondError::boxed)?;

    map = map
        .iter()
        .map(|_| d.sample(&mut rand::thread_rng()))
        .collect();

    Ok(map)
}
