import Toybox.Application;
import Toybox.System;
import Toybox.WatchUi;

class g_faceSettingsDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        var id = item.getId();
        var subMenu = Rez.Menus.SettingsSubMenu;
        if(id == "NotificationsColor")
        {
            subMenu.initialize();
        }
    }
}