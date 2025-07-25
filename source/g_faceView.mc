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

        // Load colors from properties
        var notificationsColor = Properties.getValue("NotificationsColor");
        var stepsColor = Properties.getValue("StepsColor");
        var dateColor = Properties.getValue("DateColor");
        var timeColor = Properties.getValue("TimeColor");
        var batteryColor = Properties.getValue("BatteryColor");
        var caloriesColor = Properties.getValue("CaloriesColor");
        var heartRateColor = Properties.getValue("HeartRateColor");
        var weeklyDistanceColor = Properties.getValue("WeeklyDistanceColor");
        var bluetoothColor = Properties.getValue("BluetoothColor");
        var doNotDisturbColor = Properties.getValue("DoNotDisturbColor");

        // Time
        var timeLabel = View.findDrawableById("TimeLabel") as Text;
        timeLabel.setText(getTimeString());
        timeLabel.setColor(timeColor);

        // AM/PM Label
        var pmLabel = View.findDrawableById("PmLabel") as Text;
        pmLabel.setText(getPM());
        pmLabel.setColor(timeColor);

        // Date 
        var dateLabel = View.findDrawableById("DateLabel") as Text;
        dateLabel.setText(getDate());
        dateLabel.setColor(dateColor);

        // Heart Rate
        var heartRateLabel = View.findDrawableById("HeartRateLabel") as Text;
        heartRateLabel.setText(getHeartRateString());
        heartRateLabel.setColor(heartRateColor);

        // Calories 
        var caloriesLabel = View.findDrawableById("CaloriesLabel") as Text;
        caloriesLabel.setText(getCaloriesString());
        caloriesLabel.setColor(caloriesColor);

        // Battery 
        var batteryLabel = View.findDrawableById("BatteryLabel") as Text;
        batteryLabel.setText(getBatteryString());
        batteryLabel.setColor(batteryColor);

        var batteryIcon = View.findDrawableById("BatteryIcon") as Text;
        batteryIcon.setText(getBatteryIcon());
        batteryIcon.setColor(batteryColor);

        // Steps Label
        var stepsLabel = View.findDrawableById("StepsLabel") as Text;
        stepsLabel.setText(getStepsString());
        stepsLabel.setColor(stepsColor);

        // Steps Icon
        var stepsIcon = View.findDrawableById("StepsIcon") as Text;
        stepsIcon.setColor(stepsColor);

        // Weekly running distance
        var weeklyDistanceLabel = View.findDrawableById("WeeklyMiles") as Text;
        weeklyDistanceLabel.setText(getDistanceLabel());
        weeklyDistanceLabel.setColor(weeklyDistanceColor);

        // Weekly running distance icon
        var weeklyDistanceIcon = View.findDrawableById("RunIcon") as Text;
        weeklyDistanceIcon.setColor(weeklyDistanceColor);

        // -- Systray -- //
        // Notifications
        var notificationsIcon = View.findDrawableById("NotificationsIcon") as Text;
        notificationsIcon.setText("@");
        notificationsIcon.setVisible(getNotificationIcon());
        notificationsIcon.setColor(notificationsColor);

        // Bluetooth
        var bluetoothIcon = View.findDrawableById("BluetoothIcon") as Text;
        bluetoothIcon.setVisible(getConnectionState());
        bluetoothIcon.setColor(bluetoothColor);

        // Do not disturb
        var doNotDisturbIcon = View.findDrawableById("DoNotDisturbIcon") as Text;
        doNotDisturbIcon.setVisible(getDoNotDisturb());
        doNotDisturbIcon.setColor(doNotDisturbColor);

        // Get width and height for screen location calculations
        var percX = dc.getWidth();
        var percY = dc.getHeight();

        // ***** Set dynamic element locations ***** //
        // -- AM/PM Label -- //
        if((getTime().hour >= 10 && getTime().hour<= 12) || (getTime().hour >=22) || (getTime().hour == 0))
        {
            pmLabel.setLocation(percX*0.85, percY*0.53);
        }
        else
        {
            pmLabel.setLocation(percX*0.8, percY*0.53);
        }

        // -- Steps Icon -- //
        if(getSteps() < 10)
        {
            stepsIcon.setLocation(percX*0.47, percY*0.17);
        }
        if(getSteps() >= 10 && getSteps() < 100)
        {
            stepsIcon.setLocation(percX*0.46, percY*0.17);
        }
        if(getSteps() >= 100 && getSteps() < 1000)
        {
            stepsIcon.setLocation(percX*0.44, percY*0.17);
        }
        if(getSteps() >= 1000 && getSteps() < 10000)
        {
            stepsIcon.setLocation(percX*0.42, percY*0.17);
        }
        if(getSteps() >= 10000)
        {
            stepsIcon.setLocation(percX*0.4, percY*0.17);
        }

        // -- Running Icon -- //
        if(getWeeklyRunDistanceMiles() == 0)
        {
            weeklyDistanceLabel.setText("0 mi");
            weeklyDistanceIcon.setLocation(percX*0.39, percY*0.85);
        }
        if(getWeeklyRunDistanceMiles() > 0 && getWeeklyRunDistanceMiles() < 10)
        {
            weeklyDistanceIcon.setLocation(percX*0.35, percY*0.85);
        }
        if(getWeeklyRunDistanceMiles() > 10 && getWeeklyRunDistanceMiles() < 100)
        {
            weeklyDistanceIcon.setLocation(percX*0.32, percY*0.85);
        }


        // -- Systray Locations -- //
        if(getNotificationIcon() && getConnectionState() && getDoNotDisturb())
        {
            bluetoothIcon.setLocation(percX*0.4, percY*0.05);
            notificationsIcon.setLocation(percX*0.5, percY*0.05);
            doNotDisturbIcon.setLocation(percX*0.6, percY*0.05);
        }
        if(getNotificationIcon() && getConnectionState() && !getDoNotDisturb())
        {
            bluetoothIcon.setLocation(percX*0.45, percY*0.05);
            notificationsIcon.setLocation(percX*0.55, percY*0.05);
        }
        if(getNotificationIcon() && !getConnectionState() && getDoNotDisturb())
        {
            notificationsIcon.setLocation(percX*0.45, percY*0.05);
            doNotDisturbIcon.setLocation(percX*0.55, percY*0.05);
        }
        if(!getNotificationIcon() && getConnectionState() && getDoNotDisturb())
        {
            bluetoothIcon.setLocation(percX*0.45, percY*0.05);
            doNotDisturbIcon.setLocation(percX*0.55, percY*0.05);
        }
        if(getNotificationIcon() && !getConnectionState() && !getDoNotDisturb())
        {
            notificationsIcon.setLocation(percX*0.5, percY*0.05);
        }
        if(!getNotificationIcon() && getConnectionState() && !getDoNotDisturb())
        {
            bluetoothIcon.setLocation(percX*.5, percY*0.05);
        }
        if(!getNotificationIcon() && !getConnectionState() && getDoNotDisturb())
        {
            doNotDisturbIcon.setLocation(percX*0.5, percY*0.05);
        }

        // ***** End of dynamic element locations ***** //

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Function to get current date as string
    function getDate() as String {
        // Get current date
        var curr = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        // Format date string
        var dateString = Lang.format(
            "$1$, $2$ $3$",
        [
            curr.day_of_week,
            curr.month,
            curr.day
        ]
        );
        return dateString;
    }

    // Function to get current time
    function getTime() as System.ClockTime {
        var time = System.getClockTime();
        return time;
    }

    // Function to get the current time as string
    function getTimeString() as String{
        var hours = getTime().hour;
        var min = getTime().min;
        // If system is in 12hr format
        if(!System.getDeviceSettings().is24Hour)
        {
            if(hours > 12)
            {
                hours = hours - 12;
            }
            if(hours == 0)
            {
                hours = hours + 12;
            }
        }
        // Format time string
        var timeString = Lang.format(
                "$1$:$2$",
            [
                hours,
                min.format("%02d")
            ]
        );
        return timeString;
    }

    // Function to get am or pm 
    function getPM() as String {
        //var time = System.getClockTime();
        var hours = getTime().hour;
        if(hours >= 12)
        {
            return "p";
        }
        else
        {
            return "a";
        }
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

    // Function to get battery icon based on charge level / status
    function getBatteryIcon() as String {
        
        if(getBatteryStatus())
        {
            return "|";
        }
        if(getBattery() < 10)
        {
            return "[";
        }
        if(getBattery() >= 10 && getBattery() < 20){
            return "(";
        }
        if(getBattery() >= 20 && getBattery() < 30)
        {
            return ")";
        }
        if(getBattery() >=30 && getBattery() < 40)
        {
            return "*";
        }
        if(getBattery() >= 40 && getBattery() < 50)
        {
            return "+";
        }
        if(getBattery() >= 50 && getBattery() < 60)
        {
            return ",";
        }
        if(getBattery() >= 60 && getBattery() < 70)
        {
            return "-";
        }
        if(getBattery() >= 70 && getBattery() < 80)
        {
            return ".";
        }
        if(getBattery() >= 80 && getBattery() < 90)
        {
            return ":";
        }
        if(getBattery() >= 90 && getBattery() < 95)
        {
            return "=";
        }
        if(getBattery() >=95)
        {
            return "^";
        }
        else
        {
            return "^";
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

    // Function to get start of week
    function getWeekStart() as Moment {
        var today = new Time.Moment(Time.today().value());
        var info = Gregorian.info(today, Time.FORMAT_SHORT);
        var firstDayOfWeek = 1;

        var settings = System.getDeviceSettings();
        if(settings has :firstDayOfWeek)
        {
            firstDayOfWeek = settings.firstDayOfWeek as Number;
        }

        var days = info.day_of_week as Number - firstDayOfWeek;
        if(days < 0)
        {
            days += 7;
        }

        return today.subtract(new Time.Duration(days * 86400)) as Moment;
    }

    // Function to get weekly running distance (in meters)
    function getWeeklyRunningDistance() as Number {
        var dist = 0;
        if(UserProfile has :getUserActivityHistory)
        {
            var i = UserProfile.getUserActivityHistory();
            if(i != null)
            {
                var next = i.next();
                var weekStart = getWeekStart();

                while(next != null)
                {
                    if(next.type == Activity.SPORT_RUNNING && next.distance != null)
                    {
                        if(next.startTime != null && weekStart.lessThan(next.startTime as Moment))
                        {
                            dist += next.distance as Number;
                        }
                    }
                    next = i.next();
                }
            }
        }
        return dist;
    }

    // Function to get distance in miles 
    function getWeeklyRunDistanceMiles() as Float {
        var miles = getWeeklyRunningDistance()/1609.344;
        return miles;
    }

    // Function to get distance string
    function getDistanceLabel() as String {
        var milesString = getWeeklyRunDistanceMiles().format("%0.2f") + " mi";
        return milesString;
    }

    // Function to get notification count
    function getNotificationCount() as Number {
        var devSettings = Toybox.System.getDeviceSettings();
        return devSettings.notificationCount;
    }

    // Function to for forming notification label
    function getNotificationIcon() as Boolean {
        var notifications = getNotificationCount();
        if(notifications > 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    // Function to get the connection state (with phone)
    function getConnectionState() as Boolean {
        var settings = System.getDeviceSettings();
        var conn = settings.phoneConnected;
        
        // If phone is connected
        if(conn)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    // Function to get do not disturb
    function getDoNotDisturb() as Boolean {
        var settings = System.getDeviceSettings();
        // Check if device supports do not disturb
        if(settings has :doNotDisturb)
        {
            var dnd = settings.doNotDisturb;
            // If do not disturb is on
            if(dnd)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        else
        {
            return false;
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
