# Quick Dex - An exercise in learning iOS and creating a Pokedex tool
This project was started with several goals in mind: 
  1. Learn enough Swift and iOS development to create an app from scratch to completion
  2. Create a useful tool that I would personally use

And so Quick Dex was born. Essentially a Pokédex application, it also has functionality
where you can choose your team and compare type effectivenesses against other Pokémon.

# What libraries are used?
  - SwiftyJSON
  - SnapKit
  - NotificationsBanner
  - Alamofire
  - MarqueeLabel

# How does it work?
Calls are made to the [PokeApi](https://pokeapi.co/). When the API returns the Pokémon information as a JSON, the app parses the data and saves it to the Core Data model created. This helps cache the data of a Pokémon so we aren't hammering the API (Pokémon data doesn't really change all too often).

The data received is then displayed for the user

![pokedex main view](https://github.com/ppourmand/QuickDex/blob/master/screenshots/pokedex.png)
