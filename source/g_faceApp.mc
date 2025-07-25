import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class g_faceApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return settings view (on-device settings)
    function getSettingsView() as [Views] or [Views, InputDelegates] or Null {
        return [ new g_faceSettingsView(), new g_faceSettingsDelegate() ];
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new g_faceView() ];
    }

    // New app settings have been received so trigger a UI update
    function onSettingsChanged() as Void {
        WatchUi.requestUpdate();
    }

}

function getApp() as g_faceApp {
    return Application.getApp() as g_faceApp;
}