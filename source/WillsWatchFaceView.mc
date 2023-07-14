import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.ActivityMonitor;
import Toybox.Weather;

class WillsWatchFaceView extends WatchUi.WatchFace {

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
        // Get and show the current time
        setClockDisplay();
        setBatteryDisplay();
        setHeartRateDisplay();
        // setWeatherDisplay(); // API 3.2.0  
        setStepCount();  
        setStepGoalPercent();

        

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
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

    private function setClockDisplay() {
        
        var clockTime = System.getClockTime();
        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
        var timeDisplay = View.findDrawableById("timeDisplay") as Text;
        timeDisplay.setText(timeString);

    }

    private function setBatteryDisplay() {

        var battery = System.getSystemStats().battery;
        var batteryDisplay = View.findDrawableById("batteryDisplay") as Text;
        batteryDisplay.setText(battery.format("%d") + "%");

    }

    private function setHeartRateDisplay() {

        var heartrate = "";
        var hrIterator = ActivityMonitor.getHeartRateHistory(null, false);
        var currentHeartRate = hrIterator.next().heartRate;
        

        if (null != currentHeartRate) {                                           
            if (currentHeartRate != ActivityMonitor.INVALID_HR_SAMPLE) {
                heartrate = currentHeartRate.format("%d");
            }
            else {
                heartrate = "--";
            }
        }

        var heartRateDisplay = View.findDrawableById("heartRateDisplay") as Text;
        heartRateDisplay.setText(heartrate);

    }

    private function setWeatherDisplay() {

        var weather = Weather.getCurrentConditions().temperature;
        var weatherDisplay = View.findDrawableById("weatherDisplay") as Text;
        weatherDisplay.setText(weather.format("%d"));

    }

    private function setStepCount() {

        var stepCount = ActivityMonitor.getInfo().steps;
        var stepCountDisplay = View.findDrawableById("stepCountDisplay") as Text;
        stepCountDisplay.setText(stepCount.format("%d"));

    }

    private function setStepGoalPercent() {

        var steps = ActivityMonitor.getInfo().steps;
        var stepGoal = ActivityMonitor.getInfo().stepGoal;
        var percent = 0;

        if (steps > 0 && stepGoal != null) {
            percent = ((stepGoal.toFloat() / steps.toFloat()) * 100f);
        }
        
        var stepGoalPercent = View.findDrawableById("stepGoalDisplay") as Text;
        stepGoalPercent.setText(percent.format("%d") + "%");

    }

}
