import Toybox.Application;
import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Time.Gregorian;
using Toybox.UserProfile;

class g_faceView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Get the current time and format it correctly
        var timeFormat = "$1$:$2$";
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {
            if (Application.Properties.getValue("UseMilitaryFormat")) {
                timeFormat = "$1$$2$";
                hours = hours.format("%02d");
            }
        }
        var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);

        // Time
        var timeLabel = View.findDrawableById("TimeLabel") as Text;
        timeLabel.setText(timeString);

        // Date 
        var dateLabel = View.findDrawableById("DateLabel") as Text;
        dateLabel.setText(getDate());

        // Heart Rate
        var heartRateLabel = View.findDrawableById("HeartRateLabel") as Text;
        heartRateLabel.setText(getHeartRateString());

        // Calories 
        var caloriesLabel = View.findDrawableById("CaloriesLabel") as Text;
        caloriesLabel.setText(getCaloriesString());

        // Battery 
        var batteryLabel = View.findDrawableById("BatteryLabel") as Text;
        batteryLabel.setText(getBatteryString());

        var batteryIcon = View.findDrawableById("BatteryIcon") as Text;
        batteryIcon.setText(getBatteryIcon());

        // Steps
        var stepsLabel = View.findDrawableById("StepsLabel") as Text;
        stepsLabel.setText(getStepsString());

        // Weekly running distance
        var weeklyDistanceLabel = View.findDrawableById("WeeklyMiles") as Text;
        weeklyDistanceLabel.setText(getWeeklyRunDistanceMiles());

        // Notifications
        var notificationsIcon = View.findDrawableById("NotificationsIcon") as Text;
        notificationsIcon.setText(getNotificationLabel());

        // Bluetooth
        var bluetoothIcon = View.findDrawableById("BluetoothIcon") as Text;
        bluetoothIcon.setText(getConnectionState());

        // Do not disturb
        var doNotDisturbIcon = View.findDrawableById("DoNotDisturbIcon") as Text;
        doNotDisturbIcon.setText(getDoNotDisturb());

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Function to get current date as string
    function getDate() as String {
        var curr = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        //var now = Time.now();
        //var info = Calendar.info(now, Time.FORMAT_MEDIUM);
        var dateString = Lang.format(
            "$1$, $2$ $3$",
        [
            curr.day_of_week,
            curr.month,
            curr.day
        ]
        );
        //var dateString = Lang.format("$1$ $2$ $3$")
        return dateString;
    }

    // Function to get heart rate as a number
    function getHeartRate() as Number {
        var heartRateI = Toybox.ActivityMonitor.getHeartRateHistory(1, true);
        return heartRateI.next().heartRate;
    }
    
    // Function to get heart rate as a string
    function getHeartRateString() as String {
        return getHeartRate().format("%d");
    }

    // Function to get steps as a number
    function getSteps() as Number or Null {
        return Toybox.ActivityMonitor.getInfo().steps;
    }

    // Function to get steps as a string 
    function getStepsString() as String {
        var steps = getSteps();
        if (steps == null) {
            return "-";
        }
        return getSteps().format("%d");
    }

    // Function to get battery as float
    function getBattery() as Float {
        return Toybox.System.getSystemStats().battery;
    }

    // Function to get battery percent as string 
    function getBatteryString() as String {
        return getBattery().format("%d") + "%";
    }

    // Function to get battery charging status as bool
    function getBatteryStatus() as Boolean {
        return Toybox.System.getSystemStats().charging;
    }

    // Function to get battery icon
    function getBatteryIcon() as String {
        if(getBattery() < 15)
        {
            return ":";
        }
        if(getBattery() >= 15 && getBattery() < 45){
            return ",";
        }
        if(getBattery() >= 45 && getBattery() < 85)
        {
            return "-";
        }
        if(getBattery() >=85)
        {
            return ".";
        }
        if(getBatteryStatus())
        {
            return "=";
        }
        else
        {
            return ".";
        }
    }

    // Function to get calories
    function getCalories() as Number or Null {
        return Toybox.ActivityMonitor.getInfo().calories;
    }

    // Function to get calories as string
    function getCaloriesString() as String {
        var calories = getCalories();
        if(calories == null){
            return "-";
        }
        return getCalories().format("%d");
    }

    // Function to get weekly running distance
    function getWeeklyRunningDistance() as Number or Null {
        var distance = 0;
        if(UserProfile has :getUserActivityHistory) 
        {
            var i = UserProfile.getUserActivityHistory();
            if(i != null) 
            {
                var next = i.next();
                var first = System.getDeviceSettings().firstDayOfWeek as Moment;

                while(next != null) 
                {
                    if(next.type == Activity.SPORT_RUNNING)
                    {
                        if(next.distance != null)
                        {
                            if(next.startTime != null && first.lessThan(next.startTime as Moment))
                            {
                                distance += next.distance as Number;
                            }
                        }
                        else
                        {
                            distance = 0;
                        }
                    }
                    next = i.next();
                }
            }
        }
        return distance; //distance in meters
    }

    // Function to get distance in miles as string
    function getWeeklyRunDistanceMiles() as String {
        var miles = getWeeklyRunningDistance()/1609.344;
        var milesString = miles.format("%d");
        return milesString;
    }

    // Function to get notification count
    function getNotificationCount() as Number {
        var devSettings = Toybox.System.getDeviceSettings();
        return devSettings.notificationCount;
    }

    // Function to for forming notification label
    function getNotificationLabel() as String {
        var notifications = getNotificationCount();
        if(notifications > 0)
        {
            return "@";
        }
        else
        {
            return "";
        }
    }

    // Function to get the connection state (with phone)
    function getConnectionState() as String {
        var settings = System.getDeviceSettings();
        var conn = settings.phoneConnected;

        if(conn)
        {
            return "~";
        }
        else
        {
            return " ";
        }
        // if(settings has :phoneConnected)
        // {
        //     var state = settings.connectionInfo[:BluetoothLowEnergy].state;
        
        // }
    }

    // Function to get do not disturb
    function getDoNotDisturb() as String {
        var settings = System.getDeviceSettings();
        if(settings has :doNotDisturb)
        {
            var dnd = settings.doNotDisturb;
            if(dnd)
            {
                return "?";
            }
            else
            {
                return " ";
            }
        }
        else
        {
            return " ";
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}
