import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class g_faceSettingsView extends WatchUi.Menu2 {

    function initialize() {
        // Load menu from menu.xml
        var menu = Rez.Menus.SettingsMenu;
        menu.initialize();
    }
}