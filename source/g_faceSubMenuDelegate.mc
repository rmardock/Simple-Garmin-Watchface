import Toybox.Application;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class g_faceSubMenuDelegate extends WatchUi.Menu2InputDelegate {

    // var to hold the id of the selected setting in the main menu
    var setting;
    function initialize(s) {
        Menu2InputDelegate.initialize();
        // assign id of main menu to var
        setting = s;
    }

    function onSelect(item) {
        var id = item.getId().toString();
        
        if(id.equals("CatppuccinYellow"))
        {
            // Set property and save value here
            Properties.setValue(setting, 0xf9e2af);
        }
        if(id.equals("CatppuccinRed"))
        {
            Properties.setValue(setting, 0xf38ba8);
        }
        if(id.equals("CatppuccinGreen"))
        {
            Properties.setValue(setting, 0xa6e3a8);
        }
        if(id.equals("CatppuccinBlue"))
        {
            Properties.setValue(setting, 0x89dceb);
        }
        if(id.equals("CatppuccinPurple"))
        {
            Properties.setValue(setting, 0xcba6f7);
        }
        if(id.equals("ColorWhite"))
        {
            Properties.setValue(setting, 0xffffff);
        }
        if(id.equals("ColorBlue"))
        {
            Properties.setValue(setting, 0x00aaff);
        }
        if(id.equals("ColorGreen"))
        {
            Properties.setValue(setting, 0x00ff00);
        }
    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return;
    }
}