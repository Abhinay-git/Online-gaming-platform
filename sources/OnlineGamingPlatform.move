module MyModule::GamingPlatform {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing a game with a reward pool.
    struct Game has store, key {
        reward_pool: u64,
    }

    /// Function to register a new game with an initial reward pool.
    public fun register_game(owner: &signer, initial_funds: u64) {
        let game = Game {
            reward_pool: initial_funds,
        };
        move_to(owner, game);
    }

    /// Function to reward a player from the game’s reward pool.
    public fun reward_player(game_owner: &signer, player: address, amount: u64) acquires Game {
        let game = borrow_global_mut<Game>(signer::address_of(game_owner));
        assert!(game.reward_pool >= amount, 1);
        game.reward_pool = game.reward_pool - amount;
        let reward = coin::withdraw<AptosCoin>(game_owner, amount);
        coin::deposit<AptosCoin>(player, reward);
    }
}
