import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class g_faceSettingsSubMenu extends WatchUi.Menu2 {

    function initialize() {
        // Load submenu from submenu.xml
        var subMenu = Rez.Menus.SettingsSubMenu;
        subMenu.initialize();
    }
}