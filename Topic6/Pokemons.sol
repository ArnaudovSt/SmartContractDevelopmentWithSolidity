pragma solidity ^0.4.18;

contract Pokemons {
    enum AvailablePokemons { Bulbasaur, Ivysaur, Venusaur, Charmander, Charmeleon, Charizard, Squirtle, Wartortle, Blastoise, Caterpie, Metapod, Butterfree, Weedle, Kakuna, Beedrill, Pidgey, Pidgeotto, Pidgeot, Rattata, Raticate, Spearow, Fearow, Ekans, Arbok, Pikachu, Raichu, Sandshrew, Sandslash, NidoranF, Nidorina, Nidoqueen, NidoranM } // 32 * 8-bit values

    struct PlayerInfo {
        uint256 lastCatch;
        uint8[32] collection;
    }

    mapping (address=>PlayerInfo) players;
    address[][32] pokemonOwners;

    function announceCatch(AvailablePokemons _pokemon) public returns (bool success) {
        require(players[msg.sender].lastCatch + 15 seconds < now);

        uint8 pokemonIndex = uint8(_pokemon);

        if (players[msg.sender].collection[pokemonIndex] != 0) {
            players[msg.sender].lastCatch = now;
            return false;
        }

        PlayerInfo memory currentPlayerInfo = players[msg.sender];
        currentPlayerInfo.collection[pokemonIndex] = 1;
        currentPlayerInfo.lastCatch = now;
        players[msg.sender] = currentPlayerInfo;

        pokemonOwners[pokemonIndex].push(msg.sender);
        
        return true;
    }

    function listPokemonOwners(AvailablePokemons _pokemon) public view returns (address[]) {
        return pokemonOwners[uint8(_pokemon)];
    }

    function listPokemonsOwnedBy(address _owner) public view returns(uint8[32]) {
        return players[_owner].collection;
    }
}