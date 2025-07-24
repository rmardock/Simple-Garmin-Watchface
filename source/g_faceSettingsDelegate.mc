import Toybox.Application;
import Toybox.System;
import Toybox.WatchUi;

class g_faceSettingsDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        // Initialize delegate
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        // Get selected item id as a string
        var id = item.getId().toString();

        // Switch to sub-menu    
        var subMenu = new g_faceSettingsSubMenu();
        WatchUi.pushView(subMenu, new g_faceSubMenuDelegate(id), WatchUi.SLIDE_LEFT);
    }

    // Function for back button
    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return;
    }
}