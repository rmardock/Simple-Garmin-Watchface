import Toybox.Application;
import Toybox.System;
import Toybox.WatchUi;

class g_faceSettingsDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        var id = item.getId().toString();

        // SubMenu    
        var subMenu = new g_faceSettingsSubMenu();
        WatchUi.pushView(subMenu, new g_faceSubMenuDelegate(id), WatchUi.SLIDE_LEFT);
    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return;
    }
}