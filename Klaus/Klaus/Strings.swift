//
//  Strings.swift
//  Klaus
//
//  Created by Oliver Pieper on 30.12.16.
//  Copyright © 2016 Nimm Swag. All rights reserved.
//

import Foundation

struct Strings {
    
    //Notification texts
    static var statusNotOkTitle = "Oops!"
    static var statusConnectionFail = "Leider gibt es Probleme mit der Bluetoothverbindung. Hätten wir doch lieber mal ne Serveranwendung geschrieben."
    static var statusConnectionFailButton = "Schämt euch!"
    static var statusEnemyBusy = "Ruhig brauner. Dein Opfer ist so ein krasses Opfer, dass es im Moment selber noch kämpft."
    static var statusEnemyBusyButton = "Ich warte noch"
    static var gameConnectionLost = "Während des Spiels ist die Bluetoothverbindung abgebrochen. Du kannst jetzt nochmal probieren Angriffe zu starten."
    static var gameConnetionLostButton = "Passiert den besten!"
    
    // Game titles
    static var axeGameTitle = "Axt Schwengel!"
    static var simonSaysTitle = "Pin Code MC!"
    static var shelfGameTitle = "Böse Katze!"
    static var seitenschneiderTitle = "Seiddeschneider Müsli!"
    
    // Game explanations
    static let axeGameExplanation = "Schwing die Axt! Schüttel dein Handy so schnell du kannst innerhalb von 10 Sekunden. Alles klar?"
    static let simonSaysExplanation = "In meinen Koffer packe ich... Merke dir die Reihenfolge der leuchtenden Tasten und gib sie korrekt wieder! Obacht, es wird immer nur die neueste Ziffer angezeigt. Alles klar?"
    static let shelfGameExplanation = "Fotzen Katz! Nacheinander schmeisst eine böse Katze Gegenstände vom Regal. Halte 3 Gegenstände mit 3 Fingern gleichzeitig gedrückt, um sie zu eleminieren. Sobald ein Gegenstand den Boden berührt hast du verloren."
    static let seitenschneiderExplanation = "Schneide so viele BLAUE Kabel durch indem du sie antippst... aber nicht die Bunten, du Sepp! Schnell, wir haben nicht viel Zeit."
    
    // Result strings
    static var axeGameResult = "Holla die Waldfee! Dein Schwengelfaktor beträgt: "
    static var simonSaysResultPt1 = "Unfassbar oder? Du konntest dir "
    static var simonSaysResultPt2 = " Zahlen merken, bevor dein Kopf versagt hat. Läuft bei dir!"
    static var shelfGameResultPt1 = "Da geht was! Du konntest unfassbare "
    static var shelfGameResultPt2 = " Gegenstände auffangen. Jetzt grill die Katze!"
    static var seitenschneiderResultPt1 = "In anbetracht der geltenden Regeln für dieses Spiel konntest du "
    static var seitenschneiderResultPt2 = " Drähte durschneiden. Du bist crazy drauf!"
    
    // Attack texts
    static var gratulation = "Gratulation!"
    static var fail = "Leider verkackt!"
    static var successfullDefense = "Du hast dein Item erfolgreich verteidigt!"
    static var successfullAttack = "Du hast das Item erfolgreich gestohlen!"
    static var failedDefense = "Dir wurde dein Item gestohlen!"
    static var failedAttack = "Du warst zu wack um das Item zu klauen!"
    static var happyConfirmation = "Nice"
    static var sadConfirmation = "Schade eigentlich"
    static var attention = "Obacht"
    static var attackOnYouPt1 = " versucht eine "
    static var attackOnYouPt2 = " von dir zu klauen."
    static var startDefense = "Verteidigen"
    
    // Simon Says texts
    static let simonSaysComputersTurnText = "Gib den richtigen Code ein!"
    static let simonSaysPlayersTurnText = "Versau's nicht.."
    static let simonSaysPlayerTakesLongText = "Beeil dich man!!!"
    static let simonSaysLostText = "Du Versager..."
    static let simonSaysSuccessText = "Geschafft, du Meisterdieb!"
    
    // Item infos
    static let axeInfo = "Die Axt ist eine heimtückische, als einfaches Holzbearbeitungswerkzeug getarnte Waffe! Die Meinung zur Verwendungsfähigkeit von Äxten als Liebesspielzeug ist ebenso gespalten wie manche Verfechter dieser These.";
    static let coffeeInfo = "Die Fotzenkatz. Sie schmeißt Tassen runter, miaut und hinterlässt nur Dreck. Angestachelt zerkratzt sie auch fremde Visagen... eine schwierige Zeitgenossin.";
    static let seitenschneiderInfo = "Der Seitenschneider ist ein nicht verzehrbares Eisending. Die Verwendung ist jedoch von Art zu Art unterschiedlich. Der Seitenschneider ist eine typisch deutsche Erfindung: Ein Allzweckwerkzeug, dass immer griffbereit und sehr handlich ist. ";
    static let alarmInfo = "Alarm ist das, was ausgelöst wird, wenn die Unfähigkeit eines oder mehrerer Menschen die Grenzen des guten Geschmacks übersteigt und so zur Gefahr der Allgemeinheit wird.";
    
    static let itemPointsPerSecond = "Punkte pro Min"
    static let itemAcquisitionDate = "Eigentum seit"
    
    static let stealButtonText = "Nimm Swag!";
    
    // Tutorial texts
    static let welcomeTitleText = "WELCOME TO KLAU'S"
    static let welcomeExplanationText = "Bist du der nächste Meisterdieb? Klaue Items von Gegnern, behüte und verteidige sie gegen andere Diebe. Suche nach Dieben in deiner Umgebung und beraube sie ihrer Träume und Habseligkeiten. Jedes Item beschert dir Punkte. Je mehr Items und je länger du sie besitzt, desto heftiger scorest die Punkte weg!"
    
    static let chooseAvatarText = "Tarnung Wählen"
    static let chooseAvatarDescriptionText = "Such dir eine Visage aus!"
    
    static let headLineColorText = "Farbe Bekennen"
    static let descritpionColorText = "Wähle eine Farbe aus, die zu deiner diebischen Seele passt."
    static let colorRedText = "Beerig"
    static let colorBlueText = "Blau wie Chloroform"
    static let colorGreenText = "Grün wie Gras"
    static let colorYellowText = "Gelb wie Senf"
    
    static let tutorialEndText = "Bereit?!"
    static let tutorialSwipeText = "Swipe nach rechts wenn du dir sicher bist"
    static let tutorialButtonText = "Weiter"
    
}
