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

# What does the app do/what are the features?
The data received is then displayed for the user. On the main page you can see the type effectiveness of the searched pokemon (how it fares against the different types). When searching by Pokémon, you can also use the very handy autocomplete feature!

![pokedex main view](https://github.com/ppourmand/QuickDex/blob/master/screenshots/pokedex.png)
![type effectiveness](https://github.com/ppourmand/QuickDex/blob/master/screenshots/effectiveness.png)
![dex autocomplete](https://github.com/ppourmand/QuickDex/blob/master/screenshots/pokedex-auto.png)

You can also see how your team matches up against the Pokémon you searched:

![matchups](https://github.com/ppourmand/QuickDex/blob/master/screenshots/matchup.png)

On the teams tab, you can add up to 6 pokemon and are aided by a form of autocomplete

![team autocomplete](https://github.com/ppourmand/QuickDex/blob/master/screenshots/team-auto.png)

And lastly here we can see the settings page where you can enable dark mode

![](https://github.com/ppourmand/QuickDex/blob/master/screenshots/settings.png)

# Dark mode??
Yes! There is indeed a dark mode. Yes I know iOS 13 will be coming with a system-wide dark mode, but what if you want to have the app in light mode and system in dark mode or vice versa? This gives us quite a bit of flexibility.

![](https://github.com/ppourmand/QuickDex/blob/master/screenshots/dark-pokedex.png)
![](https://github.com/ppourmand/QuickDex/blob/master/screenshots/dark-pokedex-auto.png)
![](https://github.com/ppourmand/QuickDex/blob/master/screenshots/dark-team-auto.png)_
![](https://github.com/ppourmand/QuickDex/blob/master/screenshots/dark-settings.png)
