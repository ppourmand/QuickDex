//
//  AppDelegate.swift
//  QuickDex
//
//  Created by Pasha Pourmand on 6/4/19.
//  Copyright © 2019 Pasha Pourmand. All rights reserved.
//

import UIKit
import CoreData

// global constants
let SUPER_EFFECTIVE_COLOR = UIColor(red: 0.1804, green: 0.8, blue: 0.4431, alpha: 1.0)
let NOT_VERY_EFFECTIVE_COLOR = UIColor(red: 0.9059, green: 0.298, blue: 0.2353, alpha: 1.0)
let NEUTRAL_EFFECTIVE_COLOR = UIColor(red: 0.7412, green: 0.7647, blue: 0.7804, alpha: 1.0)
let DARK_MODE_BAR_COLOR = UIColor(red: 0.0667, green: 0.0667, blue: 0.0667, alpha: 1.0)
let POKEMON_MISSING_SPRITE_URL = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/0.png"
let POKEMON_NAMES = ["abomasnow","abra","absol","accelgor","aegislash","aerodactyl","aggron","aipom","alakazam","alomomola","altaria","amaura","ambipom","amoonguss","ampharos","anorith","araquanid","arbok","arcanine","arceus","archen","archeops","ariados","armaldo","aromatisse","aron","articuno","audino","aurorus","avalugg","axew","azelf","azumarill","azurill","bagon","baltoy","banette","barbaracle","barboach","basculin","bastiodon","bayleef","beartic","beautifly","beedrill","beheeyem","beldum","bellossom","bellsprout","bergmite","bewear","bibarel","bidoof","binacle","bisharp","blacephalon","blastoise","blaziken","blissey","blitzle","boldore","bonsly","bouffalant","bounsweet","braixen","braviary","breloom","brionne","bronzong","bronzor","bruxish","budew","buizel","bulbasaur","buneary","bunnelby","burmy","butterfree","buzzwole","cacnea","cacturne","camerupt","carbink","carnivine","carracosta","carvanha","cascoon","castform","caterpie","celebi","celesteela","chandelure","chansey","charizard","charjabug","charmander","charmeleon","chatot","cherrim","cherubi","chesnaught","chespin","chikorita","chimchar","chimecho","chinchou","chingling","cinccino","clamperl","clauncher","clawitzer","claydol","clefable","clefairy","cleffa","cloyster","cobalion","cofagrigus","combee","combusken","comfey","conkeldurr","corphish","corsola","cosmoem","cosmog","cottonee","crabominable","crabrawler","cradily","cranidos","crawdaunt","cresselia","croagunk","crobat","croconaw","crustle","cryogonal","cubchoo","cubone","cutiefly","cyndaquil","darkrai","darmanitan standard","dartrix","darumaka","decidueye","dedenne","deerling","deino","delcatty","delibird","delphox","deoxys","dewgong","dewott","dewpider","dhelmise","dialga","diancie","diggersby","diglett","ditto","dodrio","doduo","donphan","doublade","dragalge","dragonair","dragonite","drampa","drapion","dratini","drifblim","drifloon","drilbur","drowzee","druddigon","ducklett","dugtrio","dunsparce","duosion","durant","dusclops","dusknoir","duskull","dustox","dwebble","eelektrik","eelektross","eevee","ekans","electabuzz","electivire","electrike","electrode","elekid","elgyem","emboar","emolga","empoleon","entei","escavalier","espeon","espurr","excadrill","exeggcute","exeggutor","exploud","farfetch’d","fearow","feebas","fennekin","feraligatr","ferroseed","ferrothorn","finneon","flaaffy","flabébé","flareon","fletchinder","fletchling","floatzel","floette","florges","flygon","fomantis","foongus","forretress","fraxure","frillish","froakie","frogadier","froslass","furfrou","furret","gabite","gallade","galvantula","garbodor","garchomp","gardevoir","gastly","gastrodon","genesect","gengar","geodude","gible","gigalith","girafarig","giratina","glaceon","glalie","glameow","gligar","gliscor","gloom","gogoat","golbat","goldeen","golduck","golem","golett","golisopod","golurk","goodra","goomy","gorebyss","gothita","gothitelle","gothorita","gourgeist","granbull","graveler","greninja","grimer","grotle","groudon","grovyle","growlithe","grubbin","grumpig","gulpin","gumshoos","gurdurr","guzzlord","gyarados","hakamo-o","happiny","hariyama","haunter","hawlucha","haxorus","heatmor","heatran","heliolisk","helioptile","heracross","herdier","hippopotas","hippowdon","hitmonchan","hitmonlee","hitmontop","ho-oh","honchkrow","honedge","hoopa","hoothoot","hoppip","horsea","houndoom","houndour","huntail","hydreigon","hypno","igglybuff","illumise","incineroar","infernape","inkay","ivysaur","jangmo-o","jellicent","jigglypuff","jirachi","jolteon","joltik","jumpluff","jynx","kabuto","kabutops","kadabra","kakuna","kangaskhan","karrablast","kartana","kecleon","keldeo","kingdra","kingler","kirlia","klang","klefki","klink","klinklang","koffing","komala","kommo-o","krabby","kricketot","kricketune","krokorok","krookodile","kyogre","kyurem","lairon","lampent","landorus","lanturn","lapras","larvesta","larvitar","latias","latios","leafeon","leavanny","ledian","ledyba","lickilicky","lickitung","liepard","lileep","lilligant","lillipup","linoone","litleo","litten","litwick","lombre","lopunny","lotad","loudred","lucario","ludicolo","lugia","lumineon","lunala","lunatone","lurantis","luvdisc","luxio","luxray","lycanroc","machamp","machoke","machop","magby","magcargo","magearna","magikarp","magmar","magmortar","magnemite","magneton","magnezone","makuhita","malamar","mamoswine","manaphy","mandibuzz","manectric","mankey","mantine","mantyke","maractus","mareanie","mareep","marill","marowak","marshadow","marshtomp","masquerain","mawile","medicham","meditite","meganium","meloetta","meowstic","meowth","mesprit","metagross","metang","metapod","mew","mewtwo","mienfoo","mienshao","mightyena","milotic","miltank","mime jr.","mimikyu","minccino","minior","minun","misdreavus","mismagius","moltres","monferno","morelull","mothim","mr. mime","mudbray","mudkip","mudsdale","muk","munchlax","munna","murkrow","musharna","naganadel","natu","necrozma","nidoking","nidoqueen","nidoran♀","nidoran♂","nidorina","nidorino","nihilego","nincada","ninetales","ninjask","noctowl","noibat","noivern","nosepass","numel","nuzleaf","octillery","oddish","omanyte","omastar","onix","oranguru","oricorio","oshawott","pachirisu","palkia","palossand","palpitoad","pancham","pangoro","panpour","pansage","pansear","paras","parasect","passimian","patrat","pawniard","pelipper","persian","petilil","phanpy","phantump","pheromosa","phione","pichu","pidgeot","pidgeotto","pidgey","pidove","pignite","pikachu","pikipek","piloswine","pineco","pinsir","piplup","plusle","poipole","politoed","poliwag","poliwhirl","poliwrath","ponyta","poochyena","popplio","porygon","porygon-z","porygon2","primarina","primeape","prinplup","probopass","psyduck","pumpkaboo","pupitar","purrloin","purugly","pyroar","pyukumuku","quagsire","quilava","quilladin","qwilfish","raichu","raikou","ralts","rampardos","rapidash","raticate","rattata","rayquaza","regice","regigigas","regirock","registeel","relicanth","remoraid","reshiram","reuniclus","rhydon","rhyhorn","rhyperior","ribombee","riolu","rockruff","roggenrola","roselia","roserade","rotom","rowlet","rufflet","sableye","salamence","salandit","salazzle","samurott","sandile","sandshrew","sandslash","sandygast","sawk","sawsbuck","scatterbug","sceptile","scizor","scolipede","scrafty","scraggy","scyther","seadra","seaking","sealeo","seedot","seel","seismitoad","sentret","serperior","servine","seviper","sewaddle","sharpedo","shaymin","shedinja","shelgon","shellder","shellos","shelmet","shieldon","shiftry","shiinotic","shinx","shroomish","shuckle","shuppet","sigilyph","silcoon","silvally","simipour","simisage","simisear","skarmory","skiddo","skiploom","skitty","skorupi","skrelp","skuntank","slaking","slakoth","sliggoo","slowbro","slowking","slowpoke","slugma","slurpuff","smeargle","smoochum","sneasel","snivy","snorlax","snorunt","snover","snubbull","solgaleo","solosis","solrock","spearow","spewpa","spheal","spinarak","spinda","spiritomb","spoink","spritzee","squirtle","stakataka","stantler","staraptor","staravia","starly","starmie","staryu","steelix","steenee","stoutland","stufful","stunfisk","stunky","sudowoodo","suicune","sunflora","sunkern","surskit","swablu","swadloon","swalot","swampert","swanna","swellow","swinub","swirlix","swoobat","sylveon","taillow","talonflame","tangela","tangrowth","tapu bulu","tapu fini","tapu koko","tapu lele","tauros","teddiursa","tentacool","tentacruel","tepig","terrakion","throh","thundurus","timburr","tirtouga","togedemaru","togekiss","togepi","togetic","torchic","torkoal","tornadus","torracat","torterra","totodile","toucannon","toxapex","toxicroak","tranquill","trapinch","treecko","trevenant","tropius","trubbish","trumbeak","tsareena","turtonator","turtwig","tympole","tynamo","type: null","typhlosion","tyranitar","tyrantrum","tyrogue","tyrunt","umbreon","unfezant","unown","ursaring","uxie","vanillish","vanillite","vanilluxe","vaporeon","venipede","venomoth","venonat","venusaur","vespiquen","vibrava","victini","victreebel","vigoroth","vikavolt","vileplume","virizion","vivillon","volbeat","volcanion","volcarona","voltorb","vullaby","vulpix","wailmer","wailord","walrein","wartortle","watchog","weavile","weedle","weepinbell","weezing","whimsicott","whirlipede","whiscash","whismur","wigglytuff","wimpod","wingull","wishiwashi","wobbuffet","woobat","wooper","wormadam","wurmple","wynaut","xatu","xerneas","xurkitree","yamask","yanma","yanmega","yungoos","yveltal","zangoose","zapdos","zebstrika","zekrom","zeraora","zigzagoon","zoroark","zorua","zubat","zweilous","zygarde"]

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "QuickDex")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

